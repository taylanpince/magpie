//
//  DataSet.h
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DataPanel;
@class DataItem;

@interface DataSet :  NSManagedObject {
	
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* data_panels;
@property (nonatomic, retain) NSSet* data_items;

@end


@interface DataSet (CoreDataGeneratedAccessors)

- (void)addData_panelsObject:(DataPanel *)value;
- (void)removeData_panelsObject:(DataPanel *)value;
- (void)addData_panels:(NSSet *)value;
- (void)removeData_panels:(NSSet *)value;

- (void)addData_itemsObject:(DataItem *)value;
- (void)removeData_itemsObject:(DataItem *)value;
- (void)addData_items:(NSSet *)value;
- (void)removeData_items:(NSSet *)value;

@end

