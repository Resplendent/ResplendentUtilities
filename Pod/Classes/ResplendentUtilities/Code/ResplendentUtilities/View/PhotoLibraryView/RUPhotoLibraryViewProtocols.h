//
//  RUPhotoLibraryViewProtocols.h
//  Shimmur
//
//  Created by Benjamin Maer on 3/11/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>





@class RUPhotoLibraryView;





@protocol RUPhotoLibraryView_assetSelectionDelegate <NSObject>

-(void)photoLibraryView:(RUPhotoLibraryView*)photoLibraryView didSelectAsset:(ALAsset*)asset;

@end
