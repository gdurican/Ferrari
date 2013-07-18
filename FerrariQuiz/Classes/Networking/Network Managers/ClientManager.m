//
//  ClientManager.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "ClientManager.h"
#import "HomeViewController.h"
#import "Packet.h"
#import "NSDataCategories.h"
#import "GamePlayViewController.h"
#import "QuestionsArray.h"
#import "SoundManager.h"
#import "PausableTimer.h"

@implementation ClientManager
@synthesize serverPeerID,lastHeartBeat;
@synthesize vc,serverDisconnected;

- (id)initWithViewController:(GamePlayViewController *)v {
    self = [super init];
    if (self != nil) {
        self.vc = v;
        self.serverDisconnected = NO;
    }
    return self;
}

- (void)showConnectionView {
    [super showConnectionView];
}

- (void)connectionEstablished:(GKSession *)newSession {
    self.session = newSession;
    self.session.delegate = self;
    [self.session setDataReceiveHandler:self withContext:nil];
    
    NSArray *peers = [self.session peersWithConnectionState:GKPeerStateConnected];
    self.serverPeerID = [peers objectAtIndex:0];
    
    if (SEND_HEARTBEATS) {
        [self beginSendingHeartBeats];
    }
}

- (void)connectionFailed {
    [vc connectionProblem];
}

- (void)serverReconnected {
    [vc restartGame];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    Packet *packet = [Packet getPacketFromReceivedData:data];
    switch (packet.packetCode) {
        case NETWORK_HEARTBEAT: {
            if (DEBUG_HEARTBEATS) {
                NSLog(@"Received Heartbeat from server");
            }
            if (self.serverDisconnected) {
                self.serverDisconnected = NO;
                [self serverReconnected];
            }
            self.lastHeartBeat = [NSDate date];
            break;
        }
        case NETWORK_STARTGAME: {
            vc.view = vc.countDownView;
            vc.remainingSeconds = 3;
            vc.showingTimer = NO;
            vc.countDownLabel.text = @"3";
            
            // vc.countDownTimer = [[[PausableTimer alloc] initWithTimeInterval:1 target:vc selector:@selector(countDownTimer:) repeats:YES userInfo:nil] autorelease];
            // [vc.countDownTimer startTimer];
            // [NSTimer scheduledTimerWithTimeInterval:1 target:vc selector:@selector(countDownTimer:) userInfo:nil repeats:YES];
            // [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            break;
        }
        case NETWORK_SEED: {
            int seed = [packet.objectData intValue];
            vc.currentQuestion = 0;
            vc.questionArray = [QuestionsArray selectX:NUMBEROFQUESTIONS randomQuestionsWithSeed:seed fromArray:[QuestionsArray allQuestions]];
            break;
        }
        case NETWORK_WASFIRST: {
            if (DEBUG_ANSWERS) {
                NSLog(@"Received Was First From Server");
            }
            [vc highLightSelectedAnswer];
            [vc highLightCorrectAnswer];
            [vc moveToNextQuestion];
            [vc.clockView removeFromSuperview];
            [vc.view addSubview:vc.timerView];
            break;
        }
        case NETWORK_WASSECOND: {
            if (DEBUG_ANSWERS) {
                NSLog(@"Received Was Second From Server");
            }
            [vc highLightCorrectAnswer];
            [vc moveToNextQuestion];
            [vc.clockView removeFromSuperview];
            [vc.view addSubview:vc.timerView];
            
            break;
        }
        case NETWORK_DISCONNECT: {
            [vc connectionProblem];
            break;
        }
        case NETWORK_RECONNECT: {
            [vc restartGame];
            break;
        }
        case NETWORK_WON: {
            vc.startGameButton.enabled = NO;
            //            [vc performSelector:@selector(gameOver:) withObject:[NSNumber numberWithInt:0] afterDelay:0];
            [vc gameOver:[NSNumber numberWithInt:0]];
            break;
        }
        case NETWORK_LOST: {
            vc.startGameButton.enabled = NO;
            //            [vc performSelector:@selector(gameOver:) withObject:[NSNumber numberWithInt:1] afterDelay:0];
            [vc gameOver:[NSNumber numberWithInt:1]];
            break;
        }
        case NETWORK_DRAW: {
            vc.startGameButton.enabled = NO;
            //            [vc performSelector:@selector(gameOver:) withObject:[NSNumber numberWithInt:2] afterDelay:0];
            [vc gameOver:[NSNumber numberWithInt:2]];
            break;
        }
        case NETWORK_RESTARTGAME: {
            //            [vc newGame];
            break;
        }
        case NETWORK_ENABLESTARTBUTTON: {
            vc.startGameButton.enabled = YES;
            break;
        }
        case NETWORK_ANSWERINGTIMER: {
            [vc timeRemainingChanged:nil];
            break;
        }
        case NETWORK_COUNTDOWNTIMER: {
            [vc countDownTimer:nil];
            break;
        }
        case NETWORK_HASANSWEREDTIMER: {
            [vc questionTimer:nil];
            break;
        }
//        case NETWORK_SCORE_RED: {
//            //            NSMutableArray *score = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//            //            NSString *blueScore = [score objectAtIndex:0];
//            //            NSString *redScore = [score objectAtIndex:1];
//            //            [vc updateScoreForRed:redScore AndBlue:blueScore];
//            NSString *score = [[NSString alloc] initWithData:packet.objectData encoding:NSASCIIStringEncoding];
//            NSLog(@"red:%@", score);
//            [vc updateScoreForRedPlayer:score];
//            break;
//        }
//        case NETWORK_SCORE_BLUE: {
//            NSString *score = [[NSString alloc] initWithData:packet.objectData encoding:NSASCIIStringEncoding];
//            NSLog(@"blue:%@", score);
//            [vc updateScoreForBluePlayer:score];
//            break;
//        }
        case NETWORK_UPDATE_SCORES: {
            NSArray *scores = [NSKeyedUnarchiver unarchiveObjectWithData:packet.objectData];
            NSString *blueScore = [scores objectAtIndex:0];
            NSString *redScore = [scores objectAtIndex:1];
            vc.questionsAnswered = [[scores objectAtIndex:2] intValue];
            [vc updateScoresForRed:redScore Blue:blueScore];
            break;
        }
        default:
            break;
    }
}

- (void)beginSendingHeartBeats {
    self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:HEARTBEATDELAY target:self selector:@selector(sendHeartBeat:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.heartBeatTimer forMode:NSRunLoopCommonModes];
    self.lastHeartBeat = [NSDate date];
}

- (void)disconnectFromServer {
    self.serverDisconnected = YES;
    [vc connectionProblem];
}

- (void)sendHeartBeat:(NSTimer *)timer {
    if (DEBUG_HEARTBEATS) {
        NSLog(@"Heartbeat packet delay %f",fabs([lastHeartBeat timeIntervalSinceNow]));
    }
    if (fabs([lastHeartBeat timeIntervalSinceNow]) >= MAXDELAY && lastHeartBeat != nil) {
        lastHeartBeat = nil;
        [self disconnectFromServer];
    }
    
    [self sendData:nil withCode:NETWORK_HEARTBEAT toPeers:[NSArray arrayWithObject:serverPeerID]];
}

@end

