//
//  NSString+RUFormatting.h
//  Camerama
//
//  Created by Benjamin Maer on 10/14/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSString (RUFormatting)

-(NSString*)ru_stringByRemovingCharactersFromSet:(NSCharacterSet*)characterSet;
-(NSString*)ru_stringByRemovingAllButDecimals;

@end
