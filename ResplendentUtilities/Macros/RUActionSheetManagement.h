//
//  RUActionSheetManagement.h
//  Albumatic
//
//  Created by Benjamin Maer on 5/3/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RUActionSheetSynthesizeActionSheetIVar UIActionSheet* _currentActionSheet;

#define RUActionSheetSynthesizeDismissDeclaration \
-(void)dismissCurrentActionSheet;

#define RUActionSheetSynthesizeDismiss \
-(void)dismissCurrentActionSheet \
{ \
    if (_currentActionSheet) \
    { \
        [_currentActionSheet dismissWithClickedButtonIndex:_currentActionSheet.cancelButtonIndex animated:YES]; \
        _currentActionSheet = nil; \
    } \
} \

#define RUActionSheetSynthesizeShowDeclaration \
-(void)showActionSheet:(UIActionSheet *)actionSheet

#define RUActionSheetSynthesizeShow \
RUActionSheetSynthesizeShowDeclaration \
{ \
[self dismissCurrentActionSheet]; \
_currentActionSheet = actionSheet; \
[_currentActionSheet showInView:self];  \
}

#define RUActionSheetSynthesizeShowInViewDeclaration \
RUActionSheetSynthesizeShowDeclaration inView:(UIView*)view

#define RUActionSheetSynthesizeShowInView \
RUActionSheetSynthesizeShowInViewDeclaration \
{ \
[self dismissCurrentActionSheet]; \
_currentActionSheet = actionSheet; \
[_currentActionSheet showInView:view];  \
}

#define RUActionSheetCheckAndClearActionSheetForButtonClick \
if (actionSheet == _currentActionSheet) \
{ \
    _currentActionSheet = nil; \
} \
else \
{ \
    RUDLog(@"actionSheet %@ should equal _currentActionSheet %@",actionSheet,_currentActionSheet); \
} \
