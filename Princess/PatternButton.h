//
//  PatternButton.h
//  Princess
//
//  Created by Pavel Krusek on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PatternButton : CCSprite {
    
}

@property (nonatomic, assign, readonly) NSString *pattern;

- (PatternButton *) initWithButtonType:(PatternButtonTypes)buttonID;

@end
