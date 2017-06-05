//
//  CALayer+RUCornerRadius.h
//  Pods
//
//  Created by Benjamin Maer on 6/5/17.
//
//

#import <QuartzCore/QuartzCore.h>





@interface CALayer (RUCornerRadius)

#pragma mark - cornerRadius_rounded
-(CGFloat)ru_cornerRadius_rounded_from_boundingSize:(CGSize)boundingSize;
-(void)ru_setCornerRadius_rounded_from_boundingSize:(CGSize)boundingSize;

@end
