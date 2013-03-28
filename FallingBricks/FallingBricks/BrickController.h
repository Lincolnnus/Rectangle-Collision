//
//  BrickController.h
//  FallingBricks
//
//  Created by Shaohuan Li on 12/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BrickModel.h"
#import "BrickView.h"
#import "WorldView.h"
#import "WorldModel.h"

@interface BrickController : UIViewController{
    BrickModel *brickModel;
    BrickView *brickView;
    WorldView  *worldView;
    WorldModel *worldModel;
    Vector2D *gravity;
}

@property (nonatomic,readonly,strong) BrickModel *brickModel;
@property (nonatomic,strong)BrickView *brickView;
@property (nonatomic,readonly,strong)WorldModel *worldModel;
@property (nonatomic,readonly,strong)WorldView *worldView;
@property (nonatomic) Vector2D *gravity;

-(id) initWithContainer:(WorldView*)con World:(WorldModel*)wd At:(CGPoint)c Width:(CGFloat)w Height:(CGFloat)h Mass:(CGFloat)m Rotation:(CGFloat)r Restitution:(CGFloat)rest Friction:(CGFloat)fric Color:(UIColor*) color;

-(void) updateGravity:(Vector2D*)g;
-(void) updateVelocity;
-(void) updatePosition;
-(void) reloadView;

@end
