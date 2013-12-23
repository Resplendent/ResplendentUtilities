//
//  HTTPSClientJSONAPIController.m
//  Albumatic
//
//  Created by Sheldon Thomas on 2/5/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "HTTPSClientJSONAPIController.h"
#import "AFHTTPRequestOperation.h"

@implementation HTTPSClientJSONAPIController

-(id)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super initWithBaseUrl:baseUrl];
    if (self)
    {
        NSString* secureUrl = [baseUrl stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"https"];
        [self setSecureNetwork:[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:secureUrl]]];
    }
    return self;
}

-(void)postSecureNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock
{
    [_secureNetwork postPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self postSuccessLogicWithReponseObject:responseObject fromOperation:operation completionBlock:completionBlock failBlock:failBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock)
            failBlock(operation,error);
    }];
}

-(void)postSecureMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey fileName:(NSString*)fileName mimeType:(NSString*)mimeType noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock
{
    [self postSecureMultipartDataNetworkRequestWithUrl:url params:params data:data dataParamKey:dataParamKey noSuccessError:noSuccessError constructingBodyBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:dataParamKey fileName:fileName mimeType:mimeType];
    } completionBlock:completionBlock progressBlock:progressBlock failBlock:failBlock];
}

-(void)postSecureMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock
{
    [self postSecureMultipartDataNetworkRequestWithUrl:url params:params data:data dataParamKey:dataParamKey noSuccessError:noSuccessError constructingBodyBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:data name:dataParamKey];
    } completionBlock:completionBlock progressBlock:progressBlock failBlock:failBlock];
}

-(void)postSecureMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey noSuccessError:(NSError*)noSuccessError constructingBodyBlock:(void (^)(id <AFMultipartFormData>formData))constructingBodyBlock completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock
{
    if (params && [params objectForKey:dataParamKey])
    {
        NSLog(@"%s has to manually remove data from param list",__PRETTY_FUNCTION__);
        NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithDictionary:params];
        [mDict removeObjectForKey:dataParamKey];
        params = [NSDictionary dictionaryWithDictionary:mDict];
    }
    
    NSMutableURLRequest* uploadRequest = uploadRequest = [_secureNetwork multipartFormRequestWithMethod:@"POST" path:url parameters:params constructingBodyWithBlock:constructingBodyBlock];
    
    [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc]initWithRequest:uploadRequest];
    
    //    __weak AFHTTPRequestOperation* opWeak = op;
    
    [op setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        if ([self respondsToSelector:@selector(didFireExpiration)])
            [self didFireExpiration];
    }];
    
    [op setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (progressBlock)
        {
            progressBlock((float)totalBytesWritten / (float)totalBytesExpectedToWrite);
        }
    }];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self postSuccessLogicWithReponseObject:responseObject fromOperation:operation completionBlock:completionBlock failBlock:failBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock)
            failBlock(operation,error);
    }];
    
    [op start];
}

-(void)putSecureNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock
{
    [_secureNetwork putPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self postSuccessLogicWithReponseObject:responseObject fromOperation:operation completionBlock:completionBlock failBlock:failBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock)
            failBlock(operation,error);
    }];
}

@end
