//
//  RUTableSectionManager.h
//  Pods
//
//  Created by Benjamin Maer on 5/13/15.
//
//

#import "RUTableSectionManagerProtocols.h"

#import <Foundation/Foundation.h>





@interface RUTableSectionManager : NSObject

@property (nonatomic, assign) id<RUTableSectionManager_SectionDelegate> sectionDelegate;

@property (nonatomic, assign) NSInteger firstSection;
@property (nonatomic, assign) NSInteger lastSection;

@property (nonatomic, readonly) NSInteger numberOfSectionsAvailable;

-(NSInteger)sectionForIndexPathSection:(NSInteger)indexPathSection;
-(NSInteger)indexPathSectionForSection:(NSInteger)section;

-(instancetype)initWithFirstSection:(NSInteger)firstSection lastSection:(NSInteger)lastSection;

@end
