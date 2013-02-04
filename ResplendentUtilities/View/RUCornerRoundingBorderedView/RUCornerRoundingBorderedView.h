//
//  RUCornerRoundingBorderedView.h
//  Albumatic
//
//  Created by Benjamin Maer on 2/3/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUCornerRoundingBorderedView : UIView
{
    UIBezierPath* _path;
}

@property (nonatomic, assign) UIRectCorner cornerMasks;
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) UIColor* borderColor;

@end





@interface RUCornerRoundingBorderedView (TextField)

extern NSString* const kRUCornerRoundingBorderedViewTextFieldObservingKey;
extern NSString* const kRUCornerRoundingBorderedViewTextFieldHorizontalPaddingObservingKey;

@property (nonatomic, readonly) UITextField* inputTextField;
@property (nonatomic, readonly) CGRect inputTextFieldFrame;

//@property (nonatomic, assign) CGFloat textFieldHorizontalPadding;
-(void)setTextFieldHorizontalPadding:(CGFloat)textFieldHorizontalPadding;

-(void)addInputTextField;
-(void)layoutInputTextField;

@end

