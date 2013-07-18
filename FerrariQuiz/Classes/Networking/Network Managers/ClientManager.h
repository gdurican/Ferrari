//
//  ClientManager.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiplayerManager.h"

@class GamePlayViewController;
@interface ClientManager : MultiplayerManager

@property (nonatomic,retain) NSString *serverPeerID;
@property (nonatomic,retain) NSDate *lastHeartBeat;
@property (nonatomic,assign) GamePlayViewController *vc;
@property (nonatomic,assign) BOOL serverDisconnected;

- (id)initWithViewController:(GamePlayViewController *)v;
- (void)disconnectFromServer;
- (void)sendHeartBeat:(NSTimer *)timer;
- (void)connectionEstablished:(GKSession *)newSession;

@end
