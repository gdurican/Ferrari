//
//  QuestionAnswer.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionAnswer : NSObject

@property (nonatomic,assign) BOOL isCorrect;
@property (nonatomic,assign) int index;
@property (nonatomic,assign) float timeForAnswer;

@end
