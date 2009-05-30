//
//  DataEntry.h
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DataItem;

@interface DataEntry :  NSManagedObject {
	
}

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) DataItem * data_item;

@end



