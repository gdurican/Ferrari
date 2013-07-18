//
//  GamePlayViewController.m
//  ActellionQuizServer
//
//  Created by Silviu on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GamePlayViewController.h"
#import "Packet.h"
#import "NSDataCategories.h"
#import "Question.h"
#import "QuestionsArray.h"
#import "ClientManager.h"
#import "SoundManager.h"
#import "PausableTimer.h"
#import "UILabel+FitToFrame.h"
#import "QuartzCore/QuartzCore.h"
#import "HomeViewController.h"
#define PERCENTAGE 0.143

@implementation GamePlayViewController
@synthesize statementLabel,answer1Button,answer2Button,answer3Button,answer4Button,answerLabels,countDownLabel,nextQuestionCountDown,questionNumberLabel;
@synthesize countDownView,joinGameView,gameplayView,waitingForPlayerView;
@synthesize remainingSeconds,currentQuestion,questionArray,allQuestions,nextQuestionTime,showingTimer,selectedIndex;
@synthesize startTime;
@synthesize timerView,clockView,gameOverView;
@synthesize gamePaused;
@synthesize clientManager;
@synthesize permanentFailureView,reconnectingView;
@synthesize playerColor;
@synthesize questionWaveTimer,remainingTime;
@synthesize waveStartDate,timeSinceWaveStart;
@synthesize answer1Label,answer2Label,answer3Label,answer4Label;
@synthesize endGameLabelTop,endGameLabelBottom;
@synthesize startGameButton;
@synthesize answeringTimer,hasAnsweredTimer,countDownTimer;
@synthesize stopLight1, stopLight2, stopLight3, stopLight4, stopLight5;
@synthesize bluePlayerRect, redPlayerRect, blueScoreLabel, redScoreLabel, rectContainerView;
@synthesize questionsAnswered;

static UIImage *correctQuestionImage;
static UIImage *grayQuestionImage;
static UIImage *redQuestionImage;
static UIImage *blueQuestionImage;
static UIImage *blueQuestionText;
static UIImage *redQuestionText;
static UIImage *redResponseText;
static UIImage *blueResponseText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.gamePaused = NO;
        correctQuestionImage = [UIImage imageNamed:@"question_field_active"];
        [correctQuestionImage retain];
        grayQuestionImage = [UIImage imageNamed:@"question_field"];
        [grayQuestionImage retain];
        blueQuestionImage = [UIImage imageNamed:@"question_field"];
        [blueQuestionImage retain];
        redQuestionImage = [UIImage imageNamed:@"question_field"];
        [redQuestionImage retain];
        
        redQuestionText = [UIImage imageNamed:@"question_field"];
        [redQuestionText retain];
        blueQuestionText = [UIImage imageNamed:@"question_field"];
        [blueQuestionText retain];
        redResponseText = [UIImage imageNamed:@"question_field"];
        [redResponseText retain];
        blueResponseText = [UIImage imageNamed:@"question_field"];
        [blueResponseText retain];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    timerView.frame = clockView.frame;
    
    NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"tag" ascending:true] autorelease];
//    self.bubbles = [bubbles sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
//    maskOriginalFrame = waveMask.frame;
//    self.selectedViews = [selectedViews sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}

- (void)hideSelections {
//    for (UIView *v in selectedViews) {
//        v.alpha = 0;
//    }
}
- (void)setBackGroundForButton:(UIButton *)b andAnswer:(NSString *)answer {
    Question *q = [questionArray objectAtIndex:currentQuestion - 1];
    
    [b setBackgroundImage:[answer isEqualToString:[q correctAnswer]] ? correctQuestionImage : grayQuestionImage forState:UIControlStateNormal];
}

- (void)setUpWithSession:(GKSession *)session {
    self.clientManager = [[[ClientManager alloc] initWithViewController:self] autorelease];
    [clientManager connectionEstablished:session];
}

- (IBAction)didPressAnwer:(id)sender {
    if (DEBUG_ANSWERS) {
        //        NSLog(@"Answer Button Tapped");
    }
    self.selectedIndex = [sender tag];
    Question *q = [questionArray objectAtIndex:currentQuestion - 1];
    QuestionAnswer *answer = [[[QuestionAnswer alloc] init] autorelease];
    answer.index = currentQuestion - 1;
    answer.isCorrect = [[q.answers objectAtIndex:[sender tag]] isEqualToString:q.correctAnswer];
    
    answer.timeForAnswer = fabs([startTime timeIntervalSinceNow]);
    
    if (DEBUG_ANSWERS) {
        //        NSLog(@"Sending Answer Data To Server");
    }
    [clientManager sendData:[NSData createWithQuestionAnswer:answer] withCode:NETWORK_ANSWER toPeers:[NSArray arrayWithObject:clientManager.serverPeerID]];
    
    
    answer1Button.userInteractionEnabled = NO;
    answer2Button.userInteractionEnabled = NO;
    answer3Button.userInteractionEnabled = NO;
    answer4Button.userInteractionEnabled = NO;
    //[answeringTimer invalidate];
}

- (void)highLightSelectedAnswer {
    Question *q = [questionArray objectAtIndex:currentQuestion - 1];
    
    UIButton *button = nil;
    
    switch (self.selectedIndex) {
        case 0:
            button = answer1Button;
            break;
        case 1:
            button = answer2Button;
            break;
        case 2:
            button = answer3Button;
            break;
        case 3:
            button = answer4Button;
    }
    
    if ([[q.answers objectAtIndex:selectedIndex] isEqualToString:q.correctAnswer]) {
        
        [button setBackgroundImage:correctQuestionImage forState:UIControlStateNormal];
        [[SoundManager sharedInstance] playSound:CorrectSound];
    } else {
//        [[selectedViews objectAtIndex:selectedIndex] setAlpha:1];
        [[SoundManager sharedInstance] playSound:WrongSound];
    }
}

- (void)highLightCorrectAnswer {
    
    [self setBackGroundForButton:answer1Button andAnswer:answer1Label.text];
    [self setBackGroundForButton:answer2Button andAnswer:answer2Label.text];
    [self setBackGroundForButton:answer3Button andAnswer:answer3Label.text];
    [self setBackGroundForButton:answer4Button andAnswer:answer4Label.text];
}

- (void)moveToNextQuestion {
    if (!self.showingTimer) {
        self.showingTimer = YES;
        answer1Button.userInteractionEnabled = NO;
        answer2Button.userInteractionEnabled = NO;
        answer3Button.userInteractionEnabled = NO;
        answer4Button.userInteractionEnabled = NO;
        
//        self.headertextImageView.image = playerColor == RedPlayer ? redResponseText : blueResponseText;
        self.nextQuestionTime = TIMEAFTERQUESITON;
        self.nextQuestionCountDown.text = [NSString stringWithFormat:@"%ds",TIMEAFTERQUESITON];
        self.hasAnsweredTimer = [[[PausableTimer alloc] initWithTimeInterval:1 target:self selector:@selector(questionTimer:) repeats:YES userInfo:nil] autorelease];
        // [hasAnsweredTimer startTimer];
        //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(questionTimer:) userInfo:nil repeats:YES];
        //[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (IBAction)startGamePressed:(id)sender {
    self.view = waitingForPlayerView;
    [[SoundManager sharedInstance] stopAllSounds];
    [clientManager sendData:nil withCode:NETWORK_REQUESTSTART toPeers:[NSArray arrayWithObject:clientManager.serverPeerID]];
}

- (void)questionTimer:(NSTimer *)timer {
    
    self.nextQuestionTime--;
    
    self.nextQuestionCountDown.text = [NSString stringWithFormat:@"%ds",nextQuestionTime];
    if (nextQuestionTime == 0) {
        //[hasAnsweredTimer invalidate];
        
        [self showCurrentQuestion];
        self.showingTimer = NO;
        [timerView removeFromSuperview];
        [self.view addSubview:clockView];
    }
}

- (void)gameOver:(NSNumber *)won {
    self.questionsAnswered = 0;
    [self resetScores];
    
    self.view = gameOverView;
    int status = [won intValue];
    if (status == 0) {
        endGameLabelTop.text = WINTOPLABEL;
        endGameLabelBottom.text = WINBOTTOMLABEL;
    } else if (status == 1) {
        endGameLabelTop.text = LOSETOPLABEL;
        endGameLabelBottom.text = LOSEBOTTOMLABEL;
    } else {
        endGameLabelTop.text = DRAWTOPLABEL;
        endGameLabelBottom.text = DRAWBOTTOMLABEL;
    }
}

- (void)setButtonTitle:(UIButton *)button title:(NSString*)string {
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitle:string forState:UIControlStateHighlighted];
    [button setTitle:string forState:UIControlStateDisabled];
    [button setTitle:string forState:UIControlStateSelected];
}

- (void)timeRemainingChanged:(NSTimer *)timer {
    self.remainingTime--;
    
    //    NSLog(@"%f",maskOriginalFrame.size.width - maskOriginalFrame.size.width * (( 7.0 - remainingTime) / 6.0));
    
    if (self.remainingTime == 0) {
        //[answeringTimer invalidate];
        [clientManager sendData:[NSData createWithInt:self.currentQuestion - 1] withCode:NETWORK_TIMEEXPIRED toPeers:[NSArray arrayWithObject:clientManager.serverPeerID]];
    } else {
        //        [waveMask.layer removeAllAnimations];
        //        [UIView animateWithDuration:TIMEPERQUESTION / 6.0
        //                              delay:0
        //                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
        //                         animations:^{
        //                             waveMask.frame = CGRectMake(maskOriginalFrame.origin.x + maskOriginalFrame.size.width * ((7.0 - remainingTime) / 6.0),
        //                                                         maskOriginalFrame.origin.y,
        //                                                         maskOriginalFrame.size.width - maskOriginalFrame.size.width * (( 7.0 - remainingTime) / 6.0) ,
        //                                                         waveMask.frame.size.height);}
        //                         completion:^(BOOL finished){}];
        //
        //
        //        [UIView animateWithDuration:0.3 animations:^{
        //            if (5 - remainingTime < 5) {
        //                [[bubbles objectAtIndex:5 - remainingTime] setAlpha:1];
        //            }
        //        }];
        NSLog(@"secs: %d", remainingSeconds);
        NSLog(@"time: %d", remainingTime);
        switch (remainingTime) {
            case 5:
                stopLight1.image = [UIImage imageNamed:@"stop_red_active"];
                break;
            case 4:
                stopLight2.image = [UIImage imageNamed:@"stop_red_active"];
                break;
            case 3:
                stopLight3.image = [UIImage imageNamed:@"stop_red_active"];
                break;
            case 2:
                stopLight4.image = [UIImage imageNamed:@"stop_yellow_active"];
                break;
            case 1:
                stopLight5.image = [UIImage imageNamed:@"stop_green_active"];
                break;
            default:
                break;
        }
    }
}

//- (void)newGame {
//    self.clockView.hidden = NO;
//    self.timerView.hidden = NO;
//    [gameplayView addSubview:clockView];
//    self.view = joinGameView;
//    [[SoundManager sharedInstance] playSound:WaitingMusic];
//}

- (void)showCurrentQuestion {
    
    stopLight1.image = [UIImage imageNamed:@"stop_red_inactive"];
    stopLight2.image = [UIImage imageNamed:@"stop_red_inactive"];
    stopLight3.image = [UIImage imageNamed:@"stop_red_inactive"];
    stopLight4.image = [UIImage imageNamed:@"stop_yellow_inactive"];
    stopLight5.image = [UIImage imageNamed:@"stop_green_inactive"];
//    self.headertextImageView.image = (playerColor == RedPlayer ? redQuestionText : blueQuestionText);
    
    [self hideSelections];
    
    //    NSLog(@"%d",playerColor);
    
    [answer1Button setBackgroundImage:playerColor == RedPlayer ? redQuestionImage : blueQuestionImage forState:UIControlStateNormal];
    [answer2Button setBackgroundImage:playerColor == RedPlayer ? redQuestionImage : blueQuestionImage forState:UIControlStateNormal];
    [answer3Button setBackgroundImage:playerColor == RedPlayer ? redQuestionImage : blueQuestionImage forState:UIControlStateNormal];
    [answer4Button setBackgroundImage:playerColor == RedPlayer ? redQuestionImage : blueQuestionImage forState:UIControlStateNormal];
    
//    for (UIView *v in bubbles) {
//        v.alpha = 0.5;
//    }
    
    if (self.currentQuestion == questionArray.count) {
        return;
    }
    self.remainingTime = 6;
    
    // self.answeringTimer = [[[PausableTimer alloc] initWithTimeInterval:TIMEPERQUESTION / 6.0  target:self selector:@selector(timeRemainingChanged:) repeats:YES userInfo:nil] autorelease];
    // [answeringTimer startTimer];
    //self.questionWaveTimer = [NSTimer scheduledTimerWithTimeInterval:TIMEPERQUESTION / 6.0 target:self selector:@selector(timeRemainingChanged:) userInfo:nil repeats:YES];
    //[[NSRunLoop mainRunLoop] addTimer:self.questionWaveTimer forMode:NSRunLoopCommonModes];
    //self.waveStartDate = [NSDate date];
    
    answer1Button.userInteractionEnabled = YES;
    answer2Button.userInteractionEnabled = YES;
    answer3Button.userInteractionEnabled = YES;
    answer4Button.userInteractionEnabled = YES;
    
    
    Question *q = [questionArray objectAtIndex:currentQuestion];
    statementLabel.text = q.statement;
    [statementLabel fitToFrameWithMinFontSize:10 maxFontSize:28];
    
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%d",currentQuestion + 1];
    
//    self.referenceLabel.text = q.reference;
//    [referenceLabel fitToFrameWithMinFontSize:10 maxFontSize:16];
    
    //    NSLog(@"answers:%@", q.answers);
    self.answer1Label.text = [q.answers objectAtIndex:0];
    self.answer2Label.text = [q.answers objectAtIndex:1];
    self.answer3Label.text = [q.answers objectAtIndex:2];
    self.answer4Label.text = [q.answers objectAtIndex:3];
    
    //    self.answer3Button.hidden = YES;
    
    BOOL hideThirdQuestion = NO;
    
    if (q.answers.count == 3) {
        self.answer3Button.hidden = NO;
        hideThirdQuestion = NO;
        self.answer3Label.text = [q.answers objectAtIndex:2];
    }
    
//    for (UIView *v in thirdAnswerViews) {
//        v.hidden = hideThirdQuestion;
//    }
    
//    waveMask.frame = maskOriginalFrame;
//    [UIView animateWithDuration:TIMEPERQUESTION / 6.0
//                          delay:0
//                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         waveMask.frame = CGRectMake(wave.frame.origin.x + wave.frame.size.width * 1.0 / 6,
//                                                     waveMask.frame.origin.y,
//                                                     waveMask.frame.size.width - waveMask.frame.size.width * 1.0 / 6 ,
//                                                     waveMask.frame.size.height);}
//                     completion:^(BOOL finished){}];
//    

    self.currentQuestion++;
    self.startTime = [NSDate date];
}

- (void)countDownTimer:(NSTimer *)timer {
    
    self.remainingSeconds--;
    
    self.countDownLabel.text = [NSString stringWithFormat:@"%d",remainingSeconds];
    if (remainingSeconds == 0) {
        //  [countDownTimer invalidate];
        self.view = gameplayView;
        [self showCurrentQuestion];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)restartGame {
    if (!gamePaused) {
        return;
    }
    
    self.gamePaused = NO;
    [reconnectingView removeFromSuperview];
    
    //[answeringTimer startTimer];
    // [hasAnsweredTimer startTimer];
    // [countDownTimer startTimer];
}

- (IBAction)playAgain:(id)sender {
    self.view = joinGameView;
    startGameButton.enabled = YES;
}

- (IBAction)playNewGame:(id)sender {
    HomeViewController *hvc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:hvc animated:YES];
    [hvc release];
}

- (void)connectionProblem {
    self.gamePaused = YES;
    self.view = reconnectingView;
//    if (reconnectingView == nil) {
//        NSArray *xib1 = [[NSBundle mainBundle] loadNibNamed:playerColor == RedPlayer ? @"ReconnectViewRed" : @"ReconnectViewBlue" owner:nil options:nil];
//        self.reconnectingView = [xib1 objectAtIndex:0];
//        NSArray *xib2 = [[NSBundle mainBundle] loadNibNamed:@"ReconnectFailedView" owner:nil options:nil];
//        self.permanentFailureView = [xib2 objectAtIndex:0];
//    }
//    
//    [self.view addSubview:reconnectingView];
    //    [answeringTimer pauseTimer];
    //    [hasAnsweredTimer pauseTimer];
    //    [countDownTimer pauseTimer];
}

//- (void)updateScoreForBluePlayer:(NSString *)score {
//    self.blueScoreLabel.text = score;
//}
//
//- (void)updateScoreForRedPlayer:(NSString *)score {
//    self.redScoreLabel.text = score;
//}

- (void)updateScoresForRed:(NSString *)red Blue:(NSString *)blue {
    self.blueScoreLabel.text = blue;
    self.redScoreLabel.text = red;
    [self updateRectsRed:[red intValue] Blue:[blue intValue]];
}

- (void)updateRectsRed:(int)redScore Blue:(int)blueScore {
    float redPercent = self.questionsAnswered > 0 ? PERCENTAGE + (1 - 2*PERCENTAGE) * redScore / self.questionsAnswered : 0.5;
    float bluePercent = self.questionsAnswered > 0 ? PERCENTAGE + (1 - 2*PERCENTAGE) * blueScore / self.questionsAnswered : 0.5;
    
    [UIView animateWithDuration:0.5 animations:^ {
        bluePlayerRect.frame = CGRectMake(0, 0, rectContainerView.frame.size.width * bluePercent, rectContainerView.frame.size.height);
        redPlayerRect.frame = CGRectMake(rectContainerView.frame.size.width * bluePercent, 0, rectContainerView.frame.size.width * redPercent, rectContainerView.frame.size.height);
    }];
}

- (void)resetScores {
    self.blueScoreLabel.text = @"0";
    self.redScoreLabel.text = @"0";
}

- (void)dealloc {
    self.joinGameView = nil;
    self.waitingForPlayerView = nil;
    self.countDownView = nil;
    self.gameplayView = nil;
    self.questionArray = nil;
    self.allQuestions = nil;
    self.gameOverView = nil;
    self.clockView = nil;
    self.timerView = nil;
    self.startTime = nil;
    self.clientManager = nil;
    self.reconnectingView = nil;
    self.permanentFailureView = nil;
    [stopLight1 release];
    [stopLight2 release];
    [stopLight3 release];
    [stopLight4 release];
    [stopLight5 release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setStopLight1:nil];
    [self setStopLight2:nil];
    [self setStopLight3:nil];
    [self setStopLight4:nil];
    [self setStopLight5:nil];
    [super viewDidUnload];
}
@end
