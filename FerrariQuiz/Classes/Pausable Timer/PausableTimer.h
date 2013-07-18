//
//  PausableTimer.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PausableTimer : NSObject
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,assign) NSTimeInterval timeInterval;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL selector;
@property (nonatomic,assign) BOOL repeats;
@property (nonatomic,assign) float delay;
@property (nonatomic,assign) BOOL paused;
@property (nonatomic,assign) BOOL firstTick;
@property (nonatomic,assign) id userInfo;
@property (nonatomic,retain) NSMutableArray *runningIntervals;
@property (nonatomic,retain) NSMutableArray *pauseIntervals;
@property (nonatomic,assign) BOOL invalidated;

- (id)initWithTimeInterval:(NSTimeInterval)t target:(id)tar selector:(SEL)sel repeats:(BOOL)rep userInfo:(id)info;
- (void)startTimer;
- (void)pauseTimer;
- (void)invalidate;

@end
