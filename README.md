ResplendentUtilities
====================

### A block of Objective-C code, uncompiled, in source form that accomplish various tasks in various roles. 

### Categories

### NSDate+Utility

122 seconds returns 2m, and so forth up to days.

	[_timeLabel setText:_idea.createdAt.daysOrHoursOrMinutesOrSecondsString];
	
### NSManagedObject+Utility

Convenience method that automatically diff's with the receiver to prevent unruly dirty flags in Core Data.
You can then easily enumerate JSON objects, setting each property on each Core Data object to it's value on the server, call save, and know your NSFetchedResultController's delegate will only get a single callback with the change.

	NSManagedObject* i = [NSEntityDescription insertNewObjectForEntityName:@"myEnt" inManagedObjectContent:m];
	[i updateValue:[mediaDic objectForKey:@"type"] propertyName:@"mediaType"];

### UIButton+Utility

C function which sets a UIButton's frame to it's normal, selected, or highlighted image size at given coordinates.

	setButtonSizeToImageAndCoordinates(_friendsButton, _photosButton.frame.origin.x, 0);

Best when called in -layoutSubviews to keep a UIButton matching the size of an image which might've changed the last time through the draw pipeline.

	+(UIButton*)buttonCrossWithFrame:(CGRect)buttonFrame crossColor:(UIColor*)crossColor crossSize:(CGSize)crossSize

Creates an X button which is truly a clickable X rather than a rectangular frame containing a drawn X. Think different.

### UIImage+Resizing

C function which resizes an UIImage to a target size, whilst keeping the aspect ratio the same. Note, this can leave undrawn, or transparent space. Helpful for reducing photos passed by UIImagePickerController.

	UIImage* resizedImagePreservingAspectRatio(UIImage* sourceImage, CGSize targetSize)
	
### UIView + CoreGraphics