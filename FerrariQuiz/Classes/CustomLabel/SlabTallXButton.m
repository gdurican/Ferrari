//
//  SlabTallXButton.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "SlabTallXButton.h"

@implementation SlabTallXButton

- (id)init {
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont fontWithName:@"SlabTallX" size:self.titleLabel.font.pointSize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"SlabTallX" size:self.titleLabel.font.pointSize];
}

@end
