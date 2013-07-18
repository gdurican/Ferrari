//
//  NSDataCategories.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionAnswer.h"

@interface NSData(NSDataCategories)
+ (NSData *)createWithBOOL:(BOOL)value;
- (BOOL)BOOLValue;
+ (NSData *)createWithCGPoint:(CGPoint)point;
- (CGPoint)CGPointValue;
+ (NSData *)createWithInt:(int)value;
- (int)intValue;
+ (NSData *)createWithQuestionAnswer:(QuestionAnswer *)value;
- (QuestionAnswer *)questionAnswerValue;

@end

