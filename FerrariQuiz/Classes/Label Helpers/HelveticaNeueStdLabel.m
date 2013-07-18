//
//  HelveticaNeueStdLabel.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "HelveticaNeueStdLabel.h"

@implementation HelveticaNeueStdLabel

- (void)awakeFromNib {
    self.font = [UIFont fontWithName:@"Helvetica Neue LT Std" size:self.font.pointSize];
    if (self.numberOfLines == 1) {
        CGRect frameLabel = self.frame;
        CGSize sizeLabel = [self.text sizeWithFont:self.font];
        frameLabel.size.width = sizeLabel.width;
        frameLabel.size.height = sizeLabel.height;
        
        self.frame = frameLabel;
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumFontSize = 10;
    }
}

@end
