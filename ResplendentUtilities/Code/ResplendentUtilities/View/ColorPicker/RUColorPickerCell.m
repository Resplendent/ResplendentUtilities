//
//  RUColorPickerCell.m
//  Doodler
//
//  Created by Benjamin Maer on 3/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "RUColorPickerCell.h"





@interface RUColorPickerCell ()

-(void)updateForState;

@end





@implementation RUColorPickerCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _disabledShadow = [UIView new];
        [_disabledShadow setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.6f]];
        [self.contentView addSubview:_disabledShadow];
        
        [self updateForState];
    }
    
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_disabledShadow setFrame:self.bounds];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - State
-(void)setState:(RUColorPickerCellState)state
{
    if (self.state == state)
        return;
    
    _state = state;

    [self updateForState];
}

-(void)updateForState
{
    [_disabledShadow setHidden:(self.state != RUColorPickerCellStateDisabled)];
    
    switch (self.state)
    {
        case RUColorPickerCellStateNone:
            [self.layer setBorderWidth:0.0f];
            break;
            
        case RUColorPickerCellStateSelected:
            [self.layer setBorderWidth:2.0f];
            [self.layer setBorderColor:self.selectedBorderColor.CGColor];
            break;
            
        case RUColorPickerCellStateDisabled:
            [self.layer setBorderWidth:2.0f];
            [self.layer setBorderColor:self.disabledBorderColor.CGColor];
            break;
    }
}

@end
