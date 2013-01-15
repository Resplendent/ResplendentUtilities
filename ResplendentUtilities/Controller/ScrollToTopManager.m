//
//  ScrollToTopManager.m
//  Albumatic
//
//  Created by Benjamin Maer on 1/14/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "ScrollToTopManager.h"

@interface ScrollToTopManager ()
{
    NSMutableArray* _scrollToTopViewStack;
}

-(BOOL)setScrollsToTopForLastItem:(BOOL)scrollsToTop;
-(void)pushOffStack;
-(void)addToStack:(UIScrollView*)scrollView;
-(NSUInteger)indexInStack:(UIScrollView*)scrollView;

RU_SYNTHESIZE_SINGLETON_DECLARATION_FOR_CLASS_WITH_ACCESSOR(ScrollToTopManager, sharedInstance);

@end




@implementation ScrollToTopManager

-(id)init
{
    if (self = [super init])
    {
        _scrollToTopViewStack = [NSMutableArray array];
    }

    return self;
}

#pragma mark - Private methods
-(BOOL)setScrollsToTopForLastItem:(BOOL)scrollsToTop
{
    if (_scrollToTopViewStack.count)
    {
        UIScrollView* lastScrollView = [_scrollToTopViewStack lastObject];
        [lastScrollView setScrollsToTop:scrollsToTop];
        return YES;
    }

    return NO;
}

-(void)pushOffStack
{
    if ([self setScrollsToTopForLastItem:NO])
    {
        [_scrollToTopViewStack removeLastObject];
        [self setScrollsToTopForLastItem:YES];
    }
}

-(void)addToStack:(UIScrollView *)scrollView
{
    [self setScrollsToTopForLastItem:NO];
    [_scrollToTopViewStack addObject:scrollView];
    [self setScrollsToTopForLastItem:YES];
}

-(NSUInteger)indexInStack:(UIScrollView*)scrollView
{
    return [_scrollToTopViewStack indexOfObject:scrollView];
}

#pragma mark - Staitc methods
+(void)popOffStack
{
    [[ScrollToTopManager sharedInstance] pushOffStack];
}

+(void)addToStack:(UIScrollView*)scrollView
{
    [[ScrollToTopManager sharedInstance] addToStack:scrollView];
}

+(NSUInteger)indexInStack:(UIScrollView*)scrollView
{
    return [[ScrollToTopManager sharedInstance] indexInStack:scrollView];
}

RU_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(ScrollToTopManager, sharedInstance);

@end
