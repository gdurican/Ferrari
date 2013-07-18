//
//  ClientViewController.h
//  ActellionQuizServer
//
//  Created by Silviu on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Gamekit/Gamekit.h>
#import "Packet.h"
#import "GamePlayViewController.h"
#define TIMEOUT 4

@interface ClientViewController : UIViewController <GKSessionDelegate, UITextFieldDelegate> {
    BOOL animating;
}

@property (nonatomic, retain) GKSession *gameSession;
@property (nonatomic, retain) IBOutlet UIView *searchingView;
@property (nonatomic, retain) IBOutlet UIView *passwordView;
@property (nonatomic, retain) NSMutableArray *triedServers;
@property (nonatomic, assign) IBOutlet UITextField *passwordField;
@property (nonatomic, assign) IBOutlet UILabel *serverName1;
@property (nonatomic, assign) IBOutlet UILabel *serverName2;
@property (nonatomic, retain) NSString *serverID;
@property (nonatomic, retain) IBOutlet UIView *waitingView;
@property (nonatomic, retain) NSString *sName;
@property (nonatomic, assign) PlayerColor playerColor;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, assign) BOOL tryingConnection;
@property (nonatomic, assign) IBOutlet UILabel *wrongPasswordLabel;
@property (nonatomic, assign) IBOutlet UIImageView *connectingSpinner;
@property (nonatomic, assign) IBOutlet UIImageView *searchingSpinner;
@property (nonatomic, assign) IBOutlet UITextView *infoTextView;
@property (nonatomic, assign) NSMutableArray *peerList;
@property (nonatomic, retain) IBOutlet UIView *serversView;
@property (nonatomic, retain) IBOutlet UITableView *serversList;

- (IBAction)cancelConnection:(id)sender;
- (IBAction)validatePassword:(id)sender;
- (void)sendData:(NSData *)data withCode:(PacketCode)code toPeers:(NSArray *)peers;
- (void)showStartGameScreen;
- (IBAction)backToMainMenu:(id)sender;

@end
