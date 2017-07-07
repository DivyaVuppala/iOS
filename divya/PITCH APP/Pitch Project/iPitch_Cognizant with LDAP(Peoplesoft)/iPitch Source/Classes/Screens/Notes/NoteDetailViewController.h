//
//  NoteDetailViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 4/3/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteDetailDelegate <NSObject>

-(void)noteSaveClicked:(BOOL)noteStatus;

@end

@interface NoteDetailViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *noteTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteContentTextView;
@property (weak, nonatomic) NSString *noteTitle;
@property (weak, nonatomic) NSString *noteContent;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *noteCancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *noteSaveButton;
@property (assign, nonatomic)BOOL existingNote;
@property (nonatomic,weak) id <NoteDetailDelegate> delegate;

- (IBAction)noteSaveButtonClicked:(id)sender;
- (IBAction)noteCancelButtonClicked:(id)sender;

@end
