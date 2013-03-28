//
//  CircleView.h
//  FallingBricks
//
//  Created by Shaohuan Li on 22/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView
{
    CGFloat radius;
}

- (id)initWithFrame:(CGRect)frame Radius:(CGFloat)rad Color:(UIColor*)color;

@end
