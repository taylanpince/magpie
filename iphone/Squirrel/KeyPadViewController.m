//
//  KeyPadViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 05/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "KeyPadViewController.h"


@implementation KeyPadViewController

@synthesize delegate;


- (void)loadView {
	[super loadView];
}


- (IBAction)didTapKey:(id)sender {
	UIButton *button = (UIButton *)sender;
	
	[delegate didTapKeyPad:self onKey:button.currentTitle];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [super dealloc];
}


@end
