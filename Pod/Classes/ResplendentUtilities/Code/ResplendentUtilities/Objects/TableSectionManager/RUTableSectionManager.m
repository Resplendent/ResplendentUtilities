//
//  RUTableSectionManager.m
//  Pods
//
//  Created by Benjamin Maer on 5/13/15.
//
//

#import "RUTableSectionManager.h"
#import "RUConditionalReturn.h"





@interface RUTableSectionManager ()

-(BOOL)firstAndLastSectionsAreAppropriate;
-(BOOL)sectionDelegate_sectionIsAvailable:(NSInteger)section;

@end





@implementation RUTableSectionManager

#pragma mark - init
-(instancetype)initWithFirstSection:(NSInteger)firstSection lastSection:(NSInteger)lastSection
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
	NSInteger firstSection = self.firstSection;

	kRUConditionalReturn_ReturnValue(self.firstAndLastSectionsAreAppropriate == false, YES, firstSection);

	NSInteger forLoopMax = firstSection + indexPathSection;
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
	
	NSInteger indexPathSectionPlusFirst = indexPathSection + firstSection;
	NSInteger finalSection = indexPathSectionPlusFirst + sectionsSkipped;
	kRUConditionalReturn_ReturnValue([self sectionIsWithinBounds:finalSection] == false, YES, firstSection)
	
	return finalSection;
}

-(NSInteger)indexPathSectionForSection:(NSInteger)section
{
	kRUConditionalReturn_ReturnValue([self sectionDelegate_sectionIsAvailable:section] == false, YES, NSNotFound);
	
	NSInteger firstSection = self.firstSection;

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

#pragma mark - section delegate
-(BOOL)sectionDelegate_sectionIsAvailable:(NSInteger)section
{
	return [self.sectionDelegate tableSectionManager:self sectionIsAvailable:section];
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

@end
