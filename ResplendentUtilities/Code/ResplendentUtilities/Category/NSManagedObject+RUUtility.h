//
//  NSManagedObject+RUUtility.h
//  Resplendent
//
//  Created by Benjamin Maer on 9/29/12.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <CoreData/CoreData.h>





@interface NSManagedObject (RUUtility)

-(void)setValue:(id)value forName:(NSString*)name;
-(void)updateValue:(id)newValue setterName:(NSString*)setterName getterName:(NSString*)getterName;
-(void)updateValue:(id)newValue propertyName:(NSString*)propertyName;

@end
