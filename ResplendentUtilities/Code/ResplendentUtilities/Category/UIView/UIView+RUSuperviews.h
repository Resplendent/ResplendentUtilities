//
//  UIView+RUSuperviews.h
//  VibeWithIt
//
//  Created by Benjamin Maer on 1/10/15.
//  Copyright (c) 2015 VibeWithIt. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIView (RUSuperviews)

-(UIView*)ru_viewOrSuperviewThatIsKindOfClass:(Class)viewClass;

@end
