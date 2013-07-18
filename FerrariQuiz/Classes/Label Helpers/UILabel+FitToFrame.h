//
//  UILabel+FitToFrame.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEFAULTMINIMUM 5
#define DEFAULTMAXIMUM 50

@interface UILabel(FitToFrame)

- (void)fitToFrameWithMinFontSize:(int)minFontSize maxFontSize:(int)maxFontSize;
- (void)fitToFrame;

@end

