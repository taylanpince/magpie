//
//  IntroView.m
//  Magpie
//
//  Created by Taylan Pince on 09-10-05.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "IntroView.h"


@implementation IntroView

@synthesize delegate;

- (id)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        [self setUserInteractionEnabled:YES];
    }

    return self;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[delegate didTapIntroView:self];
}


- (void)dealloc {
    [super dealloc];
}

@end
