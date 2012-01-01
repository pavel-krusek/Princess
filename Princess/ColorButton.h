//
//  ColorButton.h
//  Princess
//
//  Created by Pavel Krusek on 12/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ColorButton : CCSprite {

}

@property (nonatomic, readonly) Colors colors;

- (ColorButton *) initWithButtonType:(ColorButtonTypes)buttonID;

@end
