//
//  MainViewController.h
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "EditDataEntryViewController.h"
#import "IntroViewController.h"

@class HelpView;


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, EditDataEntryViewControllerDelegate, IntroViewControllerDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIBarButtonItem *quickEntryButton;
	
	HelpView *helpView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *quickEntryButton;

@property (nonatomic, retain) HelpView *helpView;

- (IBAction)showSettings;
- (IBAction)showQuickAdd;
- (IBAction)showIntro;

@end
