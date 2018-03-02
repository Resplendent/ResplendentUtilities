//
//  RTSMTableSectionManagerProtocols.h
//  Pods
//
//  Created by Benjamin Maer on 5/13/15.
//
//

#import <Foundation/Foundation.h>





@class RTSMTableSectionManager;





@protocol RTSMTableSectionManager_SectionDelegate <NSObject>

-(BOOL)tableSectionManager:(nonnull RTSMTableSectionManager*)tableSectionManager sectionIsAvailable:(NSInteger)section;

@end
