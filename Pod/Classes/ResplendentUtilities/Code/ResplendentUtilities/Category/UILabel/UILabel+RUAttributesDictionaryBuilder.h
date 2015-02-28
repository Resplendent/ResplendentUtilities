//
//  UILabel+RUAttributesDictionaryBuilder.h
//  Nifti
//
//  Created by Benjamin Maer on 12/12/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import <UIKit/UIKit.h>





@class RUAttributesDictionaryBuilder;





@interface UILabel (RUAttributesDictionaryBuilder)

-(void)ru_absorbPropertiesFromAttributesDictionaryBuilder:(RUAttributesDictionaryBuilder*)attributesDictionaryBuilder;

@end
