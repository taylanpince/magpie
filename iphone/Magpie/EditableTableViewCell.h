//
//  EditableTableViewCell.h
//  Magpie
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@protocol EditableTableViewCellDelegate;


@interface EditableTableViewCell : UITableViewCell <UITextFieldDelegate> {
	UITextField *textField;
	NSIndexPath *indexPath;
	
	BOOL showsAccessoryButton;
	
	id <EditableTableViewCellDelegate> delegate;
}

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL showsAccessoryButton;

@property (nonatomic, assign) id <EditableTableViewCellDelegate> delegate;

@end


@protocol EditableTableViewCellDelegate
- (void)didEndEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue;
- (void)didBeginEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withTextField:(UITextField *)field;
- (void)didChangeEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue;
@end
