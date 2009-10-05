//
//  IntroViewController.h
//  Magpie
//
//  Created by Taylan Pince on 09-10-05.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "IntroView.h"

@protocol IntroViewControllerDelegate;

@interface IntroViewController : UIViewController <UIScrollViewDelegate, IntroViewDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	
	BOOL pageControlUsed;
	
	id <IntroViewControllerDelegate> delegate;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, assign) id <IntroViewControllerDelegate> delegate;

- (IBAction)changePage:(id)sender;

@end

@protocol IntroViewControllerDelegate
- (void)didCloseIntroView;
@end
