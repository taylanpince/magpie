//
//  PanelView.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PanelView.h"
#import "DataPanel.h"
#import "DataItem.h"
#import "DataSet.h"
#import "DataEntry.h"
#import "LayerDelegate.h"


@implementation PanelView

@synthesize dataPanel, delegate, rendered;


#define SMALL_FONT_SIZE 12
#define MAIN_FONT_SIZE 18

static UIFont *smallFont = nil;
static UIFont *smallBoldFont = nil;
static UIFont *mainFont = nil;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		smallFont = [[UIFont systemFontOfSize:SMALL_FONT_SIZE] retain];
		smallBoldFont = [[UIFont boldSystemFontOfSize:SMALL_FONT_SIZE] retain];
        mainFont = [[UIFont boldSystemFontOfSize:MAIN_FONT_SIZE] retain];
		
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)setDataPanel:(DataPanel *)aDataPanel {
	if (dataPanel != aDataPanel) {
		dataPanel = aDataPanel;
		
		[self layoutSubviews];
	}
}


- (void)layoutSubviews {
	if (rendered) return;

	CGPoint point = CGPointMake(20.0, 5.0);
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, self.frame.size.width - 40.0, 14.0)];
	
	titleLabel.text = dataPanel.name;
	titleLabel.font = smallBoldFont;
	titleLabel.textAlignment = UITextAlignmentRight;
	titleLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:titleLabel];
	
	point.y += titleLabel.frame.size.height;
	
	[titleLabel release];
	
	UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, self.frame.size.width - 40.0, 20.0)];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	dateLabel.text = [dateFormatter stringFromDate:dataPanel.dataSet.lastUpdated];
	dateLabel.font = smallFont;
	dateLabel.textAlignment = UITextAlignmentRight;
	dateLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:dateLabel];
	
	point.y += dateLabel.frame.size.height + 10.0;
	
	[dateLabel release];
	
	int counter = 0;
	
	if ([dataPanel.type isEqualToString:@"Bar Chart"]) {
		for (DataItem *dataItem in dataPanel.dataSet.dataItems) {
			CGSize titleSize = [dataItem.name sizeWithFont:mainFont];
			UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
			
			[titleButton setTitle:dataItem.name forState:UIControlStateNormal];
			[titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
			[titleButton addTarget:self action:@selector(didTouchAddButton:) forControlEvents:UIControlEventTouchUpInside];
			
			titleButton.frame = CGRectMake(point.x, point.y, titleSize.width, titleSize.height);
			titleButton.font = mainFont;
			titleButton.tag = counter;
			
			[self addSubview:titleButton];
			
			UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
			
			[editButton setImage:[UIImage imageNamed:@"cog.png"] forState:UIControlStateNormal];
			[editButton addTarget:self action:@selector(didTouchAddButton:) forControlEvents:UIControlEventTouchUpInside];
			
			editButton.frame = CGRectMake(point.x + titleSize.width + 6.0, point.y + 3.0, 16.0, 16.0);
			editButton.tag = counter;
			
			[self addSubview:editButton];
			
			point.y += titleButton.frame.size.height + 6.0;
			
			CALayer *barLayer = [CALayer layer];
			
			barLayer.anchorPoint = CGPointMake(0.0, 0.0);
			barLayer.frame = CGRectMake(point.x, point.y, 0.0, 20.0);
			barLayer.backgroundColor = [[UIColor blackColor] CGColor];
			
			CALayer *barBGLayer = [CALayer layer];
			
			barBGLayer.frame = CGRectMake(point.x, point.y, self.frame.size.width - 40.0, 20.0);
			barBGLayer.backgroundColor = [[UIColor darkGrayColor] CGColor];
			
			[self.layer addSublayer:barBGLayer];
			[self.layer addSublayer:barLayer];
			
			CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];

			resizeAnimation.duration = 1.0;
			resizeAnimation.beginTime = CACurrentMediaTime() + (counter / 10.0);
			resizeAnimation.removedOnCompletion = NO;
			resizeAnimation.fillMode = kCAFillModeForwards;
			resizeAnimation.toValue = [NSNumber numberWithDouble:((self.frame.size.width - 40.0) * dataItem.percentage / 100.0)];
			resizeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

			[barLayer addAnimation:resizeAnimation forKey:@"animateWidth"];
			
			point.y += barLayer.bounds.size.height + 6.0;
			
			counter++;
		}
	} else if ([dataPanel.type isEqualToString:@"Pie Chart"]) {
		double totalPercentage = 0.0;
		CGFloat circleTop = point.y;
		
		LayerDelegate *layerDelegate = [[LayerDelegate alloc] init];
		
		point.y += 210.0;
		
		for (DataItem *dataItem in dataPanel.dataSet.dataItems) {
			CALayer *circleLayer = [CALayer layer];
			
			circleLayer.frame = CGRectMake(point.x, circleTop, self.frame.size.width - 40.0, 200.0);
			circleLayer.opacity = 0.0;

			[self.layer addSublayer:circleLayer];
			[circleLayer setValue:[NSNumber numberWithInt:counter] forKey:@"tag"];
			[circleLayer setValue:[NSNumber numberWithDouble:totalPercentage] forKey:@"totalPercentage"];
			[circleLayer setValue:[NSNumber numberWithDouble:dataItem.percentage] forKey:@"percentage"];
			[circleLayer setDelegate:layerDelegate];
			[circleLayer setNeedsDisplay];
			
			CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			
			fadeAnimation.duration = 1.0;
			fadeAnimation.beginTime = CACurrentMediaTime() + (counter / 10.0);
			fadeAnimation.removedOnCompletion = NO;
			fadeAnimation.fillMode = kCAFillModeForwards;
			fadeAnimation.toValue = [NSNumber numberWithDouble:1.0];
			fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
			
			[circleLayer addAnimation:fadeAnimation forKey:@"animateFade"];

			CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
			
			scaleAnimation.duration = 0.5;
			scaleAnimation.beginTime = CACurrentMediaTime() + (counter / 10.0);
			scaleAnimation.removedOnCompletion = NO;
			scaleAnimation.fillMode = kCAFillModeForwards;
			scaleAnimation.fromValue = [NSNumber numberWithDouble:1.5];
			scaleAnimation.toValue = [NSNumber numberWithDouble:1.0];
			scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
			
			[circleLayer addAnimation:scaleAnimation forKey:@"animateScale"];
			
			totalPercentage += dataItem.percentage;
			
			CGSize titleSize = [dataItem.name sizeWithFont:mainFont];
			
			CALayer *boxLayer = [CALayer layer];
			
			boxLayer.frame = CGRectMake(point.x, point.y, titleSize.height, titleSize.height);
			boxLayer.backgroundColor = [[UIColor colorWithWhite:(0.1 * counter) alpha:1.0] CGColor];
			
			[self.layer addSublayer:boxLayer];
			
			UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
			
			[titleButton setTitle:dataItem.name forState:UIControlStateNormal];
			[titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
			[titleButton addTarget:self action:@selector(didTouchAddButton:) forControlEvents:UIControlEventTouchUpInside];
			
			titleButton.frame = CGRectMake(point.x + titleSize.height + 6.0, point.y, titleSize.width, titleSize.height);
			titleButton.font = mainFont;
			titleButton.tag = counter;
			
			[self addSubview:titleButton];
			
			UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
			
			[editButton setImage:[UIImage imageNamed:@"cog.png"] forState:UIControlStateNormal];
			[editButton addTarget:self action:@selector(didTouchAddButton:) forControlEvents:UIControlEventTouchUpInside];
			
			editButton.frame = CGRectMake(point.x + titleSize.width + titleSize.height + 12.0, point.y + 3.0, 16.0, 16.0);
			editButton.tag = counter;
			
			[self addSubview:editButton];
			
			point.y += titleButton.frame.size.height + 6.0;
			
			counter++;
		}
	} else if ([dataPanel.type isEqualToString:@"Latest Entry as Words"]) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		
		[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
		
		NSNumber *numberValue = [[[dataPanel.dataSet latestDataItem] latestDataEntry] value];
		CGSize valueSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] sizeWithFont:mainFont constrainedToSize:CGSizeMake(self.frame.size.width - 40.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, valueSize.width, valueSize.height)];

		valueLabel.lineBreakMode = UILineBreakModeWordWrap;
		valueLabel.numberOfLines = 0;
		valueLabel.text = [[numberFormatter stringFromNumber:numberValue] uppercaseString];
		valueLabel.font = mainFont;
		valueLabel.backgroundColor = [UIColor clearColor];
		
		[self addSubview:valueLabel];

		point.y += valueLabel.frame.size.height + 6.0;

		[valueLabel release];
		[numberFormatter release];
	} else if ([dataPanel.type isEqualToString:@"Latest Entry as Numbers"]) {
		NSNumber *numberValue = [[[dataPanel.dataSet latestDataItem] latestDataEntry] value];
		CGSize valueSize = [[numberValue stringValue] sizeWithFont:mainFont constrainedToSize:CGSizeMake(self.frame.size.width - 40.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, valueSize.width, valueSize.height)];
		
		valueLabel.lineBreakMode = UILineBreakModeWordWrap;
		valueLabel.numberOfLines = 0;
		valueLabel.text = [numberValue stringValue];
		valueLabel.font = mainFont;
		valueLabel.backgroundColor = [UIColor clearColor];
		
		[self addSubview:valueLabel];
		
		point.y += valueLabel.frame.size.height + 6.0;
		
		[valueLabel release];
	} else if ([dataPanel.type isEqualToString:@"Latest Entry Type"]) {
		NSString *entryName = [[dataPanel.dataSet latestDataItem] name];
		CGSize valueSize = [[entryName uppercaseString] sizeWithFont:mainFont constrainedToSize:CGSizeMake(self.frame.size.width - 40.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, valueSize.width, valueSize.height)];
		
		valueLabel.lineBreakMode = UILineBreakModeWordWrap;
		valueLabel.numberOfLines = 0;
		valueLabel.text = [entryName uppercaseString];
		valueLabel.font = mainFont;
		valueLabel.backgroundColor = [UIColor clearColor];
		
		[self addSubview:valueLabel];
		
		point.y += valueLabel.frame.size.height + 6.0;
		
		[valueLabel release];
	}
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, point.y + 18.0);
	
	rendered = YES;
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	rect.size.width -= 20.0;
	rect.size.height -= 14.0;
	rect.origin.x += 10.0;
	
	CGContextSaveGState(context);
	CGContextSetShadow(context, CGSizeMake(2.0, -8.0), 4.0);
	CGContextSetRGBFillColor(context, 0.88, 0.88, 0.88, 1.0);
	
	int corner_radius = 10;
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x + corner_radius, rect.origin.y, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - corner_radius, rect.origin.y);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + corner_radius, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - corner_radius);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, rect.origin.x + rect.size.width - corner_radius, rect.origin.y + rect.size.height, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + corner_radius, rect.origin.y + rect.size.height);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x, rect.origin.y + rect.size.height - corner_radius, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextClosePath(context);
	
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	
	int header_height = 40;

	CGContextBeginPath(context);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x + corner_radius, rect.origin.y, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - corner_radius, rect.origin.y);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + corner_radius, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + header_height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + header_height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextClosePath(context);

	CGContextClip(context);
	
	size_t num_locations = 4;
	CGFloat locations[4] = {
		0.0,
		0.025,
		0.975,
		1.0
	};

	CGFloat components[16] = {
		1.0, 1.0, 1.0, 1.0,
		0.65, 0.65, 0.65, 1.0,
		0.5, 0.5, 0.5, 1.0,
		0.4, 0.4, 0.4, 1.0
	};
	
	CGGradientRef gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), components, locations, num_locations);
	
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(0.0, header_height), 0);
	
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);

	CGContextBeginPath(context);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x + corner_radius, rect.origin.y, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - corner_radius, rect.origin.y);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + corner_radius, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - corner_radius);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, rect.origin.x + rect.size.width - corner_radius, rect.origin.y + rect.size.height, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + corner_radius, rect.origin.y + rect.size.height);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x, rect.origin.y + rect.size.height - corner_radius, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextClosePath(context);
	
	CGContextClip(context);

	size_t bottom_locations_num = 2;
	CGFloat bottom_locations[2] = {
		0.0,
		1.0
	};
	
	CGFloat bottom_components[16] = {
		0.88, 0.88, 0.88, 1.0,
		0.6, 0.6, 0.6, 1.0
	};
	
	CGGradientRef bottom_gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), bottom_components, bottom_locations, bottom_locations_num);
	
	CGContextDrawLinearGradient(context, bottom_gradient, CGPointMake(0.0, rect.size.height - 6.0), CGPointMake(0.0, rect.size.height), 0);
	
	CGGradientRelease(bottom_gradient);
}


- (void)didTouchAddButton:(id)sender {
	UIButton *addButton = (UIButton *)sender;
	DataItem *dataItem = [dataPanel.dataSet.dataItems objectAtIndex:addButton.tag];
	
	[delegate didBeginAddingNewDataEntryForView:self forDataItem:dataItem];
}


- (void)dealloc {
    [super dealloc];
}


@end
