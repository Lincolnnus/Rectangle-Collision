//
//  BrickModel.h
//  FallingBricks
//
//  Created by Shaohuan Li on 12/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ObjectModel.h"
typedef enum {
    kTopLeftCorner = 1,
    kTopRightCorner = 2,
    kBottomLeftCorner = 3,
    kBottomRightCorner = 4
} CornerType;

@interface BrickModel : ObjectModel{
}

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

@property (nonatomic, readonly) CGPoint* corners;

-(id)initWidthCenter:(CGPoint)c width:(CGFloat)w height:(CGFloat)h rotation:(CGFloat)r
                mass:(CGFloat)m restitution:(CGFloat)rest friction:(CGFloat)fric;

@end
