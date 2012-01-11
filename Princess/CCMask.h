@interface CCMask : CCNode {
	// the mask
    CCSprite *maskSprite_;
	// the object to be masked
    CCNode *objectSprite_;
    
    // RenderTexture use for masking
    CCRenderTexture *masked_;
    CCRenderTexture *maskNegative_;
}

@property (nonatomic, retain) CCRenderTexture* masked;

// Initialize a masked object based on an object sprite and a mask sprite
+ (id) createMaskForObject: (CCNode*) object withMask: (CCSprite*) mask;
+ (CCSprite *) createNegativeMaskSprite:(CCSprite *)mask size:(CGSize)size;
- (id) initWithObject: (CCNode*) object mask: (CCSprite*) mask;

//change the 'background object'
- (void) setObject: (CCNode*) object;
//change the maskSprite
- (void) setMask: (CCSprite*) mask;
- (CCSprite*) maskSprite; 

- (void) mask;
- (void) maskWithClear:(float) r g:(float) g b:(float) b a:(float) a;

//useful for multiple masks in one render texture
- (void) maskWithoutClear;

//useful for animations or touch/mouse events to create a scratch-off effect
- (void) reDrawMask;

@end