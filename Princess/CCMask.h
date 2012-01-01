//
//  CCMask.h
//  Princess
//
//  Created by Pavel Krusek on 12/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface CCMask : CCSprite {
    CGSize size;
    CGPoint screenMid;
    
    // The given sprites
    CCSprite *maskSprite;
    CCSprite *objectSprite;
    
    // RenderTextures use for masking
    CCRenderTexture *maskNegative;
    CCRenderTexture *masked;
}

// Initialize a masked object based on an object sprite and a mask sprite
+ (id) createMaskForObject: (CCNode *) object withMask: (CCSprite *) mask;

// Redraw the masked image
- (void) redrawMasked;
-(void) reRender;

// When dynamic masking is active, you have the ability to change the masked object or the mask itself
- (void) setObject: (CCSprite *) object;
- (void) setMask: (CCSprite *) mask;

// Return the masked object as a sprite
- (CCSprite *) getMaskedSprite;

@end
