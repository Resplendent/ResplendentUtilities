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

@implementation NSDate (Utility)

-(NSString*)daysOrHoursOrMinutesOrSecondsString
{
    return [NSDate daysOrHoursOrMinutesOrSecondsStringWithTimeIntervalNow:self.timeIntervalSinceNow];
}

-(NSTimeInterval)daysOrHoursOrMinutesOrSecondsTypeTimeInterval
{
    NSTimeInterval timeSince = abs(self.timeIntervalSinceNow);
    if (timeSince < 60.0f)                          //Seconds
        return 1;
    else if (timeSince < 60.0f * 60.0f)             //Minutes
        return 60.0f;
    else if (timeSince < 60.0f * 60.0f * 24.0f)     //Hours
        return 60.0f * 60.0f;
    else                                            //Days
        return 60.0f * 60.0f * 24.0f;
}

+(NSString*)daysOrHoursOrMinutesOrSecondsStringWithTimeIntervalNow:(NSTimeInterval)timeInterval
{
    double timeSince = abs(timeInterval);
    NSString* timeLabel = nil;
    if (timeSince < 60.0f)                          //Seconds
        timeLabel = [NSString stringWithFormat:@"%.fs",floor(timeSince)];
    else if (timeSince < 60.0f * 60.0f)             //Minutes
        timeLabel = [NSString stringWithFormat:@"%.fm",floor(timeSince / 60.0f)];
    else if (timeSince < 60.0f * 60.0f * 24.0f)     //Hours
        timeLabel = [NSString stringWithFormat:@"%.fh",floor(timeSince / 60.0f / 60.0f)];
    else                                            //Days
        timeLabel = [NSString stringWithFormat:@"%.fd",floor(timeSince / 60.0f / 60.0f / 24.0f)];
    
    return timeLabel;
}

-(NSString*)timeAgoString
{
    if (!gregorian)
    {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
//    int unitFlags = ;
    NSDateComponents *comps = [gregorian components:gregorianComponents fromDate:self toDate:[NSDate date] options:0];

    NSString *timeAgoString = nil;
    if ([comps year] > 0)
    {
        timeAgoString = [NSString stringWithFormat:@"%iy", [comps year]];
    }
    else if ([comps month] > 0)
    {
        timeAgoString = [NSString stringWithFormat:@"%imo", [comps month]];
    }
    else if ([comps day] > 0)
    {
        timeAgoString = [NSString stringWithFormat:@"%id", [comps day]];
    }
    else if ([comps hour] > 0)
    {
        timeAgoString = [NSString stringWithFormat:@"%ih", [comps hour]];
    }
    else if ([comps minute] > 0)
    {
        timeAgoString = [NSString stringWithFormat:@"%im", [comps minute]];
    }
    else if ([comps second] > 0)
    {
        timeAgoString = [NSString stringWithFormat:@"%is", [comps second]];
    }

    return [timeAgoString stringByAppendingString:@" ago"];;
}

@end
