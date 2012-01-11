//
//  Princess.m
//  Princess
//
//  Created by Pavel Krusek on 1/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Princess.h"
#import "CCDirector+CCDirector_ScreenshotUIImage.h"
#import "CJSONDeserializer.h"
#import "PrincessManager.h"

@interface Princess (PrivateMethods)
- (void) selectSpriteForTouch:(CGPoint)touchLocation;
- (void) buildPrincess:(NSString *)princess;
- (void) loadPrincess:(NSString *)princess;
- (void) addNavigation;
- (void) addPatternButtons;
- (void) addColorButtons;
- (void) loadPrincess;
- (NSString *) jsonFromFile:(NSString *)file;
- (void) handleError:(NSError *)error;
@end

#define AS(A,B) [(A) stringByAppendingString:(B)]

enum {
	TAG_BTN_CAMERA = 0,
    TAG_BTN_NEXT = 1,
	TAG_PRINCESS_MENU = 2,
    TAG_FLASH = 3
};

@implementation Princess

+ (CCScene *) scene:(NSString *)princess {
	CCScene *scene = [CCScene node];
	Princess *layer = [Princess node];
    [layer buildPrincess:princess];
	[scene addChild: layer];

	return scene;
}

#pragma mark -
#pragma mark INIT, ENTER & EXIT stuff
- (id) init {
	if( (self = [super initWithColor:ccc4(255,255,255,255)])) {
        CCLOG(@"debug: %@: %@", NSStringFromSelector(_cmd), self);
	}
	return self;
}

- (void) onEnter {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

- (void) onExit {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

#pragma mark -
#pragma mark Required CCTargetedTouchDelegate callback
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    
    return YES;
}

#pragma mark -
#pragma mark Irregular shape touch detection
- (int) getValueAtPoint:(CGPoint)pt {
    int retVal = 255;
    
    if(touchData) {
        pt.y = self.contentSize.height - pt.y;
        int offset = pt.y * self.contentSize.width + pt.x;
        NSRange range = {offset, sizeof(Byte)};
        NSData *pixelValue = [touchData subdataWithRange:range];  
        
        retVal = *(int*)[pixelValue bytes];
    }
    return retVal;
}

#pragma mark -
#pragma mark "Paint" algorithm
- (void) selectSpriteForTouch:(CGPoint)touchLocation {
    ColorButton *colorSprite = nil;
    for (ColorButton *sprite in colorButtons) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {            
            colorSprite = sprite;
            break;
        }
    }
    
    PatternButton *patternSprite = nil;
    for (PatternButton *sprite in patterns) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {            
            patternSprite = sprite;
            break;
        }
    }
    
    ClothesPiece *clothesSprite = nil;
    int value = [self getValueAtPoint:touchLocation];
    if (value != 255)
        clothesSprite = [clothesDictionary objectForKey:[NSString stringWithFormat:@"%i", value]];
    
    if (colorSprite) {
        currentColor = colorSprite.colors;
        currentPattern = nil;
    }
    
    if (clothesSprite) {
        if (currentPattern)
            [clothesSprite addPattern:touchLocation pattern:currentPattern.pattern];
        else
            [clothesSprite.piece runAction:[CCTintTo actionWithDuration:0.15 red:currentColor.red green:currentColor.green blue:currentColor.blue]];
    }
    
    if (patternSprite)
        currentPattern = patternSprite;
}

#pragma mark -
#pragma mark Composite build scene method
- (void) buildPrincess:(NSString *)princess {
    //touch data
    NSString *filePath = [[NSBundle mainBundle] pathForResource:AS(@"_", princess) ofType:@"raw"];  
    touchData = [NSData dataWithContentsOfFile:filePath];
    [touchData retain];
    
    //assets
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:AS(princess, @".plist")];
    
    currentColor.red = 255;
    currentColor.green = 255;
    currentColor.red = 255;
    
    [self loadPrincess:princess];
    [self addColorButtons];
    [self addPatternButtons];
    [self addNavigation];
}

#pragma mark -
#pragma mark Dealloc scene from memory
- (void) dealloc {
    CCLOG(@"debug: %@: %@", NSStringFromSelector(_cmd), self);
    [touchData release];
    [colorButtons release];
    [patterns release];
    [clothesDictionary release];
    colorButtons = nil;
    patterns = nil;
    clothesDictionary = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark BUILD SCENE FROM JSON
#pragma mark Add princess 
- (void) loadPrincess:(NSString *)princess {
    clothesDictionary = [[NSMutableDictionary alloc] init];
    NSString *jsonString = [self jsonFromFile:princess];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
    [self handleError:error];
    NSArray *dataArray = [resultsDictionary objectForKey:@"princess"];
    for (NSDictionary *pDictionary in dataArray) {
        NSString *objType = [pDictionary objectForKey:@"type"];
        if ([objType isEqualToString:@"static"]) {
            CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[pDictionary objectForKey:@"asset"]];
            NSArray *positionArray = [pDictionary objectForKey:@"position"];
            NSArray *anchorArray = [pDictionary objectForKey:@"anchor"];
            sprite.position = ccp([[positionArray objectAtIndex:0] floatValue], [[positionArray objectAtIndex:1] floatValue]);
            sprite.anchorPoint = ccp([[anchorArray objectAtIndex:0] floatValue],[[anchorArray objectAtIndex:1] floatValue]);
            [self addChild:sprite];
        }
        if ([objType isEqualToString:@"touchable"]) {
            NSArray *positionArray = [pDictionary objectForKey:@"position"];
            NSArray *strokeArray = [pDictionary objectForKey:@"stroke"];
            NSArray *pieceArray = [pDictionary objectForKey:@"piece"];
            Piece stroke;
            stroke.source = [strokeArray objectAtIndex:0];
            stroke.xPos = [[strokeArray objectAtIndex:1] floatValue];
            stroke.yPos = [[strokeArray objectAtIndex:2] floatValue];
            stroke.z = [[strokeArray objectAtIndex:3] intValue];
            Piece piece;
            piece.source = [pieceArray objectAtIndex:0];
            piece.xPos = [[pieceArray objectAtIndex:1] floatValue];
            piece.yPos = [[pieceArray objectAtIndex:2] floatValue];
            piece.z = [[pieceArray objectAtIndex:3] intValue];
            
            ClothesPiece *p = [ClothesPiece node];
            [p constructPiece:stroke piece:piece];
            p.position = ccp([[positionArray objectAtIndex:0] floatValue], [[positionArray objectAtIndex:1] floatValue]);
            [self addChild:p];
            [clothesDictionary setObject:p forKey:[pDictionary objectForKey:@"touchData"]];
        }
    }
}

#pragma mark Add navigation 
- (void) addNavigation {
    CCSprite *next = [CCSprite spriteWithSpriteFrameName:@"btnNext.png"];
    CCMenuItem *nextItem = [CCMenuItemSprite itemFromNormalSprite:next selectedSprite:nil target:self selector:@selector(buttonTapped:)];
    nextItem.tag = TAG_BTN_NEXT;
    nextItem.anchorPoint = ccp(0, 0);
    nextItem.position = ccp(24, 658);
    
    CCSprite *camera = [CCSprite spriteWithSpriteFrameName:@"btnCamera.png"];
    CCMenuItem *cameraItem = [CCMenuItemSprite itemFromNormalSprite:camera selectedSprite:nil target:self selector:@selector(buttonTapped:)];
    cameraItem.tag = TAG_BTN_CAMERA;
    cameraItem.position = ccp(75, 607);
    
    CCMenu *princessMenu = [CCMenu menuWithItems:cameraItem, nextItem, nil];
    princessMenu.tag = TAG_PRINCESS_MENU;
    princessMenu.position = CGPointZero;
    
    [self addChild:princessMenu];
}

#pragma mark Add pattern buttons 
- (void) addPatternButtons {    
    patterns = [[CCArray alloc] init];
    
    float btnXpos[10] = {902.00, 907.00, 909.00, 918.00, 915.00, 917.00, 916.00, 914.00, 917.00, 909.00};
    float btnYpos[10] = {660.00, 589.00, 527.00, 468.00, 401.00, 342.00, 280.00, 221.00, 159.00, 86.00};
    
    for (int i = 0; i < 10; ++i) {
        PatternButton *pb = [(PatternButton *)[PatternButton alloc] initWithButtonType:i];
        pb.position = ccp(btnXpos[i] + pb.contentSize.width / 2, btnYpos[i] + pb.contentSize.height / 2);
        [self addChild:pb];
        [patterns addObject:pb];
    }    
}

#pragma mark Add color buttons 
- (void) addColorButtons {    
    colorButtons = [[CCArray alloc] init];
    
    float btnXpos[13] = {60.00, 124.00, 198.00, 268.00, 338.00, 421.00, 491.00, 556.00, 632.00, 706.00, 773.00, 848.00, 916.00};
    float btnYpos[13] = {50.00, 49.00, 50.00, 47.00, 49.00, 46.00, 50.00, 56.00, 46.00, 52.00, 46.00, 54.00, 52.00};
    
    for (int i = 0; i < 13; ++i) {
        ColorButton *cb = [(ColorButton *)[ColorButton alloc] initWithButtonType:i];
        cb.position = ccp(btnXpos[i], btnYpos[i]);
        [self addChild:cb];
        [colorButtons addObject:cb];
    }    
}

#pragma mark -
#pragma mark NAVIGATION MENU CALLBACK
- (void) buttonTapped:(CCMenuItem *)sender {
    switch (sender.tag) {
        case TAG_BTN_CAMERA:{
            CCLayerColor *flash = [CCLayerColor layerWithColor:ccc4(255,255,255,0)];
            flash.tag = TAG_FLASH;
            [self addChild:flash];
            id fadeIn = [CCSequence actions:[CCFadeIn actionWithDuration:0.07],
                         [CCCallFunc actionWithTarget:self selector:@selector(flashDown)],
                         nil];
            [flash runAction:fadeIn];
            [sender setVisible:NO];// TO DO - pak obnovit (time out)
            break;
        }
        case TAG_BTN_NEXT:
            //zatim natvrdo reload
            [[PrincessManager sharedPrincessManager] runPrincessScene:@"green"];
            break;
        default:
            CCLOG(@"debug: Unknown ID, cannot tap button");
            return;
            break;
    }
}

#pragma mark Flash callback
- (void) flashDown {
    //CCMenu *menu = (CCMenu *)[self getChildByTag:TAG_PRINCESS_MENU];
    //menu.visible = NO;
    CCLayerColor *flash = (CCLayerColor *)[self getChildByTag:TAG_FLASH];
    id fadeOut = [CCSequence actions:[CCFadeOut actionWithDuration:0.1],
                  [CCCallFunc actionWithTarget:self selector:@selector(flashEnd)],
                  nil];
    [flash runAction:fadeOut];
}

#pragma mark Flash end callback - write screenshot to Photos
#pragma mark TO DO - vytvorit galerii, neukladat k ostatnim
- (void) flashEnd {
    CCLayerColor *flash = (CCLayerColor *)[self getChildByTag:100];
    [self removeChild:flash cleanup:YES];
    UIImage *screenshot = [[CCDirector sharedDirector] screenshotUIImage];
    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
}

#pragma mark -
#pragma mark Data from json
- (NSString *) jsonFromFile:(NSString *)file {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];  
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    NSString *s = [[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding] autorelease];    
    return s;
}

#pragma mark Error handler
- (void) handleError:(NSError *)error {
    if (error != nil) {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [errorAlertView show];
        [errorAlertView release];
    }
}



@end
