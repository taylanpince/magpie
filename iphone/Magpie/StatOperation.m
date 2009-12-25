//
//  StatOperation.m
//  Magpie
//
//  Created by Taylan Pince on 09-12-22.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "StatOperation.h"
#import "Display.h"


@implementation StatOperation

@synthesize display, cellIndex, statImage, delegate;

- (id)initWithDisplay:(Display *)aDisplay index:(NSUInteger)aCellIndex {
	if (self = [super init]) {
		display = [aDisplay retain];
		cellIndex = aCellIndex;
	}
	
	return self;
}

- (void)dealloc {
	[display release];
	[statImage release];
	[super dealloc];
}

- (void)main {
	if (!self.isCancelled) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		//statImage = [[display imageForDisplay] retain];
		
		[pool drain];
		
		if (!self.isCancelled && delegate) {
			[delegate statOperationComplete:self];
		}
	}
}

@end
