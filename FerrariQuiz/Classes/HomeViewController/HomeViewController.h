//
//  HomeViewController.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 02.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

- (IBAction)startServer:(id)sender;
- (IBAction)startClient:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *startServerButton;
@property (retain, nonatomic) IBOutlet UIButton *startClientButton;
@property (retain, nonatomic) IBOutlet UITextView *infoTextView;

@end
