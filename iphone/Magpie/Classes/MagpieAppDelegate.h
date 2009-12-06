//
//  MagpieAppDelegate.h
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Hippo Foundry 2009. All rights reserved.
//

@class MainViewController;

@interface MagpieAppDelegate : NSObject <UIApplicationDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) NSMutableArray *dataSets;
@property (nonatomic, retain) NSMutableArray *dataPanels;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

- (NSString *)applicationDocumentsDirectory;

@end

