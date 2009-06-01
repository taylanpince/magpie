//
//  EditableTableViewCell.m
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "EditableTableViewCell.h"


@implementation EditableTableViewCell

@synthesize textField, delegate, indexPath;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        textField = [[UITextField alloc] initWithFrame:CGRectZero];
		textField.placeholder = @"Name";
		textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:16.0];
        textField.textColor = [UIColor blackColor];
		textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		textField.enablesReturnKeyAutomatically = YES;
		textField.returnKeyType = UIReturnKeyDone;
		
        [self addSubview:textField];
    }
    return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];

    textField.frame = CGRectInset(self.contentView.frame, 10.0, 11.0);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        textField.textColor = [UIColor whiteColor];
    } else {
        textField.textColor = [UIColor blackColor];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)field {
	[delegate didBeginEditingTextFieldAtIndexPath:indexPath withTextField:field];
}

- (void)textFieldDidEndEditing:(UITextField *)field {
	[delegate didEndEditingTextFieldAtIndexPath:indexPath withValue:field.text];
}

- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSMutableString *replacedString = [NSMutableString stringWithString:field.text];
	[replacedString replaceCharactersInRange:range withString:string];

	[delegate didChangeEditingTextFieldAtIndexPath:indexPath withValue:replacedString];
	
	return YES;
}


- (void)dealloc {
	[textField release];
	[indexPath release];
	
    [super dealloc];
}


@end
