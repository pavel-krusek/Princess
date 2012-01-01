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
        //patterns = [[CCArray alloc] init];        
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
    
    masked = [CCMask createMaskForObject:obj withMask: mask];
    [self addChild: masked z:3];
       
//    //        CCSprite *p = [CCSprite spriteWithFile:@"p9.png"];
//    //        p.position = ccp(300, 100);
//    //        [obj addChild:p];

}

- (void) addPattern:(CGPoint)touchLocation pattern:(NSString *)pattern {
    CCLOG(@"ADD PATTERN");
    CCSprite *p = [CCSprite spriteWithFile:pattern];
    p.scale = 1.00;
    p.position = [self convertToNodeSpace:touchLocation];  
    //[patterns addObject:p];
    [masked setObject:p];
    [masked redrawMasked];
}

@end

