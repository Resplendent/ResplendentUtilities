//
//  RUTextViewWithPlaceholderContainerView.h
//  Shimmur
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RUTextViewWithPlaceholderContainerView : UIView <UITextViewDelegate>

@property (nonatomic, readonly) UITextView* textView;
@property (nonatomic, readonly) CGRect textViewFrame;

@property (nonatomic, readonly) UILabel* textViewPlaceholderLabel;
@property (nonatomic, readonly) CGRect textViewPlaceholderLabelFrame;

-(void)updateTextViewPlaceholderLabelVisilibity;

//UITextViewDelegate methods used.
- (void)textViewDidEndEditing:(UITextView *)theTextView;
- (void)textViewDidChange:(UITextView *)textView;

@end
