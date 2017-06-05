//
//  CALayer+RUCornerRadius.m
//  Pods
//
//  Created by Benjamin Maer on 6/5/17.
//
//

#import "CALayer+RUCornerRadius.h"





@implementation CALayer (RUCornerRadius)

#pragma mark - cornerRadius_rounded
-(CGFloat)ru_cornerRadius_rounded_from_boundingSize:(CGSize)boundingSize
{
	return MIN(boundingSize.width, boundingSize.height) / 2.0f;
}

-(void)ru_setCornerRadius_rounded_from_boundingSize:(CGSize)boundingSize
{
	[self setCornerRadius:[self ru_cornerRadius_rounded_from_boundingSize:boundingSize]];
}

@end
