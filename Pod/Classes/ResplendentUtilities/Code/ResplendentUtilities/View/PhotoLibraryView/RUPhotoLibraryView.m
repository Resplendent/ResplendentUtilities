//
//  RUPhotoLibraryView.m
//  Shimmur
//
//  Created by Benjamin Maer on 3/11/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import "RUPhotoLibraryView.h"
#import "RUPhotoLibraryCollectionViewCell.h"

#import <AssetsLibrary/AssetsLibrary.h>





NSString* const kRUPhotoLibraryView_cellIdentifier_RUPhotoLibraryCollectionViewCell = @"cellIdentifier_RUPhotoLibraryCollectionViewCell";





@interface RUPhotoLibraryView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, readonly) ALAssetsLibrary* assetsLibrary;
@property (nonatomic, assign) BOOL isEnumeratingAssetsLibrary;

@property (nonatomic, strong) ALAssetsGroup* currentAssetsGroup;
-(ALAsset*)assetAtIndexPath:(NSIndexPath*)indexPath;

@property (nonatomic, readonly) UICollectionViewFlowLayout* collectionViewFlowLayout;
@property (nonatomic, readonly) CGFloat collectionViewFlowLayoutItemPadding;
@property (nonatomic, readonly) CGSize collectionViewFlowLayoutItemSize;
@property (nonatomic, readonly) NSUInteger collectionViewFlowLayoutNumberOfColumns;

@property (nonatomic, readonly) UICollectionView* collectionView;
@property (nonatomic, readonly) CGRect collectionViewFrame;

-(void)loadAssetGroup;

@end





@implementation RUPhotoLibraryView

#pragma mark - UIView
-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		_assetsLibrary = [ALAssetsLibrary new];

		_collectionViewFlowLayout = [UICollectionViewFlowLayout new];
		[self.collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
		[self.collectionViewFlowLayout setMinimumInteritemSpacing:0.0f];
		
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewFlowLayout];
		[self.collectionView setDelegate:self];
		[self.collectionView setDataSource:self];
		[self.collectionView registerClass:[RUPhotoLibraryCollectionViewCell class] forCellWithReuseIdentifier:kRUPhotoLibraryView_cellIdentifier_RUPhotoLibraryCollectionViewCell];
		[self.collectionView setBackgroundColor:[UIColor clearColor]];
		[self addSubview:self.collectionView];

		[self loadAssetGroup];
	}

	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	[self.collectionViewFlowLayout setMinimumLineSpacing:self.collectionViewFlowLayoutItemPadding];
	[self.collectionViewFlowLayout setItemSize:self.collectionViewFlowLayoutItemSize];
	[self.collectionView setFrame:self.collectionViewFrame];
}

#pragma mark - Frames
-(CGFloat)collectionViewFlowLayoutItemPadding
{
	return 4.0f;
}

-(NSUInteger)collectionViewFlowLayoutNumberOfColumns
{
	return 3.0f;
}

-(CGSize)collectionViewFlowLayoutItemSize
{
	CGFloat collectionViewFlowLayoutItemPadding = self.collectionViewFlowLayoutItemPadding;
	NSUInteger collectionViewFlowLayoutNumberOfColumns = self.collectionViewFlowLayoutNumberOfColumns;
	CGFloat collectionViewFlowLayoutNumberOfColumns_float = collectionViewFlowLayoutNumberOfColumns;
	CGRect collectionViewFrame = self.collectionViewFrame;
	
	CGFloat itemDimensionLength = (CGRectGetWidth(collectionViewFrame) - ((collectionViewFlowLayoutNumberOfColumns_float - 1) * collectionViewFlowLayoutItemPadding)) / collectionViewFlowLayoutNumberOfColumns_float;
	
	return (CGSize){
		.width		= itemDimensionLength,
		.height		= itemDimensionLength,
	};
}

-(CGRect)collectionViewFrame
{
	return self.bounds;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.currentAssetsGroup.numberOfAssets;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	RUPhotoLibraryCollectionViewCell* photoLibraryCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kRUPhotoLibraryView_cellIdentifier_RUPhotoLibraryCollectionViewCell forIndexPath:indexPath];
	[photoLibraryCollectionViewCell setAsset:[self assetAtIndexPath:indexPath]];
	
	return photoLibraryCollectionViewCell;
}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	[self.productSelectionDelegate productsCollectionView:self didSelectProduct:[self dataSource_productAtIndex:indexPath.row]];
//}

#pragma mark - Load Asset Group
-(void)loadAssetGroup
{
	kRUConditionalReturn(self.isEnumeratingAssetsLibrary, YES);

	[self setIsEnumeratingAssetsLibrary:YES];

	__block BOOL stopped = NO;
	__weak typeof(self) weakSelf = self;
	[self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

		RUDLog(@"!!");
		*stop = YES;

		if ((stopped == false) && (*stop == YES))
		{
			stopped = YES;
			RUDLog(@"stopped");
			if (weakSelf)
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					if (weakSelf)
					{
						[weakSelf setIsEnumeratingAssetsLibrary:NO];
						[weakSelf setCurrentAssetsGroup:group];
					}
				});
			}
		}
		
	} failureBlock:^(NSError *error) {
		RUDLog(@"error: %@",error);
	}];
}

#pragma mark - currentAssetsGroup
-(void)setCurrentAssetsGroup:(ALAssetsGroup *)currentAssetsGroup
{
	kRUConditionalReturn(self.currentAssetsGroup == currentAssetsGroup, NO);

	if (currentAssetsGroup)
	{
		[currentAssetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
	}

	_currentAssetsGroup = currentAssetsGroup;

	[self.collectionView reloadData];
}

#pragma mark - Assets
-(ALAsset*)assetAtIndexPath:(NSIndexPath*)indexPath
{
	kRUConditionalReturn_ReturnValueNil(self.currentAssetsGroup == nil, YES);
	kRUConditionalReturn_ReturnValueNil((indexPath.row >= self.currentAssetsGroup.numberOfAssets), YES);
	
	__block ALAsset* asset = nil;
	
	[self.currentAssetsGroup enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:indexPath.row] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
		if (result)
		{
			asset = result;
			*stop = YES;
		}
	}];
	
	return asset;
}

#pragma mark - Scrolling
-(void)scrollToTop:(BOOL)animated
{
	[self.collectionView setContentOffset:CGPointZero animated:animated];
}

@end
