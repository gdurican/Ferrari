//
//  FontUtils.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "FontUtils.h"


@implementation FontUtils


+(void)applyFont:(NSString *)fontName forView:(UIView *)view {
    if([view isKindOfClass:[UILabel class]]) {
        [FontUtils setFont:fontName forLabel:(UILabel *)view];
    }
    else if([view isKindOfClass:[UIButton class]]) {
        [FontUtils setFont:fontName forButton:(UIButton *)view];
    }
    else if([view isKindOfClass:[UITextField class]]) {
        [FontUtils setFont:fontName forTextField:(UITextField *)view];
    }
    else if ([view isKindOfClass:[UISearchBar class]]) {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                [FontUtils setFont:fontName forTextField:(UITextField *) subView];
            }
        }
    }
    else if ([view isKindOfClass:[UITextView class]]) {
        [FontUtils setFont:fontName forTextView:(UITextView *)view];
    }
}

+(void)setFont:(NSString *)fontName forLabel:(UILabel *)label {
    UIFont *font = [UIFont fontWithName:fontName size:label.font.pointSize];
    label.font = font;
}

+(void)setFont:(NSString *)fontName forButton:(UIButton *)button {
    UIFont *font = [UIFont fontWithName:fontName size:button.titleLabel.font.pointSize];
    button.titleLabel.font = font;
}

+(void)setFont:(NSString *)fontName forTextField:(UITextField *)textField {
    UIFont *font = [UIFont fontWithName:fontName size:textField.font.pointSize];
    textField.font = font;
}

+ (void)setFont:(NSString *)fontName forTextView:(UITextView *)textView {
    UIFont *font = [UIFont fontWithName:fontName size:textView.font.pointSize];
    textView.font = font;
}


@end