//
//  NSDataCategories.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "NSDataCategories.h"

@implementation NSData(NSDataCategories)

+ (NSData *)createWithBOOL:(BOOL)value {
    NSData *result = [[[NSData alloc] initWithBytes:&value length:sizeof(BOOL)] autorelease];
    return result;
}

- (BOOL)BOOLValue {
    BOOL val;
    [self getBytes:&val];
    return val;
}

+ (NSData *)createWithCGPoint:(CGPoint)point {
    float data[2];
    data[0] = point.x;
    data[1] = point.y;
    
    NSData *result = [[[NSData alloc] initWithBytes:data length:sizeof(float) * 2] autorelease];
    
    return result;
}

- (CGPoint)CGPointValue {
    float data[2];
    [self getBytes:data];
    
    return CGPointMake(data[0], data[1]);
}

+ (NSData *)createWithInt:(int)value {
    NSData *result = [[[NSData alloc] initWithBytes:&value length:sizeof(int)] autorelease];
    return result;
}

- (int)intValue {
    int val;
    [self getBytes:&val];
    return val;
}

+ (NSData *)createWithQuestionAnswer:(QuestionAnswer *)value {
    
    int data[2];
    data[0] = value.isCorrect;
    data[1] = value.index;
    
    NSMutableData *result = [[[NSMutableData alloc] initWithBytes:data length:sizeof(int) * 2] autorelease];
    
    float floatData[1];
    floatData[0] = value.timeForAnswer;
    
    [result appendBytes:floatData length:sizeof(float)];
    
    return result;
}

- (QuestionAnswer *)questionAnswerValue {
    int intData[2];
    float floatData[1];
    
    [self getBytes:intData range:NSMakeRange(0, sizeof(int) * 2)];
    [self getBytes:floatData range:NSMakeRange(sizeof(int) * 2, sizeof(float))];
    
    
    QuestionAnswer *result = [[[QuestionAnswer alloc] init] autorelease];
    result.isCorrect = intData[0];
    result.index = intData[1];
    result.timeForAnswer = floatData[0];
    
    return result;
}

@end
