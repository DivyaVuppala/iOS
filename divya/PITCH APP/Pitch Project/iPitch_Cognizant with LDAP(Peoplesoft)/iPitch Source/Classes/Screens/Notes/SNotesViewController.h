//
//  SNotesViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 2/13/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MCSwipeTableViewCell.h"

#import "NoteDetailViewController.h"


@interface SNotesViewController : UIViewController<MCSwipeTableViewCellDelegate,NoteDetailDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *noteSaveButton;

- (IBAction)addNewNoteButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *addNewNoteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *noteCancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *notesEmailButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *previousNotesTableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyNotesLabel;

- (IBAction)noteCancelButtonPressed:(id)sender;
- (IBAction)noteSaveButtonCancelled:(id)sender;
- (IBAction)notesEmailButtonClicked:(id)sender;
@end
