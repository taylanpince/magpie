//
//  SquirrelAppDelegate.h
//  Squirrel
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

@class DataSet, DataPanel, MainViewController;

@interface SquirrelAppDelegate : NSObject <UIApplicationDelegate> {
    sqlite3 *database;
	NSMutableArray *dataSets;
	NSMutableArray *dataPanels;
	
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) NSMutableArray *dataSets;
@property (nonatomic, retain) NSMutableArray *dataPanels;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

- (void)removeDataSet:(DataSet *)dataSet;
- (void)addDataSet:(DataSet *)dataSet;
- (void)removeDataPanel:(DataPanel *)dataPanel;
- (void)addDataPanel:(DataPanel *)dataPanel;
- (void)reorderDataPanels;

@end

