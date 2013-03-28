//
//  ViewController.h
//  FallingBricks
//
//  Created by Shaohuan Li on 12/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorldModel.h"
#import "WorldView.h"
#import "BrickController.h"
#import "CircleController.h"

#define accCoef 250
#define timerInterval (1.5f/60.0f)

#define constantK 0.005     // max separation allowed
#define constantFactor 0.40   // constant E used to calculate bias
#define Fcoefficient 0.95   // coefficient used to help deduce good reference edge

@interface ViewController : UIViewController<UIAccelerometerDelegate>{
    WorldModel *worldModel;
    WorldView *worldView;
}
@property (strong, nonatomic) IBOutlet WorldView *worldView;

@property (nonatomic,readonly,strong) WorldModel *worldModel;

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

- (void) collisionDetection;// detecting collisions

- (void) handleCollision: (ObjectModel*) two with: (ObjectModel*) one;//handle collision of two generic shape objects

- (void) handleCollisionRR: (BrickModel*) two with: (BrickModel*) one;//handle collision of two rectangles

- (void) handleCollisionCR: (CircleModel*) two with: (BrickModel*) one;//handle collision of two rectangles

- (void) handleImpulse:(ObjectModel*)two with: (ObjectModel*)one contacting:(Vector2D*)contact withNormal: (Vector2D*)normal seperatedBy:(double)separation;//handle impulse of two rectangles

@end
