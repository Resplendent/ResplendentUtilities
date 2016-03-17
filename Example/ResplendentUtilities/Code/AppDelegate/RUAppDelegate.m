//
//  RUAppDelegate.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 02/10/2016.
//  Copyright (c) 2016 Benjamin Maer. All rights reserved.
//

#import "RUAppDelegate.h"
#import "RUSynthesizeUserDefaultMethods_Testing.h"

#import "RUConstants.h"
#import "RUConditionalReturn.h"
#import "RUOrderedMutableDictionary.h"
#import "RUOrderedDictionary.h"





@interface RUAppDelegate ()

#pragma mark - test_RUOrderedMutableDictionary
-(void)test_RUOrderedMutableDictionary;

#pragma mark - test_RUOrderedDictionary
-(void)test_RUOrderedDictionary;

@end





@implementation RUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self test_RUOrderedMutableDictionary];

	[self test_RUOrderedDictionary];

	[RUSynthesizeUserDefaultMethods_Testing runTests];

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - test_RUOrderedMutableDictionary
-(void)test_RUOrderedMutableDictionary
{
	/*
	 RUOrderedMutableDictionary validates itself in its `+initialize` method, so we are just calling the class method `class` to trigger it.
	 */
	
	[RUOrderedMutableDictionary class];
}

#pragma mark - test_RUOrderedDictionary
-(void)test_RUOrderedDictionary
{
	/*
	 RUOrderedMutableDictionary validates itself in its `+initialize` method, so we are just calling the class method `class` to trigger it.
	 */
	
	[RUOrderedDictionary class];
}

@end
