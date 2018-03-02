//
//  RTSMTableSectionRangeManager.h
//  Pods
//
//  Created by Benjamin Maer on 1/26/16.
//
//

#import <Foundation/Foundation.h>

#import "RTSMTableSectionRangeManager_SectionLengthDelegate.h"





@class RTSMTableSectionManager;





@interface RTSMTableSectionRangeManager : NSObject

#pragma mark - tableSectionManager
@property (nonatomic, strong, nullable) RTSMTableSectionManager* tableSectionManager;
-(BOOL)tableSectionManager_sectionIsAvailable:(NSInteger)section;

#pragma mark - sectionLengthDelegate
@property (nonatomic, weak, nullable) id<RTSMTableSectionRangeManager_SectionLengthDelegate> sectionLengthDelegate;
-(NSUInteger)sectionLengthDelegate_tableSectionRangeManager:(nonnull RTSMTableSectionRangeManager*)tableSectionRangeManager
											lengthOfSection:(NSInteger)section;

#pragma mark - Index Path Section Range
-(NSUInteger)indexPathSectionLengthForSection:(NSInteger)section;
-(NSUInteger)indexPathSectionForSection:(NSInteger)section;
-(NSRange)indexPathSectionRangeForSection:(NSInteger)section;
-(NSInteger)sectionForIndexPathSection:(NSUInteger)indexPathSection;
-(NSUInteger)indexPathSectionCount;

@end
