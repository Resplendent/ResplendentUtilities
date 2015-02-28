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

@property (nonatomic, readonly) UIFont* _placeholderFont;
@property (nonatomic, readonly) UIColor* _placeholderTextColor;

@end





@implementation RUTextFieldCustomizablePlaceholder

#pragma mark - UITextField
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
	
	UIFont* placeholderFont = self._placeholderFont;
	
	if (placeholderFont)
	{
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
		{
			switch (self.contentVerticalAlignment)
			{
				case UIControlContentVerticalAlignmentCenter:
					placeholderRect.origin.y = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(placeholderFont.pointSize, CGRectGetHeight(self.bounds));
					break;
					
				default:
					break;
			}
		}
	}
	
	return UIEdgeInsetsInsetRect(placeholderRect, self.placeholderTextInsets);
	//    return placeholderRect;
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
	CGRect textRect = [super textRectForBounds:bounds];

	return UIEdgeInsetsInsetRect(textRect, self.textInsets);
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
	CGRect editingRect = [super editingRectForBounds:bounds];
	
	return UIEdgeInsetsInsetRect(editingRect, self.textInsets);
}

-(void)drawPlaceholderInRect:(CGRect)rect
{
	if (self.placeholder.length)
	{
		UIColor* textColor = self._placeholderTextColor;
		if (!textColor)
		{
			return;
		}

		UIFont* textFont = self._placeholderFont;
		if (!textFont)
		{
			return;
		}

		[textColor setFill];

		if ([[self placeholder] respondsToSelector:@selector(drawInRect:withAttributes:)])
		{
			[[self placeholder] drawInRect:rect withAttributes:self.placeholderAttributes];
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
	return UIEdgeInsetsInsetRect(leftViewRect, self.leftViewInsets);
}

#pragma mark - Getters
-(UIFont *)_placeholderFont
{
	return (self.placeholderFont ?: self.font);
}

-(UIColor *)_placeholderTextColor
{
	return (self.placeholderTextColor ?: self.textColor);
}

//- (CGRect)editingRectForBounds:(CGRect)bounds
//{
//    CGRect editingRect = [super editingRectForBounds:bounds];
//    editingRect.origin.x += self.placeholderLeftPadding;
//    editingRect.size.width -= self.placeholderLeftPadding;
//    return editingRect;
//}
//
//-(CGRect)textRectForBounds:(CGRect)bounds
//{
//    CGRect textRect = [super textRectForBounds:bounds];
//    textRect.origin.x += self.placeholderLeftPadding;
//    textRect.size.width -= self.placeholderLeftPadding;
//    return textRect;
//}

#pragma mark - Setters
-(void)setPlaceholderFont:(UIFont *)placeholderFont
{
    if (self.placeholderFont == placeholderFont)
        return;
    
    _placeholderFont = placeholderFont;
    
    [self setNeedsDisplay];
}

-(void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    if (self.placeholderTextColor == placeholderTextColor)
        return;
    
    _placeholderTextColor = placeholderTextColor;

    [self setNeedsDisplay];
}

//-(void)setPlaceholderLeftPadding:(CGFloat)placeholderLeftPadding
//{
//    if (self.placeholderLeftPadding == placeholderLeftPadding)
//        return;
//
//    _placeholderLeftPadding = placeholderLeftPadding;
//
//    [self setNeedsDisplay];
//}

-(void)setTextInsets:(UIEdgeInsets)textInsets
{
	if (UIEdgeInsetsEqualToEdgeInsets(self.textInsets, textInsets))
	{
		return;
	}
	
	_textInsets = textInsets;
	
	[self setNeedsDisplay];
}

-(void)setPlaceholderTextInsets:(UIEdgeInsets)placeholderTextInsets
{
	if (UIEdgeInsetsEqualToEdgeInsets(self.placeholderTextInsets, placeholderTextInsets))
	{
		return;
	}
	
	_placeholderTextInsets = placeholderTextInsets;
	
	[self setNeedsDisplay];
}

-(void)setLeftViewInsets:(UIEdgeInsets)leftViewInsets
{
	if (UIEdgeInsetsEqualToEdgeInsets(self.leftViewInsets, leftViewInsets))
	{
		return;
	}
	
	_leftViewInsets = leftViewInsets;
	
	[self setNeedsDisplay];
}

#pragma mark - Attributes
@synthesize placeholderParagraphStyle = _placeholderParagraphStyle;
-(NSParagraphStyle*)placeholderParagraphStyle
{
    if (_placeholderParagraphStyle) {
        return _placeholderParagraphStyle;
    }
    
	return self.ruParagraphStyle;
}

- (void)setPlaceholderParagraphStyle:(NSParagraphStyle *)placeholderParagraphStyle {
    _placeholderParagraphStyle = placeholderParagraphStyle;
}

-(NSDictionary*)placeholderAttributes
{
	return @{
			 NSFontAttributeName: self._placeholderFont,
			 NSForegroundColorAttributeName: self._placeholderTextColor,
			 NSParagraphStyleAttributeName: self.placeholderParagraphStyle
			 };
}


@end
