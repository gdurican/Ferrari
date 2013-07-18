//
//  ServerManager.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiplayerManager.h"
#import "Player.h"
#import "QuizGame.h"
#define ANTILAG 0

@class SpectatorViewController;
@interface ServerManager : MultiplayerManager

@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, retain) QuizGame *quizGame;
@property (nonatomic, assign) SpectatorViewController *vc;
@property (nonatomic, retain) NSMutableArray *clientIDs;
@property (nonatomic, assign) int remainingTime;
@property (nonatomic, assign) int remainingHasAnsweredTime;

- (id)initWithViewController:(SpectatorViewController *)v;
- (void)connectionEstablished:(GKSession *)newSession withRedPeerID:(NSString *)redID andBluePeerID:(NSString *)blueID;
- (void)disconnectDetectedForClient:(Player *)c;
- (void)sendHeartBeat:(NSTimer *)timer;
- (Player *)playerByPeerID:(NSString *)ID;
- (void)sendAnswer;
- (void)startNewGame;
- (void)startHasAnsweredTimer;
- (Player *)rivalPlayer:(Player *)player;

@end

