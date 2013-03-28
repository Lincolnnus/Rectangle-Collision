//
//  ObjectModel.h
//  FallingBricks
//
//  Created by Shaohuan Li on 12/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"
#define timerInterval (1.5f/60.0f)

typedef enum{
    kRectType =1,
    kCircleType=2
}ShapeType;

@interface ObjectModel : NSObject{
    CGFloat mass;
    CGPoint center;
    CGFloat friction;
    CGFloat rotation;
    CGFloat restitution;
    CGFloat momentOfInertia;
    
    CGFloat angularVelocity;
    CGFloat torque;
    Vector2D *velocity;
    Vector2D *force;
    ShapeType objectType;
}

@property (nonatomic, readonly) CGFloat mass;
@property (nonatomic, readonly) CGFloat momentOfInertia;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGFloat rotation;
@property (nonatomic, readonly) CGFloat restitution;
@property (nonatomic, readonly) CGFloat friction;

@property (nonatomic) CGFloat angularVelocity;
@property (nonatomic) CGFloat torque;

@property (nonatomic) Vector2D *velocity;
@property (nonatomic) Vector2D *force;

@property (nonatomic, readonly) ShapeType objectType;
@end
