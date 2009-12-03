//
//  AboutView.h
//  Magpie
//
//  Created by Taylan Pince on 09-10-06.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@protocol AboutViewDelegate;


@interface AboutView : UIView {
	id <AboutViewDelegate> delegate;
}

@property (nonatomic, assign) id <AboutViewDelegate> delegate;

@end


@protocol AboutViewDelegate
- (void)didTapAboutView:(AboutView *)aboutView;
- (void)didTapCompanyLink:(AboutView *)aboutView;
- (void)didTapCompanyEmail:(AboutView *)aboutView;
@end

