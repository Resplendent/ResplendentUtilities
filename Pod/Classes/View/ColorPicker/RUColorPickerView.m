//
//  RUColorPickerView.m
//  Doodler
//
//  Created by Benjamin Maer on 3/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "RUColorPickerView.h"
#import "RUColorPickerCell.h"





NSString* const kRUColorPickerViewCollectionViewReuseIdentifierRUColorPickerCell = @"kRUColorPickerViewCollectionViewReuseIdentifierRUColorPickerCell";





@interface RUColorPickerView ()

-(CGFloat)itemWidthForHeight:(CGFloat)height;

-(RUColorPickerCellState)colorPickerCellStateForIndexPath:(NSIndexPath*)indexPath;

@end




@implementation RUColorPickerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _layout = [UICollectionViewFlowLayout new];
        [_layout setMinimumInteritemSpacing:0];
        [_layout setMinimumLineSpacing:0];
        [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[RUColorPickerCell class] forCellWithReuseIdentifier:kRUColorPickerViewCollectionViewReuseIdentifierRUColorPickerCell];
        [self addSubview:_collectionView];
    }

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat itemWidth = [self itemWidthForHeight:CGRectGetHeight(self.bounds)];
    [_layout setItemSize:(CGSize){itemWidth,itemWidth}];

    [_collectionView setFrame:self.bounds];
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGFloat numberOfRows = self.numberOfRows;

    if (numberOfRows)
    {
        CGFloat itemWidth = [self itemWidthForHeight:size.height];
        return (CGSize){MIN(size.width, itemWidth * ceil((CGFloat)self.colors.count / (CGFloat)numberOfRows)),size.height};
    }
    else
    {
		NSAssert(FALSE, @"Must set a number of rows");
        return CGSizeZero;
    }
}

#pragma mark - Frames
-(CGFloat)itemWidthForHeight:(CGFloat)height
{
    CGFloat numberOfRows = self.numberOfRows;
    if (numberOfRows)
    {
        return height / (CGFloat)numberOfRows;
    }
    else
    {
		NSAssert(FALSE, @"Must set a number of rows");
        return 0;
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RUColorPickerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRUColorPickerViewCollectionViewReuseIdentifierRUColorPickerCell forIndexPath:indexPath];

    [cell setSelectedBorderColor:self.cellSelectedBorderColor];
    [cell setDisabledBorderColor:self.cellDisabledBorderColor];

    [cell setBackgroundColor:[self colorForIndexPath:indexPath]];

    [cell setState:[self colorPickerCellStateForIndexPath:indexPath]];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate colorPickerView:self didSelectColorAtIndexPath:indexPath];
}

#pragma mark - Setters
-(void)setColors:(NSArray *)colors
{
    if (self.colors == colors)
        return;

    _colors = colors;

    [_collectionView reloadData];
}

#pragma mark - Getters
-(UIColor*)colorForIndexPath:(NSIndexPath*)indexPath
{
    return [self.colors objectAtIndex:indexPath.row];
}

-(RUColorPickerCellState)colorPickerCellStateForIndexPath:(NSIndexPath*)indexPath
{
    if (self.delegate)
    {
        return [self.delegate colorPickerView:self cellStateForIndexPath:indexPath];
    }
    else
    {
        return ([_collectionView.indexPathsForSelectedItems containsObject:indexPath]);
    }
}

@end
