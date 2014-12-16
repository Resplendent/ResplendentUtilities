//
//  NSDate+RUUtility.m
//  Resplendent
//
//  Created by Benjamin Maer on 9/6/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "NSDate+RUTimeAgo.h"
#import "RUConstants.h"
#import "RUProtocolOrNil.h"
#import "RUConditionalReturn.h"





@interface NSDate (_RUTimeAgo)

+(NSCalendar*)ru_staticGregorianCalendar;

-(NSDateComponents*)ru_timoAgoDateComponentsFromDate;

+(NSInteger)ru_timeAgoStringAmountWithCalendarUnitType:(NSDate_RU_CalendarUnit)calendarUnit dateCompontents:(NSDateComponents*)comps;
+(NSString*)ru_timeAgoStringSuffixWithCalendarUnitType:(NSDate_RU_CalendarUnit)calendarUnit;

+(NSDate_RU_CalendarUnit)ru_timeAgoMinCalendarUnitWithDateCompontents:(NSDateComponents*)comps;

@end





@implementation NSDate (_RUTimeAgo)

+(NSCalendar*)ru_staticGregorianCalendar
{
	static NSCalendar *gregorian;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	});

	return gregorian;
}

-(NSDateComponents*)ru_timoAgoDateComponentsFromDate
{
	NSInteger const gregorianComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	return [[self.class ru_staticGregorianCalendar] components:gregorianComponents fromDate:self toDate:[NSDate date] options:0];
}

+(NSString*)ru_timeAgoStringSuffixWithCalendarUnitType:(NSDate_RU_CalendarUnit)calendarUnit
{
	switch (calendarUnit)
	{
		case NSDate_RU_CalendarUnitYear:
			return @"y";

		case NSDate_RU_CalendarUnitMonth:
			return @"mo";
			break;
		case NSDate_RU_CalendarUnitDay:
			return @"d";
			break;
		case NSDate_RU_CalendarUnitHour:
			return @"h";
			break;
		case NSDate_RU_CalendarUnitMinute:
			return @"m";
			break;
		case NSDate_RU_CalendarUnitSecond:
			return @"s";
			break;
			
		default:
			return nil;
			break;
	}
}

+(NSInteger)ru_timeAgoStringAmountWithCalendarUnitType:(NSDate_RU_CalendarUnit)calendarUnit dateCompontents:(NSDateComponents*)comps
{
	switch (calendarUnit)
	{
		case NSDate_RU_CalendarUnitYear:
			return comps.year;

		case NSDate_RU_CalendarUnitMonth:
			return comps.month;

		case NSDate_RU_CalendarUnitDay:
			return comps.day;

		case NSDate_RU_CalendarUnitHour:
			return comps.hour;

		case NSDate_RU_CalendarUnitMinute:
			return comps.minute;

		case NSDate_RU_CalendarUnitSecond:
			return MAX(comps.second, 0);
	}

	NSAssert(false, @"unhandled");
	return NSNotFound;
}

+(NSDate_RU_CalendarUnit)ru_timeAgoMinCalendarUnitWithDateCompontents:(NSDateComponents*)comps
{
	if ([comps year] > 0)
	{
		return NSDate_RU_CalendarUnitYear;
	}
	else if ([comps month] > 0)
	{
		return NSDate_RU_CalendarUnitMonth;
	}
	else if ([comps day] > 0)
	{
		return NSDate_RU_CalendarUnitDay;
	}
	else if ([comps hour] > 0)
	{
		return NSDate_RU_CalendarUnitHour;
	}
	else if ([comps minute] > 0)
	{
		return NSDate_RU_CalendarUnitMinute;
	}
	else if ([comps second] >= 0)
	{
		return NSDate_RU_CalendarUnitSecond;
	}
	
	return NSDate_RU_CalendarUnitSecond;
}

@end





@implementation NSDate (RUTimeAgo)

-(NSString*)ru_timeAgoString
{
	return [self ru_timeAgoStringWithFormatter:nil];
}

-(NSString*)ru_timeAgoStringWithFormatter:(id<NSDate_RUTimeAgoFormatter>)formatter
{
	kRUConditionalReturn_ReturnValueNil(((formatter != nil) && (kRUProtocolOrNil(formatter, NSDate_RUTimeAgoFormatter) == nil)), YES);

	NSDateComponents *comps = [self ru_timoAgoDateComponentsFromDate];
	NSDate_RU_CalendarUnit calendarUnit = [self.class ru_timeAgoMinCalendarUnitWithDateCompontents:comps];

	NSString* timeAgoString = (formatter == nil ?
							   [self.class ru_timeAgoStringSuffixWithCalendarUnitType:calendarUnit] :
							   [formatter ruTimeAgoFormatterForCalendarUnit:calendarUnit]);
	long timeAgoStringAmount = [self.class ru_timeAgoStringAmountWithCalendarUnitType:calendarUnit dateCompontents:comps];

	return RUStringWithFormat(@"%li%@",timeAgoStringAmount,timeAgoString);
}

-(NSTimeInterval)ru_minTimeAgoUnitSeconds
{
    NSDateComponents *comps = [self ru_timoAgoDateComponentsFromDate];
	NSDate_RU_CalendarUnit minCalendarUnit = [self.class ru_timeAgoMinCalendarUnitWithDateCompontents:comps];
    switch (minCalendarUnit)
    {
        case NSDate_RU_CalendarUnitDay:
            return 86400.0f;

		case NSDate_RU_CalendarUnitHour:
            return 3600.0f;

		case NSDate_RU_CalendarUnitMinute:
            return 60.0f;

		case NSDate_RU_CalendarUnitSecond:
            return 1.0f;

		case NSDate_RU_CalendarUnitYear:
        case NSDate_RU_CalendarUnitMonth:
        default:
            return 0.0f;
    }

	NSAssert(false, @"unhandled");
	return 0;
}

@end
