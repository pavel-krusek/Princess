//
//  PrincessManager.h
//  Princess
//
//  Created by Pavel Krusek on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Princess.h"

@interface PrincessManager : NSObject

+ (PrincessManager *) sharedPrincessManager;

- (void) runPrincessScene:(NSString *)scene;

@end
