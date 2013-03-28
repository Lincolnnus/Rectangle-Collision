//
//  BrickModel.m
//  FallingBricks
//
//  Created by Shaohuan Li on 12/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BrickModel.h"

@implementation BrickModel

@synthesize width;
@synthesize height;

-(id)initWidthCenter:(CGPoint)c width:(CGFloat)w height:(CGFloat)h rotation:(CGFloat)r mass:(CGFloat)m restitution:(CGFloat)rest friction:(CGFloat)fric{

    self = [super init];
    if(self == nil) {
        return self;
    }
    width = w;
    height = h;
    center = c;
    rotation = r;
    mass = m;
    
    momentOfInertia=(w * w + h * h)/12 * m;
    velocity = [Vector2D vectorWith:0 y:0];
    force=[Vector2D vectorWith:0 y:0];
    
    torque=0;
    angularVelocity=0;
    objectType = kRectType;
    
    if(rest > 1 ||rest < 0){
        NSLog(@"Invalid Restitution");
        restitution = 0;
    }else
        restitution = rest;
    
    if(fric > 1 || fric < 0){
        NSLog(@"Invalid Friction");
        friction = 1;
    }else
        friction = fric;
    return self;
}
- (CGPoint)rotatePoint:(CGPoint)oldPoint {
	//REQUIRES : An old CGPoint
	//EFFECTS : Returns the new point after rotating
	CGPoint relative, newPoint;
	CGFloat angle=self.rotation * M_PI/180.0;
	relative.x = oldPoint.x-self.center.x;
	relative.y = oldPoint.y-self.center.y;
	/*newPoint.x = relative.x*cos(angle) - relative.y*sin(angle)+self.center.x;
	newPoint.y = relative.x*sin(angle) + relative.y*cos(angle)+self.center.y;*/
    newPoint.x = relative.x * cos(angle) + relative.y * sin(angle) + self.center.x;
    newPoint.y = -relative.x * sin(angle) + relative.y * cos(angle) + self.center.y;
	return newPoint;
    /*
     Yujing:
     Are you sure your transformation matrix is correct?
     Remember: you are not using your traditional math coordinate system
     For the coordinate system that you are using, it should be:
     newPoint.x = relative.x * cos(angle) + relative.y * sin(angle) + self.center.x;
     newPoint.y = -relative.x * sin(angle) + relative.y * cos(angle) + self.center.y;
     But since I modified your code so that it is in the Math coordinate system, your transformation matrix is correct :p
     */
}
- (CGPoint)cornerFrom:(CornerType)corner {
    // REQUIRES: corner is a enum constant defined in PEShape.h as follows:
    //           kTopLeftCorner, kTopRightCorner, kBottomLeftCorner,
    //		   kBottomRightCorner
    // EFFECTS: returns the coordinates of the specified rotated rectangle corner after rotating
    switch (corner) {
        case kTopLeftCorner:
            return [self rotatePoint:CGPointMake(self.center.x-self.width/2, self.center.y-self.height/2)];
            break;
        case kTopRightCorner:
            return [self rotatePoint:CGPointMake(self.center.x+self.width/2, self.center.y-self.height/2)];
            break;
        case kBottomLeftCorner:
            return [self rotatePoint:CGPointMake(self.center.x-self.width/2, self.center.y+self.height/2)];
            break;
        case kBottomRightCorner:
            return [self rotatePoint:CGPointMake(self.center.x+self.width/2, self.center.y+self.height/2)];
            break;
        default:
            break;
    }
}

- (CGPoint*)corners {
    // EFFECTS:  return an array with all the rectangle corners
    
    CGPoint *corners = (CGPoint*) malloc(4*sizeof(CGPoint));
    corners[0] = [self cornerFrom: kTopLeftCorner];
    corners[1] = [self cornerFrom: kTopRightCorner];
    corners[2] = [self cornerFrom: kBottomRightCorner];
    corners[3] = [self cornerFrom: kBottomLeftCorner];
    return corners;
}

@end
