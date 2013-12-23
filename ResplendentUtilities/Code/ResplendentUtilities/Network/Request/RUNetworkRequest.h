//
//  RURequest.h
//  Pineapple
//
//  Created by Benjamin Maer on 4/14/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUNetworkRequest : NSObject <NSURLConnectionDataDelegate>
{
    NSURLConnection* _connection;
    NSMutableData* _data;
}

@property (nonatomic, readonly) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, readonly) NSTimeInterval timeoutInterval;

-(void)fetchWithUrl:(NSURL*)url;
-(void)fetchWithUrlRequest:(NSURLRequest*)urlRequest;
-(void)cancel;

//For subclasses
-(void)didFinishRequestWithResponseString:(NSString*)responseString;
-(void)didFailRequestWithError:(NSError*)error;

@end
