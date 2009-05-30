//
//  DataItem.h
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DataSet;
@class DataEntry;

@interface DataItem :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) DataSet * data_set;
@property (nonatomic, retain) NSSet* data_entries;

@end


@interface DataItem (CoreDataGeneratedAccessors)
- (void)addData_entriesObject:(DataEntry *)value;
- (void)removeData_entriesObject:(DataEntry *)value;
- (void)addData_entries:(NSSet *)value;
- (void)removeData_entries:(NSSet *)value;

@end

