//
//  ScrollToTopManager.m
//  Resplendent
//
//  Created by Benjamin Maer on 1/14/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUScrollToTopManager.h"
#import "RUDLog.h"
#import "RUSingleton.h"





#define kScrollToTopManagerEnableWhining 0





@interface RUScrollToTopManager ()
{
    NSMutableArray* _scrollToTopViewStack;
}

-(BOOL)setScrollsToTopForLastItem:(BOOL)scrollsToTop;
-(void)pushOffStack:(UIScrollView *)scrollView;
-(void)addToStack:(UIScrollView*)scrollView;
-(NSUInteger)indexInStack:(UIScrollView*)scrollView;

@end




@implementation RUScrollToTopManager

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
        RUDLog(@"**can't send non nil scroll view");
        return;
    }

    NSInteger index = [self indexInStack:scrollView];

    if (index == NSNotFound)
    {
#if kScrollToTopManagerEnableWhining
        RUDLog(@"**scroll view %@ isn't in the stack %@",scrollView,_scrollToTopViewStack);
#endif
    }
    else
    {
        BOOL isLast = (index + 1 == _scrollToTopViewStack.count);

        if (isLast)
        {
            if (scrollView.scrollsToTop)
            {
                [scrollView setScrollsToTop:NO];
                [_scrollToTopViewStack removeObjectAtIndex:index];
                [self setScrollsToTopForLastItem:YES];
            }
            else
            {
                RUDLog(@"**last item didn't have scroll to tops on");
                [_scrollToTopViewStack removeObjectAtIndex:index];
            }
        }
        else
        {
            if (scrollView.scrollsToTop)
            {
                RUDLog(@"**remove scroll view %@ which isn't at end of stack %@ but has scrolls to top on",scrollView,_scrollToTopViewStack);
                [scrollView setScrollsToTop:NO];
                [_scrollToTopViewStack removeObjectAtIndex:index];
                [self setScrollsToTopForLastItem:YES];
            }
            else
            {
                [_scrollToTopViewStack removeObjectAtIndex:index];
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
#if kScrollToTopManagerEnableWhining
    else
    {
        RUDLog(@"**already in the stack");
    }
#endif
}

-(NSUInteger)indexInStack:(UIScrollView*)scrollView
{
    return [_scrollToTopViewStack indexOfObject:scrollView];
}

#pragma mark - Staitc methods
+(void)popOffStack:(UIScrollView *)scrollView
{
    [[RUScrollToTopManager sharedInstance] pushOffStack:scrollView];
}

+(void)addToStack:(UIScrollView*)scrollView
{
    [[RUScrollToTopManager sharedInstance] addToStack:scrollView];
}

+(NSUInteger)indexInStack:(UIScrollView*)scrollView
{
    return [[RUScrollToTopManager sharedInstance] indexInStack:scrollView];
}

#pragma mark - Singleton
RUSingletonUtil_Synthesize_Singleton_Implementation_SharedInstance

@end
