//
//  Constants.h
//  Princess
//
//  Created by Pavel Krusek on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

typedef enum {
    kYellow,
    kWhite,
    kBlack,
    kBrown,
    kMint,
    kViolet,
    kOrange,
    kAzure,
    kRose,
    kRed,
    kGreen,
    kBlue,
    kLightYellow
} ColorButtonTypes;

typedef enum {
    kOne,
    kTwo,
    kThree,
    kFour,
    kFive,
    kSix,
    kSeven,
    kEight,
    kNine,
    kTen
} PatternButtonTypes;

typedef struct {
    GLubyte red;
    GLubyte green;
    GLubyte blue;
} Colors;

typedef struct {
    NSString *source;
    float xPos;
    float yPos;
    int z;
} Piece;