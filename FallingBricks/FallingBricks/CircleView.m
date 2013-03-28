//
//  CircleView.m
//  FallingBricks
//
//  Created by Shaohuan Li on 22/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawCircle];
}
- (void)drawCircle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor redColor] set];
    CGContextAddArc(context, radius, radius, radius, 0.0, M_PI * 2.0, YES);
    CGContextFillPath(context);
}
- (id)initWithFrame:(CGRect)frame Radius:(CGFloat)rad Color:(UIColor*)color
{
    self = [self initWithFrame:frame];
    radius=rad;
    self.backgroundColor = [UIColor clearColor];
    return self;
}

@end
