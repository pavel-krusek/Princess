//
//  ClothesPiece.h
//  Princess
//
//  Created by Pavel Krusek on 12/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCMask.h"

@interface ClothesPiece : CCLayer {
    CCSprite *mask;
}

@property (nonatomic, assign) CCSprite *piece;
@property (nonatomic, assign) CCMask *masked;

- (void) addPattern:(CGPoint)touchLocation pattern:(NSString *)pattern;
- (void) constructPiece:(Piece)stroke piece:(Piece)p;
 

@end
