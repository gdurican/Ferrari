//
//  ServerConnection.h
//  ActellionQuizServer
//
//  Created by Silviu on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

@property (nonatomic,retain) NSString *serverID;
@property (nonatomic,assign) float connectionTime;

- (id)initWithServerID:(NSString *)ID;

@end
