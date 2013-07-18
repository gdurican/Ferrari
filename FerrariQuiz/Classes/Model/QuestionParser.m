//
//  QuestionParser.m
//  ActellionQuizServer
//
//  Created by Silviu on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QuestionParser.h"
#import "Question.h"

@implementation QuestionParser
@synthesize currentAnswers,currentString,result,currentQuestion,type;

- (id)initWithPath:(NSString *)ppath {
    self = [super initWithPath:ppath];
    if (self != nil) {
        self.result = [[[NSMutableArray alloc] init] autorelease];
        self.currentAnswers = [[[NSMutableArray alloc] init] autorelease];
        self.type = QuestionParse;
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"question"]) {
        self.currentQuestion = [[[Question alloc] init] autorelease];
        self.type = QuestionParse;
    }
    
    if ([elementName isEqualToString:@"answer"]) {
        self.type = AnswerParse;
    } else if ([elementName isEqualToString:@"correctanswer"]) {
        self.type = CorrectParse;
    } else if ([elementName isEqualToString:@"statement"]) {
        self.type = StatementParse;
    } else if ([elementName isEqualToString:@"reference"]) {
        self.type = ReferenceParse;
    } else if ([elementName isEqualToString:@"explanation"]) {
        self.type = ExplanationParse;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"question"]) {
        self.currentQuestion.answers = currentAnswers;
        self.currentAnswers = [[[NSMutableArray alloc] init] autorelease];
        [result addObject:currentQuestion];
    }
    self.type = QuestionParse;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    switch (self.type) {
        case AnswerParse:
            [currentAnswers addObject:string];
            break;
        case CorrectParse:
            currentQuestion.correctAnswer = string;
            break;
        case StatementParse:
            currentQuestion.statement = string;
            break;
        case ReferenceParse:
            currentQuestion.reference = string;
            break;
        case ExplanationParse:
            currentQuestion.explanation = string;
        default:
            break;
    }
}


- (void)dealloc {
    self.currentQuestion = nil;
    self.result = nil;
    self.currentAnswers = nil;
    self.currentString = nil;
    [super dealloc];
}

@end
