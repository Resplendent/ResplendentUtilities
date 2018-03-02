//
//  UITableView+RTSMEmptySpace.m
//  Pods
//
//  Created by Benjamin Maer on 4/22/16.
//
//

#import "UITableView+RTSMEmptySpace.h"

#import "RTSMTableSectionRangeManager.h"
#import "RTSMTableSectionManager.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation UITableView (RTSMEmptySpace)

-(CGFloat)rtsm_emptySpaceFromSection:(NSInteger)fromSection
						   toSection:(NSInteger)toSection
			tableSectionRangeManager:(nonnull RTSMTableSectionRangeManager*)tableSectionRangeManager
						  tableFrame:(CGRect)tableFrame
{
	kRUConditionalReturn_ReturnValue((fromSection < tableSectionRangeManager.tableSectionManager.firstSection) ||
									 (fromSection > tableSectionRangeManager.tableSectionManager.lastSection) ||
									 (toSection < tableSectionRangeManager.tableSectionManager.firstSection) ||
									 (toSection > tableSectionRangeManager.tableSectionManager.lastSection), YES, 0);
	
	CGFloat heightMax = CGRectGetHeight(tableFrame) - self.contentInset.top - self.contentInset.bottom;
	
	CGFloat heightTotal = 0.0f;
	NSUInteger numberOfSectionsTotal = 0;
	
	for (NSInteger section_loop = fromSection;
		 section_loop < toSection;
		 section_loop++)
	{
		if ([tableSectionRangeManager tableSectionManager_sectionIsAvailable:section_loop] == false)
		{
			continue;
		}

		NSUInteger tableViewSectionLengthForType = [tableSectionRangeManager indexPathSectionLengthForSection:section_loop];
		NSUInteger numberOfSectionsTotal_new = numberOfSectionsTotal + tableViewSectionLengthForType;
		
		NSUInteger indexPathSection_forSectionLoop = [tableSectionRangeManager indexPathSectionForSection:section_loop];
		NSUInteger indexPathSection_last = indexPathSection_forSectionLoop + tableViewSectionLengthForType;
		
		for (NSUInteger indexPathSection = indexPathSection_forSectionLoop;
			 indexPathSection < indexPathSection_last;
			 indexPathSection++)
		{
			CGFloat height_section = 0.0f;
			NSUInteger numberOfRowsForSection = [self.dataSource tableView:self numberOfRowsInSection:indexPathSection];
			for (NSUInteger indexPathRow = 0;
				 indexPathRow < numberOfRowsForSection;
				 indexPathRow++)
			{
				CGFloat height_row = [self.delegate tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPathRow inSection:indexPathSection]];
				height_section += height_row;
			}
			
			CGFloat height_new = height_section;
			
			if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
			{
				CGFloat height_header = [self.delegate tableView:self heightForHeaderInSection:indexPathSection];
				height_new += height_header;
			}
			
			CGFloat heightTotal_new = heightTotal + height_new;
			if (heightTotal_new >= heightMax)
			{
				return 0.0f;
			}
			
			heightTotal = heightTotal_new;
		}
		
		numberOfSectionsTotal = numberOfSectionsTotal_new;
	}
	
	return heightMax - heightTotal;
}

#pragma mark - Empty Space with Table Section Manager
-(CGFloat)rtsm_emptySpaceFromSection:(NSInteger)fromSection
						   toSection:(NSInteger)toSection
				 tableSectionManager:(nonnull RTSMTableSectionManager*)tableSectionManager
						  tableFrame:(CGRect)tableFrame
{
	kRUConditionalReturn_ReturnValue((fromSection < tableSectionManager.firstSection) ||
									 (fromSection > tableSectionManager.lastSection) ||
									 (toSection < tableSectionManager.firstSection) ||
									 (toSection > tableSectionManager.lastSection), YES, 0);
	
	CGFloat heightMax = CGRectGetHeight(tableFrame) - self.contentInset.top - self.contentInset.bottom;
	
	CGFloat heightTotal = 0.0f;
	
	for (NSInteger section_loop = fromSection;
		 section_loop < toSection;
		 section_loop++)
	{
		if ([tableSectionManager sectionDelegate_sectionIsAvailable:section_loop] == false)
		{
			continue;
		}

		NSUInteger indexPathSection = [tableSectionManager indexPathSectionForSection:section_loop];
		
		CGFloat height_section = 0.0f;
		NSUInteger numberOfRowsForSection = [self.dataSource tableView:self numberOfRowsInSection:indexPathSection];
		for (NSUInteger indexPathRow = 0;
			 indexPathRow < numberOfRowsForSection;
			 indexPathRow++)
		{
			CGFloat height_row = [self.delegate tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPathRow inSection:indexPathSection]];
			height_section += height_row;
		}
		
		CGFloat height_new = height_section;
		
		if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
		{
			CGFloat height_header = [self.delegate tableView:self heightForHeaderInSection:indexPathSection];
			height_new += height_header;
		}
		
		CGFloat heightTotal_new = heightTotal + height_new;
		if (heightTotal_new >= heightMax)
		{
			return 0.0f;
		}
		
		heightTotal = heightTotal_new;
	}
	
	return heightMax - heightTotal;
}

@end
