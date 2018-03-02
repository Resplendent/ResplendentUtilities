//
//  UITableView+RTSMEmptySpace.h
//  Pods
//
//  Created by Benjamin Maer on 4/22/16.
//
//

#import <UIKit/UIKit.h>





@class RTSMTableSectionRangeManager;
@class RTSMTableSectionManager;





@interface UITableView (RTSMEmptySpace)

/**
 A method that determines the amount of height from `fromSection` (inclusive) to `toSection` (inclusive).
 
 @param fromSection					The section to start determining the height from, inclusive.
 @param toSection					The section to stop determining the height from, exclusive.
 @param tableSectionRangeManager	A table section range manager, used for converting sections to index path sections.
 @param tableFrame					The frame for table. Needed to determine proper the max height.

 @return The total amount of empty space remaining on the table view from between `fromSection` and `toSection`.
 */
-(CGFloat)rtsm_emptySpaceFromSection:(NSInteger)fromSection
						   toSection:(NSInteger)toSection
			tableSectionRangeManager:(nonnull RTSMTableSectionRangeManager*)tableSectionRangeManager
						  tableFrame:(CGRect)tableFrame;

/**
 A method that determines the amount of height from `fromSection` (inclusive) to `toSection` (inclusive).
 
 @param fromSection					The section to start determining the height from, inclusive.
 @param toSection					The section to stop determining the height from, exclusive.
 @param tableSectionManager			A table section manager, used for converting sections to index path sections.
 @param tableFrame					The frame for table. Needed to determine proper the max height.
 
 @return The total amount of empty space remaining on the table view from between `fromSection` and `toSection`.
 */
-(CGFloat)rtsm_emptySpaceFromSection:(NSInteger)fromSection
						   toSection:(NSInteger)toSection
				 tableSectionManager:(nonnull RTSMTableSectionManager*)tableSectionManager
						  tableFrame:(CGRect)tableFrame;

@end
