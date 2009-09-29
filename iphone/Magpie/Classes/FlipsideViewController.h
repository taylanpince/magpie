//
//  FlipsideViewController.h
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

@protocol FlipsideViewControllerDelegate;
@class HelpView;


@interface FlipsideViewController : UITableViewController {
	id <FlipsideViewControllerDelegate> delegate;
	HelpView *helpView;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) HelpView *helpView;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
