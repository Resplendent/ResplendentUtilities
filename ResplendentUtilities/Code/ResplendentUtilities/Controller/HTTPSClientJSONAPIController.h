//
//  HTTPSClientJSONAPIController.h
//  Albumatic
//
//  Created by Sheldon Thomas on 2/5/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "HTTPClientJSONAPIController.h"

@interface HTTPSClientJSONAPIController : HTTPClientJSONAPIController

//Post
-(void)postSecureNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;

//Post multi part with data
-(void)postSecureMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey fileName:(NSString*)fileName mimeType:(NSString*)mimeType noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;
-(void)postSecureMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;
-(void)postSecureMultipartDataNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params data:(NSData*)data dataParamKey:(NSString*)dataParamKey noSuccessError:(NSError*)noSuccessError constructingBodyBlock:(void (^)(id <AFMultipartFormData>formData))constructingBodyBlock completionBlock:(void(^)(NSDictionary* responseDict))completionBlock progressBlock:(void(^)(float progress))progressBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;

-(void)putSecureNetworkRequestWithUrl:(NSString*)url params:(NSDictionary*)params noSuccessError:(NSError*)noSuccessError completionBlock:(void(^)(NSDictionary* responseDict))completionBlock failBlock:(void(^)(AFHTTPRequestOperation *operation, NSError* error))failBlock;

@property(nonatomic, retain)AFHTTPClient* secureNetwork;

@end
