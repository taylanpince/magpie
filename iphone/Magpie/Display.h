//
//  Display.h
//  Magpie
//
//  Created by Taylan Pince on 09-10-03.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@class Category;

@interface Display : NSManagedObject {
	
}

@property (nonatomic, retain) NSDecimalNumber *weight;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) Category *category;

- (CGFloat)heightForDisplay;
- (UIImage *)imageForDisplay;

@end