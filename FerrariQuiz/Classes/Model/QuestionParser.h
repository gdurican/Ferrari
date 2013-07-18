//
//  QuestionParser.h
//  ActellionQuizServer
//
//  Created by Silviu on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"
#import "Question.h"

typedef enum {
    AnswerParse,
    StatementParse,
    CorrectParse,
    QuestionParse,
    ExplanationParse,
    ReferenceParse
} ParseTypes;

@interface QuestionParser : XMLParser {

}

@property(nonatomic, retain) Question *currentQuestion;
@property(nonatomic, retain) NSMutableArray *currentAnswers;
@property(nonatomic, retain) NSString *currentString;
@property(nonatomic, retain) NSMutableArray *result;
@property(nonatomic, assign) ParseTypes type;

@end
