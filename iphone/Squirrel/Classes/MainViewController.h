//
//  MainViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "DataEntryViewController.h"
#import "PanelView.h"


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, PanelViewDelegate, DataEntryViewControllerDelegate> {
	IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (IBAction)showInfo;

@end
