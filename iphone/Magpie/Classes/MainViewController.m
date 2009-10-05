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
#import "IntroViewController.h"

#import "DataPanel.h"
#import "DataSet.h"
#import "DataItem.h"
#import "DataEntry.h"
#import "DataPanel.h"

#import "PanelView.h"
#import "HelpView.h"


@interface MainViewController (PrivateMethods)
- (void)reloadPanels;
- (void)hideTutorial;
- (void)displayTutorial:(NSUInteger)step;
@end


@implementation MainViewController

@synthesize scrollView, quickEntryButton, helpView;


- (void)viewDidLoad {
	[super viewDidLoad];
	
	[scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]]];
	
	if ([[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count] > 0) {
		[self reloadPanels];
	}
	
	helpView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if ([[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count] > 0) {
		[quickEntryButton setEnabled:YES];
	} else {
		[quickEntryButton setEnabled:NO];
	}
	
	if (helpView != nil) {
		[helpView removeFromSuperview];
		[helpView release];
		
		helpView = nil;
	}
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *dataPanels = [(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels];
	
	if ([dataPanels count] == 0) {
		[self displayTutorial:1];
	} else if ([dataPanels count] == 1 && [[[dataPanels objectAtIndex:0] dataSet] total] == 0.0) {
		[self displayTutorial:2];
	} else if ([defaults boolForKey:@"tutorialCompleted"] == NO) {
		[defaults setBool:YES forKey:@"tutorialCompleted"];
		[self displayTutorial:3];
	}
	
	if ([dataPanels count] > 0) {
		[scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
	} else {
		[scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-logo.png"]]];
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


- (void)hideTutorial {
	[UIView beginAnimations:@"fadeOutHelp" context:NULL];
	[helpView setAlpha:0.0];
	[UIView commitAnimations];
}


- (void)displayTutorial:(NSUInteger)step {
	switch (step) {
		case 1:
			helpView = [[HelpView alloc] initWithFrame:CGRectMake(0.0, 335.0, 250.0, 120.0)];
			
			[helpView setAlpha:0.0];
			[helpView setHelpText:@"Welcome to Magpie!\nYou don't seem to have any Displays setup yet. Tap on the gear icon below to start."];
			[helpView setHelpBubbleCorner:4];
			
			[self.view addSubview:helpView];
			
			[UIView beginAnimations:@"fadeInHelp" context:NULL];
			[helpView setAlpha:1.0];
			[helpView setFrame:CGRectMake(0.0, 295.0, 250.0, 120.0)];
			[UIView commitAnimations];
			break;
		case 2:
			helpView = [[HelpView alloc] initWithFrame:CGRectMake(112.0, 325.0, 220.0, 130.0)];
			
			[helpView setAlpha:0.0];
			[helpView setHelpText:@"Your Display is here, but there are no Entries yet.\nTap on the plus sign to launch the Quick Entry panel and add an Entry."];
			[helpView setHelpBubbleCorner:3];
			
			[self.view addSubview:helpView];
			
			[UIView beginAnimations:@"fadeInHelp" context:NULL];
			[helpView setAlpha:1.0];
			[helpView setFrame:CGRectMake(112.0, 285.0, 220.0, 130.0)];
			[UIView commitAnimations];
			break;
		case 3:
			helpView = [[HelpView alloc] initWithFrame:CGRectMake(0.0, 325.0, 250.0, 130.0)];
			
			[helpView setAlpha:0.0];
			[helpView setHelpText:@"Congratulations, you created your first Display and Entry!\nYou can also add, delete and modify Entries for an Item under its Category's settings panel."];
			[helpView setHelpBubbleCorner:4];
			
			[self.view addSubview:helpView];
			
			[UIView beginAnimations:@"fadeInHelp" context:NULL];
			[helpView setAlpha:1.0];
			[helpView setFrame:CGRectMake(0.0, 285.0, 250.0, 130.0)];
			[UIView commitAnimations];
			
			[NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(hideTutorial) userInfo:nil repeats:NO];
			break;
		default:
			break;
	}
}


- (void)didCloseEditDataEntryView {
	[self dismissModalViewControllerAnimated:YES];
	[self reloadPanels];
}


- (void)didCloseIntroView {
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
			[controller setDataItem:[view.dataPanel.dataSet.dataItems objectAtIndex:0]];
			break;
		}
	}
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[self presentModalViewController:navController animated:YES];
	
	[controller release];
	[navController release];
}


- (IBAction)showIntro {
	IntroViewController *controller = [[IntroViewController alloc] initWithNibName:@"IntroView" bundle:nil];
	
	[controller setDelegate:self];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[navController setNavigationBarHidden:YES];
	
	[self presentModalViewController:navController animated:YES];
	
	[controller release];
	[navController release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	if (helpView != nil) {
		[helpView release];
	}
	
	[scrollView release];
	[quickEntryButton release];
    [super dealloc];
}


@end
