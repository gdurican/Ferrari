//
//  Player.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic, retain) NSString *peerID;
@property (nonatomic, assign) int score;
@property (nonatomic, retain) NSDate *lastHeartBeat;
@property (nonatomic, assign) BOOL requestedStartGame;
@property (nonatomic, assign) float timeForAnswer;
@property (nonatomic, assign) BOOL lastAnswerWasCorrect;
@property (nonatomic, assign) BOOL connectionLost;


- (id)initWithPeerID:(NSString *)ID;
- (void)resetTime;
- (void)resetScore;

@end