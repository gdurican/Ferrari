//
//  QuestionsArray.m
//  ActellionQuizServer
//
//  Created by Silviu on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QuestionsArray.h"
#import "QuestionParser.h"

@implementation QuestionsArray

+ (NSArray *)selectX:(int)x randomQuestionsWithSeed:(int)seed fromArray:(NSArray *)array {
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    srandom(seed);
    
    bool selected[array.count];
    for (int i = 0 ; i < array.count ; ++i) {
        selected[i] = false;
    }
    
    x = MIN(x,array.count);
    int count = 0;
    while (count < x) {
        int index = random() % array.count;
        if (!selected[index]) {
            [result addObject:[array objectAtIndex:index]];
            selected[index] = true;
            count++;
        }
    }
    
    return result;
}

+ (NSArray *)allQuestions {
    QuestionParser *parser = [[[QuestionParser alloc] initWithPath:@"Questions_ferrari"] autorelease];
    
    [parser startParsing];
    
    return parser.result;
}

@end
