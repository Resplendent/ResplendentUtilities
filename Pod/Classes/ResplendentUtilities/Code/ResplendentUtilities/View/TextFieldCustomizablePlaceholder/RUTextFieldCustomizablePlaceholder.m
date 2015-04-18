//
//  RUTextFieldCustomizablePlaceholder.m
//  Resplendent
//
//  Created by Benjamin Maer on 1/31/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUTextFieldCustomizablePlaceholder.h"
#import "UIView+RUUtility.h"
#import "RUSystemVersionUtils.h"
#import "RUConstants.h"
#import "UITextField+RUAttributes.h"





@interface RUTextFieldCustomizablePlaceholder ()

@property (nonatomic, readonly) UIFont* ru__placeholderFont;
@property (nonatomic, readonly) UIColor* ru__placeholderTextColor;

@end





@implementation RUTextFieldCustomizablePlaceholder

#pragma mark - UITextField
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
	
	UIFont* placeholderFont = self.ru__placeholderFont;
	
	if (placeholderFont)
	{
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
		{
			switch (self.contentVerticalAlignment)
			{
				case UIControlContentVerticalAlignmentCenter:
					if (self.isFirstResponder == false)
					{
						placeholderRect.size.height		-= CGRectGetVerticallyAlignedYCoordForHeightOnHeight(placeholderFont.pointSize, CGRectGetHeight(self.bounds));
					}
					break;
					
				default:
					break;
			}
		}
	}

	placeholderRect = CGRectCeilOrigin(UIEdgeInsetsInsetRect(placeholderRect, self.ru_placeholderTextInsets));
	return placeholderRect;
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
	CGRect textRect = [super textRectForBounds:bounds];

	textRect = CGRectCeilOrigin(UIEdgeInsetsInsetRect(textRect, self.ru_textInsets));
	return textRect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
	CGRect editingRect = [super editingRectForBounds:bounds];

	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
	{
		switch (self.contentVerticalAlignment)
		{
			case UIControlContentVerticalAlignmentCenter:
				editingRect.size.height		-= CGRectGetVerticallyAlignedYCoordForHeightOnHeight(self.font.pointSize, CGRectGetHeight(self.bounds));
				break;
				
			default:
				break;
		}
	}

	editingRect = CGRectCeilOrigin(UIEdgeInsetsInsetRect(editingRect, self.ru_textInsets));
	return editingRect;
}

-(void)drawPlaceholderInRect:(CGRect)rect
{
	if (self.placeholder.length)
	{
		UIColor* textColor = self.ru__placeholderTextColor;
		if (!textColor)
		{
			return;
		}

		UIFont* textFont = self.ru__placeholderFont;
		if (!textFont)
		{
			return;
		}

		[textColor setFill];

		if ([[self placeholder] respondsToSelector:@selector(drawInRect:withAttributes:)])
		{
			[[self placeholder] drawInRect:rect withAttributes:self.ru_placeholderAttributes];
		}
		else
		{
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
			[[self placeholder] drawInRect:rect withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:self.textAlignment];
#pragma clang diagnostic pop
		}
	}
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
	CGRect leftViewRect = [super leftViewRectForBounds:bounds];

	CGRect leftViewRect_inset = UIEdgeInsetsInsetRect(leftViewRect, self.ru_leftViewInsets);
	return leftViewRect_inset;
}

#pragma mark - Getters
-(UIFont *)ru__placeholderFont
{
	return (self.ru_placeholderFont ?: self.font);
}

-(UIColor *)ru__placeholderTextColor
{
	return (self.ru_placeholderTextColor ?: self.textColor);
}

#pragma mark - Setters
-(void)setRu_placeholderFont:(UIFont *)ru_placeholderFont
{
    if (self.ru_placeholderFont == ru_placeholderFont)
        return;
    
    _ru_placeholderFont = ru_placeholderFont;
    
    [self setNeedsDisplay];
}

-(void)setRu_placeholderTextColor:(UIColor *)ru_placeholderTextColor
{
    if (self.ru_placeholderTextColor == ru_placeholderTextColor)
        return;
    
    _ru_placeholderTextColor = ru_placeholderTextColor;

    [self setNeedsDisplay];
}

-(void)setRu_textInsets:(UIEdgeInsets)ru_textInsets
{
	if (UIEdgeInsetsEqualToEdgeInsets(self.ru_textInsets, ru_textInsets))
	{
		return;
	}
	
	_ru_textInsets = ru_textInsets;
	
	[self setNeedsDisplay];
}

-(void)setRu_placeholderTextInsets:(UIEdgeInsets)ru_placeholderTextInsets
{
	if (UIEdgeInsetsEqualToEdgeInsets(self.ru_placeholderTextInsets, ru_placeholderTextInsets))
	{
		return;
	}
	
	_ru_placeholderTextInsets = ru_placeholderTextInsets;
	
	[self setNeedsDisplay];
}

-(void)setRu_leftViewInsets:(UIEdgeInsets)ru_leftViewInsets
{
	if (UIEdgeInsetsEqualToEdgeInsets(self.ru_leftViewInsets, ru_leftViewInsets))
	{
		return;
	}
	
	_ru_leftViewInsets = ru_leftViewInsets;
	
	[self setNeedsDisplay];
}

#pragma mark - Attributes
@synthesize ru_placeholderParagraphStyle = _ru_placeholderParagraphStyle;
-(NSParagraphStyle*)ru_placeholderParagraphStyle
{
    if (_ru_placeholderParagraphStyle) {
        return _ru_placeholderParagraphStyle;
    }
    
	return self.ruParagraphStyle;
}

- (void)setRu_placeholderParagraphStyle:(NSParagraphStyle *)ru_placeholderParagraphStyle
{
    _ru_placeholderParagraphStyle = ru_placeholderParagraphStyle;
}

-(NSDictionary*)ru_placeholderAttributes
{
	return @{
			 NSFontAttributeName: self.ru__placeholderFont,
			 NSForegroundColorAttributeName: self.ru__placeholderTextColor,
			 NSParagraphStyleAttributeName: self.ru_placeholderParagraphStyle
			 };
}

@end
