//
//  UITableView+RUSpinner.m
//  Pineapple
//
//  Created by Benjamin Maer on 6/16/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "UITableView+RUSpinner.h"
#import <objc/runtime.h>
#import "RUDeallocHook.h"

NSString* const kUITableViewRUSpinnerAssociatedObjectSpinnerVisibilityNumber = @"kUITableViewRUSpinnerAssociatedObjectSpinnerVisibilityNumber";
NSString* const kUITableViewRUSpinnerAssociatedObjectSpinnerActivityIndicatorView = @"kUITableViewRUSpinnerAssociatedObjectSpinnerActivityIndicatorView";
NSString* const kUITableViewRUSpinnerAssociatedObjectSpinnerVisibilityDeallocHook = @"kUITableViewRUSpinnerAssociatedObjectSpinnerVisibilityDeallocHook";

@interface UITableView (RUSpinnerAssociatedObjects)

@property (nonatomic) NSNumber* ruSpinnerVisibilityNumber;
@property (nonatomic) UIActivityIndicatorView* ruSpinnerActivityIndicatorView;
@property (nonatomic) RUDeallocHook* ruSpinnerVisibilityDeallocHook;

@end

@interface UITableView (RUSpinnerFrames)

@property (nonatomic, readonly) CGPoint spinnerFrame;

@end

@implementation UITableView (RUSpinner)

-(void)setRuSpinnerVisibility:(BOOL)ruSpinnerVisibility
{
    if (self.ruSpinnerVisibility == ruSpinnerVisibility)
        return;

    [self setRuSpinnerVisibilityNumber:@(ruSpinnerVisibility)];

    if (ruSpinnerVisibility)
    {
        if (!self.ruSpinnerActivityIndicatorView)
        {
//            UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        }
    }
}

-(BOOL)ruSpinnerVisibility
{
    return self.ruSpinnerVisibilityNumber.boolValue;
}

@end

@implementation UITableView (RUSpinnerAssociatedObjects)

#pragma mark - ruSpinnerVisibilityNumber
-(NSNumber *)ruSpinnerVisibilityNumber
{
    return objc_getAssociatedObject(self, &kUITableViewRUSpinnerAssociatedObjectSpinnerVisibilityNumber);
}

-(void)setRuSpinnerVisibilityNumber:(NSNumber *)ruSpinnerVisibilityNumber
{
    objc_setAssociatedObject(self, &kUITableViewRUSpinnerAssociatedObjectSpinnerVisibilityNumber, ruSpinnerVisibilityNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - deallocHook
-(RUDeallocHook *)ruSpinnerVisibilityDeallocHook
{
    return objc_getAssociatedObject(self, &kUITableViewRUSpinnerAssociatedObjectSpinnerVisibilityDeallocHook);
}

-(void)setRuSpinnerVisibilityDeallocHook:(RUDeallocHook *)ruSpinnerVisibilityDeallocHook
{
    objc_setAssociatedObject(self, &kUITableViewRUSpinnerAssociatedObjectSpinnerVisibilityDeallocHook, ruSpinnerVisibilityDeallocHook, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - spinner
-(UIActivityIndicatorView *)ruSpinnerActivityIndicatorView
{
    return objc_getAssociatedObject(self, &kUITableViewRUSpinnerAssociatedObjectSpinnerActivityIndicatorView);
}

-(void)setRuSpinnerActivityIndicatorView:(UIActivityIndicatorView *)ruSpinnerActivityIndicatorView
{
    objc_setAssociatedObject(self, &kUITableViewRUSpinnerAssociatedObjectSpinnerActivityIndicatorView, ruSpinnerActivityIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
