//
//  AddedEventViewController.h
//  iPitch V2
//
//  Created by Vineet on 20/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Events.h"
#import "PresentationPaneViewController.h"
#import "Playlist.h"

@interface AddedEventViewController : UIViewController

{
    UIPopoverController *popOverController;

}
@property (weak, nonatomic) IBOutlet UIButton *eventCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *PlayButton;
@property (weak, nonatomic) IBOutlet UIButton *RemindMeButton;
@property (weak, nonatomic) IBOutlet UIButton *RescheduleButton;
@property (weak, nonatomic) IBOutlet UIButton *AddNotesButton;
@property (weak, nonatomic) IBOutlet UIButton *DocumentButton;
@property (weak, nonatomic) IBOutlet UIButton *ProductButton;
@property (weak, nonatomic) IBOutlet UIButton *RecentActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *addDocumentButton;
@property (weak, nonatomic) IBOutlet UIScrollView *selectedDocumentsScrollView;
@property (weak, nonatomic) IBOutlet UIButton *addUsersButton;;
@property (weak, nonatomic) IBOutlet UIScrollView *selectedUsersScrollView;
@property (weak, nonatomic) IBOutlet UILabel *purposeOfMettingLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *purposeOfMeetingTextView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectID *eventID;
@property (strong, nonatomic) Events *event;
@property (retain, nonatomic) PresentationPaneViewController *pptPaneView;

- (IBAction)addDocumentButtonClicked:(id)sender;
- (IBAction)eventCancelButtonClicked:(id)sender;
- (IBAction)RemindMeButtonClicked:(id)sender;
- (IBAction)RescheduleButtonClicked:(id)sender;
- (IBAction)AddNotesButtonClicked:(id)sender;
- (IBAction)PlayButtonClicked:(id)sender;
- (IBAction)addNewRecipients:(id)sender;
- (IBAction)DocumentButtonClicked:(id)sender;
- (IBAction)ProductButtonClicked:(id)sender;
- (IBAction)RecentActivityButtonClicked:(id)sender;

@end
