//
//  MainViewController.h
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "EditDataEntryViewController.h"


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, EditDataEntryViewControllerDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIBarButtonItem *quickEntryButton;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *quickEntryButton;

- (IBAction)showSettings;
- (IBAction)showQuickAdd;

@end
