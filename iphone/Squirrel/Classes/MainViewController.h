//
//  MainViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "EditDataEntryViewController.h"


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, EditDataEntryViewControllerDelegate> {
	IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (IBAction)showSettings;
- (IBAction)showQuickAdd;

@end
