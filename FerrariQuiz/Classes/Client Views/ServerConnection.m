//
//  ServerConnection.m
//  ActellionQuizServer
//
//  Created by Silviu on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ServerConnection.h"

@implementation ServerConnection

@synthesize serverID,connectionTime;

- (id)initWithServerID:(NSString *)ID {
    self = [super init];
    if (self != nil) {
        self.serverID = ID;
        self.connectionTime = 0.2;
    }
    return self;
}

@end
