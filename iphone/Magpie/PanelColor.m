//
//  PanelColor.m
//  Magpie
//
//  Created by Taylan Pince on 29/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "PanelColor.h"


@implementation PanelColor

+ (UIColor *)colorWithName:(NSString *)colorName alpha:(CGFloat)alpha {
	if ([colorName isEqualToString:@"Red"]) {
		return [UIColor colorWithRed:0.86 green:0.23 blue:0.11 alpha:alpha];
	} else if ([colorName isEqualToString:@"Green"]) {
		return [UIColor colorWithRed:0.25 green:0.56 blue:0.06 alpha:alpha];
	} else if ([colorName isEqualToString:@"Blue"]) {
		return [UIColor colorWithRed:0.24 green:0.48 blue:0.65 alpha:alpha];
	} else if ([colorName isEqualToString:@"Cyan"]) {
		return [UIColor colorWithRed:0.0 green:0.75 blue:0.95 alpha:alpha];
	} else if ([colorName isEqualToString:@"Yellow"]) {
		return [UIColor colorWithRed:1.0 green:0.79 blue:0.01 alpha:alpha];
	} else if ([colorName isEqualToString:@"Purple"]) {
		return [UIColor colorWithRed:0.96 green:0.20 blue:0.25 alpha:alpha];
	} else {
		return [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:alpha];
	}
}

@end
