//
//  NSDate+RUUtility.h
//  Resplendent
//
//  Created by Benjamin Maer on 9/6/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>





typedef enum{
	NSDate_RU_CalendarUnitSecond,
	NSDate_RU_CalendarUnitMinute,
	NSDate_RU_CalendarUnitHour,
	NSDate_RU_CalendarUnitDay,
	NSDate_RU_CalendarUnitMonth,
	NSDate_RU_CalendarUnitYear
}NSDate_RU_CalendarUnit;




@protocol NSDate_RUTimeAgoFormatter <NSObject>

-(NSString*)ruTimeAgoFormatterForCalendarUnit:(NSDate_RU_CalendarUnit)calendarUnit;

@end





@interface NSDate (RUTimeAgo)

-(NSString*)ru_timeAgoString;
-(NSString*)ru_timeAgoStringWithFormatter:(id<NSDate_RUTimeAgoFormatter>)formatter;

//Returns 0 if the date is over a month old, otherwise returns number of seconds for the min unit of the time ago string
-(NSTimeInterval)ru_minTimeAgoUnitSeconds;

@end
