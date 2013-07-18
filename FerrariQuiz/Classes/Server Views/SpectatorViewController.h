//
//  SpectatorViewController.h
//  ActellionQuizServer
//
//  Created by Silviu on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <MediaPlayer/MediaPlayer.h>

#define PERCENTAGE 0.143
#define AUTOPLAYENDMOVIETIME 5

@class ServerManager,QuizGame,PausableTimer;

@interface SpectatorViewController : UIViewController

@property (nonatomic,retain) ServerManager *serverManager;
@property (nonatomic,assign) IBOutlet UILabel *redScoreLabel;
@property (nonatomic,assign) IBOutlet UILabel *blueScoreLabel;
@property (nonatomic,assign) IBOutlet UILabel *answer1Label;
@property (nonatomic,assign) IBOutlet UILabel *answer2Label;
@property (nonatomic,assign) IBOutlet UILabel *answer3Label;
@property (nonatomic,assign) IBOutlet UILabel *answer4Label;
@property (nonatomic,assign) IBOutlet UILabel *questionNumberLabel;
@property (nonatomic,assign) IBOutlet UILabel *statementLabel;

@property (nonatomic,assign) IBOutlet UIView *rectContainerView;
@property (nonatomic,assign) IBOutlet UIView *bluePlayerRect;
@property (nonatomic,assign) IBOutlet UIView *redPlayerRect;
@property (nonatomic,retain) IBOutlet UIView *waitingForPlayersView;
@property (nonatomic,retain) IBOutlet UIView *spectatorView;
@property (retain, nonatomic) IBOutlet UIView *questionView;
@property (retain, nonatomic) IBOutlet UIView *answersView;

@property (nonatomic,retain) IBOutlet UIView *topEndGameView;
@property (nonatomic,retain) IBOutlet UIView *reconnectingView;
@property (nonatomic,retain) UIView *permanentFailureView;
@property (nonatomic,retain) IBOutlet UIView *middleEndGameView;

@property (nonatomic,retain) QuizGame *game;

@property (nonatomic,retain) IBOutletCollection(UIImageView) NSArray *bubbles;
@property (nonatomic,retain) IBOutletCollection(UIView) NSArray *thirdQuestion;
@property (nonatomic,retain) NSTimer *questionTimer;
@property (nonatomic,assign) int timeLeft;

@property (nonatomic,assign) IBOutlet UIImageView *wave;
@property (nonatomic,assign) IBOutlet UIImageView *waveMask;

@property (nonatomic,assign) BOOL gamePaused;
@property (nonatomic,retain) IBOutlet UIImageView *headerTextImageView;

@property (nonatomic,assign) IBOutlet UILabel *countDownLabel;
@property (nonatomic,retain) IBOutlet UIView *countDownView;
@property (nonatomic,retain) IBOutlet UILabel *correctQuestionLetter;

@property (nonatomic,retain) PausableTimer *answeringTimer;
@property (nonatomic,retain) PausableTimer *hasAnsweredTimer;
@property (nonatomic,retain) PausableTimer *countDownTimer;

@property (nonatomic,assign) BOOL isPlayingEndMovie;

@property (retain, nonatomic) IBOutlet UIImageView *stopLight1;
@property (retain, nonatomic) IBOutlet UIImageView *stopLight2;
@property (retain, nonatomic) IBOutlet UIImageView *stopLight3;
@property (retain, nonatomic) IBOutlet UIImageView *stopLight4;
@property (retain, nonatomic) IBOutlet UIImageView *stopLight5;
@property (retain, nonatomic) IBOutlet UIImageView *answerImage1;
@property (retain, nonatomic) IBOutlet UIImageView *answerImage2;
@property (retain, nonatomic) IBOutlet UIImageView *answerImage3;
@property (retain, nonatomic) IBOutlet UIImageView *answerImage4;

@property (nonatomic, assign) IBOutlet UILabel *winnerLabel;

- (void)setUpWithSession:(GKSession *)session andRedPlayerPeerID:(NSString *)redID andBluePlayerPeerID:(NSString *)blueID;
- (void)updateState;
- (void)showNextQuestion;
- (void)updateRects:(int)redScore blue:(int)blueScore;
- (void)displaySpectatorView;
- (void)connectionProblem;
- (void)restartGame;
- (void)movieEnded:(NSNotification *)notification;
- (IBAction)playEndMovie:(id)sender;
- (IBAction)playNewGame:(id)sender;

@end
