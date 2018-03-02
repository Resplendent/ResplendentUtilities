//
//  RTSMTableSectionRangeManager.m
//  Pods
//
//  Created by Benjamin Maer on 1/26/16.
//
//

#import "RTSMTableSectionRangeManager.h"
#import "RTSMTableSectionManager.h"

#import "RUConditionalReturn.h"





@interface RTSMTableSectionRangeManager ()

@end





@implementation RTSMTableSectionRangeManager

#pragma mark - tableSectionManager
-(BOOL)tableSectionManager_sectionIsAvailable:(NSInteger)section
{
	return [self.tableSectionManager sectionDelegate_sectionIsAvailable:section];
}

#pragma mark - sectionLengthDelegate
-(NSUInteger)sectionLengthDelegate_tableSectionRangeManager:(RTSMTableSectionRangeManager*)tableSectionRangeManager
											lengthOfSection:(NSInteger)section
{
	return [self.sectionLengthDelegate tableSectionRangeManager:self lengthOfSection:section];
}

#pragma mark - Index Path Section Range
-(NSUInteger)indexPathSectionLengthForSection:(NSInteger)section
{
	kRUConditionalReturn_ReturnValue([self tableSectionManager_sectionIsAvailable:section] == false, YES, 0);

	return [self sectionLengthDelegate_tableSectionRangeManager:self lengthOfSection:section];
}

-(NSUInteger)indexPathSectionForSection:(NSInteger)section
{
	kRUConditionalReturn_ReturnValue([self tableSectionManager_sectionIsAvailable:section] == false, YES, NSNotFound);
	
	NSUInteger sectionCount = 0;
	for (NSInteger section_loop = self.tableSectionManager.firstSection;
		 section_loop < section;
		 section_loop++)
	{
		if ([self tableSectionManager_sectionIsAvailable:section_loop])
		{
			NSUInteger tableViewSectionLengthForType = [self indexPathSectionLengthForSection:section_loop];
			sectionCount += tableViewSectionLengthForType;
		}
	}
	
	return sectionCount;
}

-(NSRange)indexPathSectionRangeForSection:(NSInteger)section
{
	NSUInteger indexPathSectionForSection = [self indexPathSectionForSection:section];
	kRUConditionalReturn_ReturnValue(indexPathSectionForSection == NSNotFound, YES, NSMakeRange(indexPathSectionForSection, 0));

	NSUInteger sectionLength = [self indexPathSectionLengthForSection:section];

	return NSMakeRange(indexPathSectionForSection, sectionLength);
}

-(NSInteger)sectionForIndexPathSection:(NSUInteger)indexPathSection
{
	RTSMTableSectionManager* const tableSectionManager = self.tableSectionManager;
	kRUConditionalReturn_ReturnValue(tableSectionManager == nil, NO, NSNotFound);

	NSUInteger sectionCount = 0;
	for (NSInteger section_loop = tableSectionManager.firstSection;
		 section_loop <= tableSectionManager.lastSection;
		 section_loop++)
	{
		if ([self tableSectionManager_sectionIsAvailable:section_loop])
		{
			NSUInteger tableViewSectionLengthForType = [self indexPathSectionLengthForSection:section_loop];
			NSUInteger sectionCount_new = sectionCount + tableViewSectionLengthForType;
			if (sectionCount_new > indexPathSection)
			{
				return section_loop;
			}
			
			sectionCount = sectionCount_new;
		}
	}
	
	NSAssert(false, @"unhandled");
	return self.tableSectionManager.firstAvailableSection;
}

-(NSUInteger)indexPathSectionCount
{
	RTSMTableSectionManager* const tableSectionManager = self.tableSectionManager;
	kRUConditionalReturn_ReturnValue(tableSectionManager == nil, NO, 0.0f);

	NSUInteger sectionCount = 0;
	for (NSInteger section_loop = tableSectionManager.firstSection;
		 section_loop <= tableSectionManager.lastSection;
		 section_loop++)
	{
		if ([self tableSectionManager_sectionIsAvailable:section_loop])
		{
			NSUInteger tableViewSectionLengthForType = [self indexPathSectionLengthForSection:section_loop];
			sectionCount += tableViewSectionLengthForType;
		}
	}
	
	return sectionCount;
}

@end
