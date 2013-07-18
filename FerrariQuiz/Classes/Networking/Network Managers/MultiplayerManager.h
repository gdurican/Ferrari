//
//  MultiplayerManager.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "PacketCodes.h"

#define HEARTBEATDELAY 0.2
#define MAXDELAY 1

@interface MultiplayerManager : NSObject <GKSessionDelegate>

@property (nonatomic,retain) GKSession *session;
@property (nonatomic,retain) NSTimer *heartBeatTimer;

- (void)sendData:(NSData *)data withCode:(PacketCode)code toPeers:(NSArray *)peers;

- (void)showConnectionView;
- (void)invalidateSession:(GKSession *)gsession;
- (void)beginSendingHeartBeats;
- (void)sendHeartBeat:(NSTimer *)timer;

@end

