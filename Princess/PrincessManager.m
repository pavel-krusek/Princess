//
//  PrincessManager.m
//  Princess
//
//  Created by Pavel Krusek on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrincessManager.h"

@implementation PrincessManager

static PrincessManager *_sharedPrincessManager = nil;

#pragma mark -
#pragma mark Tady singleton 
+ (PrincessManager *) sharedPrincessManager {
    @synchronized([PrincessManager class])
    {
        if(!_sharedPrincessManager)
            [[self alloc] init]; 
        return _sharedPrincessManager;
    }
    return nil; 
}

+ (id) alloc {
    @synchronized ([PrincessManager class])
    {
        NSAssert(_sharedPrincessManager == nil,
                 @"debug: Attempted to allocated a second instance of the PrincessManager singleton");
        _sharedPrincessManager = [super alloc];
        return _sharedPrincessManager;
    }
    return nil;  
}

- (id) init {
    self = [super init];
    if (self != nil)
        CCLOG(@"debug: Game Manager Singleton, init");
    return self;
}

// Zatim jenom simple reload nez bude grafika...
- (void) runPrincessScene:(NSString *)scene {
    if ([[CCDirector sharedDirector] runningScene] == nil)
        [[CCDirector sharedDirector] runWithScene:[Princess scene:scene]];        
    else
        [[CCDirector sharedDirector] replaceScene: [Princess scene:scene]];
}


@end
