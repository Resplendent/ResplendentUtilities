//
//  RURadioButtonGroup.m
//  Shimmur
//
//  Created by Benjamin Maer on 12/16/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RURadioButtonGroup.h"
#import "RUConditionalReturn.h"





const struct RURadioButtonGroup_KVOProperties RURadioButtonGroup_KVOProperties = {
	.buttons				= @"buttons",
	.selectedButtonIndex	= @"selectedButtonIndex",
};





@interface RURadioButtonGroup ()

-(void)selectButtonAtCurrentlySelectedButtonIndex;

-(void)pressed_button:(UIButton*)button;

@end





@implementation RURadioButtonGroup

#pragma mark - buttons
-(void)setButtons:(NSArray *)buttons
{
	kRUConditionalReturn(self.buttons == buttons, NO);

	for (UIButton* oldButton in self.buttons)
	{
		[oldButton removeTarget:self action:@selector(pressed_button:) forControlEvents:UIControlEventTouchUpInside];
	}

	_buttons = [buttons copy];

	for (UIButton* newButton in self.buttons)
	{
		[newButton addTarget:self action:@selector(pressed_button:) forControlEvents:UIControlEventTouchUpInside];
	}

	[self setSelectedButtonIndex:(self.allowDeselectionOfSelectedButton ? NSNotFound : 0)];
	[self selectButtonAtCurrentlySelectedButtonIndex];
}

#pragma mark - Actions
-(void)pressed_button:(UIButton *)button
{
	NSInteger buttonIndex = [self.buttons indexOfObject:button];
	kRUConditionalReturn(buttonIndex == NSNotFound, YES);

	if (self.allowDeselectionOfSelectedButton)
	{
		if (buttonIndex == self.selectedButtonIndex)
		{
			buttonIndex = NSNotFound;
		}
	}

	[self setSelectedButtonIndex:buttonIndex];
	[self.selectionDelegate radioButtonGroup:self pressedButtonAtIndex:buttonIndex];
}

#pragma mark - SelectedButtonIndex
-(void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex
{
	kRUConditionalReturn(self.selectedButtonIndex == selectedButtonIndex, NO);

	UIButton* unSelectButton = self.selectedButton;
	[unSelectButton setSelected:NO];
	
	_selectedButtonIndex = selectedButtonIndex;
	[self selectButtonAtCurrentlySelectedButtonIndex];
}

-(void)selectButtonAtCurrentlySelectedButtonIndex
{
	UIButton* selectedButton = self.selectedButton;
	[selectedButton setSelected:YES];
}

#pragma mark - selectedButton
-(UIButton *)selectedButton
{
	return [self buttonOrNilAtIndex:self.selectedButtonIndex];
}

-(UIButton *)buttonOrNilAtIndex:(NSInteger)buttonIndex
{
	kRUConditionalReturn_ReturnValueNil(buttonIndex >= self.buttons.count, NO);
	kRUConditionalReturn_ReturnValueNil(buttonIndex == NSNotFound, NO);

	return [self.buttons objectAtIndex:buttonIndex];
}

@end
