//
//  KeyPadViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 05/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@protocol KeyPadViewControllerDelegate;


@interface KeyPadViewController : UIViewController {
	id <KeyPadViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <KeyPadViewControllerDelegate> delegate;

- (IBAction)didTapKey:(id)sender;

@end


@protocol KeyPadViewControllerDelegate
- (void)didTapKeyPad:(KeyPadViewController *)keyPad onKey:(NSInteger)key;
@end
