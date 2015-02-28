//
//  RUAttributesDictionaryBuilder.h
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface RUAttributesDictionaryBuilder : NSObject

@property (nonatomic, strong) UIFont* font;
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, strong) NSNumber* lineSpacing;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, assign) BOOL textColorShouldUseCoreTextKey;
@property (nonatomic, assign) NSTextAlignment textAlignment;

-(void)absorbPropertiesFromLabel:(UILabel*)label;
-(void)absorbPropertiesFromButton:(UIButton*)button;
-(void)absorbPropertiesFromTextField:(UITextField*)textField;
-(void)absorbPropertiesFromTextView:(UITextView*)textView;

-(NSDictionary*)createAttributesDictionary;

@end
