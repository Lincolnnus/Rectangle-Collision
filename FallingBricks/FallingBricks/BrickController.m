//
//  BrickController.m
//  FallingBricks
//
//  Created by Shaohuan Li on 12/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BrickController.h"

@interface BrickController ()

@end

@implementation BrickController

@synthesize worldModel;
@synthesize worldView;
@synthesize brickModel;
@synthesize brickView;
@synthesize gravity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(id)initWithContainer:(WorldView*)con World:(WorldModel*)wd At:(CGPoint)c Width:(CGFloat)w Height:(CGFloat)h Mass:(CGFloat)m Rotation:(CGFloat)r Restitution:(CGFloat)rest Friction:(CGFloat)fric Color:(UIColor*)color{
    self = [super init];
    if(self == nil){
        NSLog(@"malloc error");
        return self;
    }
    worldView = con;
    worldModel = wd;
    
    //add model
    brickModel = [[BrickModel alloc] initWidthCenter:c width:w height:h rotation:r mass:m restitution:rest friction:fric];
    
    [worldModel addObject:brickModel];
    
    //load view
    brickView= [[BrickView alloc]
                        initWithFrame:(CGRectMake(c.x-w/2, c.y-h/2, w, h))
                        Color:color];
    
    [brickView setTransform : CGAffineTransformMakeRotation(r * M_PI / 180 )];
    [worldView addSubview:brickView];
    return self;
}

-(void) updateGravity:(Vector2D*)g
{
    //EFFECT:update gravity
    gravity=g;
}
-(void) updateVelocity
{
    //EFFECT: update velocity with gravity for a time interval
    if(brickModel.mass!=INFINITY)
    {
        brickModel.velocity = [brickModel.velocity add:[[gravity add:[brickModel.force multiply:1.0/brickModel.mass]] multiply:timerInterval]];
        brickModel.angularVelocity=brickModel.angularVelocity +brickModel.torque*timerInterval/brickModel.momentOfInertia;
    }
}
-(void) updatePosition
{
    //EFFECT: update position of the object according to its velocities and time interval given
    Vector2D *temp = [brickModel.velocity multiply:timerInterval];
    brickModel.rotation = brickModel.rotation + timerInterval*brickModel.angularVelocity/M_PI * 180;
    brickModel.center = CGPointMake(brickModel.center.x+temp.x, brickModel.center.y+temp.y);
    
}

-(void)reloadView
{
    //EFFECT: update the controller's main view
    [brickView setCenter:[brickModel center]];
    [brickView setTransform : CGAffineTransformMakeRotation(brickModel.rotation * M_PI / 180 )];
}
@end
