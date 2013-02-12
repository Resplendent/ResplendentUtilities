//
//  RUShowViewUtil.h
//  Albumatic
//
//  Created by Benjamin Maer on 1/10/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RUSynthesizeShowFunctionDeclarationForView(methodName) \
-(void)show##methodName:(BOOL)show animated:(BOOL)animated

#define RUSynthesizeShowFunctionForView(methodName, view) \
-(void)show##methodName:(BOOL)show animated:(BOOL)animated \
{ \
    if (animated) \
    { \
        [UIView animateWithDuration:0.25f animations:^{ \
            [self show##methodName:show animated:NO]; \
        }]; \
    } \
    else \
    { \
        [view setAlpha:(show ? 1.0f : 0.0f)]; \
    } \
}

#define RUSynthesizeShowFunctionDeclarationForViewWithCompletion(methodName) \
-(void)show##methodName:(BOOL)show animated:(BOOL)animated completion:(void(^)())completion

#define RUSynthesizeShowFunctionForViewWithCompletion(methodName, view) \
-(void)show##methodName:(BOOL)show animated:(BOOL)animated completion:(void(^)())completion \
{ \
if (animated) \
{ \
[UIView animateWithDuration:0.25f animations:^{ \
[self show##methodName:show animated:NO]; \
} completion:^(BOOL finished) { \
if (completion) \
completion(); \
}]; \
} \
else \
{ \
[view setAlpha:(show ? 1.0f : 0.0f)]; \
if (completion) \
    completion(); \
} \
}

