//
//  NSDate+Utility.m
//  Memeni
//
//  Created by Benjamin Maer on 9/6/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "NSDate+Utility.h"

typedef enum{
    kRUNSDateCalendarUnitSecond,
    kRUNSDateCalendarUnitMinute,
    kRUNSDateCalendarUnitHour,
    kRUNSDateCalendarUnitDay,
    kRUNSDateCalendarUnitMonth,
    kRUNSDateCalendarUnitYear
}kRUNSDateCalendarUnit;

static NSCalendar *gregorian;

NSInteger const gregorianComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

NSCalendar* staticGregorianCalendar();
NSDateComponents* timoAgoDateComponentsFromDate(NSDate* date);

NSString* NSDateTimeAgoStringSuffixWithDateCompontents(NSDateComponents* comps);
NSString* NSDateTimeAgoStringSuffix(NSDate* date);

NSInteger NSDateTimeAgoStringAmountWithDateCompontents(NSDateComponents* comps);
NSInteger NSDateTimeAgoStringAmount(NSDate* date);

kRUNSDateCalendarUnit NSDateTimeAgoMinCalendarUnitWithDateCompontents(NSDateComponents* comps);


@implementation NSDate (Utility)

-(NSString*)timeAgoString
{
    NSDateComponents *comps = timoAgoDateComponentsFromDate(self);
    return [NSString stringWithFormat:@"%i%@",NSDateTimeAgoStringAmountWithDateCompontents(comps),NSDateTimeAgoStringSuffixWithDateCompontents(comps)];
}

-(NSTimeInterval)minTimeAgoUnitSeconds
{
    NSDateComponents *comps = timoAgoDateComponentsFromDate(self);
    kRUNSDateCalendarUnit minCalendarUnit = NSDateTimeAgoMinCalendarUnitWithDateCompontents(comps);
    switch (minCalendarUnit)
    {
        case kRUNSDateCalendarUnitDay:
            return 86400.0f;
            break;
        case kRUNSDateCalendarUnitHour:
            return 3600.0f;
            break;
        case kRUNSDateCalendarUnitMinute:
            return 60.0f;
            break;
        case kRUNSDateCalendarUnitSecond:
            return 1.0f;
            break;
        case kRUNSDateCalendarUnitYear:
        case kRUNSDateCalendarUnitMonth:
        default:
            return 0.0f;
            break;
    }}

#pragma mark - C methods
NSCalendar* staticGregorianCalendar()
{
    if (!gregorian)
    {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }

    return gregorian;
}

NSDateComponents* timoAgoDateComponentsFromDate(NSDate* date)
{
    return [staticGregorianCalendar() components:gregorianComponents fromDate:date toDate:[NSDate date] options:0];
}

NSString* NSDateTimeAgoStringSuffixWithDateCompontents(NSDateComponents* comps)
{
    kRUNSDateCalendarUnit minCalendarUnit = NSDateTimeAgoMinCalendarUnitWithDateCompontents(comps);
    switch (minCalendarUnit)
    {
        case kRUNSDateCalendarUnitYear:
            return @"y";
            break;
        case kRUNSDateCalendarUnitMonth:
            return @"mo";
            break;
        case kRUNSDateCalendarUnitDay:
            return @"d";
            break;
        case kRUNSDateCalendarUnitHour:
            return @"h";
            break;
        case kRUNSDateCalendarUnitMinute:
            return @"m";
            break;
        case kRUNSDateCalendarUnitSecond:
            return @"s";
            break;
            
        default:
            return nil;
            break;
    }
}

NSString* NSDateTimeAgoStringSuffix(NSDate* date)
{
    return NSDateTimeAgoStringSuffixWithDateCompontents(timoAgoDateComponentsFromDate(date));
}

NSInteger NSDateTimeAgoStringAmountWithDateCompontents(NSDateComponents* comps)
{
    kRUNSDateCalendarUnit minCalendarUnit = NSDateTimeAgoMinCalendarUnitWithDateCompontents(comps);
    switch (minCalendarUnit)
    {
        case kRUNSDateCalendarUnitYear:
            return comps.year;
            break;
        case kRUNSDateCalendarUnitMonth:
            return comps.month;
            break;
        case kRUNSDateCalendarUnitDay:
            return comps.day;
            break;
        case kRUNSDateCalendarUnitHour:
            return comps.hour;
            break;
        case kRUNSDateCalendarUnitMinute:
            return comps.minute;
            break;
        case kRUNSDateCalendarUnitSecond:
            return MAX(comps.second, 0);
            break;

        default:
            return NSNotFound;
            break;
    }
}

NSInteger NSDateTimeAgoStringAmount(NSDate* date)
{
    return NSDateTimeAgoStringAmountWithDateCompontents(timoAgoDateComponentsFromDate(date));
}

kRUNSDateCalendarUnit NSDateTimeAgoMinCalendarUnitWithDateCompontents(NSDateComponents* comps)
{
    if ([comps year] > 0)
    {
        return kRUNSDateCalendarUnitYear;
    }
    else if ([comps month] > 0)
    {
        return kRUNSDateCalendarUnitMonth;
    }
    else if ([comps day] > 0)
    {
        return kRUNSDateCalendarUnitDay;
    }
    else if ([comps hour] > 0)
    {
        return kRUNSDateCalendarUnitHour;
    }
    else if ([comps minute] > 0)
    {
        return kRUNSDateCalendarUnitMinute;
    }
    else if ([comps second] >= 0)
    {
        return kRUNSDateCalendarUnitSecond;
    }

    return kRUNSDateCalendarUnitSecond;
}

@end
