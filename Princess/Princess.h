//
//  Princess.h
//  Princess
//
//  Created by Pavel Krusek on 1/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ColorButton.h"
#import "PatternButton.h"
#import "ClothesPiece.h"
#import "CCMask.h"

@interface Princess : CCLayerColor <CCTargetedTouchDelegate> {
    CCArray *colorButtons;
    CCArray *patterns;
    NSMutableDictionary *clothesDictionary;
    
    //current selected color & pattern
    Colors currentColor;
    PatternButton *currentPattern;
    
    //touch data
    NSData *touchData;
}

+ (CCScene *) scene:(NSString *)princess;

@end
