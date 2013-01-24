//
//  NSDate+Utility.m
//  Memeni
//
//  Created by Benjamin Maer on 9/6/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

-(NSString*)daysOrHoursOrMinutesOrSecondsString
{
    return [NSDate daysOrHoursOrMinutesOrSecondsStringWithTimeIntervalSince1970:self.timeIntervalSinceNow];
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

+(NSString*)daysOrHoursOrMinutesOrSecondsStringWithTimeIntervalSince1970:(NSTimeInterval)timeInterval
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

@end
