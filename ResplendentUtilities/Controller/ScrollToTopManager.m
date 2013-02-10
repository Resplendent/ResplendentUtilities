//
//  ScrollToTopManager.m
//  Albumatic
//
//  Created by Benjamin Maer on 1/14/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "ScrollToTopManager.h"
#import "RUConstants.h"

@interface ScrollToTopManager ()
{
    NSMutableArray* _scrollToTopViewStack;
}

-(BOOL)setScrollsToTopForLastItem:(BOOL)scrollsToTop;
-(void)pushOffStack:(UIScrollView *)scrollView;
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

-(void)pushOffStack:(UIScrollView *)scrollView
{
    if (!scrollView)
    {
        RUDLog(@"can't send non nil scroll view");
        return;
    }

    NSInteger index = [self indexInStack:scrollView];

    if (index == NSNotFound)
    {
        RUDLog(@"scroll view %@ isn't in the stack %@",scrollView,_scrollToTopViewStack);
    }
    else
    {
        BOOL isLast = (index + 1 == _scrollToTopViewStack.count);

        if (isLast)
        {
            if (scrollView.scrollsToTop)
            {
                [scrollView setScrollsToTop:NO];
                [_scrollToTopViewStack removeLastObject];
                [self setScrollsToTopForLastItem:YES];
            }
        }
        else
        {
            RUDLog(@"remove scroll view %@ which isn't at end of stack %@",scrollView,_scrollToTopViewStack);
            if (scrollView.scrollsToTop)
            {
                RUDLog(@"and was scrolls to top was on");
                [scrollView setScrollsToTop:NO];
                [self setScrollsToTopForLastItem:YES];
            }
        }
    }
}

-(void)addToStack:(UIScrollView *)scrollView
{
    if ([self indexInStack:scrollView] == NSNotFound)
    {
        [self setScrollsToTopForLastItem:NO];
        [_scrollToTopViewStack addObject:scrollView];
        [self setScrollsToTopForLastItem:YES];
    }
    else
    {
        RUDLog(@"already in the stack");
    }
}

-(NSUInteger)indexInStack:(UIScrollView*)scrollView
{
    return [_scrollToTopViewStack indexOfObject:scrollView];
}

#pragma mark - Staitc methods
+(void)popOffStack:(UIScrollView *)scrollView
{
    [[ScrollToTopManager sharedInstance] pushOffStack:scrollView];
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
