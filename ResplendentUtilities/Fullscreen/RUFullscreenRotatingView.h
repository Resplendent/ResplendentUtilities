//
//  RUFullscreenRotatingView.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/3/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUSingleton.h"

@interface RUFullscreenRotatingView : UIView
{
    UIView* _contentView;
}

-(void)showWithCompletion:(void (^)())completion;
-(void)hide;

RU_SYNTHESIZE_SINGLETON_DECLARATION_FOR_CLASS_WITH_ACCESSOR(RUFullscreenRotatingView, sharedInstance);

@end
