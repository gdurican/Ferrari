//
//  CreateGameViewController.h
//  ActellionQuizServer
//
//  Created by Silviu on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/Gamekit.h>
#import "PacketCodes.h"

@interface CreateGameViewController : UIViewController <GKSessionDelegate>

@property (nonatomic, assign) IBOutlet UIButton *startButton;
@property (nonatomic, assign) IBOutlet UIButton *exchangeColorsButton;
@property (nonatomic, assign) IBOutlet UILabel *passwordLabel;
@property (nonatomic, assign) IBOutlet UILabel *bluePlayerLabel;
@property (nonatomic, assign) IBOutlet UILabel *redPlayerLabel;
@property (nonatomic, retain) GKSession *gameSession;
@property (nonatomic, assign) int connectedPlayerCount;
@property (nonatomic, retain) NSString *redPlayerPeerID;
@property (nonatomic, retain) NSString *bluePlayerPeerID;
@property (nonatomic, assign) BOOL redEnteredPassword;
@property (nonatomic, assign) BOOL blueEnteredPassword;
@property (nonatomic, assign) IBOutlet UIView *redPlayerView;
@property (nonatomic, assign) IBOutlet UIView *bluePlayerView;

- (IBAction)startGame:(id)sender;
- (IBAction)cancelGame:(id)sender;
- (IBAction)exchangeColors:(id)sender;
- (void)sendData:(NSData *)data withCode:(PacketCode)code toPeers:(NSArray *)peers;

@end
