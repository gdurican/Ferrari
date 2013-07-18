//
//  ClientViewController.m
//  ActellionQuizServer
//
//  Created by Silviu on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ClientViewController.h"
#import "PacketCodes.h"
#import "NSDataCategories.h"
#import "ServerConnection.h"
#import "FontUtils.h"

@implementation ClientViewController
@synthesize gameSession,searchingView,passwordView,triedServers,passwordField,serverName1,serverName2,serverID,waitingView,sName;
@synthesize playerColor;
@synthesize connected;
@synthesize tryingConnection;
@synthesize wrongPasswordLabel;
@synthesize connectingSpinner;
@synthesize searchingSpinner;
@synthesize infoTextView;
@synthesize peerList;
@synthesize serversView, serversList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.triedServers = [[[NSMutableArray alloc] init] autorelease];
        self.connected = NO;
        self.tryingConnection = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)backToMainMenu:(id)sender {
    gameSession.available = NO;
    gameSession.delegate = nil;
    [gameSession setDataReceiveHandler:nil withContext:NULL];
    self.gameSession = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FontUtils applyFont:SLAB_TALL_X forView:self.infoTextView];
    self.gameSession = [[[GKSession alloc] initWithSessionID:SESSIONID displayName:[UIDevice currentDevice].name sessionMode:GKSessionModeClient] autorelease];
    gameSession.delegate = self;
    gameSession.available = YES;
    [gameSession setDataReceiveHandler:self withContext:nil];
    wrongPasswordLabel.hidden = YES;
    passwordField.delegate = self;
    [self startSpin];
    
}

- (IBAction)cancelConnection:(id)sender {
    if (self.gameSession != nil && self.serverID != nil) {
        [gameSession sendData:nil toPeers:[NSArray arrayWithObject:serverID] withDataMode:GKSendDataReliable error:nil];
        [gameSession disconnectFromAllPeers];
        gameSession.delegate = nil;
        [gameSession setDataReceiveHandler:nil withContext:nil];
        self.gameSession = [[[GKSession alloc] initWithSessionID:SESSIONID displayName:[UIDevice currentDevice].name sessionMode:GKSessionModeClient] autorelease];
        gameSession.delegate = self;
        gameSession.available = YES;
        [gameSession setDataReceiveHandler:self withContext:nil];
        self.serverID = @"";
        self.connected = NO;
        self.tryingConnection = NO;
        [self stopSpin];
        [self startSpin];
        self.view = searchingView;
        [self.peerList release];
        self.peerList = nil;
    }
    
}

- (IBAction)validatePassword:(id)sender {
    [self sendData:[NSData createWithInt:[passwordField.text intValue]] withCode:NETWORK_PASSWORD toPeers:[NSArray arrayWithObject:serverID]];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    Packet *packet = [Packet getPacketFromReceivedData:data];
    switch (packet.packetCode) {
        case NETWORK_OKPASSWORD : {
            self.view = waitingView;
            [self startSpin];
            break;
        }
        case NETWORK_WRONGPASSWORD: {
            NSLog(@"Wrong Password");
            wrongPasswordLabel.hidden = NO;
            break;
        }
        case NETWORK_PLAYERCOLOR: {
            self.playerColor = [packet.objectData intValue];
        }
        case NETWORK_SERVERSTARTEDGAME: {
            gameSession.available = NO;
            [self showStartGameScreen];
            break;
        }
        case NETWORK_LEAVEGAME: {
            [self cancelConnection:nil];
        }
        default:
            break;
    }
}

- (void)showStartGameScreen {
    
    GamePlayViewController *gameplayViewController = playerColor == RedPlayer ?
    [[[GamePlayViewController alloc] initWithNibName:@"GamePlayViewControllerRed" bundle:nil] autorelease] :
    [[[GamePlayViewController alloc] initWithNibName:@"GamePlayViewControllerBlue" bundle:nil] autorelease] ;
    
    [gameSession setDataReceiveHandler:nil withContext:NULL];
    
    gameplayViewController.playerColor = playerColor;
    [gameplayViewController setUpWithSession:gameSession];
    UINavigationController *controller = self.navigationController;
    
    [[self retain] autorelease];
    
    [controller popViewControllerAnimated:NO];
    [controller pushViewController:gameplayViewController animated:YES];
}

- (void)sendData:(NSData *)data withCode:(PacketCode)code toPeers:(NSArray *)peers {
    [gameSession sendData:[Packet encodePacketWithData:data packetCode:code]
                  toPeers:peers
             withDataMode:GKSendDataReliable error:nil];
}


- (void)tryConnection:(NSString *)peer {
    if (!self.connected && !self.tryingConnection) {
        self.sName = [gameSession displayNameForPeer:peer];
        [gameSession connectToPeer:peer withTimeout:TIMEOUT];
        self.serverID = peer;
        self.tryingConnection = YES;
    }
}


- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    if (!self.connected) {
        [self startSpin];
        NSLog(@"Failed With Error: %d",error.code);
        [gameSession disconnectFromAllPeers];
        self.tryingConnection = NO;
        
        [self performSelector:@selector(tryingConnection) withObject:peerID afterDelay:2];
    }
}

- (void)loadPeerList:(GKSession *)session {
    self.peerList = [[NSMutableArray alloc] initWithArray:[session peersWithConnectionState:GKPeerStateAvailable]];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    if ([[error domain] isEqualToString:GKSessionErrorDomain] && [error code] == GKSessionCannotEnableError) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Bluetooth" message:@"Please turn bluetooth on." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state) {
        case GKPeerStateAvailable: {
            if (!self.connected) {
                NSLog(@"Connections available:");
                NSLog(@"%@ Is available",[session displayNameForPeer:peerID]);
                
                ServerConnection *connection = nil;
                for (ServerConnection *c in triedServers) {
                    if ([c.serverID isEqualToString:peerID]) {
                        connection = c;
                        break;
                    }
                }
                [self loadPeerList:session];
                [self.serversList reloadData];
//                for (NSString *peer in peerList) {
//                    NSLog(@"peer:  %@", [session displayNameForPeer:peer]);
//                }
                
                if (connection == nil) {
                    [self performSelector:@selector(tryConnection:) withObject:peerID afterDelay:0.2];
                } else {
                    [self performSelector:@selector(tryConnection:) withObject:peerID afterDelay:connection.connectionTime];
                }
            }
            break;
            
        }
        case GKPeerStateConnected: {
            //            if (!self.connected && self.gameSession != nil) {
            //                NSLog(@"Connected to %@",[session displayNameForPeer:peerID]);
            //                self.view = passwordView;
            //                [self stopSpin];
            //                self.serverName1.text = sName;
            //                self.serverName2.text = sName;
            //                self.passwordField.text = @"";
            //                self.connected = YES;
            //
            //                ServerConnection *connection = nil;
            //
            //                for (ServerConnection *c in triedServers) {
            //                    if (serverID != nil && [c.serverID isEqualToString:serverID]) {
            //                        connection = c;
            //                        break;
            //                    }
            //                }
            //
            //                if (connection == nil) {
            //                    connection = [[[ServerConnection alloc] initWithServerID:serverID] autorelease];
            //                    [self.triedServers addObject:connection];
            //                }
            //
            //                connection.connectionTime+=0.5;
            //                if (connection.connectionTime > 3) {
            //                    connection.connectionTime = 0.2;
            //                }
            //            }
            self.view = serversView;
            break;
        }
        case GKPeerStateDisconnected: {
            NSLog(@"Disconnected from %@",[session displayNameForPeer:peerID]);
            if ([peerID isEqualToString:serverID]) {
                self.connected = NO;
                self.serverID = @"";
                self.view = searchingView;
                self.tryingConnection = NO;
            }
            break;
        }
        case GKPeerStateUnavailable: {
            NSLog(@"%@ is no longer available", [session displayNameForPeer:peerID]);
            [self.serversList reloadData];
            break;
        }
        default:
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    self.gameSession = nil;
    self.searchingView = nil;
    self.passwordView = nil;
    self.triedServers = nil;
    self.waitingView = nil;
    self.sName = nil;
    self.serverID = nil;
    [super dealloc];
}

#pragma mark - spinner rotation
- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 1.0f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.connectingSpinner.transform = CGAffineTransformRotate(self.connectingSpinner.transform, M_PI / 2);
                         self.searchingSpinner.transform = CGAffineTransformRotate(self.searchingSpinner.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void) startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self sendData:[NSData createWithInt:[passwordField.text intValue]] withCode:NETWORK_PASSWORD toPeers:[NSArray arrayWithObject:serverID]];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.peerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text =[gameSession displayNameForPeer:[peerList objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
