//
//  ServerManager.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "ServerManager.h"
#import "Player.h"
#import "Packet.h"
#import "NSDataCategories.h"
#import "QuizGame.h"
#import "QuestionAnswer.h"
#import "SpectatorViewController.h"
#import "QuestionsArray.h"
#import "PausableTimer.h"
#import "SoundManager.h"

@implementation ServerManager
@synthesize players,quizGame,vc,clientIDs,remainingTime,remainingHasAnsweredTime;

- (id)initWithViewController:(SpectatorViewController *)v {
    self = [super init];
    if (self != nil) {
        self.vc = v;
    }
    return self;
}

- (void)connectionEstablished:(GKSession *)newSession withRedPeerID:(NSString *)redID andBluePeerID:(NSString *)blueID {
    
    self.players = [[[NSMutableArray alloc] init] autorelease];
    self.session = newSession;
    self.session.delegate = self;
    [self.session setDataReceiveHandler:self withContext:nil];
    
    
    self.clientIDs = [NSMutableArray arrayWithObjects:blueID,redID, nil];
    
    for (NSString *pID in clientIDs) {
        Player *c = [[[Player alloc] initWithPeerID:pID] autorelease];
        [players addObject:c];
    }
    
    self.quizGame = [[[QuizGame alloc]initWithRedPlayerID:redID
                                               bluePlayer:blueID
                                         andQuestionArray:[QuestionsArray allQuestions]] autorelease];
    
    if (SEND_HEARTBEATS) {
        [self beginSendingHeartBeats];
    }
    
}

- (void)startNewGame {
    [self sendData:nil withCode:NETWORK_RESTARTGAME toPeers:clientIDs];
    for (Player *p in players) {
        [p resetScore];
    }
    self.quizGame = [[[QuizGame alloc]initWithRedPlayerID:quizGame.redPlayer.peerID
                                               bluePlayer:quizGame.bluePlayer.peerID
                                         andQuestionArray:[QuestionsArray allQuestions]] autorelease];
}

- (void)connectionFailed {
    
}

- (void)sendAnswer {
    if (quizGame.redAnsweredLastQuestion) {
        [self sendData:nil withCode:NETWORK_WASFIRST toPeers:[NSArray arrayWithObject:quizGame.redPlayer.peerID]];
        [self sendData:nil withCode:NETWORK_WASSECOND toPeers:[NSArray arrayWithObject:quizGame.bluePlayer.peerID]];
    } else {
        [self sendData:nil withCode:NETWORK_WASFIRST toPeers:[NSArray arrayWithObject:quizGame.bluePlayer.peerID]];
        [self sendData:nil withCode:NETWORK_WASSECOND toPeers:[NSArray arrayWithObject:quizGame.redPlayer.peerID]];
    }
    [self.vc updateState];
    [self startHasAnsweredTimer];
    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:TIMEAFTERQUESITON target:self selector:@selector(showNext:) userInfo:nil repeats:NO];
    //[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [quizGame clearPlayers];
}

- (void)clientReconnected {
    [vc restartGame];
}

- (void)countDown:(NSTimer *)timer {
    [self sendData:nil withCode:NETWORK_COUNTDOWNTIMER toPeers:clientIDs];
    remainingTime--;
    vc.countDownLabel.text = [NSString stringWithFormat:@"%d",remainingTime];
    if (remainingTime == 0) {
        [vc.countDownTimer invalidate];
        [vc displaySpectatorView];
        [vc showNextQuestion];
    }
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    Packet *packet = [Packet getPacketFromReceivedData:data];
    
    switch (packet.packetCode) {
        case NETWORK_HEARTBEAT: {
            if (DEBUG_HEARTBEATS) {
                NSLog(@"Received Heartbeat from %@",[self.session displayNameForPeer:peer]);
            }
            Player *c = [self playerByPeerID:peer];
            c.lastHeartBeat = [NSDate date];
            if (c.connectionLost) {
                c.connectionLost = NO;
                Player *rival = [self rivalPlayer:c];
                if (!rival.connectionLost) {
                    [self clientReconnected];
                    [self sendData:nil withCode:NETWORK_RECONNECT toPeers:clientIDs];
                }
            }
            break;
        }
        case NETWORK_ANSWER: {
            if (DEBUG_ANSWERS) {
                NSLog(@"Received Answer From: %@",[self.session displayNameForPeer:peer]);
            }
            quizGame.playerWasCorrect = NO;
            QuestionAnswer *answer = [packet.objectData questionAnswerValue];
            [quizGame receiveAnswerFrom:peer forQuestionIndex:answer.index andAnswerState:answer.isCorrect andTime:answer.timeForAnswer];
            [vc.answeringTimer invalidate];
            [self startHasAnsweredTimer];
            // NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:TIMEAFTERQUESITON target:self selector:@selector(showNext:) userInfo:nil repeats:NO];
            //  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            [self performSelector:@selector(sendAnswer) withObject:nil afterDelay:ANTILAG];
            break;
        }
        case NETWORK_TIMEEXPIRED: {
            if (DEBUG_ANSWERS) {
                NSLog(@"Received Time Expired From: %@",[self.session displayNameForPeer:peer]);
            }
            
            quizGame.playerWasCorrect = NO;
            quizGame.currentQuestion = [packet.objectData intValue] + 1;
            [self sendData:nil withCode:NETWORK_WASSECOND toPeers:[NSArray arrayWithObject:peer]];
            
            [self.vc updateState];
            [self startHasAnsweredTimer];
            //  NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:TIMEAFTERQUESITON target:self selector:@selector(showNext:) userInfo:nil repeats:NO];
            // [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            break;
        }
        case NETWORK_REQUESTSTART: {
            Player *c = [self playerByPeerID:peer];
            c.requestedStartGame = YES;
            BOOL shouldStart = YES;
            for (Player *client in players) {
                shouldStart = shouldStart && client.requestedStartGame;
            }
            
            if (shouldStart || START_WITH_ONE_PLAYER) {
                NSArray *peers = [self.session peersWithConnectionState:GKPeerStateConnected];
                [self sendData:[NSData createWithInt:quizGame.seed] withCode:NETWORK_SEED toPeers:peers];
                [self sendData:nil withCode:NETWORK_STARTGAME toPeers:peers];
                
                vc.view = vc.countDownView;
                [[SoundManager sharedInstance] stopAllSounds];
                vc.countDownLabel.text = @"3";
                self.remainingTime = 3;
                
                vc.countDownTimer = [[[PausableTimer alloc] initWithTimeInterval:1 target:self selector:@selector(countDown:) repeats:YES userInfo:nil] autorelease];
                [vc.countDownTimer startTimer];
                //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
                
            }
            break;
        }
        default:
            break;
    }
}

- (void)hasAnsweredTick:(NSTimer *)timer {
    [self sendData:nil withCode:NETWORK_HASANSWEREDTIMER toPeers:clientIDs];
    remainingHasAnsweredTime--;
    if (remainingHasAnsweredTime == 0) {
        [vc.hasAnsweredTimer invalidate];
        [self.vc showNextQuestion];
    }
}

- (void)startHasAnsweredTimer {
    if (remainingHasAnsweredTime != 0) {
        return;
    }
    vc.hasAnsweredTimer = [[[PausableTimer alloc] initWithTimeInterval:1 target:self selector:@selector(hasAnsweredTick:) repeats:YES userInfo:nil] autorelease];
    [vc.hasAnsweredTimer startTimer];
    self.remainingHasAnsweredTime = TIMEAFTERQUESITON;
}

- (Player *)rivalPlayer:(Player *)player {
    if ([player.peerID isEqualToString:[[players objectAtIndex:0] peerID]]) {
        return [players objectAtIndex:1];
    }
    return [players objectAtIndex:0];
}

- (Player *)playerByPeerID:(NSString *)ID {
    for (Player * c in players) {
        if ([c.peerID isEqualToString:ID]) {
            return c;
        }
    }
    return nil;
}

- (void)beginSendingHeartBeats {
    self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:HEARTBEATDELAY target:self selector:@selector(sendHeartBeat:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.heartBeatTimer forMode:NSRunLoopCommonModes];
    for (Player *c in players) {
        c.lastHeartBeat = [NSDate date];
    }
}

- (void)disconnectDetectedForClient:(Player *)c {
    c.connectionLost = YES;
    Player *rival = [self rivalPlayer:c];
    NSLog(@"Sending Disconnect Message To: %@",[self.session displayNameForPeer:rival.peerID]);
    [self sendData:nil withCode:NETWORK_DISCONNECT toPeers:[NSArray arrayWithObject:rival.peerID]];
    [vc connectionProblem];
}

- (void)sendHeartBeat:(NSTimer *)timer {
    for (Player *c in players) {
        if (DEBUG_HEARTBEATS) {
            NSLog(@"Heartbeat packet delay %f",fabs([c.lastHeartBeat timeIntervalSinceNow]));
        }
        if (fabs([c.lastHeartBeat timeIntervalSinceNow]) >= MAXDELAY && c.lastHeartBeat != nil) {
            c.lastHeartBeat = nil;
            [self disconnectDetectedForClient:c];
        }
    }
    [super sendData:nil withCode:NETWORK_HEARTBEAT toPeers:clientIDs];
}

- (void)dealloc {
    self.players = nil;
    self.quizGame = nil;
    [super dealloc];
}


@end
