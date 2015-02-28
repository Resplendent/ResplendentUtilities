//
//  UIView+RUEnableTapToResignFirstResponder.m
//  Resplendent
//
//  Created by Benjamin Maer on 11/12/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "UIView+RUEnableTapToResignFirstResponder.h"

#import "RUSynthesizeAssociatedObjects.h"

NSString* const kUIViewRUEnableTapToResignFirstResponderTapAssociatedKey = @"kUIViewRUEnableTapToResignFirstResponderTapAssociatedKey";
NSString* const kUIViewRUEnableTapToResignFirstResponderAssociatedKey = @"kUIViewRUEnableTapToResignFirstResponderAssociatedKey";

@implementation UIView (RUEnableTapToResignFirstResponder)

-(UIView *)ruSelfOrSubviewFirstResponder
{
    if (self.isFirstResponder)
    {
        return self;
    }
    else
    {
        for (UIView* subview in self.subviews)
        {
            UIView* subviewFirstResponder = subview.ruSelfOrSubviewFirstResponder;
            if (subviewFirstResponder)
            {
                return subviewFirstResponder;
            }
        }

        return nil;
    }
}

#pragma mark - ruEnableTapToResignFirstResponder
-(BOOL)ruEnableTapToResignFirstResponder
{
    return self._ruEnableTapToResignFirstResponder;
}

-(void)setRuEnableTapToResignFirstResponder:(BOOL)ruEnableTapToResignFirstResponder
{
    if (self.ruEnableTapToResignFirstResponder == ruEnableTapToResignFirstResponder)
        return;
    
    [self set_RuEnableTapToResignFirstResponder:ruEnableTapToResignFirstResponder];
    
    if (ruEnableTapToResignFirstResponder)
    {
        if (!self.ruEnableTapToResignFirstResponderTap)
        {
            [self setRuEnableTapToResignFirstResponderTap:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_ruEnableTapToResignFirstResponderDidTapSelf:)]];
        }
        
        if (![self.gestureRecognizers containsObject:self.ruEnableTapToResignFirstResponderTap])
        {
            [self addGestureRecognizer:self.ruEnableTapToResignFirstResponderTap];
        }
    }
    else
    {
        
        if (self.ruEnableTapToResignFirstResponderTap)
        {
            if ([self.gestureRecognizers containsObject:self.ruEnableTapToResignFirstResponderTap])
            {
                [self removeGestureRecognizer:self.ruEnableTapToResignFirstResponderTap];
            }
            
            [self setRuEnableTapToResignFirstResponderTap:nil];
        }
    }
}

#pragma mark - Actions
-(void)_ruEnableTapToResignFirstResponderDidTapSelf:(UITapGestureRecognizer*)tap
{
	[self endEditing:YES];
//    [self.ruSelfOrSubviewFirstResponder resignFirstResponder];
}

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru, Ru, EnableTapToResignFirstResponderTap, UITapGestureRecognizer*, &kUIViewRUEnableTapToResignFirstResponderTapAssociatedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
RU_Synthesize_AssociatedObject_GetterSetterNumberFromPrimative_Implementation(_ru, _Ru, EnableTapToResignFirstResponder, BOOL, boolValue, &kUIViewRUEnableTapToResignFirstResponderAssociatedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end
