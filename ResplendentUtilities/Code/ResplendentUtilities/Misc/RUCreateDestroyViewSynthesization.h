//
//  RUCreateDestroyViewSynthesization.h
//  Albumatic
//
//  Created by Benjamin Maer on 3/31/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RUCreateDestroyViewSynthesizeDeclarations(viewVarName) \
-(void)create##viewVarName; \
-(void)destroy##viewVarName;

#define RUDestroyViewSynthesizeImplementation(getterVarName,iVarName) \
-(void)destroy##getterVarName \
{ \
    if (iVarName) \
    { \
        [iVarName removeFromSuperview]; \
        iVarName = nil; \
    } \
}
