//
//  RUSubviewTouchesView.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/5/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUSubviewTouchesView.h"
#import "UIView+RUSubviews.h"
#import "RUConditionalReturn.h"
#import "RUClassOrNilUtil.h"





@interface RUSubviewTouchesView ()

@property (nonatomic, readonly) NSMutableArray* subviewsToAllowTouchesFromMutable;

@end





@implementation RUSubviewTouchesView

#pragma mark - NSObject
-(instancetype)init
{
	if (self = [super init])
	{
		_subviewsToAllowTouchesFromMutable = [NSMutableArray array];
	}

	return self;
}

#pragma mark - UIView
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView* subview = [self ru_subviewFromSubviews:self.subviewsToAllowTouchesFrom inPoint:point fromEvent:event];
	return (subview != nil);
}

#pragma mark - subviewsToAllowTouchesFrom
-(NSArray *)subviewsToAllowTouchesFrom
{
	return [self.subviewsToAllowTouchesFromMutable copy];
}

-(void)addSubviewToAllowTouchesFrom:(UIView *)view
{
	kRUConditionalReturn(kRUClassOrNil(view, UIView) == nil, YES);
	[self.subviewsToAllowTouchesFromMutable addObject:view];
}

-(void)removeSubviewToAllowTouchesFrom:(UIView *)view
{
	kRUConditionalReturn(kRUClassOrNil(view, UIView) == nil, YES);
	[self.subviewsToAllowTouchesFromMutable removeObject:view];
}

@end
