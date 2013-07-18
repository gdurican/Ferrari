//
//  FontUtils.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SLAB_TALL_X @"SlabTallX"
#define SLAB_TALL_X_BOLD @"SlabTallX-Medium"

@interface FontUtils : NSObject {
    
}

+(void)applyFont:(NSString *)fontName forView:(UIView *)view;

@end
