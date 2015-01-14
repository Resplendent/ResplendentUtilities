//
//  RUPerformOperationToCompletionManagerProtocols.h
//  Nifti
//
//  Created by Benjamin Maer on 12/13/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import <Foundation/Foundation.h>





@protocol RUPerformOperationToCompletionManagerOperation <NSObject>

-(void)ru_performOperationToCompletion:(void(^)(BOOL didFinishSuccessfully))completion;

@end
