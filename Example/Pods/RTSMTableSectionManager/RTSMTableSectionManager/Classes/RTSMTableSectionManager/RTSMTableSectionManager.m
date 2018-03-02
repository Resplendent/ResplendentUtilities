//
//  RTSMTableSectionManager.m
//  Pods
//
//  Created by Benjamin Maer on 5/13/15.
//
//

#import "RTSMTableSectionManager.h"

#import "RUConditionalReturn.h"





@interface RTSMTableSectionManager ()

#pragma mark - Appropriate Sections
-(BOOL)firstAndLastSectionsAreAppropriate;

@end





@implementation RTSMTableSectionManager

#pragma mark - init
-(nonnull instancetype)initWithFirstSection:(NSInteger)firstSection lastSection:(NSInteger)lastSection
{
	if (self = [self init])
	{
		[self setFirstSection:firstSection];
		[self setLastSection:lastSection];

		NSAssert(self.firstAndLastSectionsAreAppropriate, @"should be");
	}

	return self;
}

#pragma mark - numberOfSectionsAvailable
-(NSInteger)numberOfSectionsAvailable
{
	kRUConditionalReturn_ReturnValue(self.firstAndLastSectionsAreAppropriate == false, YES, 0);

	NSInteger numberOfSections = 0;
	
	for (NSInteger sectionLoop = self.firstSection;
		 sectionLoop <= self.lastSection;
		 sectionLoop++)
	{
		if ([self sectionDelegate_sectionIsAvailable:sectionLoop])
		{
			numberOfSections++;
		}
	}
	
	return numberOfSections;
}

#pragma mark - sectionForIndexPathSection
-(NSInteger)sectionForIndexPathSection:(NSInteger)indexPathSection
{
	NSInteger const firstSection = self.firstSection;

	kRUConditionalReturn_ReturnValue(self.firstAndLastSectionsAreAppropriate == false, YES, firstSection);

	NSInteger const forLoopMax = MIN(firstSection + indexPathSection, self.lastSection);
	kRUConditionalReturn_ReturnValue(forLoopMax < firstSection, YES, firstSection);

	NSInteger sectionsSkipped = 0;

	for (NSInteger sectionLoop = firstSection;
		 sectionLoop - sectionsSkipped <= forLoopMax;
		 sectionLoop++)
	{
		if (![self sectionDelegate_sectionIsAvailable:sectionLoop])
		{
			sectionsSkipped++;
		}
	}
	
	NSInteger const indexPathSectionPlusFirst = indexPathSection + firstSection;
	NSInteger const finalSection = indexPathSectionPlusFirst + sectionsSkipped;
	kRUConditionalReturn_ReturnValue([self sectionIsWithinBounds:finalSection] == false, YES, firstSection)
	
	return finalSection;
}

-(NSInteger)indexPathSectionForSection:(NSInteger)section
{
	kRUConditionalReturn_ReturnValue([self sectionDelegate_sectionIsAvailable:section] == false, YES, NSNotFound);
	
	NSInteger const firstSection = self.firstSection;

	NSInteger sectionsSkipped = 0;
	for (NSInteger sectionLoop = firstSection;
		 sectionLoop < section;
		 sectionLoop++)
	{
		if ([self sectionDelegate_sectionIsAvailable:sectionLoop] == false)
		{
			sectionsSkipped++;
		}
	}
	
	return section - sectionsSkipped - firstSection;
}

#pragma mark - sectionDelegate
-(BOOL)sectionDelegate_sectionIsAvailable:(NSInteger)section
{
	id<RTSMTableSectionManager_SectionDelegate> const sectionDelegate = self.sectionDelegate;
	kRUConditionalReturn_ReturnValueTrue(sectionDelegate == nil, NO);

	return [sectionDelegate tableSectionManager:self sectionIsAvailable:section];
}

#pragma mark - firstAndLastSectionsAreAppropriate
-(BOOL)firstAndLastSectionsAreAppropriate
{
	return (self.firstSection <= self.lastSection);
}

-(BOOL)sectionIsWithinBounds:(NSInteger)section
{
	return ((section >= self.firstSection) &&
			(section <= self.lastSection));
}

#pragma mark - Available Sections
-(NSInteger)firstAvailableSection
{
	NSInteger const returnValue_error = NSNotFound;
	kRUConditionalReturn_ReturnValue(self.firstAndLastSectionsAreAppropriate == false, YES, returnValue_error);
	
	for (NSInteger sectionLoop = self.firstSection;
		 sectionLoop <= self.lastSection;
		 sectionLoop++)
	{
		if ([self sectionDelegate_sectionIsAvailable:sectionLoop])
		{
			return sectionLoop;
		}
	}

	return returnValue_error;
}

-(NSInteger)lastAvailableSection
{
	NSInteger numberOfSectionsAvailable = self.numberOfSectionsAvailable;
	kRUConditionalReturn_ReturnValue(numberOfSectionsAvailable == 0, NO, NSNotFound);

	return [self sectionForIndexPathSection:numberOfSectionsAvailable - 1];
}

@end
