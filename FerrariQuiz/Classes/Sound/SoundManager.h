//
//  SoundManager.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WaitingMusic,
    AnsweringMusic,
    CorrectSound,
    WrongSound,
    WinSound
} SoundEffect;


@interface SoundManager : NSObject {
    NSMutableDictionary *soundEffects;
}

@property (nonatomic,retain) NSMutableDictionary *soundEffects;

+ (void)loadSoundFiles;
+ (SoundManager *)sharedInstance;
- (void)playSound:(SoundEffect)soundEffect;
- (void)stopAllSounds;
- (void)setRepeatCountForEffect:(SoundEffect)soundEffect;
@end
