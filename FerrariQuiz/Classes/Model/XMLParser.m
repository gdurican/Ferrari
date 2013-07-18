//
//  QuestionXMLParser.m
//  ActellionQuizServer
//
//  Created by Silviu on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser
@synthesize path;

- (id)initWithPath:(NSString *)ppath {
    self = [super init];
    if (self != nil) {
        self.path = ppath;
    }
    return self;
}



- (void)startParsing {
    NSError *parseError = nil;
    NSBundle *bundle = [NSBundle mainBundle];    
    
    [self parseXMLFileAtURL:[NSURL fileURLWithPath: [bundle pathForResource:self.path ofType:@"xml"]] parseError:&parseError];
}

- (BOOL)parseXMLFileAtURL:(NSURL *)file parseError:(NSError **)error {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:file];
    
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if(parseError && error) {
        *error = parseError;
    }
    
    [self endOfParsing];
    
    [parser release];
    
    return (parseError) ? YES : NO; 
}

- (void)endOfParsing {
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Error on XML Parse: %@", [parseError localizedDescription] );
    
}

@end
