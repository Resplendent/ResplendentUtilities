//
//  RTSMTableSectionManager.h
//  Pods
//
//  Created by Benjamin Maer on 5/13/15.
//
//

#import "RTSMTableSectionManagerProtocols.h"

#import <Foundation/Foundation.h>





@interface RTSMTableSectionManager : NSObject

#pragma mark - sectionDelegate
@property (nonatomic, assign, nullable) id<RTSMTableSectionManager_SectionDelegate> sectionDelegate;
-(BOOL)sectionDelegate_sectionIsAvailable:(NSInteger)section;

#pragma mark - Sections
@property (nonatomic, assign) NSInteger firstSection;
@property (nonatomic, assign) NSInteger lastSection;

#pragma mark - Available Sections
@property (nonatomic, readonly) NSInteger numberOfSectionsAvailable;

#pragma mark - Convert Sections And Index Path Sections
-(NSInteger)sectionForIndexPathSection:(NSInteger)indexPathSection;
-(NSInteger)indexPathSectionForSection:(NSInteger)section;

#pragma mark - Init
-(nonnull instancetype)initWithFirstSection:(NSInteger)firstSection lastSection:(NSInteger)lastSection;

#pragma mark - Available Sections
-(NSInteger)firstAvailableSection;
-(NSInteger)lastAvailableSection;

@end
