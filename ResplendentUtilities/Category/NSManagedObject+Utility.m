//
//  NSManagedObject+Utility.m
//  Memeni
//
//  Created by Benjamin Maer on 9/29/12.
//
//

#import "NSManagedObject+Utility.h"
#include <objc/message.h>

@implementation NSManagedObject (Utility)

-(void)updateValue:(id)newValue propertyName:(NSString*)propertyName
{
    NSString* setterName = [NSString stringWithFormat:@"set%@%@:",[propertyName substringToIndex:1].uppercaseString,[propertyName substringFromIndex:1]];
    [self updateValue:newValue setterName:setterName getterName:propertyName];
}

-(void)updateValue:(id)newValue setterName:(NSString *)setterName getterName:(NSString *)getterName
{
    SEL getter = NSSelectorFromString(getterName);
    if (getter && [self respondsToSelector:getter])
    {
        SEL setter = NSSelectorFromString(setterName);
        if (setter && [self respondsToSelector:setter])
        {
            id currentValue = objc_msgSend(self, getter);
            if (!newValue || [newValue isKindOfClass:[NSNull class]])
            {
                if (currentValue)
                    objc_msgSend(self, setter, nil);
            }
            else
            {
                if (!(currentValue && newValue) || currentValue != newValue ||
                    (!([currentValue respondsToSelector:@selector(compare:)] && [newValue respondsToSelector:@selector(compare:)])) ||
                    [currentValue compare:newValue] != NSOrderedSame)
                    objc_msgSend(self, setter, newValue);
            }
        }
        else
        {
            NSLog(@"bad setterName %@ for updateValue",setterName);
        }
    }
    else
    {
        NSLog(@"bad getterName %@ for updateValue",getterName);
    }
}

-(void)setValue:(id)value forName:(NSString*)name
{
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", name]);
    if ([value isKindOfClass:[NSNull class]])
    {
        objc_msgSend(self,selector,nil);
    }
    else
    {
        objc_msgSend(self,selector,value);
    }
}

@end
