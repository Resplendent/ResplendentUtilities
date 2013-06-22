//
//  ECHTTPClientAPIController.h
//  Everycam
//
//  Created by Benjamin Maer on 10/3/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

#define kNSErrorMake(_text,_code) [NSError errorWithDomain:_text code:_code userInfo:nil]

//BOOL kHTTPClientJSONAPIControllerResponseDictionaryHasValidSuccessValue(NSDictionary* responseDict);

@interface HTTPClientJSONAPIController : NSObject

@property (nonatomic, strong) AFHTTPClient* network;

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method;
- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method respectingCancellableRequests:(BOOL)respectingCancellableRequests;
//Can be overloaded by subclass
-(BOOL)operationCanBeCancelled:(AFHTTPRequestOperation*)operation;

-(void)didFireExpiration;

-(id)initWithBaseUrl:(NSString*)baseUrl;

//Delete
-(void)deleteNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;

//Post
-(void)postNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;

//Post multi part with data
-(void)postMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey fileName:(NSString*)fileName mimeType:(NSString*)mimeType noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;
-(void)postMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;
-(void)postMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey noSuccessError:(NSError*)noSuccessError constructingBodyBlock:(void (^)(id <AFMultipartFormData>formData))constructingBodyBlock completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;

//Get
-(void)getNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError *)noSuccessError completionBlock:(void (^)(NSDictionary* responseDict))completionBlock failBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failBlock;

//Put
-(void)putNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;

//Post Success Logic
-(NSError*)errorForResponseJsonParseObject:(id)responseJSONParsedObject fromOperation:(AFHTTPRequestOperation*)operation;
-(void)postSuccessLogicWithReponseObject:(id)responseObject fromOperation:(AFHTTPRequestOperation*)operation completionBlock:(void(^)(id responseObject))completionBlock failBlock:(void(^)(AFHTTPRequestOperation* operation, NSError* error))failBlock;

@end
