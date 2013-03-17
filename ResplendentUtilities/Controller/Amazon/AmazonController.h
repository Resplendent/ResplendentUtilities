//
//  AmazonController.h
//  Pineapple
//
//  Created by Benjamin Maer on 3/17/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>

@interface AmazonController : NSObject <AmazonServiceRequestDelegate>
{
    AmazonS3Client* _amazonS3Client;
}

//Must be overloaded by a subclass
@property (nonatomic, readonly) NSString* bucketName;

//returns name of photo in amazon bucket
-(void)uploadImage:(UIImage*)image imageName:(NSString*)imageName;
-(NSURL*)imageURLForImageName:(NSString*)imageName;

@end
