//
//  ApplicationConstants.h
//  FerrariQuiz
//
//  Created by Gabi Durican on 03.07.2013.
//  Copyright (c) 2013 Gabi Durican. All rights reserved.
//

#ifndef FerrariQuiz_ApplicationConstants_h
#define FerrariQuiz_ApplicationConstants_h

#define SESSIONID @"ActellionQuiz"
#define NUMBEROFQUESTIONS 10
#define TIMEPERQUESTION 20
#define TIMEAFTERQUESITON 3
#define WINTOPLABEL @"Bravo !"
#define WINBOTTOMLABEL @"Ati castigat jocul!"
#define LOSETOPLABEL @"Sfarsitul jocului:"
#define LOSEBOTTOMLABEL @"Adversarul a castigat."
#define DRAWTOPLABEL @"Un joc bun !"
#define DRAWBOTTOMLABEL @"Egalitate intre jucatori."
#define START_WITH_ONE_PLAYER NO
#define CHECK_PASSWORD YES
#define SEND_HEARTBEATS YES
#define PLAY_SOUNDS YES
#define DEBUG_HEARTBEATS NO
#define DEBUG_ANSWERS NO
#define ANIMATE_INVERTCOLORS YES
#define PASSWORD @"123456"

#define APP_DEBUG

#ifdef APP_DEBUG
#define DDBG DBG(@"")    // PRINTEAZA LINIA
#define DBG(xx) NSLog(@"%p %s (%d): %@", self, __PRETTY_FUNCTION__, __LINE__, xx) // PRINTEAZA OBIECT
#define DBGRECT(xx) DBG(NSStringFromCGRect(xx)) // RECT
#define DBGPOINT(xx) DBG(NSStringFromCGPoint(xx)) // PUNCT
#define LOG(xx, ...) NSLog(@"%p %s (%d): %@", self, __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:xx, ##__VA_ARGS__]) // CA NSLOG
#else
#define DDBG
#define DBG(xx)
#define DBGRECT(xx)
#define DBGPOINT(xx)
#define LOG(xx, ...)
#endif

typedef enum {
    RedPlayer,
    BluePlayer
} PlayerColor;

#endif
