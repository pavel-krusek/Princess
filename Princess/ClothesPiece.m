//
//  ClothesPiece.m
//  Princess
//
//  Created by Pavel Krusek on 12/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClothesPiece.h"


@implementation ClothesPiece

@synthesize piece, masked;

- (id)init {
    self = [super init];
    if (self) {
        CCLOG(@"debug: %@: %@", NSStringFromSelector(_cmd), self);
    }
    return self;
}

- (void) constructPiece:(Piece)stroke piece:(Piece)p {
    if (![stroke.source isEqualToString:@"none"]) {
        CCSprite *shadow = [CCSprite spriteWithSpriteFrameName:stroke.source];
        shadow.position = ccp(stroke.xPos, stroke.yPos);
        shadow.anchorPoint = ccp(0, 0);
        [self addChild:shadow z:stroke.z];
    }
    
    CCSprite *obj = [CCSprite spriteWithSpriteFrameName:p.source];
    obj.opacity = 0;
    obj.position = ccp(p.xPos, p.yPos);
    obj.anchorPoint = ccp(0, 0);
    
    piece = [CCSprite spriteWithSpriteFrameName:p.source];
    piece.anchorPoint = ccp(0, 0);
    piece.position = ccp(p.xPos, p.yPos);
    [self addChild:piece z:p.z];
    
    mask = [CCSprite spriteWithSpriteFrameName:p.source];
    mask.position = ccp(p.xPos, p.yPos);
    mask.anchorPoint = ccp(0, 0);
    
    CCSprite *negative_mask = [CCMask createNegativeMaskSprite:mask size:mask.contentSize];
    masked = [CCMask createMaskForObject:obj withMask: negative_mask];
    
    //masked = [CCMask createMaskForObject:obj withMask: mask];
    [self addChild: masked z:2];
    [masked mask];
}

- (void) addPattern:(CGPoint)touchLocation pattern:(NSString *)pattern {
    CCSprite *p = [CCSprite spriteWithFile:pattern];
    p.scale = 0.60;
    p.position = [self convertToNodeSpace:touchLocation];
    [masked setObject:p];
    [masked maskWithoutClear];
}

- (void) dealloc {
    CCLOG(@"debug: %@: %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}

@end

