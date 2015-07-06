//
//  NSString+RUMacros.h
//  Pods
//
//  Created by Richard Reitzfeld on 7/6/15.
//
//

#import <Foundation/Foundation.h>





#define RUDefineNSStringConstant(name) \
static NSString * const name = @""##name;




