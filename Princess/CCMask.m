//
//  CCMask.m
//  Masking
//
//  Created by Gilles Lesire on 22/04/11.
//  Copyright 2011 iCapps. All rights reserved.
//

#import "CCMask.h"

@interface CCMask(Private)

- (id) initWithObject: (CCSprite *) object mask: (CCSprite *) mask;
- (void) resetObject;
- (void) mask;

@end

@implementation CCMask

+ (id) createMaskForObject: (CCSprite *) object withMask: (CCSprite *) mask {
	return [[[self alloc] initWithObject: object mask: mask] autorelease];
}

- (id) initWithObject: (CCSprite *) object mask: (CCSprite *) mask {
	NSAssert(object != nil, @"Invalid sprite for object");
    NSAssert(mask != nil, @"Invalid sprite for mask");
    
	if((self = [super init])) {
		[self setObject: object];
		[self setMask: mask];
        
        // Get window size, we want masking over entire screen don't we?
		size = [[CCDirector sharedDirector] winSize];
        
        // Create point with middle of screen
        screenMid = ccp(size.width * 0.5f, size.height * 0.5f);
        
        // Create the rendureTextures to create cut outs
        maskNegative = [CCRenderTexture renderTextureWithWidth: size.width height: size.height];
        masked = [CCRenderTexture renderTextureWithWidth: size.width height: size.height];
        
        // Set render textures at middle of screen
        maskNegative.position = screenMid;
        masked.position = screenMid;
        
        // Set correct alpha channel for textures
        [[maskNegative sprite] setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
        [[masked sprite] setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
//        [[[maskNegative sprite] texture] setAliasTexParameters];
//        [[[masked sprite] texture] setAliasTexParameters];
        //[[maskNegative sprite] setOpacityModifyRGB:YES];
        //[[masked sprite] setOpacityModifyRGB:YES];
        
        // Load object into RenderTextures
        [self resetObject];
        
        // Mask the object
        [self mask];
        
        // Add the masked object to the screen
        [self addChild: masked];
	}
    
	return self;
}

- (void) resetObject {
    // Clear everyting and begin action for the negative
    [maskNegative beginWithClear:0 g:0 b:0 a:1.0];
    //[maskNegative begin];

    // Load sprite
    [objectSprite visit];
    
    // End loading sprites
    [maskNegative end];
    
    // Clear everyting and begin action for masked
    //[masked beginWithClear:0 g:0 b:0 a:1.0];
    [masked begin];
    
    // Load sprite
    [objectSprite visit];
    
    // End loading sprites
    [masked end];
}

- (void) redrawMasked {
    // Put object back on the screen
    [self resetObject];
    
    // Cut out the parts we don't want to see
    [self mask];
    
    for (CCSprite *sprite in self.children) {
        CCLOG(@"SPRITE %@", sprite);
//        if (sprite.visible) {
//            //do something
//        }
    }
}

- (void) reRender {
    
    [self resetObject];
    
    [self removeChild:maskNegative cleanup:YES];
    [self removeChild:masked cleanup:YES];
    [self mask];
    [self addChild:masked];
}

- (void) mask {
    // Set up the burn sprite that will "knock out" parts of the darkness layer depending on the alpha value of the pixels in the image.
    [maskSprite setBlendFunc: (ccBlendFunc) {  GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
    [maskSprite setOpacityModifyRGB:NO];
    [maskSprite retain];
    
    // Start cutting out the parts we want to show
    [maskNegative begin];
    
    // Limit drawing to the alpha channel
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Draw
    [maskSprite visit];
    
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [maskNegative end];
    
    //[self addChild: maskNegative];
    [maskNegative retain];
    
    // Create a temporary mask of the left cut out
    CCSprite *maskCut = maskNegative.sprite;
    maskCut.position = screenMid;
    
    // Set up the burn sprite that will "knock out" parts of the darkness layer depending on the alpha value of the pixels in the image.
    [maskCut setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
    [maskCut setOpacityModifyRGB:NO];
    [maskCut retain];
    
    [masked begin];
    
    // Limit drawing to the alpha channel
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Draw
    [maskCut visit];
    
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [masked end];
}

- (void) setObject: (CCSprite *) object {
    objectSprite = object;
    [objectSprite retain];
}

- (void) setMask: (CCSprite *) mask {
    maskSprite = mask;
    [maskSprite retain];
}

- (CCSprite *) getMaskedSprite {
    return masked.sprite;
}

- (void) dealloc {
    [maskNegative release];
    [masked release];
    
    [super dealloc];
}

@end