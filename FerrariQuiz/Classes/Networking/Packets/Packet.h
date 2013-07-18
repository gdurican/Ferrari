//
//  Packet.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PacketCodes.h"

@interface Packet : NSObject {
    NSData *objectData;
    int packetNumber;
    PacketCode packetCode;
}

@property (nonatomic,retain) NSData *objectData;
@property (nonatomic,assign) int packetNumber;
@property (nonatomic,assign) PacketCode packetCode;

+ (NSData *)encodePacketWithData:(NSData *)data packetCode:(PacketCode)code;
+ (Packet *)getPacketFromReceivedData:(NSData *)data;

@end
