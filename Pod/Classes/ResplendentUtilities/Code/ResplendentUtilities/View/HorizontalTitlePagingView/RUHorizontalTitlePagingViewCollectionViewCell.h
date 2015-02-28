//
//  RUHorizontalTitlePagingViewCollectionViewCell.h
//  Wallflower Food
//
//  Created by Benjamin Maer on 3/14/14.
//  Copyright (c) 2014 Wallflower Food. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RUHorizontalTitlePagingViewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) UIImage* image;

@property (nonatomic, readonly) UILabel* titleLabel;

@end
