//
//  Question.m
//  ActellionQuizServer
//
//  Created by Silviu on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Question.h"

@implementation Question

@synthesize statement, additionalDetails, answers, correctAnswer, explanation, reference;

- (id)initWithStatement:(NSString *)st andAnswers:(NSArray *)ans andCorrectAnswer:(NSString *)correct {
    self = [super init];
    
    if (self != nil) {
        self.statement = st;
        self.answers = ans;
        self.correctAnswer = correct;
    }
    
    return self;
}

- (id)initWithStatement:(NSString *)st andAnswers:(NSArray *)ans andCorrectAnswer:(NSString *)correct andAdditionalDetails:(NSString *)details {
    self = [self initWithStatement:statement andAnswers:ans andCorrectAnswer:correct];
    if (self != nil) {
        self.additionalDetails = details;
    }
    
    return self;
}

- (NSString *)description {
    NSMutableString *desc = [NSMutableString stringWithString:[super description]];
    [desc appendFormat:@"\nstatement: %@\nanswers: %@\ncorrect: %@\nexplanation: %@\nref: %@", statement, answers, correctAnswer, explanation, reference];
    return desc;
}

- (void)dealloc {
    self.statement = nil;
    self.additionalDetails = nil;
    self.answers = nil;
    self.correctAnswer = nil;
    self.explanation = nil;
    self.reference = nil;
}

@end
