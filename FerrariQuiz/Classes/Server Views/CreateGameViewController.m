//
//  CreateGameViewController.m
//  ActellionQuizServer
//
//  Created by Silviu on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateGameViewController.h"
#import "Packet.h"
#import "NSDataCategories.h"
#import "PacketCodes.h"
#import "SpectatorViewController.h"
#import "FontUtils.h"

@implementation CreateGameViewController
@synthesize startButton,exchangeColorsButton,passwordLabel,bluePlayerLabel,redPlayerLabel,gameSession,redPlayerPeerID,bluePlayerPeerID,connectedPlayerCount;
@synthesize redEnteredPassword,blueEnteredPassword;
@synthesize redPlayerView,bluePlayerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.redEnteredPassword = NO;
        self.blueEnteredPassword = NO;
    }
    return self;
}

- (IBAction)exchangeColors:(id)sender {
    
    NSString *temp = self.bluePlayerPeerID;
    self.bluePlayerPeerID = self.redPlayerPeerID;
    self.redPlayerPeerID = temp;
    
//    temp = redPlayerLabel.text;
//    redPlayerLabel.text = bluePlayerLabel.text;
//    bluePlayerLabel.text = temp;
    
    BOOL tempb = redEnteredPassword;
    redEnteredPassword = blueEnteredPassword;
    blueEnteredPassword = tempb;
    
    if (ANIMATE_INVERTCOLORS) {
        CGRect tempRect = redPlayerView.frame;
        [UIView animateWithDuration:0.5 animations:^{
            redPlayerView.frame = bluePlayerView.frame;
            bluePlayerView.frame = tempRect;
        }];
    }
}

- (IBAction)startGame:(id)sender {
    gameSession.available = NO;
    if (START_WITH_ONE_PLAYER) {
        self.redPlayerPeerID = @"Red";
    }
    
    [self sendData:[NSData createWithInt:BluePlayer] withCode:NETWORK_PLAYERCOLOR toPeers:[NSArray arrayWithObject:bluePlayerPeerID]];
    [self sendData:[NSData createWithInt:RedPlayer] withCode:NETWORK_PLAYERCOLOR toPeers:[NSArray arrayWithObject:redPlayerPeerID]];
    
    [self sendData:nil withCode:NETWORK_SERVERSTARTEDGAME toPeers:[gameSession peersWithConnectionState:GKPeerStateConnected]];
    
    SpectatorViewController *spectatorViewController = [[[SpectatorViewController alloc] init] autorelease];
    
    [gameSession setDataReceiveHandler:nil withContext:NULL];
    [spectatorViewController setUpWithSession:gameSession andRedPlayerPeerID:redPlayerPeerID andBluePlayerPeerID:bluePlayerPeerID];
    
    UINavigationController *controller = self.navigationController;
    
    [[self retain] autorelease];
    
    [controller popViewControllerAnimated:NO];
    [controller pushViewController:spectatorViewController animated:YES];
}

- (IBAction)cancelGame:(id)sender {
    [gameSession sendDataToAllPeers:[Packet encodePacketWithData:nil packetCode:NETWORK_LEAVEGAME] withDataMode:GKSendDataReliable error:nil];
    gameSession.available = NO;
    gameSession.delegate = nil;
    [gameSession disconnectFromAllPeers];
    self.gameSession = nil;
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.startButton.enabled = NO;
    self.exchangeColorsButton.enabled = NO;
    self.bluePlayerLabel.text = @"";
    self.redPlayerLabel.text = @"";
//    self.passwordLabel.text = [NSString stringWithFormat:@"%d",100000 + arc4random() % 900000];
    self.passwordLabel.text = PASSWORD;
    self.gameSession = [[[GKSession alloc] initWithSessionID:SESSIONID
                                                 displayName:[UIDevice currentDevice].name 
                                                 sessionMode:GKSessionModeServer] autorelease];
    
    gameSession.delegate = self;
    gameSession.available = YES;
    [gameSession setDataReceiveHandler:self withContext:nil];
    
    self.connectedPlayerCount = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)handleDisconnectFromPeer:(NSString *)peerID {
    if ([peerID isEqualToString:bluePlayerPeerID]) {
        self.bluePlayerPeerID = nil;
        self.bluePlayerLabel.text = @"";
        self.connectedPlayerCount--;
        self.blueEnteredPassword = NO;
        self.startButton.enabled = NO;
    } else if ([peerID isEqualToString:redPlayerPeerID]) {
        self.redEnteredPassword = NO;
        self.redPlayerLabel.text = @"";
        self.redPlayerPeerID = nil;
        self.connectedPlayerCount--;
        self.startButton.enabled = NO;
    }
    self.exchangeColorsButton.enabled = self.connectedPlayerCount == 2;
    
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    Packet *packet = [Packet getPacketFromReceivedData:data];
    
    switch (packet.packetCode) {
        case NETWORK_PASSWORD: {
            NSString *password = [NSString stringWithFormat:@"%d",[packet.objectData intValue]];
            if ([password isEqualToString:passwordLabel.text]) {
                if ([peer isEqualToString:redPlayerPeerID]) {
                    redEnteredPassword = YES;
                    redPlayerLabel.text = [[gameSession displayNameForPeer:peer] stringByAppendingString:@"- connectat"];
                    [self sendData:nil withCode:NETWORK_OKPASSWORD toPeers:[NSArray arrayWithObject:peer]];
                } else {
                    blueEnteredPassword = YES;
                    bluePlayerLabel.text = [[gameSession displayNameForPeer:peer] stringByAppendingString:@"- connectat"];
                    [self sendData:nil withCode:NETWORK_OKPASSWORD toPeers:[NSArray arrayWithObject:peer]];
                }
            } else {
                [self sendData:nil withCode:NETWORK_WRONGPASSWORD toPeers:[NSArray arrayWithObject:peer]];
            }
            if (redEnteredPassword && blueEnteredPassword) {
                startButton.enabled = YES;
            }
            break;
        }
        case NETWORK_LEAVEGAME: {
            [self handleDisconnectFromPeer:peer];
            break;
        }
        default:
            break;
    }
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state) {
        case GKPeerStateAvailable: {
            break;
        }
        case GKPeerStateConnected: {
            break;
        }
        case GKPeerStateDisconnected : {
            [self handleDisconnectFromPeer:peerID];
        }
        default:
            break;
    }
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    if ([[error domain] isEqualToString:GKSessionErrorDomain] && [error code] == GKSessionCannotEnableError) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Bluetooth" 
                                                         message:@"Please turn bluetooth on." 
                                                        delegate:self 
                                               cancelButtonTitle:@"Cancel" 
                                               otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (void)sendData:(NSData *)data withCode:(PacketCode)code toPeers:(NSArray *)peers {
    [gameSession sendData:[Packet encodePacketWithData:data packetCode:code] 
                   toPeers:peers
              withDataMode:GKSendDataReliable error:nil];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    if (self.connectedPlayerCount == 2) {
        [gameSession denyConnectionFromPeer:peerID];
        return;
    }
    self.connectedPlayerCount++;
    
    if (START_WITH_ONE_PLAYER) {
        startButton.enabled = YES;
    }
    
    if (connectedPlayerCount == 2 && !CHECK_PASSWORD) {
        startButton.enabled = YES;
    }
    
    self.exchangeColorsButton.enabled = self.connectedPlayerCount == 2;

    if (self.bluePlayerPeerID == nil) {
        self.bluePlayerPeerID = peerID;
        self.bluePlayerLabel.text = [gameSession displayNameForPeer:peerID];
    } else if (self.redPlayerPeerID == nil) {
        self.redPlayerPeerID = peerID;
        self.redPlayerLabel.text = [gameSession displayNameForPeer:peerID];
    }
    
    [gameSession acceptConnectionFromPeer:peerID error:nil];
}

- (void)dealloc {
    self.gameSession = nil;
    self.redPlayerPeerID = nil;
    self.bluePlayerPeerID = nil;
    [super dealloc];
}


@end
