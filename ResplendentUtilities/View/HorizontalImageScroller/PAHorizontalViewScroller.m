//
//  PAHorizontalViewScroller.m
//  Pineapple
//
//  Created by Benjamin Maer on 4/3/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "PAHorizontalViewScroller.h"
#import "RUStaticVariableSynthesization.h"
#import "RUConstants.h"
#import "RUShowViewUtil.h"

@interface PAHorizontalViewScroller ()

//@property (nonatomic, readonly) CGFloat cornerRibbonAlpha;
//-(CGFloat)cornerRibbonAlphaForContentXOffset:(CGFloat)contentXOffset;

RUSynthesizeShowFunctionDeclarationForView(CornerRibbon);

@end

@interface PAHorizontalViewScroller (Images)

RUStaticVariableSynthesizationGetterImageDeclaration(paSelectedRibbonImage);

@end

@implementation PAHorizontalViewScroller

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        _cornerRibbon = [[UIImageView alloc] initWithImage:[PAHorizontalViewScroller paSelectedRibbonImage]];
//        [_cornerRibbon setFrame:CGRectSetX(1.0f, _cornerRibbon.frame)];
        [self addSubview:_cornerRibbon];
        [self showCornerRibbon:NO animated:NO];
    }

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//#pragma mark - Getter methods
//-(CGFloat)cornerRibbonAlphaForContentXOffset:(CGFloat)contentXOffset
//{
//    NSInteger index = self.selectedIndex;
//    CGFloat width = CGRectGetWidth(self.bounds);
//    CGFloat isolatedRange = ((contentXOffset - (index * width)) / width); //0 - 1
//    return fabsf((isolatedRange * 2) - 1);
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)addView:(UIView *)view
{
    [super addView:view];

    if (self.numberOfViews)
    {
        [self showCornerRibbon:YES animated:NO];
        [self updateCornerRibbonFrame];
    }
}

#pragma mark - Show methods
RUSynthesizeFadingShowFunctionForView(CornerRibbon, _cornerRibbon);

//#pragma mark - Timer methods
//-(void)destroyCornerRibbonTimer
//{
//    if (_cornerRibbonTimer)
//    {
//        [_cornerRibbonTimer invalidate];
//        _cornerRibbonTimer = nil;
//    }
//}
//
//-(void)createCornerRibbonTimer
//{
//    
//}

-(void)updateCornerRibbonFrame
{
    CGPoint origin = self.selectedView.frame.origin;
    origin.x -= self.scrollView.contentOffset.x;
    [_cornerRibbon setFrame:CGRectSetOrigin(origin, _cornerRibbon.frame)];
}

#pragma mark - Overloaded methods
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
    [self updateCornerRibbonFrame];
//    [_cornerRibbon setFrame:CGRectSetX(CGRectGetMinX(self.selectedView.frame), _cornerRibbon.frame)];
    [self showCornerRibbon:YES animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [self showCornerRibbon:NO animated:YES];
//    [_cornerRibbon setAlpha:[self cornerRibbonAlphaForContentXOffset:scrollView.contentOffset.x]];
//    RUDLog(@"%f",[self cornerRibbonAlphaForContentXOffset:scrollView.contentOffset.x]);
}

@end


@implementation PAHorizontalViewScroller (Images)

RUStaticVariableSynthesizationWithGetterImage(paSelectedRibbonImage, @"saveFSVAsBookmark-imageScroller-ribbonSelected");

@end

