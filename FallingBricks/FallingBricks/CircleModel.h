//
//  CircleModel.h
//  FallingBricks
//
//  Created by Shaohuan Li on 22/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ObjectModel.h"

@interface CircleModel : ObjectModel{
}

@property (nonatomic, readonly) CGFloat radius;

-(id)initWithCenter:(CGPoint)c radius:(CGFloat)r mass:(CGFloat)m;

@end
