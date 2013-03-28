//
//  CircleModel.m
//  FallingBricks
//
//  Created by Shaohuan Li on 22/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CircleModel.h"

@implementation CircleModel

@synthesize radius;

- (id)initWithCenter:(CGPoint)c radius:(CGFloat)r mass:(CGFloat)m
{
    radius = r;
    center = c;
    rotation = 45;
    mass = m;
    velocity = [Vector2D vectorWith:0 y:0];
    momentOfInertia=(radius*radius*M_PI)/4 * mass;
    angularVelocity = 0;
    restitution = 0.5;
    force=[Vector2D vectorWith:0 y:0];
    torque=0;
    objectType = kCircleType;
    return self;
}


- (void)translateX:(CGFloat)dx Y:(CGFloat)dy {
   center = CGPointMake(center.x+dx, center.y+dy);
}

@end
