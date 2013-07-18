//
//  SlabTallXBoldLabel.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 04.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "SlabTallXBoldLabel.h"

@implementation SlabTallXBoldLabel

- (id)init {
    self = [super init];
    if (self) {
        self.font = [UIFont fontWithName:@"SlabTallX-Medium" size:self.font.pointSize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"SlabTallX-Medium" size:self.font.pointSize];
}


@end