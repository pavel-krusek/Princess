//
//  HelloWorldLayer.m
//  Princess
//
//  Created by Pavel Krusek on 11/19/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCDirector+CCDirector_ScreenshotUIImage.h"
#import "CJSONDeserializer.h"

@interface HelloWorldLayer (PrivateMethods)
- (void) loadPrincess;
- (NSString *) jsonFromFile:(NSString *)file;
- (void) handleError:(NSError *)error;
@end


enum {
	TAG_BTN_CAMERA = 0,
	TAG_PRINCESS_MENU = 1
};

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) addClouds {
    CCSprite *cloud1;
    CCSprite *cloud2;
    CCSprite *cloud3;
    CCSprite *cloud4;
    
    cloud1 = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    cloud1.position = ccp(880.00, 577.00);
    [self addChild:cloud1];
    
    cloud2 = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    cloud2.position = ccp(704.00, 523.00);
    [self addChild:cloud2];
    
    cloud3 = [CCSprite spriteWithSpriteFrameName:@"cloud3.png"];
    cloud3.position = ccp(767.00, 642.00);
    [self addChild:cloud3];
    
    cloud4 = [CCSprite spriteWithSpriteFrameName:@"cloud4.png"];
    cloud4.position = ccp(938.00, 703.00);
    [self addChild:cloud4];
    
    id cloud1Move = [CCSequence actions:[CCMoveTo actionWithDuration:160 position:ccp(517.00, 577.00)],
                     [CCMoveTo actionWithDuration:0.00 position:ccp(880.00, 577.00)],
                     nil];
    id cloud2Move = [CCSequence actions:[CCMoveTo actionWithDuration:106 position:ccp(506.00, 523.00)],
                    [CCMoveTo actionWithDuration:0.00 position:ccp(871.00, 523.00)],
                     nil];
    id cloud3Move = [CCSequence actions:[CCMoveTo actionWithDuration:126 position:ccp(494.00, 642.00)],
                    [CCMoveTo actionWithDuration:0.00 position:ccp(877.00, 642.00)],
                     nil];
    id cloud4Move = [CCSequence actions:[CCMoveTo actionWithDuration:151 position:ccp(514.00, 703.00)],
                     [CCMoveTo actionWithDuration:0.00 position:ccp(938.00, 703.00)],
                     nil];
    
    [cloud1 runAction:[CCRepeatForever actionWithAction:cloud1Move]];
    [cloud2 runAction:[CCRepeatForever actionWithAction:cloud2Move]];
    [cloud3 runAction:[CCRepeatForever actionWithAction:cloud3Move]];
    [cloud4 runAction:[CCRepeatForever actionWithAction:cloud4Move]];
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

- (void)onEnter {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

- (int) getValueAtPoint:(CGPoint)pt {
    int retValue = 255;
    
    if(lookupData) 
    {
        pt.y = self.contentSize.height - pt.y;
        int offset = pt.y * self.contentSize.width + pt.x;
        NSRange range = {offset,sizeof(Byte)};
        NSData *pixelValue = [lookupData subdataWithRange:range];  
        
        retValue = *(int*)[pixelValue bytes];
    }
    return retValue;
}

- (void) selectSpriteForTouch:(CGPoint)touchLocation {
    ColorButton *newSprite = nil;
    for (ColorButton *sprite in colorButtons) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {            
            newSprite = sprite;
            break;
        }
    }
    
//    ClothesPiece *clothSprite = nil;
//    for (ClothesPiece *sprite in clothesArray) {
////        if (CGRectContainsPoint(sprite.piece.boundingBox, [sprite convertToNodeSpace:touchLocation])) {
////            clothSprite = sprite;
////            break;
////        }
//        if (CGRectContainsPoint(sprite.piece.boundingBox, [sprite convertToNodeSpace:touchLocation])) {
//            CGPoint loc = [sprite.piece convertToNodeSpace:touchLocation];
//            int value = [sprite getValueAtPoint:loc];
//            CCLOG(@"%i", value);
//            if (value == 1) {
//                clothSprite = sprite;
//            }
//            break;
//        }
//    }
    ClothesPiece *clothSprite = nil;
    CGPoint loc = [self convertToNodeSpace:touchLocation];
    int value = [self getValueAtPoint:loc];
    //CCLOG(@"%i", value);
    switch (value) {
        case 1:
            clothSprite = [clothesArray objectAtIndex:1];
            break;
        case 2:
            clothSprite = [clothesArray objectAtIndex:0];
            break;
        case 3:
            break;
        default:                       
            break;
    }
    CCLOG(@"PIECE %@", clothSprite);
    
    PatternButton *patternSprite = nil;
    for (PatternButton *sprite in patterns) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {            
            patternSprite = sprite;
            break;
        }
    }
    
    colorButton = newSprite;
    clothesPiece = clothSprite;
    pattern = patternSprite;
    
    if (colorButton) {
        currentColor = colorButton.colors;
        currentPattern = nil;
    }
    
    if (clothesPiece) {
        if (currentPattern) {
            [clothesPiece addPattern:touchLocation pattern:currentPattern.pattern];
        } else {
            CCTintTo *tint = [CCTintTo actionWithDuration:0.15 red:currentColor.red green:currentColor.green blue:currentColor.blue];
            [clothesPiece.piece runAction:tint];
        }
    }
    
    if (pattern) {
        currentPattern = pattern;
    }
}


//- (void) handleSingleTap:(UITapGestureRecognizer *)recognizer {
//    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
//    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
//    //touchLocation = [self convertToNodeSpace:touchLocation];                
//    [self selectSpriteForTouch:touchLocation];
//}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    //CCLOG(@"TOUCH LOCATION %g %g", touchLocation.x, touchLocation.y);
    [self selectSpriteForTouch:touchLocation];
    
    return YES;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(255,255,255,255)])) {
        NSString *filePath = 
        [[NSBundle mainBundle] pathForResource:@"_green" ofType:@"raw"];  
        
        // load it as NSData
        lookupData = [NSData dataWithContentsOfFile:filePath];
        [lookupData retain];
        
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"assets.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"green.plist"];
        
        currentColor.red = 255;
        currentColor.green = 255;
        currentColor.red = 255;
        
        CCSprite *sky = [CCSprite spriteWithSpriteFrameName:@"sky.png"];
        sky.anchorPoint = ccp(0, 1);
        sky.position = ccp(446, 768);
        [self addChild:sky];
        
        CCSprite *sun = [CCSprite spriteWithSpriteFrameName:@"sun.png"];
        sun.position = ccp(729, 667);
        [self addChild:sun];
        
        [self addClouds];
        
        CCSprite *room = [CCSprite spriteWithSpriteFrameName:@"room.png"];
        room.anchorPoint = ccp(0, 0);
        [self addChild:room];
        
        CCSprite *camera = [CCSprite spriteWithSpriteFrameName:@"btnCamera.png"];
        
        CCMenuItem *cameraItem = [CCMenuItemSprite itemFromNormalSprite:camera selectedSprite:nil target:self selector:@selector(buttonTapped:)];
        cameraItem.tag = TAG_BTN_CAMERA;
        cameraItem.position = ccp(75, 607);
        
        CCMenu *princessMenu = [CCMenu menuWithItems:cameraItem, nil];
        princessMenu.tag = TAG_PRINCESS_MENU;
        princessMenu.position = CGPointZero;
        
        [self addChild:princessMenu];
        

        
//        testL = [ClothesPiece node];
//        testL.position = ccp(4.00, 90.00);
//        [self addChild:testL];
//        clothesArray = [[CCArray alloc] init];
//        [clothesArray addObject:testL];
        
        [self addColorButtons];
        [self addPatternButtons];
        
        clothesArray = [[CCArray alloc] init];
        [self loadPrincess];
        
//        CCSprite *p = [CCSprite spriteWithFile:@"p9.png"];
//        p.position = ccp(300, 300);
//        [self addChild:p];
        
	}
	return self;
}

- (void) loadPrincess {
    NSString *jsonString = [self jsonFromFile:@"green"];
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
            sprite.position = ccp([[positionArray objectAtIndex:0] floatValue], [[positionArray objectAtIndex:1] floatValue]);
            sprite.anchorPoint = ccp(0, 0);
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
            [p constructPiece:stroke piece:piece touchData:[pDictionary objectForKey:@"touchData"]];
            p.position = ccp([[positionArray objectAtIndex:0] floatValue], [[positionArray objectAtIndex:1] floatValue]);
            
            [self addChild:p];
            [clothesArray addObject:p];
        }
    }
}

#pragma mark -
#pragma mark Data from file - helper method
- (NSString *) jsonFromFile:(NSString *)file {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];  
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    NSString *s = [[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding] autorelease];    
    return s;
}


#pragma mark -
#pragma mark Error handlers
- (void) handleError:(NSError *)error {
    if (error != nil) {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [errorAlertView show];
        [errorAlertView release];
    }
}

- (void) buttonTapped:(CCMenuItem *)sender {
    switch (sender.tag) {
        case TAG_BTN_CAMERA:
            {
                CCLayerColor *flash = [CCLayerColor layerWithColor:ccc4(255,255,255,0)];
                flash.tag = 100;
                [self addChild:flash];
                id fadeIn = [CCSequence actions:[CCFadeIn actionWithDuration:0.07],
                             [CCCallFunc actionWithTarget:self selector:@selector(flashDown)],
                             nil];
                [flash runAction:fadeIn];
                break;
            }
        default:
            CCLOG(@"Princess debug: Unknown ID, cannot tap button");
            return;
            break;
    }
}

- (void) flashDown {
    CCMenu *menu = (CCMenu *)[self getChildByTag:TAG_PRINCESS_MENU];
    menu.visible = NO;
    CCLayerColor *flash = (CCLayerColor *)[self getChildByTag:100];
    id fadeOut = [CCSequence actions:[CCFadeOut actionWithDuration:0.1],
                 [CCCallFunc actionWithTarget:self selector:@selector(flashEnd)],
                 nil];
    [flash runAction:fadeOut];
}

- (void) flashEnd {
    CCLayerColor *flash = (CCLayerColor *)[self getChildByTag:100];
    [self removeChild:flash cleanup:YES];
    //CCLOG(@"SCREENSHOT: %@", [[CCDirector sharedDirector] screenshotTexture]);
    UIImage *screenshot = [[CCDirector sharedDirector] screenshotUIImage];
    
    //NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Screenshot.png"];
    
    //[UIImagePNGRepresentation(screenshot) writeToFile:savePath atomically:YES];
    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [colorButtons release];
    colorButtons = nil;
	[super dealloc];
}
@end
