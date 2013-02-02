//
//  RUSynthesizeUserDefaultMethods.h
//  Albumatic
//
//  Created by Benjamin Maer on 2/2/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RUSynthesizeSetUserDefaultsMethod(varName,key) \
-(void)set##varName:(id)varName \
{ \
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults]; \
    if (varName) [userDefaults setObject:varName forKey:key]; \
    else [userDefaults removeObjectForKey:key]; \
    [userDefaults synchronize]; \
}

