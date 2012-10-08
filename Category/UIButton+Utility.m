//
//  UIButton+Utility.m
//  Memeni
//
//  Created by Benjamin Maer on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIButton+Utility.h"

#define kUIButtonCrossHeightDefault     4.0f

@implementation UIButton (Utility)

#pragma mark - Static methods
+(UIButton*)buttonWithCrossFrame:(CGRect)frame
{
    return [UIButton buttonWithCrossFrame:frame crossColor:[UIColor whiteColor]];
}

+(UIButton*)buttonWithCrossFrame:(CGRect)frame crossColor:(UIColor*)crossColor
{
    return [UIButton buttonWithCrossFrame:frame crossColor:crossColor crossHeight:kUIButtonCrossHeightDefault];
}

+(UIButton*)buttonWithCrossFrame:(CGRect)frame crossColor:(UIColor*)crossColor crossHeight:(CGFloat)crossHeight
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];

    UIView* xDiagPiece1 = [[UIView alloc] initWithFrame:CGRectMake(0, (button.frame.size.height - crossHeight) / 2.0f, button.frame.size.width, crossHeight)];
    [xDiagPiece1 setBackgroundColor:[UIColor whiteColor]];
    [xDiagPiece1 setUserInteractionEnabled:NO];
    xDiagPiece1.transform = CGAffineTransformMakeRotation(M_PI * 1.0f / 4.0f);
    [button addSubview:xDiagPiece1];
    
    UIView* xDiagPiece2 = [[UIView alloc] initWithFrame:CGRectMake(0, (button.frame.size.height - crossHeight) / 2.0f, button.frame.size.width, crossHeight)];
    [xDiagPiece2 setBackgroundColor:[UIColor whiteColor]];
    [xDiagPiece2 setUserInteractionEnabled:NO];
    xDiagPiece2.transform = CGAffineTransformMakeRotation(M_PI * 3.0f / 4.0f);
    [button addSubview:xDiagPiece2];

    return button;
}

@end
