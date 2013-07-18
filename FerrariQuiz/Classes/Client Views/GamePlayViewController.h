//
//  GamePlayViewController.h
//  ActellionQuizServer
//
//  Created by Silviu on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/Gamekit.h>
#import "PacketCodes.h"
#import "SpectatorViewController.h"

@class ClientManager,PausableTimer;
@interface GamePlayViewController : UIViewController

@property (nonatomic,assign) IBOutlet UILabel *countDownLabel;
@property (nonatomic,assign) IBOutlet UILabel *questionNumberLabel;
@property (nonatomic,assign) IBOutlet UIButton *answer1Button;
@property (nonatomic,assign) IBOutlet UIButton *answer2Button;
@property (nonatomic,assign) IBOutlet UIButton *answer3Button;
@property (nonatomic,assign) IBOutlet UIButton *answer4Button;
@property (nonatomic,assign) IBOutlet UILabel *nextQuestionCountDown;
@property (nonatomic,assign) IBOutlet UILabel *statementLabel;
@property (nonatomic,retain) NSMutableArray *answerLabels;

@property (nonatomic,retain) IBOutlet UIView *joinGameView;
@property (nonatomic,retain) IBOutlet UIView *waitingForPlayerView;
@property (nonatomic,retain) IBOutlet UIView *countDownView;
@property (nonatomic,retain) IBOutlet UIView *gameplayView;
@property (nonatomic,assign) int remainingSeconds;
@property (nonatomic,assign) int currentQuestion;
@property (nonatomic,assign) int nextQuestionTime;

@property (nonatomic,retain) NSArray *questionArray;
@property (nonatomic,retain) NSArray *allQuestions;

@property (nonatomic,assign) BOOL showingTimer;
@property (nonatomic,assign) int selectedIndex;

@property (nonatomic,retain) NSDate *startTime;

@property (nonatomic,retain) IBOutlet UIView *clockView;
@property (nonatomic,retain) IBOutlet UIView *timerView;
@property (nonatomic,retain) IBOutlet UIView *gameOverView;

@property (nonatomic,assign) BOOL gamePaused;
@property (nonatomic,retain) ClientManager *clientManager;

@property (nonatomic,retain) IBOutlet UIView *reconnectingView;
@property (nonatomic,retain) UIView *permanentFailureView;
@property (nonatomic,assign) PlayerColor playerColor;

@property (nonatomic,retain) NSDate *waveStartDate;
@property (nonatomic,retain) NSTimer *questionWaveTimer;
@property (nonatomic,assign) int remainingTime;
@property (nonatomic,assign) float timeSinceWaveStart;

@property (nonatomic,assign) IBOutlet UILabel *answer1Label;
@property (nonatomic,assign) IBOutlet UILabel *answer2Label;
@property (nonatomic,assign) IBOutlet UILabel *answer3Label;
@property (nonatomic,assign) IBOutlet UILabel *answer4Label;

@property (nonatomic,assign) IBOutlet UILabel *endGameLabelTop;
@property (nonatomic,assign) IBOutlet UILabel *endGameLabelBottom;


@property (nonatomic,retain) IBOutlet UIButton *startGameButton;

@property (nonatomic,retain) PausableTimer *answeringTimer;
@property (nonatomic,retain) PausableTimer *hasAnsweredTimer;
@property (nonatomic,retain) PausableTimer *countDownTimer;

@property (retain, nonatomic) IBOutlet UIImageView *stopLight1;
@property (retain, nonatomic) IBOutlet UIImageView *stopLight2;
@property (retain, nonatomic) IBOutlet UIImageView *stopLight3;
@property (retain, nonatomic) IBOutlet UIImageView *stopLight4;
@property (retain, nonatomic) IBOutlet UIImageView *stopLight5;

@property (retain, nonatomic) IBOutlet UIView *rectContainerView;
@property (retain, nonatomic) IBOutlet UIImageView *bluePlayerRect, *redPlayerRect;
@property (assign, nonatomic) IBOutlet UILabel *blueScoreLabel, *redScoreLabel;
@property (nonatomic, assign) int questionsAnswered;


- (IBAction)startGamePressed:(id)sender;
- (IBAction)didPressAnwer:(id)sender;
- (void)countDownTimer:(NSTimer *)timer;
- (void)questionTimer:(NSTimer *)timer;
- (void)timeRemainingChanged:(NSTimer *)timer;
- (void)showCurrentQuestion;
- (void)gameOver:(NSNumber *)won;
- (void)setUpWithSession:(GKSession *)session;
- (void)highLightSelectedAnswer;
- (void)highLightCorrectAnswer;
- (void)moveToNextQuestion;
- (void)connectionProblem;
- (void)restartGame;
- (void)newGame;
- (IBAction)playAgain:(id)sender;
- (void)updateScoresForRed:(NSString *)red Blue:(NSString *)blue;
- (void)resetScores;
@end
