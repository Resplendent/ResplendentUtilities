//
//  RUAttributesDictionaryBuilder.h
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface RUAttributesDictionaryBuilder : NSObject

@property (nonatomic, strong) UIFont* font;
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, strong) NSNumber* lineSpacing;

-(void)absorbPropertiesFromLabel:(UILabel*)label;
-(void)absorbPropertiesFromButton:(UIButton*)button;

-(NSDictionary*)createAttributesDictionary;

@end
