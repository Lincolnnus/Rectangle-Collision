//
//  CircleController.h
//  FallingBricks
//
//  Created by Shaohuan Li on 22/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CircleModel.h"
#import "CircleView.h"
#import "WorldView.h"
#import "WorldModel.h"

@interface CircleController : UIViewController
{
    CircleModel *circleModel;
    CircleView *circleView;
    WorldView  *worldView;
    WorldModel *worldModel;
    Vector2D *gravity;
}

@property (nonatomic,readonly,strong) CircleModel *circleModel;
@property (nonatomic,strong) CircleView *circleView;
@property (nonatomic,readonly,strong)WorldModel *worldModel;
@property (nonatomic,readonly,strong)WorldView *worldView;
@property (nonatomic) Vector2D *gravity;

- (id) initWithContainer:(WorldView*)con World:(WorldModel*)wd
                     At:(CGPoint)c Radius:(CGFloat)rad Mass:(CGFloat)mass
                  Color:(UIColor*) color;

-(void) updateGravity:(Vector2D*)g;
-(void) updateVelocity;
-(void) updatePosition;
-(void) reloadView;

@end
