//
//  RTSMTableSectionRangeManager_SectionLengthDelegate.h
//  Pods
//
//  Created by Benjamin Maer on 1/26/16.
//
//

#import <Foundation/Foundation.h>





@class RTSMTableSectionRangeManager;





@protocol RTSMTableSectionRangeManager_SectionLengthDelegate <NSObject>

-(NSUInteger)tableSectionRangeManager:(nonnull RTSMTableSectionRangeManager*)tableSectionRangeManager
					  lengthOfSection:(NSInteger)section;

@end
