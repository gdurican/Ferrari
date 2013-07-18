//
//  SlabTallXTextView.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 05.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "SlabTallXTextView.h"

@implementation SlabTallXTextView

- (id)init {
    self = [super init];
    if (self) {
        self.font = [UIFont fontWithName:@"SlabTallX" size:self.font.pointSize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"SlabTallX" size:self.font.pointSize];
}

@end
