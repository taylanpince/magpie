//
//  MainViewController.m
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "MagpieAppDelegate.h"
#import "MainViewController.h"
#import "FlipsideViewController.h"
#import "EditDataEntryViewController.h"
#import "DataPanel.h"
#import "DataSet.h"
#import "DataItem.h"
#import "DataEntry.h"
#import "DataPanel.h"
#import "PanelView.h"
#import "HelpView.h"


@interface MainViewController (PrivateMethods)
- (void)reloadPanels;
- (void)displayLogoAndTutorial;
@end


@implementation MainViewController

@synthesize scrollView, quickEntryButton;


- (void)viewDidLoad {
	[super viewDidLoad];
	
	[scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
	
	if ([[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count] > 0) {
		[self reloadPanels];
	} else {
		[self displayLogoAndTutorial];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if ([[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count] > 0) {
		[quickEntryButton setEnabled:YES];
	} else {
		[quickEntryButton setEnabled:NO];
	}
}


- (void)reloadPanels {
	for (UIView *view in scrollView.subviews) {
		if ([view isKindOfClass:[PanelView class]]) {
			[view removeFromSuperview];
		}
	}
	
	CGPoint top = CGPointMake(0.0, 10.0);
	
	for (DataPanel *dataPanel in [(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels]) {
		PanelView *panelView = [[PanelView alloc] initWithFrame:CGRectMake(top.x, top.y, scrollView.frame.size.width, 0.0)];
		
		[dataPanel.dataSet selectRelated];

		panelView.dataPanel = dataPanel;

		[scrollView addSubview:panelView];
		
		top.y += panelView.frame.size.height + 10.0;

		[panelView release];
	}
	
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, top.y);
}


- (void)displayLogoAndTutorial {
	HelpView *helpView = [[HelpView alloc] initWithFrame:CGRectMake(0.0, 270.0, 250.0, 200.0)];
	
	[helpView setAlpha:0.0];
	[helpView setHelpText:@"Welcome to Magpie!\nYou seem to be new around here. To start setting up your data sets, tap on the gear icon below."];
	[helpView setHelpBubbleCorner:4];
	
	[self.view addSubview:helpView];
	
	[UIView beginAnimations:@"fadeInHelp" context:NULL];
	[helpView setAlpha:100.0];
	[helpView setFrame:CGRectMake(0.0, 215.0, 250.0, 200.0)];
	[UIView commitAnimations];
	
	[helpView release];
}


- (void)didCloseEditDataEntryView {
	[self dismissModalViewControllerAnimated:YES];
	[self reloadPanels];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
	[self reloadPanels];
}


- (IBAction)showSettings {
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[self presentModalViewController:navController animated:YES];
	
	[controller release];
	[navController release];
}


- (IBAction)showQuickAdd {
	EditDataEntryViewController *controller = [[EditDataEntryViewController alloc] initWithNibName:@"DataEntryView" bundle:nil];
	
	controller.delegate = self;
	controller.dataEntry = [[[DataEntry alloc] init] autorelease];
	
	for (PanelView *view in scrollView.subviews) {
		if ([view isKindOfClass:[PanelView class]] && view.frame.origin.y > scrollView.contentOffset.y && view.frame.origin.y < scrollView.contentOffset.y + scrollView.contentSize.height) {
			controller.dataItem = [view.dataPanel.dataSet.dataItems objectAtIndex:0];
			break;
		}
	}
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[self presentModalViewController:navController animated:YES];
	
	[controller release];
	[navController release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[scrollView release];
	[quickEntryButton release];
    [super dealloc];
}


@end
