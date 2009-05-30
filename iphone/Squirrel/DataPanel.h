//
//  DataPanel.h
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DataSet;

@interface DataPanel :  NSManagedObject {
	
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) DataSet * data_set;

@end



