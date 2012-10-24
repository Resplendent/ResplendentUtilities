ResplendentUtilities
====================

### A block of Objective-C code, uncompiled, in source form that accomplish various tasks in various roles. 

### Categories

### NSDate+Utility

122 Seconds returns 2m, and so forth up to days.

	[_timeLabel setText:_idea.createdAt.daysOrHoursOrMinutesOrSecondsString];
	
### NSManagedObject+Utility

Convenience method that automatically diff's with the receiver to prevent unruly dirty flags in Core Data.
You can then easily enumerate JSON objects, setting each property on each Core Data object to it's value on the server, call save, and know your NSFetchedResultController's delegate will only get a single callback with the change.

	NSManagedObject* i = [NSEntityDescription insertNewObjectForEntityName:@"myEnt" inManagedObjectContent:m];
	[i updateValue:[mediaDic objectForKey:@"type"] propertyName:@"mediaType"];

### UIButton+Utility

