//
//  Display.h
//  Magpie
//
//  Created by Taylan Pince on 09-10-03.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@class Category;

@interface Display : NSManagedObject {
	BOOL hasImage;
	BOOL hasQueuedOperation;
}

@property (nonatomic, retain) NSDecimalNumber *weight;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) Category *category;

@property (nonatomic, assign) BOOL hasImage;
@property (nonatomic, assign) BOOL hasQueuedOperation;

- (CGFloat)heightForDisplay;

@end