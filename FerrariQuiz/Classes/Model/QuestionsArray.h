//
//  QuestionsArray.h
//  ActellionQuizServer
//
//  Created by Silviu on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionsArray : NSMutableArray

+ (NSArray *)selectX:(int)x randomQuestionsWithSeed:(int)seed fromArray:(NSArray *)array;
+ (NSArray *)allQuestions;

@end
