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
#import "DataEntryViewController.h"
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
	[self reloadPanels];
}


- (void)reloadPanels {
	CGPoint top = CGPointMake(10.0, 10.0);
	
	for (DataPanel *dataPanel in [(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels]) {
		PanelView *panelView = [[PanelView alloc] initWithFrame:CGRectMake(top.x, top.y, scrollView.frame.size.width - 20.0, 0.0)];
		
		[dataPanel.dataSet selectRelated];

		panelView.dataPanel = dataPanel;
		panelView.delegate = self;

		[scrollView addSubview:panelView];
		
		top.y += panelView.frame.size.height + 10.0;

		[panelView release];
	}
	
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, top.y);
}


- (void)didBeginAddingNewDataEntryForView:(PanelView *)panelView forDataItem:(DataItem *)dataItem {
	DataEntryViewController *controller = [[DataEntryViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	controller.delegate = self;
	controller.dataItem = dataItem;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[self presentModalViewController:navController animated:YES];
	
	[controller release];
	[navController release];
}


- (void)didCloseDataEntryView {
	[self dismissModalViewControllerAnimated:YES];
	[self reloadPanels];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
	[self reloadPanels];
}


- (IBAction)showInfo {
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithStyle:UITableViewStyleGrouped];
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
