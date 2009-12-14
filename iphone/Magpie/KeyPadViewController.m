//
//  KeyPadViewController.m
//  Magpie
//
//  Created by Taylan Pince on 05/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "KeyPadViewController.h"


@implementation KeyPadViewController

@synthesize delegate;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-keypad.png"]]];
}

- (IBAction)didTapKey:(id)sender {
	UIButton *button = (UIButton *)sender;
	
	[delegate didTapKeyPad:self onKey:button.tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

@end