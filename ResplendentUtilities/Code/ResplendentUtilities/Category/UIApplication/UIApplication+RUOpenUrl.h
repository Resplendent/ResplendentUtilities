//
//  UIApplication+RUOpenUrl.h
//  VibeWithIt
//
//  Created by Benjamin Maer on 12/1/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIApplication (RUOpenUrl)

-(BOOL)ru_attemptToOpenUrls:(NSArray*)urls;

@end
