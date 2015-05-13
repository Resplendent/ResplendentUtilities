//
//  RUTableSectionManagerProtocols.h
//  Pods
//
//  Created by Benjamin Maer on 5/13/15.
//
//

#import <Foundation/Foundation.h>





@class RUTableSectionManager;





@protocol RUTableSectionManager_SectionDelegate <NSObject>

-(BOOL)tableSectionManager:(RUTableSectionManager*)tableSectionManager sectionIsAvailable:(NSInteger)section;

@end
