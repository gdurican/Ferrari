//
//  SoundManager.m
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import "SoundManager.h"
#import "AVFoundation/AVAudioPlayer.h"

static SoundManager *instance;

@implementation SoundManager
@synthesize soundEffects;

- (AVAudioPlayer *)loadSoundWithPath:(NSString *)path {
    NSError *error = [[[NSError alloc] init] autorelease];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],path]];
    AVAudioPlayer *audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] autorelease];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer prepareToPlay];
    return audioPlayer;
}

- (SoundEffect)effectForString:(NSString *)string {
    if ([string isEqualToString:@"WaitingMusic"]) {
        return WaitingMusic;
    }
    if ([string isEqualToString:@"AnsweringMusic"]) {
        return AnsweringMusic;
    }
    if ([string isEqualToString:@"CorrectSound"]) {
        return CorrectSound;
    }
    if ([string isEqualToString:@"WrongSound"]) {
        return WrongSound;
    }
    if ([string isEqualToString:@"WinSound"]) {
        return WinSound;
    }
    
    return -1;
}

- (id)init {
    self = [super init];
    if (self && PLAY_SOUNDS) {
        self.soundEffects = [[[NSMutableDictionary alloc] init] autorelease];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SoundFiles" ofType:@"plist"];
        NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        for (NSString *effectName in plistData) {
            NSLog(@"%@",effectName);
            SoundEffect effect = [self effectForString:effectName];
            
            AVAudioPlayer *soundFile = [self loadSoundWithPath:[plistData valueForKey:effectName]];
            
            [self.soundEffects setObject:soundFile forKey:[NSNumber numberWithInt:effect]];
        }
    }
    
    return self;
}

+ (SoundManager *)sharedInstance {
    if (instance == nil) {
        instance = [[SoundManager alloc] init];
    }
    return instance;
}

+ (void)loadSoundFiles {
    if (instance == nil) {
        instance = [[SoundManager alloc] init];
    }
}

- (void)playSound:(SoundEffect)soundEffect {
    if (PLAY_SOUNDS) {
        
        for (NSNumber * nr in soundEffects) {
            AVAudioPlayer *audioPlayer = [self.soundEffects objectForKey:nr];
            if (audioPlayer.playing) {
                [audioPlayer pause];
            }
        }
        
        AVAudioPlayer *audioPlayer = [self.soundEffects objectForKey:[NSNumber numberWithInt:soundEffect]];
        audioPlayer.currentTime = 0;
        [audioPlayer play];
    }
}

- (void)setRepeatCountForEffect:(SoundEffect)soundEffect {
    AVAudioPlayer *audioPlayer = [self.soundEffects objectForKey:[NSNumber numberWithInt:soundEffect]];
    audioPlayer.numberOfLoops = -1;
}

- (void)stopAllSounds {
    for (NSNumber * nr in soundEffects) {
        AVAudioPlayer *audioPlayer = [self.soundEffects objectForKey:nr];
        if (audioPlayer.playing) {
            [audioPlayer pause];
        }
    }
}

@end

