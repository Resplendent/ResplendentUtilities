//
//  ECHTTPClientAPIController.m
//  Everycam
//
//  Created by Benjamin Maer on 10/3/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "HTTPClientJSONAPIController.h"
#import "JSONKit.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "RUConstants.h"
#import "RUClassOrNilUtil.h"

#define kHTTPClientJSONAPIControllerPostMultipartDataNoDataError kNSErrorMake(@"postMultipartDataNetworkRequestWithUrl:params:data:dataParamKey:noSuccessError:completionBlock:failBlock: must have a non-nil data param.",420)


@implementation HTTPClientJSONAPIController

-(id)initWithBaseUrl:(NSString*)baseUrl
{
    if (self = [super init])
    {
        [self setNetwork:[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:baseUrl]]];
    }
    
    return self;
}

#pragma mark - Post Success Logic
-(NSError*)errorForResponseJsonParseObject:(id)responseJSONParsedObject fromOperation:(AFHTTPRequestOperation*)operation
{
    return nil;
}

-(void)postSuccessLogicWithReponseObject:(id)responseObject fromOperation:(AFHTTPRequestOperation*)operation completionBlock:(void(^)(id responseObject))completionBlock failBlock:(void(^)(AFHTTPRequestOperation* operation, NSError* error))failBlock
{
    NSString* response = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    id responseJSONParsedObject = [response objectFromJSONString];

    NSError* error = [self errorForResponseJsonParseObject:responseJSONParsedObject fromOperation:operation];
    if (error)
    {
        failBlock(operation,error);
    }
    else
    {
        completionBlock(responseJSONParsedObject);
    }
//    if (responseJSONParsedObject) // router returned non-compliant json
//    {
////        if (noSuccessError)
////        {
////            if (![responseJSONParsedObject isKindOfClass:[NSDictionary class]] || kHTTPClientJSONAPIControllerResponseDictionaryHasValidSuccessValue(responseJSONParsedObject))
////            {
////                if (completionBlock)
////                    completionBlock(responseJSONParsedObject);
////            }
////            else
////            {
////                if (failBlock)
////                    failBlock(nil,noSuccessError);
////            }
////        }
////        else
////        {
////            if (completionBlock)
////                completionBlock(responseJSONParsedObject);
////        }
//    }
//    else
//    {
//        if (failBlock)
//            failBlock(operation,error);
//    }
}

//#pragma mark - C methods
//BOOL kHTTPClientJSONAPIControllerResponseDictionaryHasValidSuccessValue(NSDictionary* responseDict)
//{
//        NSNumber* successValue = [responseDict objectForKey:@"success"];
//        return kRUNumberOrNil(successValue) && successValue.boolValue;
//}

#pragma mark - Public methods
//@TODO remove this after master is updated on albumatic
- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method
{
    [self cancelAllHTTPOperationsWithMethod:method respectingCancellableRequests:YES];
}

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method respectingCancellableRequests:(BOOL)respectingCancellableRequests
{
    for (NSOperation *operation in [_network.operationQueue operations])
    {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]])
        {
            continue;
        }

        if ((!method || [method isEqualToString:[[(AFHTTPRequestOperation *)operation request] HTTPMethod]]))
        {
            if (!respectingCancellableRequests || [self operationCanBeCancelled:(AFHTTPRequestOperation *)operation])
                [operation cancel];
        }
    }
}

-(BOOL)operationCanBeCancelled:(AFHTTPRequestOperation*)operation
{
    return TRUE;
}

#pragma mark Get network requests
-(void)getNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError *)noSuccessError completionBlock:(void (^)(NSDictionary* responseDict))completionBlock failBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failBlock
{
    [_network getPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self postSuccessLogicWithReponseObject:responseObject fromOperation:operation completionBlock:completionBlock failBlock:failBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock)
            failBlock(operation,error);
    }];
}

#pragma mark Post network requests
-(void)postNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError *)noSuccessError completionBlock:(void (^)(NSDictionary *))completionBlock failBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *))failBlock
{
    [_network postPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self postSuccessLogicWithReponseObject:responseObject fromOperation:operation completionBlock:completionBlock failBlock:failBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock)
            failBlock(operation,error);
    }];
}

-(void)postMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey fileName:(NSString*)fileName mimeType:(NSString*)mimeType noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;
{
    [self postMultipartDataNetworkRequestWithUrl:url params:params data:data dataParamKey:dataParamKey noSuccessError:noSuccessError constructingBodyBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:dataParamKey fileName:fileName mimeType:mimeType];
    } completionBlock:completionBlock progressBlock:progressBlock failBlock:failBlock];
}

-(void)postMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey noSuccessError:(NSError*)noSuccessError constructingBodyBlock:(void (^)(id <AFMultipartFormData>formData))constructingBodyBlock completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock
{
    if (params && [params objectForKey:dataParamKey])
    {
        NSLog(@"%s has to manually remove data from param list",__PRETTY_FUNCTION__);
        NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithDictionary:params];
        [mDict removeObjectForKey:dataParamKey];
        params = [NSDictionary dictionaryWithDictionary:mDict];
    }

    NSMutableURLRequest* uploadRequest = uploadRequest = [_network multipartFormRequestWithMethod:@"POST" path:url parameters:params constructingBodyWithBlock:constructingBodyBlock];
    
    [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc]initWithRequest:uploadRequest];

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

    [_network enqueueHTTPRequestOperation:op];
}

-(void)didFireExpiration
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)postMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock
{
    [self postMultipartDataNetworkRequestWithUrl:url params:params data:data dataParamKey:dataParamKey noSuccessError:noSuccessError constructingBodyBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:data name:dataParamKey];
    } completionBlock:completionBlock progressBlock:progressBlock failBlock:failBlock];
}

#pragma mark - Put request methods
-(void)putNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock
{
    [_network putPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self postSuccessLogicWithReponseObject:responseObject fromOperation:operation completionBlock:completionBlock failBlock:failBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock)
            failBlock(operation,error);
    }];
}

#pragma mark - Delete methods
-(void)deleteNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock
{
    [_network deletePath:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self postSuccessLogicWithReponseObject:responseObject fromOperation:operation completionBlock:completionBlock failBlock:failBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock)
            failBlock(operation,error);
    }];
}

@end
