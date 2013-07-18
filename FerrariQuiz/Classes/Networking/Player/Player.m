//
//  Player.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize peerID,score,lastHeartBeat,requestedStartGame,timeForAnswer,lastAnswerWasCorrect,connectionLost;

- (id)initWithPeerID:(NSString *)ID {
    self = [super init];
    if (self != nil) {
        self.peerID = ID;
        self.score = 0;
        self.lastHeartBeat = [NSDate date];
        self.requestedStartGame = NO;
        self.timeForAnswer = MAXFLOAT;
        self.lastAnswerWasCorrect = NO;
        self.connectionLost = NO;
    }
    return self;
}

- (void)resetTime {
    self.timeForAnswer = MAXFLOAT;
    self.lastAnswerWasCorrect = NO;
}

- (void)resetScore {
    self.score = 0;
    self.requestedStartGame = NO;
    self.timeForAnswer = MAXFLOAT;
    self.lastAnswerWasCorrect = NO;
    self.connectionLost = NO;
}

- (void)dealloc {
    self.peerID = nil;
}

@end


