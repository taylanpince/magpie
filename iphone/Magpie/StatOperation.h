//
//  StatOperation.h
//  Magpie
//
//  Created by Taylan Pince on 09-12-22.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@class Display;

@protocol StatOperationDelegate;

@interface StatOperation : NSOperation {
	Display *display;
	UIImage *statImage;
	NSUInteger cellIndex;
	
	id <StatOperationDelegate> delegate;
}

@property (nonatomic, readonly) Display *display;
@property (nonatomic, readonly) UIImage *statImage;
@property (nonatomic, readonly) NSUInteger cellIndex;

@property (nonatomic, assign) id <StatOperationDelegate> delegate;

- (id)initWithDisplay:(Display *)display index:(NSUInteger)cellIndex;

@end

@protocol StatOperationDelegate
- (void)statOperationComplete:(StatOperation *)op;
@end

