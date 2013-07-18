//
//  AppDelegate.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 02.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "SpectatorViewController.h"
#import "GamePlayViewController.h"
#import "QuestionAnswer.h"
#import "NSDataCategories.h"
#import "SpectatorViewController.h"
#import "GamePlayViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize homeViewController = _homeViewController;

- (void)dealloc
{
    [_window release];
    [_homeViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    application.idleTimerDisabled = YES;
    
    // Override point for customization after application launch.
    HomeViewController *root = [[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil] autorelease];
    
    UINavigationController *navig = [[[UINavigationController alloc] initWithRootViewController:root] autorelease];
    navig.navigationBar.hidden = YES;
    
    
    // self.window.rootViewController = navig;
    
    
    
    SpectatorViewController *vc2 = [[[SpectatorViewController alloc] init] autorelease];
    vc2.view = vc2.spectatorView;
    
    // GamePlayViewController *vc2 = [[[GamePlayViewController alloc] initWithNibName:@"GamePlayViewControllerBlue" bundle:nil] autorelease];
    //  vc2.view = vc2.gameplayView;
    
    self.window.rootViewController = navig;
    
    //SpectatorViewController *vc = [[[SpectatorViewController alloc] init] autorelease];
    
    //GamePlayViewController *vc = [[[GamePlayViewController alloc] init] autorelease];
    //
    //self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
