//
//  QuizGame.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

typedef enum {
    GAME_WIN,
    GAME_LOSE,
    GAME_DRAW
} EndGameState;

@interface QuizGame : NSObject

@property (nonatomic,retain) NSArray *questions;
@property (nonatomic,assign) int currentQuestion;
@property (nonatomic,retain) Player *bluePlayer;
@property (nonatomic,retain) Player *redPlayer;
@property (nonatomic,assign) int seed;
@property (nonatomic,assign) BOOL redAnsweredLastQuestion;
@property (nonatomic,assign) BOOL decidingWinner;
@property (nonatomic,assign) int answeredQuestions;
@property (nonatomic,assign) BOOL noAnswer;
@property (nonatomic,assign) BOOL playerWasCorrect;

- (void)receiveAnswerFrom:(NSString *)peerID forQuestionIndex:(int)index andAnswerState:(BOOL)correct andTime:(float)time;
- (id)initWithRedPlayerID:(NSString *)redPlayerID bluePlayer:(NSString *)bluePlayerID andQuestionArray:(NSArray *)questionArray;
- (Player *)getClientByPeerId:(NSString *)peerID;
- (Player *)getRivalPlayer:(Player *)player;
- (EndGameState)endGameStateForBluePlayer;
- (EndGameState)endGameStateForRedPlayer;
- (BOOL)isEndOfGame;
- (void)decideWinner;
- (void)clearPlayers;

@end

