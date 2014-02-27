//
//  RUAsynchronousImageFetchingProtocols.h
//  Resplendent
//
//  Created by Benjamin Maer on 6/14/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RUAsynchronousImageFetchingDelegate <NSObject>

-(void)ruAsynchronousFetchingImageView:(UIImageView*)imageView finishedFetchingImage:(UIImage*)image;

@end
