//
//  World.m
//  FallingBricks
//
//  Created by Shaohuan Li on 13/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "WorldModel.h"

@implementation WorldModel

@synthesize objects;

-(id)initWorld{
    self=[super init];
    if(self==nil){
        NSLog(@"Problem with malloc");
        return self;
    }
    objects=[NSMutableArray array];
    return self;
}

-(void) addObject:(ObjectModel*)object{
    if(object==nil)
        return;
    [objects addObject:object];
}
@end
