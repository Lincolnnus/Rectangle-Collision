//
//  CircleController.m
//  FallingBricks
//
//  Created by Shaohuan Li on 22/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CircleController.h"

@interface CircleController ()

@end

@implementation CircleController

@synthesize worldModel;
@synthesize worldView;
@synthesize circleModel;
@synthesize circleView;
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

//init and data handlers
- (id)initWithContainer:(WorldView*)con World:(WorldModel*)wd
                     At:(CGPoint)c Radius:(CGFloat)rad Mass:(CGFloat)mass
                  Color:(UIColor*) color
{
    self = [super init];
    
    worldView = con;
    worldModel = wd;
    circleModel = [[CircleModel alloc] initWithCenter:c radius:rad mass:mass];
    [worldModel addObject:circleModel];
    circleView= [[CircleView alloc] initWithFrame:CGRectMake(circleModel.center.x-rad,circleModel.center.y-rad,2*rad,2*rad) Radius:rad Color:(UIColor*)color];
    [worldView addSubview:circleView];
    return self;
}

-(void) updatePosition
{
    //EFFECT: update position of the object according to its velocities and time interval given
    Vector2D *temp = [circleModel.velocity multiply:timerInterval];
    circleModel.rotation = circleModel.rotation + timerInterval*circleModel.angularVelocity/M_PI * 180;
    circleModel.center = CGPointMake(circleModel.center.x+temp.x, circleModel.center.y+temp.y);
    
}

-(void) updateGravity:(Vector2D*)g
{
    //EFFECT:update gravity
    gravity=g;
}
-(void) updateVelocity
{
    //EFFECT: update velocity with gravity for a time interval
    if(circleModel.mass!=INFINITY)
    {
        circleModel.velocity = [circleModel.velocity add:[[gravity add:[circleModel.force multiply:1.0/circleModel.mass]] multiply:timerInterval]];
        circleModel.angularVelocity=circleModel.angularVelocity +circleModel.torque*timerInterval/circleModel.momentOfInertia;
    }
}

-(void)reloadView
{
    //EFFECT: update the controller's main view
    [circleView setCenter:[circleModel center]];
    [circleView setTransform : CGAffineTransformMakeRotation(circleModel.rotation * M_PI / 180 )];
}
@end
