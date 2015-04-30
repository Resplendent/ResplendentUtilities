//
//  RUNavigationControllerDelegate_navbarColorSetterProtocols.h
//  Resplendent
//
//  Created by Benjamin Maer on 3/15/15.
//  Copyright (c) 2015 Resplendent. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RUNavigationControllerDelegate_navbarColorSetter;





@protocol RUNavigationControllerDelegate_navbarColorSetter_viewControllerColorDelegate <NSObject>

@required
-(UIColor*)ruNavigationControllerDelegate_navbarColorSetter_colorForNavigationBar:(RUNavigationControllerDelegate_navbarColorSetter*)navigationControllerDelegate_navbarColorSetter;

//If not implemented, the status bar's color will be determined by ruNavigationControllerDelegate_navbarColorSetter_colorForNavigationBar:
@optional
-(UIColor*)ruNavigationControllerDelegate_navbarColorSetter_colorForStatusBar:(RUNavigationControllerDelegate_navbarColorSetter*)navigationControllerDelegate_navbarColorSetter;

@end
