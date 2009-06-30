//
//  MainViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "SquirrelAppDelegate.h"
#import "MainViewController.h"
#import "FlipsideViewController.h"
#import "EditDataEntryViewController.h"
#import "DataPanel.h"
#import "DataSet.h"
#import "DataItem.h"
#import "DataEntry.h"
#import "PanelView.h"


@interface MainViewController (PrivateMethods)
- (void)reloadPanels;
@end


@implementation MainViewController

@synthesize scrollView;


- (void)viewDidLoad {
	[super viewDidLoad];
	
	[scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
	
	[self reloadPanels];
}


- (void)reloadPanels {
	for (UIView *view in scrollView.subviews) {
		if ([view isKindOfClass:[PanelView class]]) {
			[view removeFromSuperview];
		}
	}
	
	CGPoint top = CGPointMake(0.0, 10.0);
	
	for (DataPanel *dataPanel in [(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels]) {
		PanelView *panelView = [[PanelView alloc] initWithFrame:CGRectMake(top.x, top.y, scrollView.frame.size.width, 0.0)];
		
		[dataPanel.dataSet selectRelated];

		panelView.dataPanel = dataPanel;

		[scrollView addSubview:panelView];
		
		top.y += panelView.frame.size.height + 10.0;

		[panelView release];
	}
	
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, top.y);
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
    [super dealloc];
}


@end
