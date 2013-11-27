//
//  Created by Benjamin Maer on 5/6/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "UIView+RUUtility.h"

#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAShapeLayer.h>

#define kAnimateWithFallfrontDuration1  0.3f
#define kAnimateWithFallfrontDuration2  0.3f

#define kAnimateWithFallbackDuration1   0.2f
#define kAnimateWithFallbackDuration2   0.3f

#define kMoveBackDuration   0.2f
#define kMoveBackDepth      60.0f





@implementation UIView (RUUtility)

#pragma mark - Underline methods
+(UIView*)makeDividerWithColorFloat:(float)colorFloat atXCoord:(float)xCoord atYCoord:(float)yCoord withWidth:(float)width height:(float)height
{
    UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(xCoord, yCoord, width, height)];
    [divider setBackgroundColor:[UIColor colorWithRed:colorFloat/255.0f green:colorFloat/255.0f blue:colorFloat/255.0f alpha:1.0f]];
    return divider;
}

+(UIView*)makeDividerWithColor:(UIColor*)color atXCoord:(float)xCoord atYCoord:(float)yCoord withWidth:(float)width height:(float)height
{
    UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(xCoord, yCoord, width, height)];
    [divider setBackgroundColor:color];
    return divider;
}

-(UIView*)addDividerLineWithColorFloat:(float)colorFloat withWidth:(float)width atYCoord:(float)yCoord height:(float)height
{
    UIView* overline = [UIView makeDividerWithColorFloat:colorFloat atXCoord:((self.frame.size.width - width) / 2.0f) atYCoord:yCoord withWidth:width height:height];
    [self addSubview:overline];
    return overline;    
}

-(UIView*)addDividerLineWithColorFloat:(float)colorFloat withWidth:(float)width atYCoord:(float)yCoord
{
    return [self addDividerLineWithColorFloat:colorFloat withWidth:width atYCoord:yCoord height:1.0f];
}

-(UIView*)addOverlineWithColorFloat:(float)colorFloat withWidth:(float)width
{
    return [self addDividerLineWithColorFloat:colorFloat withWidth:width atYCoord:0.0f];
}

-(UIView*)addOverlineWithColorFloat:(float)colorFloat
{
    return [self addOverlineWithColorFloat:colorFloat withWidth:self.frame.size.width];
}

-(UIView*)addOverline
{
    return [self addOverlineWithColorFloat:0.0f];
}

-(UIView*)addUnderlineWithColor:(UIColor*)color
{
    UIView* underline = [UIView makeDividerWithColor:color atXCoord:0.0f atYCoord:self.frame.size.height withWidth:self.frame.size.width height:1.0f];
    [self addSubview:underline];
    return underline;
}

-(UIView*)addUnderlineWithColorFloat:(float)colorFloat withWidth:(float)width height:(float)height
{
    UIView* underline = [UIView makeDividerWithColorFloat:colorFloat atXCoord:((self.frame.size.width - width) / 2.0f) atYCoord:self.frame.size.height - height withWidth:width height:height];
    [self addSubview:underline];
    return underline;
}

-(UIView*)addUnderlineWithColorFloat:(float)colorFloat withWidth:(float)width
{
    return [self addUnderlineWithColorFloat:colorFloat withWidth:width height:1.0f];
}

-(UIView*)addUnderlineWithColorFloat:(float)colorFloat
{
    return [self addUnderlineWithColorFloat:colorFloat withWidth:self.frame.size.width];
}

-(UIView*)addUnderline
{
    return [self addUnderlineWithColorFloat:0.0f];
}

#pragma mark - Shadow methods
-(void)setShadowSize:(CGSize)shadowSize radius:(float)radius opacity:(float)opacity
{
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = shadowSize;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
}

-(void)setShadowColor:(UIColor*)color
{
    [self.layer setShadowColor:color.CGColor];
}

-(void)setShadowHeight:(float)shadowHeight radius:(float)radius opacity:(float)opacity
{
    [self setShadowSize:CGSizeMake(0, shadowHeight) radius:radius opacity:opacity];
}

#pragma mark - Animations
-(void)animateWithFallfrontStart:(void (^)())start middle:(void (^)())middle end:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:kAnimateWithFallfrontDuration1 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        start();
        CATransform3D leftTransform = self.layer.transform;

        leftTransform = CATransform3DTranslate(leftTransform, 0, 0, PINE_ANIMATION_TRANSLATION_DEPTH);
        leftTransform = CATransform3DRotate(leftTransform, PINE_ANIMATION_ROTATION_DEGREES, 1, 0, 0);

        self.layer.transform = leftTransform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimateWithFallfrontDuration2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            middle();
            CATransform3D leftTransform = self.layer.transform;

            leftTransform = CATransform3DRotate(leftTransform, -PINE_ANIMATION_ROTATION_DEGREES, 1, 0, 0);
            leftTransform = CATransform3DTranslate(leftTransform, 0, 0, PINE_ANIMATION_TRANSLATION_DEPTH);
            
            self.layer.transform = leftTransform;
        } completion:completion];
    }];

    return;
}

-(void)animateWithFallbackStart:(void (^)())start middle:(void (^)())middle end:(void (^)(BOOL finished))completion
{
    CATransform3D initialTransform = self.layer.transform;
    initialTransform.m34 = 1.0 / -900;
    self.layer.transform = initialTransform;

    [UIView animateWithDuration:kAnimateWithFallbackDuration1 animations:^{
        CATransform3D t = self.layer.transform;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        start();
        t = CATransform3DTranslate(t, 0, 0, -PINE_ANIMATION_TRANSLATION_DEPTH);
        t = CATransform3DRotate(t, PINE_ANIMATION_ROTATION_DEGREES, 1, 0, 0); //rotate 90 degrees about the Y axis
        self.layer.transform = t;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimateWithFallbackDuration2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            middle();
            CATransform3D t = self.layer.transform;
            t = CATransform3DRotate(t, -PINE_ANIMATION_ROTATION_DEGREES, 1, 0, 0); //rotate 90 degrees about the Y axis
            t = CATransform3DTranslate(t, 0, 0, -PINE_ANIMATION_TRANSLATION_DEPTH);
            self.layer.transform = t;
        } completion:completion];
    }];
}

-(void)animateMoveBackStart:(void (^)())start completion:(void (^)(BOOL finished))completion
{
    CATransform3D initialTransform = self.layer.transform;
    initialTransform.m34 = 1.0 / -900;
    self.layer.transform = initialTransform;

    [UIView animateWithDuration:kMoveBackDuration animations:^{
        if (start)
            start();
        CATransform3D t = self.layer.transform;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        t = CATransform3DTranslate(t, 0, 0, -kMoveBackDepth);
        self.layer.transform = t;
    } completion:completion];
}

-(void)animateMoveFrontStart:(void (^)())start completion:(void (^)(BOOL finished))completion
{
    CATransform3D initialTransform = self.layer.transform;
    initialTransform.m34 = 1.0 / -900;
    self.layer.transform = initialTransform;

    [UIView animateWithDuration:kMoveBackDuration animations:^{
        if (start)
            start();
        CATransform3D t = self.layer.transform;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        t = CATransform3DTranslate(t, 0, 0, kMoveBackDepth);
        self.layer.transform = t;
    } completion:completion];
}


#pragma mark Increase frame methods
-(void)increaseWidth:(CGFloat)width
{
    [self setWidth:self.frame.size.width + width];
}

-(void)increaseHeight:(CGFloat)height
{
    [self setHeight:self.frame.size.height + height];
}

-(void)increaseWidth:(CGFloat)width height:(CGFloat)height
{
    [self setWidth:self.frame.size.width + width height:self.frame.size.height + height];
}

-(void)setWidth:(CGFloat)width
{
    [self setWidth:width height:self.frame.size.height];
}

-(void)setHeight:(CGFloat)height
{
    [self setWidth:self.frame.size.width height:height];
}

-(void)setWidth:(CGFloat)width height:(CGFloat)height
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height)];
}

-(void)setSize:(CGSize)size
{
    [self setWidth:size.width height:size.height];
}

@end
