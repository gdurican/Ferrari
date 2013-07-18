//
//  SpectatorViewController.m
//  ActellionQuizServer
//
//  Created by Silviu on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpectatorViewController.h"
#import "ServerManager.h"
#import "QuizGame.h"
#import "Question.h"
#import "Player.h"
#import "QuestionsArray.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSDataCategories.h"
#import "QuestionsArray.h"
#import "PausableTimer.h"
#import "UILabel+FitToFrame.h"
#import "SoundManager.h"
#import "HomeViewController.h"

static SpectatorViewController *instance = nil;

@implementation SpectatorViewController
@synthesize serverManager,redScoreLabel,blueScoreLabel,answer1Label,answer3Label,answer2Label,answer4Label;
@synthesize questionNumberLabel,statementLabel;
@synthesize game;
@synthesize rectContainerView,redPlayerRect,bluePlayerRect;
@synthesize waitingForPlayersView,spectatorView;
@synthesize questionView;
@synthesize answersView;
@synthesize permanentFailureView,reconnectingView;
@synthesize bubbles;
@synthesize questionTimer,timeLeft;
@synthesize waveMask,wave;
@synthesize thirdQuestion;
@synthesize headerTextImageView;
@synthesize gamePaused;
@synthesize countDownLabel;
@synthesize countDownView;
@synthesize correctQuestionLetter;
@synthesize answeringTimer,hasAnsweredTimer,countDownTimer;
@synthesize isPlayingEndMovie;
@synthesize stopLight1, stopLight2, stopLight3, stopLight4, stopLight5;
@synthesize answerImage1, answerImage2, answerImage3, answerImage4;
@synthesize winnerLabel;

static UIImage *redWinImage;
static UIImage *blueWinImage;
static UIImage *drawImage;
static UIImage *questionText;
static UIImage *responseText;

static UIImage *redPointImage;
static UIImage *bluePointImage;
static UIImage *drawPointImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isPlayingEndMovie = NO;
        blueWinImage = [UIImage imageNamed:@"BlueWins"];
        [blueWinImage retain];
        redWinImage = [UIImage imageNamed:@"RedWins"];
        [redWinImage retain];
        drawImage = [UIImage imageNamed:@"Draw"];
        [drawImage retain];
        questionText = [UIImage imageNamed:@"BlueHeaderQuestion"];
        [questionText retain];
        responseText = [UIImage imageNamed:@"BlueHeaderResponse"];
        [responseText retain];
        redPointImage = [UIImage imageNamed:@"scorebar_red"];
        [redPointImage retain];
        bluePointImage = [UIImage imageNamed:@"scorebar_yellow"];
        [bluePointImage retain];
        drawPointImage = [UIImage imageNamed:@"message_container_small"];
        [drawPointImage retain];
        
        //        NSArray *xib1 = [[NSBundle mainBundle] loadNibNamed:@"ReconnectViewServer" owner:nil options:nil];
        //        self.reconnectingView = [xib1 objectAtIndex:0];
        //        NSArray *xib2 = [[NSBundle mainBundle] loadNibNamed:@"ReconnectFailedView" owner:nil options:nil];
        //        self.permanentFailureView = [xib2 objectAtIndex:0];
        self.gamePaused = NO;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSSortDescriptor * sort = [[[NSSortDescriptor alloc] initWithKey:@"tag" ascending:true] autorelease];
    self.bubbles = [bubbles sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    [[SoundManager sharedInstance] setRepeatCountForEffect:WaitingMusic];
    [[SoundManager sharedInstance] playSound:WaitingMusic];
}

- (NSData *)toNSData:(NSMutableArray *)objectToConvert {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:objectToConvert];
    return data;
}

- (void)setUpWithSession:(GKSession *)session andRedPlayerPeerID:(NSString *)redID andBluePlayerPeerID:(NSString *)blueID {
    self.serverManager = [[[ServerManager alloc] initWithViewController:self] autorelease];
    
    [serverManager connectionEstablished:session withRedPeerID:redID andBluePeerID:blueID];
    self.game = serverManager.quizGame;
    //    [self showNextQuestion];
}



- (void)displaySpectatorView {
    self.view = spectatorView;
}

- (void)endOfGame {
    
    PacketCode bluePacketCode = NETWORK_LOST;
    PacketCode redPacketCode = NETWORK_LOST;
    
    if (game.redPlayer.score == game.bluePlayer.score) {
        redPacketCode = NETWORK_DRAW;
        bluePacketCode = NETWORK_DRAW;
    } else if (game.redPlayer.score > game.bluePlayer.score) {
        redPacketCode = NETWORK_WON;
    } else {
        bluePacketCode = NETWORK_WON;
    }
    
    
    [serverManager sendData:nil withCode:bluePacketCode toPeers:[NSArray arrayWithObject:game.bluePlayer.peerID]];
    [serverManager sendData:nil withCode:redPacketCode toPeers:[NSArray arrayWithObject:game.redPlayer.peerID]];
    
    //    [self performSelector:@selector(playEndMovie:) withObject:nil afterDelay:AUTOPLAYENDMOVIETIME];
    [serverManager startNewGame];
    self.game = serverManager.quizGame;
    // pune o imagine inainte de view-ul asta; si vezi si pe ecranele de la playeri
    self.view = waitingForPlayersView;
    [self updateRects:0 blue:0];
    self.redScoreLabel.text = [NSString stringWithFormat:@"%d",0];
    self.blueScoreLabel.text = [NSString stringWithFormat:@"%d",0];
}

- (void)updateState {
    if ([game isEndOfGame]) {
        
    }
    
    self.headerTextImageView.image = responseText;
    
    self.redScoreLabel.text = [NSString stringWithFormat:@"%d",game.redPlayer.score];
    self.blueScoreLabel.text = [NSString stringWithFormat:@"%d",game.bluePlayer.score];
    
    Question *q = [game.questions objectAtIndex:game.currentQuestion - 1];
    
    if ([[q.answers objectAtIndex:0] isEqualToString:q.correctAnswer]) {
        answerImage1.image = [UIImage imageNamed:@"question_field_active"];
    } else if ([[q.answers objectAtIndex:1] isEqualToString:q.correctAnswer]) {
        answerImage2.image = [UIImage imageNamed:@"question_field_active"];
    } else if ([[q.answers objectAtIndex:2] isEqualToString:q.correctAnswer]) {
        answerImage3.image = [UIImage imageNamed:@"question_field_active"];
    } else {
        answerImage4.image = [UIImage imageNamed:@"question_field_active"];
    }
    
    game.noAnswer = YES;
    [self updateRects:game.redPlayer.score blue:game.bluePlayer.score];
    
    //send scores to clients
//    NSData *blueScore = [blueScoreLabel.text dataUsingEncoding:NSASCIIStringEncoding];
//    NSData *redScore = [redScoreLabel.text dataUsingEncoding:NSASCIIStringEncoding];
//    [serverManager sendData:blueScore withCode:NETWORK_SCORE_BLUE toPeers:[NSArray arrayWithObject:game.bluePlayer.peerID]];
//    [serverManager sendData:blueScore withCode:NETWORK_SCORE_BLUE toPeers:[NSArray arrayWithObject:game.redPlayer.peerID]];
//    [serverManager sendData:redScore withCode:NETWORK_SCORE_RED toPeers:[NSArray arrayWithObject:game.bluePlayer.peerID]];
//    [serverManager sendData:redScore withCode:NETWORK_SCORE_RED toPeers:[NSArray arrayWithObject:game.redPlayer.peerID]];
    NSNumber *answeredQuestions = [[NSNumber alloc] initWithInt:game.answeredQuestions];
    NSArray *scores = [[NSArray alloc] initWithObjects:blueScoreLabel.text, redScoreLabel.text, answeredQuestions, nil];
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:scores];
    [serverManager sendData:dataToSend withCode:NETWORK_UPDATE_SCORES toPeers:[NSArray arrayWithObject:game.bluePlayer.peerID]];
    [serverManager sendData:dataToSend withCode:NETWORK_UPDATE_SCORES toPeers:[NSArray arrayWithObject:game.redPlayer.peerID]];
    [answeredQuestions release];
}

- (void)updateRects:(int)redScore blue:(int)blueScore {
    float redPercent = game.answeredQuestions > 0 ? PERCENTAGE + (1 - 2*PERCENTAGE) * redScore / game.answeredQuestions : 0.5;
    float bluePercent = game.answeredQuestions > 0 ? PERCENTAGE + (1 - 2*PERCENTAGE) * blueScore / game.answeredQuestions : 0.5;
    
    [UIView animateWithDuration:0.5 animations:^ {
        bluePlayerRect.frame = CGRectMake(0, 0, rectContainerView.frame.size.width * bluePercent, rectContainerView.frame.size.height);
        redPlayerRect.frame = CGRectMake(rectContainerView.frame.size.width * bluePercent, 0, rectContainerView.frame.size.width * redPercent, rectContainerView.frame.size.height);
    }];
}

- (void)countDown:(NSTimer *)timer {
    [serverManager sendData:nil withCode:NETWORK_ANSWERINGTIMER toPeers:serverManager.clientIDs];
    self.timeLeft--;
    switch (timeLeft) {
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
    if (self.timeLeft > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            if (5 - timeLeft >= 0)
                [[bubbles objectAtIndex:5 - timeLeft] setAlpha:1];}];
    } else {
        [answeringTimer invalidate];
    }
}

- (void)showNextQuestion {
    
    headerTextImageView.image = questionText;
    
    if ([game isEndOfGame]) {
        [self endOfGame];
        return;
    }
    
    for (UIView * v in bubbles) {
        v.alpha = 0.5;
    }
    
    Question *q = [game.questions objectAtIndex:game.currentQuestion];
    questionNumberLabel.text = [NSString stringWithFormat:@"%d",game.currentQuestion + 1];
    statementLabel.text = q.statement;
    [statementLabel fitToFrameWithMinFontSize:10 maxFontSize:28];
    
    answer1Label.text = [q.answers objectAtIndex:0];
    answer2Label.text = [q.answers objectAtIndex:1];
    answer3Label.text = [q.answers objectAtIndex:2];
    answer4Label.text = [q.answers objectAtIndex:3];
    
    stopLight1.image = [UIImage imageNamed:@"stop_red_inactive"];
    stopLight2.image = [UIImage imageNamed:@"stop_red_inactive"];
    stopLight3.image = [UIImage imageNamed:@"stop_red_inactive"];
    stopLight4.image = [UIImage imageNamed:@"stop_yellow_inactive"];
    stopLight5.image = [UIImage imageNamed:@"stop_green_inactive"];
    
    UIImage *answerImage = [[UIImage imageNamed:@"question_field_pressed"] retain];
    answerImage1.image = answerImage;
    answerImage2.image = answerImage;
    answerImage3.image = answerImage;
    answerImage4.image = answerImage;
    [answerImage release];
    
    [hasAnsweredTimer invalidate];
    self.answeringTimer = [[[PausableTimer alloc] initWithTimeInterval:TIMEPERQUESTION / 6.0 target:self selector:@selector(countDown:) repeats:YES userInfo:nil] autorelease];
    [answeringTimer startTimer];
    //self.questionTimer = [NSTimer scheduledTimerWithTimeInterval:TIMEPERQUESTION / 6.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    self.timeLeft = 6;
    
    waveMask.frame = CGRectMake(0,0,waveMask.superview.frame.size.width,waveMask.superview.frame.size.height);
    [UIView animateWithDuration:TIMEPERQUESTION delay:0 options:UIViewAnimationOptionCurveLinear animations:^{waveMask.frame = CGRectMake(wave.frame.origin.x + wave.frame.size.width, waveMask.frame.origin.y, 0, waveMask.frame.size.height);} completion:^(BOOL finished){}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)connectionProblem {
    self.gamePaused = YES;
    //    [self.view addSubview:reconnectingView];
    self.view = reconnectingView;
    [answeringTimer pauseTimer];
    [hasAnsweredTimer pauseTimer];
    [countDownTimer pauseTimer];
}

- (void)restartGame {
    if (!gamePaused) {
        [self endOfGame];
    }
    self.gamePaused = NO;
    [reconnectingView removeFromSuperview];
    [answeringTimer startTimer];
    [hasAnsweredTimer startTimer];
    [countDownTimer startTimer];
}

- (void)dealloc {
    self.serverManager = nil;
    self.game = nil;
    self.waitingForPlayersView = nil;
    self.spectatorView = nil;
    self.reconnectingView = nil;
    self.permanentFailureView = nil;
    [answerImage1 release];
    [answerImage2 release];
    [answerImage3 release];
    [answerImage4 release];
    [questionView release];
    [answersView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setAnswerImage1:nil];
    [self setAnswerImage2:nil];
    [self setAnswerImage3:nil];
    [self setAnswerImage4:nil];
    [self setQuestionView:nil];
    [self setAnswersView:nil];
    [super viewDidUnload];
}

- (IBAction)playNewGame:(id)sender {
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:homeViewController animated:YES];
    [homeViewController release];
}
@end
