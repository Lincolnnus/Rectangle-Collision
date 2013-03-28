//
//  BrickView.m
//  FallingBricks
//
//  Created by Shaohuan Li on 12/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BrickView.h"

@implementation BrickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) {
        NSLog(@"malloc error");
        return self;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame Color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self == nil) {
        NSLog(@"malloc error");
        return self;
    }
    self.backgroundColor = color;
    return self;
}
@end
