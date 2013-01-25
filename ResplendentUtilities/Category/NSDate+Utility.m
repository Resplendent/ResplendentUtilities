//
//  NSDate+Utility.m
//  Memeni
//
//  Created by Benjamin Maer on 9/6/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "NSDate+Utility.h"

static NSCalendar *gregorian;

NSInteger const gregorianComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

NSCalendar* staticGregorianCalendar();
NSDateComponents* timoAgoDateComponentsFromDate(NSDate* date);

NSString* NSDateTimeAgoStringSuffixWithDateCompontents(NSDateComponents* comps, NSDate* date);
NSString* NSDateTimeAgoStringSuffix(NSDate* date);

NSInteger NSDateTimeAgoStringAmountWithDateCompontents(NSDateComponents* comps, NSDate* date);
NSInteger NSDateTimeAgoStringAmount(NSDate* date);


@implementation NSDate (Utility)

//-(NSString*)daysOrHoursOrMinutesOrSecondsString
//{
//    return [NSDate daysOrHoursOrMinutesOrSecondsStringWithTimeIntervalNow:self.timeIntervalSinceNow];
//}
//
//-(NSTimeInterval)daysOrHoursOrMinutesOrSecondsTypeTimeInterval
//{
//    NSTimeInterval timeSince = abs(self.timeIntervalSinceNow);
//    if (timeSince < 60.0f)                          //Seconds
//        return 1;
//    else if (timeSince < 60.0f * 60.0f)             //Minutes
//        return 60.0f;
//    else if (timeSince < 60.0f * 60.0f * 24.0f)     //Hours
//        return 60.0f * 60.0f;
//    else                                            //Days
//        return 60.0f * 60.0f * 24.0f;
//}
//
//+(NSString*)daysOrHoursOrMinutesOrSecondsStringWithTimeIntervalNow:(NSTimeInterval)timeInterval
//{
//    double timeSince = abs(timeInterval);
//    NSString* timeLabel = nil;
//    if (timeSince < 60.0f)                          //Seconds
//        timeLabel = [NSString stringWithFormat:@"%.fs",floor(timeSince)];
//    else if (timeSince < 60.0f * 60.0f)             //Minutes
//        timeLabel = [NSString stringWithFormat:@"%.fm",floor(timeSince / 60.0f)];
//    else if (timeSince < 60.0f * 60.0f * 24.0f)     //Hours
//        timeLabel = [NSString stringWithFormat:@"%.fh",floor(timeSince / 60.0f / 60.0f)];
//    else                                            //Days
//        timeLabel = [NSString stringWithFormat:@"%.fd",floor(timeSince / 60.0f / 60.0f / 24.0f)];
//    
//    return timeLabel;
//}

-(NSString*)timeAgoString
{
    NSDateComponents *comps = timoAgoDateComponentsFromDate(self);
    return [NSString stringWithFormat:@"%i%@",NSDateTimeAgoStringAmountWithDateCompontents(comps, self),NSDateTimeAgoStringSuffixWithDateCompontents(comps, self)];
}

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

NSString* NSDateTimeAgoStringSuffixWithDateCompontents(NSDateComponents* comps, NSDate* date)
{
    if ([comps year] > 0)
    {
        return @"y";
    }
    else if ([comps month] > 0)
    {
        return @"mo";
    }
    else if ([comps day] > 0)
    {
        return @"d";
    }
    else if ([comps hour] > 0)
    {
        return @"h";
    }
    else if ([comps minute] > 0)
    {
        return @"m";
    }
    else if ([comps second] > 0)
    {
        return @"s";
    }

    return nil;
}

NSString* NSDateTimeAgoStringSuffix(NSDate* date)
{
    return NSDateTimeAgoStringSuffixWithDateCompontents(timoAgoDateComponentsFromDate(date), date);
}

NSInteger NSDateTimeAgoStringAmountWithDateCompontents(NSDateComponents* comps, NSDate* date)
{
    if ([comps year] > 0)
    {
        return comps.year;
    }
    else if ([comps month] > 0)
    {
        return comps.month;
    }
    else if ([comps day] > 0)
    {
        return comps.day;
    }
    else if ([comps hour] > 0)
    {
        return comps.hour;
    }
    else if ([comps minute] > 0)
    {
        return comps.minute;
    }
    else if ([comps second] > 0)
    {
        return comps.second;
    }
    
    return NSNotFound;
}

NSInteger NSDateTimeAgoStringAmount(NSDate* date)
{
    return NSDateTimeAgoStringAmountWithDateCompontents(timoAgoDateComponentsFromDate(date), date);
}

@end
