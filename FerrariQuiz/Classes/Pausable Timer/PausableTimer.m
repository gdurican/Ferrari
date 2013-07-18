//
//  PausableTimer.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "PausableTimer.h"

@implementation PausableTimer
@synthesize timeInterval,target,selector,repeats,delay,paused,timer,firstTick;
@synthesize pauseIntervals,runningIntervals,userInfo,invalidated;

- (id)initWithTimeInterval:(NSTimeInterval)t target:(id)tar selector:(SEL)sel repeats:(BOOL)rep userInfo:(id)info {
    self = [super init];
    if (self != nil) {
        self.timeInterval = t;
        self.target = tar;
        self.selector = sel;
        self.repeats = rep;
        self.delay = 0;
        self.paused = YES;
        self.firstTick = YES;
        self.runningIntervals = [[[NSMutableArray alloc] init] autorelease];
        self.pauseIntervals = [[[NSMutableArray alloc] init] autorelease];
        self.userInfo = info;
        self.invalidated = NO;
    }
    return self;
}

- (void)restartTimer {
    if (invalidated) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:nil repeats:repeats];
    self.pauseIntervals = [[[NSMutableArray alloc] init] autorelease];
    self.runningIntervals = [[[NSMutableArray alloc] init] autorelease];
    [runningIntervals addObject:[NSDate date]];
    
    if (!paused) {
        if (self.firstTick) {
            self.firstTick = NO;
        } else {
            [target performSelector:selector withObject:timer];
        }
    }
}

- (void)invalidate {
    [timer invalidate];
    self.invalidated = YES;
}

- (void)startTimer {
    if (invalidated) {
        return;
    }
    [self performSelector:@selector(restartTimer) withObject:userInfo afterDelay:delay];
    [runningIntervals addObject:[NSDate date]];
    self.paused = NO;
}

- (void)pauseTimer {
    if (paused || invalidated) {
        return;
    }
    
    self.paused = YES;
    [self.timer invalidate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(restartTimer) object:nil];
    
    float totalElapsedTime = 0;
    
    for (int i = 0 ; i < runningIntervals.count ; ++i) {
        if (pauseIntervals.count > i) {
            totalElapsedTime += fabs([[runningIntervals objectAtIndex:i] timeIntervalSinceNow]) - fabs([[pauseIntervals objectAtIndex:i] timeIntervalSinceNow]);
        } else {
            totalElapsedTime += fabs([[runningIntervals objectAtIndex:i] timeIntervalSinceNow]);
        }
    }
    
    self.delay = totalElapsedTime;
    self.delay -= (int)self.delay;
    self.delay += (int)fabs(totalElapsedTime) % (int)timeInterval;
    self.delay = timeInterval - delay;
    
    [pauseIntervals addObject:[NSDate date]];
    
}


@end

