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

- (id)initWithDisplay:(Display *)display index:(NSUInteger)cellIndex {
	if (self = [super init]) {
		self.display = [display retain];
		self.cellIndex = cellIndex;
	}
	
	return self;
}

- (void)dealloc {
	[display release];
	[statImage release];
	[super dealloc];
}

- (void)main {
	if (!self.cancelled) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		statImage = [[display imageForDisplay] retain];
		
		[pool drain];
		
		if (!self.cancelled && delegate) {
			[delegate statOperationComplete:self];
		}
	}
}

@end
