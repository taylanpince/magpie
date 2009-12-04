//
//  IntroView.h
//  Magpie
//
//  Created by Taylan Pince on 09-10-05.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@protocol IntroViewDelegate;


@interface IntroView : UIView {
	NSUInteger type;
	
	id <IntroViewDelegate> delegate;
}

@property (nonatomic, assign) NSUInteger type;

@property (nonatomic, assign) id <IntroViewDelegate> delegate;

@end


@protocol IntroViewDelegate
- (void)didTapIntroView:(IntroView *)introView;
@end