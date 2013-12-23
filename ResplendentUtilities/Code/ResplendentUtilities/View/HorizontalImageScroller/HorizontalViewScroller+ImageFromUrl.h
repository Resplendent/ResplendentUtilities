//
//  HorizontalViewScroller+ImageFromUrl.h
//  Pineapple
//
//  Created by Benjamin Maer on 3/31/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "HorizontalViewScroller.h"

@interface HorizontalViewScroller (ImageFromUrl)

-(void)addImageFromUrlString:(NSString*)urlString size:(CGSize)size;
-(void)addImageFromUrl:(NSURL*)url size:(CGSize)size;

@end
