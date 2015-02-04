//
//  RURadioButtonView.m
//  Resplendent
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RURadioButtonView.h"
#import "RUCompatability.h"
#import "RUDLog.h"
#import "RUConstants.h"
#import "RUConditionalReturn.h"
#import "RURadioButtonGroup.h"
#import "RUClassOrNilUtil.h"





static void* kRURadioButtonView__KVOContext = &kRURadioButtonView__KVOContext;





@interface RURadioButtonView ()

//Returns nil if ready, otherwise returns
@property (nonatomic, readonly) NSString* reasonUnableToDraw;

-(void)RURadioButtonView_setRegisteredToRadioButtonGroup:(BOOL)registered;

@end





@implementation RURadioButtonView

#pragma mark - NSObject
-(void)dealloc
{
	[self RURadioButtonView_setRegisteredToRadioButtonGroup:NO];
}

#pragma mark - UIView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
		_radioButtonGroup = [RURadioButtonGroup new];
		[self RURadioButtonView_setRegisteredToRadioButtonGroup:YES];

		[self setNumberOfRows:1];
    }

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    if (self.radioButtonGroup.buttons.count)
    {
		NSArray* buttons = self.radioButtonGroup.buttons;
        NSUInteger numberOfRows = self.numberOfRows;
        NSUInteger numberOfColumns = ceil((double)buttons.count / (double)numberOfRows);
        CGFloat buttonPadding = self.buttonPadding;
        CGFloat buttonWidth = ((CGRectGetWidth(self.frame) + buttonPadding) / (double)numberOfColumns) - buttonPadding;
        CGFloat buttonHeight = ((CGRectGetHeight(self.frame) + buttonPadding) / (double)numberOfRows) - buttonPadding;

        NSUInteger row = 0;
        NSUInteger column = 0;

        for (UIButton* button in buttons)
        {
            CGFloat xCoord = (row * (buttonWidth + buttonPadding));
            CGFloat yCoord = (column * (buttonHeight + buttonPadding));

            [button setFrame:(CGRect){xCoord, yCoord ,buttonWidth,buttonHeight}];

            if (row == numberOfColumns - 1)
            {
                row = 0;
                column++;
            }
            else
            {
                row++;
            }
        }
    }
}

#pragma mark - New Button
-(UIButton*)newButtonAtIndex:(NSUInteger)index withTitle:(NSString*)title
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:self.font];
    [button setTitleColor:self.textColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
    [button setBackgroundColor:[UIColor clearColor]];

	return button;
}

#pragma mark - Getters
-(NSString *)reasonUnableToDraw
{
    if (!self.numberOfRows)
    {
        return @"need non-zero number of rows";
    }
    else if (!self.font)
    {
        return @"need non-nil font";
    }
    else if (!self.textColor)
    {
        return @"need non-nil textColor";
    }
//    else if (!self.selectedTextColor)
//    {
//        return @"need non-nil selectedTextColor";
//    }

    return nil;
}

#pragma mark - Button Titles
-(void)setButtonsWithButtonTitles:(NSArray*)buttonTitles
{
	kRUConditionalReturn(buttonTitles.count == 0, YES);
	kRUConditionalReturn(self.reasonUnableToDraw.length > 0, YES);

	NSMutableArray* newButtons = [NSMutableArray array];
	
	[buttonTitles enumerateObjectsUsingBlock:^(NSString* buttonTitle, NSUInteger buttonTitleIndex, BOOL *stop) {
		
		UIButton* newButton = [self newButtonAtIndex:buttonTitleIndex withTitle:buttonTitle];
		
		NSAssert(newButton != nil, @"unhandled");
		if (newButton)
		{
			[newButtons addObject:newButton];
			[self addSubview:newButton];
		}
		
	}];
	
	[self.radioButtonGroup setButtons:newButtons];
}

#pragma mark - KVO
-(void)RURadioButtonView_setRegisteredToRadioButtonGroup:(BOOL)registered
{
	kRUConditionalReturn(self.radioButtonGroup == nil, YES);
	
	static NSArray* propertiesToObserve;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		propertiesToObserve = @[
								RURadioButtonGroup_KVOProperties.buttons,
								];
	});
	
	for (NSString* propertyToObserve in propertiesToObserve)
	{
		if (registered)
		{
			[self.radioButtonGroup addObserver:self forKeyPath:propertyToObserve options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:&kRURadioButtonView__KVOContext];
		}
		else
		{
			[self.radioButtonGroup removeObserver:self forKeyPath:propertyToObserve context:&kRURadioButtonView__KVOContext];
		}
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == kRURadioButtonView__KVOContext)
	{
		if (object == self.radioButtonGroup)
		{
			if ([keyPath isEqualToString:RURadioButtonGroup_KVOProperties.buttons])
			{
				NSArray* oldButtons = [change objectForKey:NSKeyValueChangeOldKey];
				if (kRUClassOrNil(oldButtons, NSArray))
				{
					for (UIButton* oldButton in oldButtons)
					{
						[oldButton removeFromSuperview];
					}
				}

				NSArray* newButtons = [change objectForKey:NSKeyValueChangeNewKey];
				if (kRUClassOrNil(newButtons, NSArray))
				{
					for (UIButton* newButton in newButtons)
					{
						[self addSubview:newButton];
					}
				}
			}
			else
			{
				NSAssert(false, @"unhandled");
			}
		}
		else
		{
			NSAssert(false, @"unhandled");
		}
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
