//
//  LayerDelegate.h
//  Squirrel
//
//  Created by Taylan Pince on 06/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//


@interface LayerDelegate : NSObject {
	
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;

@end
