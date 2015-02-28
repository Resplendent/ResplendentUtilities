//
//  NSBundle+RUPListGetters.h
//  Racer Tracer
//
//  Created by Benjamin Maer on 6/9/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSBundle (RUPListGetters)

-(NSString*)ruCFBundleShortVersionString;
-(NSString*)ru_CFBundleName;
-(NSString*)ruCFBundleVersionString;		//Commonly refered to as bundle version

-(NSString*)ruFacebookAppID;

@end
