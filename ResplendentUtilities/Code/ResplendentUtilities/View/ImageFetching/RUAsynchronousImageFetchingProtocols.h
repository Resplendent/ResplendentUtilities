//
//  RUAsynchronousImageFetchingProtocols.h
//  Albumatic
//
//  Created by Benjamin Maer on 6/14/13.
//  Copyright (c) 2013 Albumatic Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RUAsynchronousImageFetchingDelegate <NSObject>

-(void)ruAsynchronousFetchingImageView:(UIImageView*)imageView finishedFetchingImage:(UIImage*)image;

@end
