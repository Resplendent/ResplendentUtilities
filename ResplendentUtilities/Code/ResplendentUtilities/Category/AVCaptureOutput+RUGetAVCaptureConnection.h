//
//  AVCaptureOutput+RUGetAVCaptureConnection.h
//  Camerama
//
//  Created by Benjamin Maer on 11/20/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>





@interface AVCaptureOutput (RUGetAVCaptureConnection)

-(AVCaptureConnection*)ru_getAVCaptureConnectionWithPortMediaType:(NSString*)portMediaType;

@end
