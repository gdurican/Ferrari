//
//  MultiplayerManager.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "MultiplayerManager.h"
#import "Packet.h"

@implementation MultiplayerManager
@synthesize session,heartBeatTimer;

- (void)showConnectionView {
    
}

- (void)sendData:(NSData *)data withCode:(PacketCode)code toPeers:(NSArray *)peers{
    GKSendDataMode mode = GKSendDataReliable;
    if (code == NETWORK_HEARTBEAT) {
        mode = GKSendDataUnreliable;
    }
    [self.session sendData:[Packet encodePacketWithData:data packetCode:code]
                   toPeers:peers
              withDataMode:mode error:nil];
}

- (void)invalidateSession:(GKSession *)gsession {
	if(gsession != nil) {
		[gsession disconnectFromAllPeers];
		gsession.available = NO;
		[gsession setDataReceiveHandler: nil withContext: NULL];
		gsession.delegate = nil;
	}
}

- (void)beginSendingHeartBeats {
    
}

- (void)sendHeartBeat:(NSTimer *)timer {
    
}

- (void)dealloc {
    [super dealloc];
}

@end
