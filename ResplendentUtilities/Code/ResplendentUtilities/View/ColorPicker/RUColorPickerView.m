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

-(UIColor*)colorForIndexPath:(NSIndexPath*)indexPath;

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
        [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

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
    CGFloat itemWidth = [self itemWidthForHeight:size.height];
    return (CGSize){MIN(size.width, itemWidth * ceil((CGFloat)self.colors.count / (CGFloat)self.numberOfRows)),size.height};
}

#pragma mark - Frames
-(CGFloat)itemWidthForHeight:(CGFloat)height
{
    return height / (CGFloat)self.numberOfRows;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RUColorPickerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRUColorPickerViewCollectionViewReuseIdentifierRUColorPickerCell forIndexPath:indexPath];
    
    [cell setBackgroundColor:[self colorForIndexPath:indexPath]];
    
    [cell setState:[self colorPickerCellStateForIndexPath:indexPath]];
    
    return cell;
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
        return [self.delegate colorPickerCellStateForIndexPath:indexPath];
    }
    else
    {
        return ([_collectionView.indexPathsForSelectedItems containsObject:indexPath]);
    }
}

@end
