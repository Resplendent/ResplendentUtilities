//
//  AVCaptureOutput+RUGetAVCaptureConnection.m
//  Camerama
//
//  Created by Benjamin Maer on 11/20/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import "AVCaptureOutput+RUGetAVCaptureConnection.h"





@implementation AVCaptureOutput (RUGetAVCaptureConnection)

-(AVCaptureConnection*)ru_getAVCaptureConnectionWithPortMediaType:(NSString *)portMediaType
{
	for (AVCaptureConnection *connection in self.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:portMediaType])
			{
				return connection;
			}
		}
	}

	return nil;
}

@end
