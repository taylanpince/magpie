//
//  LayerDelegate.m
//  Squirrel
//
//  Created by Taylan Pince on 06/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LayerDelegate.h"
#import "PanelColor.h"


@implementation LayerDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
	CGContextSetLineWidth(ctx, 1.0f);
	
    CGFloat centerX = layer.frame.size.width / 2;
    CGFloat centerY = layer.frame.size.height / 2;
    CGFloat radius = 98.0;
	CGFloat startAngle = ((360.0 * [[layer valueForKey:@"totalPercentage"] floatValue] / 100.0) - 5.0) * (M_PI / 180.0);
	CGFloat endAngle = startAngle + ((360.0 * [[layer valueForKey:@"percentage"] floatValue] / 100.0) * (M_PI / 180.0));

	CGContextSetFillColorWithColor(ctx, [[PanelColor colorWithName:[layer valueForKey:@"color"] alpha:1.0 - (0.2 * [[layer valueForKey:@"tag"] floatValue])] CGColor]);
	CGContextMoveToPoint(ctx, centerX, centerY);
    CGContextAddArc(ctx, centerX, centerY, radius, startAngle, endAngle, 0);
	CGContextClosePath(ctx);
    CGContextFillPath(ctx);
	
	CGContextMoveToPoint(ctx, centerX, centerY);
    CGContextAddArc(ctx, centerX, centerY, radius, startAngle, endAngle, 0);
	CGContextStrokePath(ctx);
	
	CGContextMoveToPoint(ctx, centerX, centerY);
	CGContextAddLineToPoint(ctx, centerX + (radius * cos(endAngle)), centerY + (radius * sin(endAngle)));
	CGContextStrokePath(ctx);
}

@end
