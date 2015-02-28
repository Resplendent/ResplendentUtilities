//
//  RURadioButtonGroup.h
//  Shimmur
//
//  Created by Benjamin Maer on 12/16/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RURadioButtonGroupProtocols.h"





extern const struct RURadioButtonGroup_KVOProperties {
	__unsafe_unretained NSString *buttons;
	__unsafe_unretained NSString *selectedButtonIndex;
} RURadioButtonGroup_KVOProperties;





@interface RURadioButtonGroup : NSObject

@property (nonatomic, strong) NSArray* buttons;

@property (nonatomic, assign) NSInteger selectedButtonIndex;
@property (nonatomic, readonly) UIButton* selectedButton;
-(UIButton *)buttonOrNilAtIndex:(NSInteger)buttonIndex;

@property (nonatomic, assign) BOOL allowDeselectionOfSelectedButton;

@property (nonatomic, assign) id<RURadioButtonGroupButtonSelectionDelegate> selectionDelegate;

@end
