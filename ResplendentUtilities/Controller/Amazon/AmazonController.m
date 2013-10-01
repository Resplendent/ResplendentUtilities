//
//  AmazonController.m
//  Pineapple
//
//  Created by Benjamin Maer on 3/17/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "AmazonController.h"
#import "RUConstants.h"

static const char* ImageToDataQueueName = "AmazonController.ImageToDataQueue";

static dispatch_queue_t ImageToDataQueue;

@implementation AmazonController

+(void)initialize
{
    if (self == [AmazonController class])
    {
        ImageToDataQueue = dispatch_queue_create(ImageToDataQueueName, 0);
    }
}

//-(id)initWithAccessKey:(NSString*)accessKey secretKey:(NSString*)secretKey bucketName:(NSString*)bucketName
//{
//    _amazonS3Client = [[AmazonS3Client alloc] initWithAccessKey:accessKey withSecretKey:secretKey];
//    [_amazonS3Client createBucket:[[S3CreateBucketRequest alloc] initWithName:bucketName]];
//    return (self = [super init]);
//}

-(id)init
{
    if (self = [super init])
    {
        _amazonS3Client = [[AmazonS3Client alloc] initWithAccessKey:self.accessKey withSecretKey:self.secretKey];
        [_amazonS3Client createBucket:[[S3CreateBucketRequest alloc] initWithName:self.bucketName]];
    }

    return self;
}

-(void)uploadImage:(UIImage*)image imageName:(NSString*)imageName
{
    dispatch_async(ImageToDataQueue, ^{
        __block S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imageName inBucket:self.bucketName];
        por.contentType = @"image/jpeg";
        por.data = UIImagePNGRepresentation(image);
        [por setDelegate:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_amazonS3Client putObject:por];
        });
    });
}

-(NSURL*)imageURLForImageName:(NSString*)imageName
{
    S3GetPreSignedURLRequest *gpsur = [S3GetPreSignedURLRequest new];
    gpsur.key     = imageName;
    gpsur.bucket  = self.bucketName;
    gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.

    S3ResponseHeaderOverrides *override = [S3ResponseHeaderOverrides new];
    override.contentType = @"image/jpeg";
    gpsur.responseHeaderOverrides = override;

    NSURL* url = [_amazonS3Client getPreSignedURL:gpsur];
    return url;
}

#pragma mark - Getter method
-(NSString *)accessKey
{
    @throw RU_MUST_OVERRIDE;
}

-(NSString *)secretKey
{
    @throw RU_MUST_OVERRIDE;
}

-(NSString *)bucketName
{
    @throw RU_MUST_OVERRIDE;
}

#pragma mark - AmazonServiceRequestDelegate methods
-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    RUDLog(@"finished uploading image with response %@ body %@",response,response.body);
}

@end
