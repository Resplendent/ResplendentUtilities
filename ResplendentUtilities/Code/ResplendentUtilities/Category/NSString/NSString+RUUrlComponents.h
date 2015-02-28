//
//  NSString+RUUrlComponents.h
//  VibeWithIt
//
//  Created by Benjamin Maer on 11/3/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSString (RUUrlComponents)

-(NSString*)ru_urlPathWithUrlParameters:(NSDictionary*)urlParameters;

+(NSString*)ru_urlPathComponentsFromUrlParameters:(NSDictionary*)urlParameters;

@end
