//
//  RUTextViewWithPlaceholderContainerViewProtocols.h
//  Shimmur
//
//  Created by Benjamin Maer on 1/24/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RUTextViewWithPlaceholderContainerView;





@protocol RUTextViewWithPlaceholderContainerView_textDelegate <NSObject>

-(void)textViewWithPlaceholderContainerView:(RUTextViewWithPlaceholderContainerView*)textViewWithPlaceholderContainerView textViewDidChangeText:(NSString*)text;

@end
