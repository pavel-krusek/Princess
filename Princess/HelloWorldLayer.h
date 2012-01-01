//
//  HelloWorldLayer.h
//  Princess
//
//  Created by Pavel Krusek on 11/19/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "ColorButton.h"
#import "PatternButton.h"
#import "ClothesPiece.h"
#import "CCMask.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    CCArray *colorButtons;
    //CCArray *clothesArray;
    NSMutableDictionary *clothesDictionary;
    CCArray *patterns;
    
    ColorButton *colorButton;
    ClothesPiece *clothesPiece;
    PatternButton *pattern;
    
    Colors currentColor;
    PatternButton *currentPattern;
    
    
    CCRenderTexture *darknessLayer;
    CCSprite *test;
    ClothesPiece *testL;
    
    NSData *lookupData;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
