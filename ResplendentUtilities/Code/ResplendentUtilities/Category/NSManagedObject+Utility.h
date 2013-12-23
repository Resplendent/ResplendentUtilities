//
//  NSManagedObject+Utility.h
//  Memeni
//
//  Created by Benjamin Maer on 9/29/12.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Utility)

-(void)setValue:(id)value forName:(NSString*)name;
-(void)updateValue:(id)newValue setterName:(NSString*)setterName getterName:(NSString*)getterName;
-(void)updateValue:(id)newValue propertyName:(NSString*)propertyName;

@end
