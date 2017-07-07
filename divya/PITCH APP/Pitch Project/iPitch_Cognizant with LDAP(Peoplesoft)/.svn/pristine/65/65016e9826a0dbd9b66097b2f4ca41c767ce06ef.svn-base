//
//  AddEventViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 1/29/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Events.h"

#import <MessageUI/MessageUI.h>

#import "MBProgressHUD.h"

#import "iPitchConstants.h"


@protocol AddNewEventDelegate 

@optional

- (void)eventSaved:(Events *)event;

- (void)eventCancelled;

@end

@interface AddEventViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate>{
    UIPopoverController *popOverController;
    NSMutableArray *RecipientArray;
    BOOL DocsOpened;
    UIDatePicker *datePicker;
    NSString *dateString;
    MBProgressHUD *HUD;
    NSMutableArray *eventsArray;
}


@property (weak, nonatomic) IBOutlet UIButton *addRecipientButton;
@property (weak, nonatomic) IBOutlet UIButton *eventSaveButton;
@property (weak, nonatomic) IBOutlet UIButton *eventCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *addDocumentButton;
@property (weak, nonatomic) IBOutlet UIButton *sendInviteButton;
@property (weak, nonatomic) IBOutlet UIScrollView *selectedDocumentsScrollView;
@property (weak, nonatomic) IBOutlet UILabel *addDocumentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *purposeOfMettingLabel;
@property (weak, nonatomic) IBOutlet UITableView *recipientsTableView;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (strong, nonatomic) NSMutableArray *RecipientArray;
@property (weak, nonatomic) IBOutlet UITextField *eventTitleField;
@property (weak, nonatomic) IBOutlet UIButton *eventStartTime;
@property (weak, nonatomic) IBOutlet UITextField *VenueText;

@property (weak, nonatomic) IBOutlet UIButton *eventEndTime;

@property (strong, nonatomic) Events *event;
@property (assign, nonatomic) ModuleType eventRelatedToModule;
@property (strong, nonatomic) NSString *eventRelatedToID;
@property (nonatomic,weak) id <AddNewEventDelegate> delegate;

@property (strong, nonatomic) NSDate *eventDate;

@property (strong, nonatomic) NSMutableArray *documentsArray;
@property (weak, nonatomic) IBOutlet UIScrollView *recipientsScrollView;
@property (weak, nonatomic) IBOutlet UIButton *addNewRecipientsButton;
@property (weak, nonatomic) IBOutlet UITextView *purposeOfMeetingTextView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeEventCreationPage;



- (IBAction)eventCreationPageClicked:(id)sender;
- (IBAction)eventStartButtonClicked:(id)sender;
- (IBAction)eventEndTimeButtonClicked:(id)sender;
- (IBAction)addDocumentButtonClicked:(id)sender;
- (IBAction)eventSaveButtonClicked:(id)sender;
- (IBAction)eventCancelButtonClicked:(id)sender;
- (IBAction)sendInviteClicked:(id)sender;
- (IBAction)addNewRecipients:(id)sender;

@end
