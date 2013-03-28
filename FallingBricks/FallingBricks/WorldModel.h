//
//  WorldModel.h
//  FallingBricks
//
//  Created by Shaohuan Li on 13/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"
#import "BrickModel.h"
#import "Matrix2D.h"

@interface WorldModel : NSObject{
    NSMutableArray *objects;
}

@property NSMutableArray *objects;

-(id) initWorld;
-(void) addObject: (ObjectModel*)object;


@end
