//
//  NSDate+Utility.h
//  Memeni
//
//  Created by Benjamin Maer on 9/6/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

//-(NSString*)daysOrHoursOrMinutesOrSecondsString;
//
//-(NSTimeInterval)daysOrHoursOrMinutesOrSecondsTypeTimeInterval;
//
//+(NSString*)daysOrHoursOrMinutesOrSecondsStringWithTimeIntervalNow:(NSTimeInterval)timeInterval;

-(NSString*)timeAgoString;

//Returns 0 if the date is over a month old, otherwise returns number of seconds for the min unit of the time ago string
-(NSTimeInterval)minTimeAgoUnitSeconds;

@end
