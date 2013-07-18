//
//  QuizGame.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "QuizGame.h"
#import "QuestionsArray.h"
#import "Player.h"
#import "ServerManager.h"

@implementation QuizGame
@synthesize redPlayer,bluePlayer,questions,currentQuestion,seed,redAnsweredLastQuestion,decidingWinner,answeredQuestions,noAnswer,playerWasCorrect;

- (id)initWithRedPlayerID:(NSString *)redPlayerID bluePlayer:(NSString *)bluePlayerID andQuestionArray:(NSArray *)questionArray {
    self = [super init];
    if (self != nil) {
        self.currentQuestion = 0;
        self.redPlayer = [[[Player alloc] initWithPeerID:redPlayerID] autorelease];
        self.bluePlayer = [[[Player alloc] initWithPeerID:bluePlayerID] autorelease];
        self.seed = time(NULL);
        self.questions = [QuestionsArray selectX:NUMBEROFQUESTIONS randomQuestionsWithSeed:seed fromArray:questionArray];
        self.decidingWinner = NO;
        self.answeredQuestions = 0;
        self.noAnswer = YES;
    }
    return self;
}

- (BOOL)isEndOfGame {
    return currentQuestion >= NUMBEROFQUESTIONS;
}

- (void)receiveAnswerFrom:(NSString *)peerID forQuestionIndex:(int)index andAnswerState:(BOOL)correct andTime:(float)time {
    self.noAnswer = NO;
    if (index < currentQuestion) {
        return;
    }
    
    Player *player = [self getClientByPeerId:peerID];
    player.timeForAnswer = time;
    
    if (correct) {
        player.lastAnswerWasCorrect = YES;
    } else {
        player.lastAnswerWasCorrect = NO;
    }
    
    if (!self.decidingWinner) {
        self.answeredQuestions++;
        self.decidingWinner = YES;
        [self performSelector:@selector(decideWinner) withObject:nil afterDelay:ANTILAG];
    }
}

- (void)clearPlayers {
    [redPlayer resetTime];
    [bluePlayer resetTime];
}

- (void)decideWinner {
    currentQuestion++;
    
    Player *firstPlayer = redPlayer.timeForAnswer < bluePlayer.timeForAnswer ? redPlayer : bluePlayer;
    
    if (firstPlayer.lastAnswerWasCorrect) {
        firstPlayer.score++;
    } else {
        Player *rival = [self getRivalPlayer:firstPlayer];
        rival.score++;
    }
    
    
    self.playerWasCorrect = firstPlayer.lastAnswerWasCorrect;
    
    if ([firstPlayer.peerID isEqualToString:redPlayer.peerID]) {
        self.redAnsweredLastQuestion = YES;
    } else {
        self.redAnsweredLastQuestion = NO;
    }
    self.decidingWinner = NO;
}

- (Player *)getClientByPeerId:(NSString *)peerID {
    if ([redPlayer.peerID isEqualToString:peerID]) {
        return redPlayer;
    } else return bluePlayer;
}

- (Player *)getRivalPlayer:(Player *)player {
    if ([player.peerID isEqualToString:redPlayer.peerID]) {
        return bluePlayer;
    } else {
        return redPlayer;
    }
}


- (EndGameState)endGameStateForBluePlayer {
    if (redPlayer.score == bluePlayer.score) {
        return GAME_DRAW;
    } else if (bluePlayer.score > redPlayer.score) {
        return GAME_WIN;
    }
    return GAME_LOSE;
}

- (EndGameState)endGameStateForRedPlayer {
    if (redPlayer.score == bluePlayer.score) {
        return GAME_DRAW;
    } else if (redPlayer.score > bluePlayer.score) {
        return GAME_WIN;
    }
    return GAME_LOSE;
}

- (void)dealloc {
    self.questions = nil;
    self.bluePlayer = nil;
    self.redPlayer = nil;
    [super dealloc];
}

@end

