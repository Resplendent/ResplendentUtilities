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

@interface PAHorizontalViewScroller ()

//@property (nonatomic, readonly) CGFloat cornerRibbonAlpha;
-(CGFloat)cornerRibbonAlphaForContentXOffset:(CGFloat)contentXOffset;

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
        [self addSubview:_cornerRibbon];
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

#pragma mark - Getter methods
-(CGFloat)cornerRibbonAlphaForContentXOffset:(CGFloat)contentXOffset
{
    NSInteger index = self.selectedIndex;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat isolatedRange = ((contentXOffset - (index * width)) / width); //0 - 1
    return fabsf((isolatedRange * 2) - 1);
}

#pragma mark - Overloaded methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [_cornerRibbon setAlpha:[self cornerRibbonAlphaForContentXOffset:scrollView.contentOffset.x]];
    RUDLog(@"%f",[self cornerRibbonAlphaForContentXOffset:scrollView.contentOffset.x]);
}

@end


@implementation PAHorizontalViewScroller (Images)

RUStaticVariableSynthesizationWithGetterImage(paSelectedRibbonImage, @"saveFSVAsBookmark-imageScroller-ribbonSelected");

@end

