//
//  IntroViewController.m
//  Magpie
//
//  Created by Taylan Pince on 09-10-05.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroView.h"
#import "AboutView.h"


@implementation IntroViewController

@synthesize scrollView, pageControl, showIntro, delegate;

- (void)viewDidLoad {
	[scrollView setBackgroundColor:[UIColor whiteColor]];
	[scrollView setPagingEnabled:YES];
	[scrollView setShowsVerticalScrollIndicator:NO];
	[scrollView setShowsHorizontalScrollIndicator:NO];
	[scrollView setScrollsToTop:NO];
	[scrollView setDelegate:self];
	[scrollView setContentSize:CGSizeMake(320 * 4, 440)];
	
	AboutView *aboutView = [[AboutView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 440.0)];
	
	[aboutView setDelegate:self];
	[scrollView addSubview:aboutView];
	
	[aboutView release];
	
	for (NSUInteger i = 1; i < 4; i++) {
		IntroView *introView = [[IntroView alloc] initWithFrame:CGRectMake(320.0 * i, 0.0, 320.0, 440.0)];
		
		[introView setType:i];
		[introView setDelegate:self];
		
		[scrollView addSubview:introView];
		
		[introView release];
	}
}


- (void)viewWillAppear:(BOOL)animated {
	if (showIntro == YES) {
		[pageControl setCurrentPage:1];
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


- (void)didTapAboutView:(AboutView *)aboutView {
	[delegate didCloseIntroView];
}


- (void)didTapCompanyLink:(AboutView *)aboutView {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://hippofoundry.com"]];
}


- (void)didTapCompanyEmail:(AboutView *)aboutView {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@hippofoundry.com"]];
}


- (void)viewDidUnload {
	
}


- (void)dealloc {
	[scrollView release];
	[pageControl release];
    [super dealloc];
}

@end
