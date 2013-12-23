//
//  RUNetworkResponse.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUNetworkResponse.h"

#import "RUConstants.h"

@interface RUNetworkResponse ()

-(id)initWithRequestObject:(RUNetworkRequest*)request;

@end

@implementation RUNetworkResponse

-(id)initWithRequestObject:(RUNetworkRequest*)request
{
    if (!self.responseObject && !self.error)
        [NSException raise:NSInternalInconsistencyException format:@"Response created with request %@ but without an error nor response object",request];
    
    _request = request;
    return (self = [self init]);
}

-(id)initWithRequestObject:(RUNetworkRequest *)request responseObject:(id)responseObject
{
    _responseObject = responseObject;
    return (self = [self initWithRequestObject:request]);
}

-(id)initWithRequestObject:(RUNetworkRequest *)request error:(NSError *)error
{
    _error = error;
    return (self = [self initWithRequestObject:request]);
}

-(NSString *)description
{
    NSString* description = RUStringWithFormat(@"%@ with request %@",[super description],self.request);

    if (self.responseObject)
    {
        description = [description stringByAppendingFormat:@"\nResponse object: %@",self.responseObject];
    }

    if (self.error)
    {
        description = [description stringByAppendingFormat:@"\nError: %@",self.error];
    }

    return description;
}

@end
