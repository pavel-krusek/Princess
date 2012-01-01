//
//  ColorButton.m
//  Princess
//
//  Created by Pavel Krusek on 12/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ColorButton.h"


@implementation ColorButton

@synthesize colors;

-(int) getRandomNumber:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (ColorButton *) initWithButtonType:(ColorButtonTypes)buttonID {
    
    NSString *imageFile;
    switch (buttonID) {
        case kYellow: 
            imageFile = @"cbYellow.png";
            colors.red = 252;
            colors.green = 195;
            colors.blue = 0;
            break;
        case kWhite:
            imageFile = @"cbWhite.png";
            colors.red = 255;
            colors.green = 255;
            colors.blue = 255;
            break;
        case kBlack:
            imageFile = @"cbBlack.png";
            colors.red = 0;
            colors.green = 0;
            colors.blue = 0;
            break;
        case kBrown:
            imageFile = @"cbBrown.png";
            colors.red = 95;
            colors.green = 23;
            colors.blue = 0;
            break;
        case kMint:
            imageFile = @"cbMint.png";
            colors.red = 157;
            colors.green = 255;
            colors.blue = 62;
            break;
        case kViolet:
            imageFile = @"cbViolet.png";
            colors.red = 117;
            colors.green = 44;
            colors.blue = 221;
            break;
        case kOrange:
            imageFile = @"cbOrange.png";
            colors.red = 252;
            colors.green = 82;
            colors.blue = 0;
            break;
        case kAzure:
            imageFile = @"cbAzure.png";
            colors.red = 31;
            colors.green = 168;
            colors.blue = 255;
            break;
        case kRose:
            imageFile = @"cbRose.png";
            colors.red = 181;
            colors.green = 44;
            colors.blue = 188;
            break;
        case kRed:
            imageFile = @"cbRed.png";
            colors.red = 208;
            colors.green = 30;
            colors.blue = 31;
            break;
        case kGreen:
            imageFile = @"cbGreen.png";
            colors.red = 42;
            colors.green = 144;
            colors.blue = 0;
            break;
        case kBlue:
            imageFile = @"cbBlue.png";
            colors.red = 2;
            colors.green = 49;
            colors.blue = 188;
            break;
        case kLightYellow:
            imageFile = @"cbLightYellow.png";
            colors.red = 255;
            colors.green = 230;
            colors.blue = 31;
            break;
        default:
            CCLOG(@"Unknown ID, cannot create button");
            return nil;
            break;
    }
        
    self = [super initWithSpriteFrameName:imageFile];
    [imageFile release];
    
    id scaling = [CCSequence actions:
                  [CCScaleTo actionWithDuration:[self getRandomNumber:15 to:30]/10 scale:1.13],
                  [CCScaleTo actionWithDuration:[self getRandomNumber:15 to:30]/10 scale:1.0],
                  nil];
    
    [self runAction:[CCRepeatForever actionWithAction:scaling]];
    
    return self;
}

@end