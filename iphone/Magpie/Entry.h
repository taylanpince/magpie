//
//  Entry.h
//  Magpie
//
//  Created by Taylan Pince on 09-10-03.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@class Item;

@interface Entry : NSManagedObject {
	
}

@property (nonatomic, retain) NSNumber *value;
@property (nonatomic, retain) NSDate *timeStamp;
@property (nonatomic, retain) Item *item;

@end