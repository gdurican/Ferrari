//
//  UILabel+FitToFrame.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "UILabel+FitToFrame.h"

@implementation UILabel(FitTOFrame)

- (void)fitToFrameWithMinFontSize:(int)minFontSize maxFontSize:(int)maxFontSize {
    
    minFontSize = MAX(1,minFontSize);
    
    for(int i = maxFontSize; i >= minFontSize; i--)
    {
        self.font = [self.font fontWithSize:i];
        
        CGSize constraintSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
        CGSize labelSize = [self.text sizeWithFont:self.font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        if(labelSize.height <= self.frame.size.height) {
            break;
        }
    }
}

- (void)fitToFrame {
    [self fitToFrameWithMinFontSize:DEFAULTMINIMUM maxFontSize:DEFAULTMAXIMUM];
}

@end
