//
//  EditableTableViewCell.h
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditableTableViewCell : UITableViewCell {
	UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

@end
