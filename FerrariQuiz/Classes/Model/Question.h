//
//  Question.h
//  ActellionQuizServer
//
//  Created by Silviu on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic, retain) NSString *statement;
@property (nonatomic, retain) NSString *correctAnswer;
@property (nonatomic, retain) NSArray *answers;
@property (nonatomic, retain) NSString *additionalDetails;
@property (nonatomic, retain) NSString *explanation;
@property (nonatomic, retain) NSString *reference;

- (id)initWithStatement:(NSString *)st andAnswers:(NSArray *)ans andCorrectAnswer:(NSString *)correct;
- (id)initWithStatement:(NSString *)st andAnswers:(NSArray *)ans andCorrectAnswer:(NSString *)correct andAdditionalDetails:(NSString *)details;

@end
