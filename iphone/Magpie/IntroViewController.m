//
//  IntroViewController.m
//  Magpie
//
//  Created by Taylan Pince on 09-10-05.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroView.h"


@implementation IntroViewController

@synthesize scrollView, pageControl, delegate;

- (void)viewDidLoad {
	[scrollView setBackgroundColor:[UIColor whiteColor]];
	[scrollView setPagingEnabled:YES];
	[scrollView setShowsVerticalScrollIndicator:NO];
	[scrollView setShowsHorizontalScrollIndicator:NO];
	[scrollView setScrollsToTop:NO];
	[scrollView setDelegate:self];
	[scrollView setContentSize:CGSizeMake(320 * 3, 440)];
	
	for (NSUInteger i = 0; i < 3; i++) {
		IntroView *introView = [[IntroView alloc] initWithFrame:CGRectMake(320.0 * i, 0.0, 320.0, 440.0)];
		
		[introView setType:i];
		[introView setDelegate:self];
		
		[scrollView addSubview:introView];
		
		[introView release];
	}
}


- (IBAction)changePage:(id)sender {
	int page = pageControl.currentPage;
	
	CGRect frame = scrollView.frame;

    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
	[scrollView scrollRectToVisible:frame animated:YES];
	
	pageControlUsed = YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (pageControlUsed) return;
	
	CGFloat pageWidth = scrollView.frame.size.width;

    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

	[pageControl setCurrentPage:page];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    pageControlUsed = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)didTapIntroView:(IntroView *)introView {
	[delegate didCloseIntroView];
}


- (void)viewDidUnload {
	
}


- (void)dealloc {
	[scrollView release];
	[pageControl release];
    [super dealloc];
}

@end
