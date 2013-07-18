//
//  HomeViewController.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 02.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "HomeViewController.h"
#import "QuestionParser.h"
#import "ClientViewController.h"
#import "CreateGameViewController.h"
#import "GamePlayViewController.h"
#import "SoundManager.h"
#import "QuestionsArray.h"
#import "FontUtils.h"

@implementation HomeViewController
@synthesize startClientButton;
@synthesize startServerButton;
@synthesize infoTextView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [SoundManager loadSoundFiles];
    
    NSArray *arr = [QuestionsArray allQuestions];
    
    [FontUtils applyFont:SLAB_TALL_X forView:startClientButton];
    [FontUtils applyFont:SLAB_TALL_X forView:startServerButton];
    [FontUtils applyFont:SLAB_TALL_X forView:infoTextView];
    
    for (Question *q in arr) {
        if (q.explanation.length < 10) {
//            NSLog(@"Statement: %@",q.statement);
//            NSLog(@"Reference: %@",q.reference);
//            NSLog(@"Correction: %@",q.explanation);
        }
    }
}

- (IBAction)startClient:(id)sender {
    ClientViewController *clientVC = [[[ClientViewController alloc] init] autorelease];
    [self.navigationController pushViewController:clientVC animated:YES];
}

- (IBAction)startServer:(id)sender {
    CreateGameViewController *serverVC = [[[CreateGameViewController alloc] init] autorelease];
    [self.navigationController pushViewController:serverVC animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)dealloc {
    [startClientButton release];
    [startServerButton release];
    [infoTextView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setStartClientButton:nil];
    [self setStartClientButton:nil];
    [self setInfoTextView:nil];
    [super viewDidUnload];
}
@end
