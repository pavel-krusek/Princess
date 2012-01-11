//
//  PatternButton.m
//  Princess
//
//  Created by Pavel Krusek on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PatternButton.h"


@implementation PatternButton

@synthesize pattern;

-(int) getRandomNumber:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (PatternButton *) initWithButtonType:(PatternButtonTypes)buttonID {

    
    NSString *imageFile;
    switch (buttonID) {
        case kOne: 
            imageFile = @"pb1.png";
            pattern = @"p1.png";
            break;
        case kTwo:
            imageFile = @"pb2.png";
            pattern = @"p2.png";
            break;
        case kThree:
            imageFile = @"pb3.png";
            pattern = @"p3.png";
            break;
        case kFour:
            imageFile = @"pb4.png";
            pattern = @"p4.png";
            break;
        case kFive:
            imageFile = @"pb5.png";
            pattern = @"p5.png";
            break;
        case kSix:
            imageFile = @"pb6.png";
            pattern = @"p6.png";
            break;
        case kSeven:
            imageFile = @"pb7.png";
            pattern = @"p7.png";
            break;
        case kEight:
            imageFile = @"pb8.png";
            pattern = @"p8.png";
            break;
        case kNine:
            imageFile = @"pb9.png";
            pattern = @"p9";
            break;
        case kTen:
            imageFile = @"pb10.png";
            pattern = @"p10.png";
            break;
        default:
            CCLOG(@"Unknown ID, cannot create button");
            return nil;
            break;
    }
    
    self = [[super initWithSpriteFrameName:imageFile] autorelease];
    
    id scaling = [CCSequence actions:
                  [CCScaleTo actionWithDuration:[self getRandomNumber:15 to:30]/10 scale:1.05],
                  [CCScaleTo actionWithDuration:[self getRandomNumber:15 to:30]/10 scale:1.0],
                  nil];
    
    [self runAction:[CCRepeatForever actionWithAction:scaling]];
    
    return self;
}

- (void) dealloc {
    CCLOG(@"debug: %@: %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}

@end
