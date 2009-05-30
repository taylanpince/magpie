//
//  SquirrelAppDelegate.h
//  Squirrel
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

@class MainViewController;

@interface SquirrelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

