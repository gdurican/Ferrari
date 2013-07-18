//
//  Packet.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "Packet.h"
#include "PacketCodes.h"

@implementation Packet
@synthesize packetCode,packetNumber,objectData;

static int greatestPacketNumber = 0;

+ (NSData *)encodePacketWithData:(NSData *)data packetCode:(PacketCode)code {
    int header[2];
    header[0] = greatestPacketNumber;
    header[1] = code;
    greatestPacketNumber++;
    
    NSMutableData *packetData = [NSMutableData dataWithBytes:header length:sizeof(int) * 2];
    [packetData appendData:data];
    return packetData;
}

+ (Packet *)getPacketFromReceivedData:(NSData *)data {
    Packet *result = [[[Packet alloc] init] autorelease];
    
    if (self != nil) {
        int *bytes = (int *)[data bytes];
        result.packetNumber = bytes[0];
        result.packetCode = bytes[1];
        result.objectData = [NSData dataWithBytes:[data bytes] + sizeof(int) * 2 length:[data length] - sizeof(int) * 2];
    }
    
    return result;
}

@end
