//
//  QuestionXMLParser.h
//  ActellionQuizServer
//
//  Created by Silviu on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate>
@property (nonatomic, retain) NSString *path;

- (id)initWithPath:(NSString *)ppath;
- (void)startParsing;
- (BOOL)parseXMLFileAtURL:(NSURL *)file parseError:(NSError **)error;
- (void)endOfParsing;

@end
