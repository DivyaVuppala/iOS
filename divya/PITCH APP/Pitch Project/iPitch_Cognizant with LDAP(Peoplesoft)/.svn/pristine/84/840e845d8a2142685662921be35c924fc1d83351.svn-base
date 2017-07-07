//
//  AddEventViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 1/29/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "AddEventViewController.h"

#import "AppDelegate.h"

#import "LocalFilesViewController.h"

#import "LoginViewController.h"

#import "SNSDateUtils.h"

#import "File.h"

#import "EventRecipientsCell.h"

#import "ModelTrackingClass.h"

#import "LeadsListViewController.h"

#import "QuartzCore/CALayer.h"

#import "recipientView.h"

#import "Events.h"

#import "ZohoHelper.h"

#import "Utils.h"

#import "iPitchAnalytics.h"

#import "Customers.h"

#import "ZohoConstants.h"

#import "ThemeHelper.h"

#import "CRMHelper.h"

#import "SalesForceHelper.h"

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AddEventViewController ()
{
    UIAlertView *eventStartDateAlert;
    UIAlertView *eventEndDateAlert;
    UIAlertView *eventSaveAlert;
}

@end

@implementation AddEventViewController
@synthesize addRecipientButton;
@synthesize eventSaveButton;
@synthesize eventCancelButton;
@synthesize addDocumentButton;
@synthesize sendInviteButton;
@synthesize selectedDocumentsScrollView;
@synthesize addDocumentsLabel;
@synthesize purposeOfMettingLabel;
@synthesize recipientsTableView;
@synthesize event;
@synthesize eventDateLabel;
@synthesize eventTimeLabel;
@synthesize eventDate;
@synthesize documentsArray;
@synthesize RecipientArray;
@synthesize eventTitleField;
@synthesize purposeOfMeetingTextView;
@synthesize eventEndTime;
@synthesize eventStartTime;
@synthesize recipientsScrollView;
@synthesize addNewRecipientsButton, VenueText;
@synthesize venueLabel,startTimeLabel,endTimeLabel;
@synthesize eventRelatedToModule;
@synthesize eventRelatedToID;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
     [[datePicker.subviews objectAtIndex:0] removeFromSuperview];
    
    DocsOpened = TRUE;
    eventsArray=[[NSMutableArray alloc]init];
    
   self.managedObjectContext =SAppDelegateObject.managedObjectContext;
    NSEntityDescription *eventNew = [NSEntityDescription entityForName:@"Events" inManagedObjectContext:self.managedObjectContext];
    self.event = [[Events alloc] initWithEntity:eventNew insertIntoManagedObjectContext:nil];

    self.endTimeLabel.text=NSLocalizedString(@"END_TIME", "End Time");
    self.startTimeLabel.text=NSLocalizedString(@"START_TIME", "Start Time");
  
    self.venueLabel.text=NSLocalizedString(@"VENUE", @"Venue");
    self.addDocumentsLabel.text=NSLocalizedString(@"ADD_DOCUMENTS", @"Add Documents");
    [self.sendInviteButton setTitle:NSLocalizedString(@"SEND_INVITES", @"Send Invite(s)") forState:UIControlStateNormal] ;
    [self.eventSaveButton setTitle:NSLocalizedString(@"SAVE", @"Save") forState:UIControlStateNormal] ;


    documentsArray=[[NSMutableArray alloc]init];
    
    [addRecipientButton addTarget:self action:@selector(addUsers:) forControlEvents: UIControlEventTouchUpInside];
    
    RecipientArray=[[NSMutableArray alloc]init];
    // [RecipientArray addObject:@"Add Recipient"];
    
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSLog(@"eventDate: %@",self.eventDate);
    
    dateString=[formatter stringFromDate:[SNSDateUtils dateWithOutTime:eventDate]];
    
    NSLog(@"date string: %@",dateString);
    
    
    self.eventDateLabel.text=dateString;
    
    if ([SNSDateUtils componentsForDate:eventDate].hour<=9 && ([SNSDateUtils componentsForDate:eventDate].hour+1)<=9)
        self.eventTimeLabel.text=[NSString stringWithFormat:@"0%d:00 - 0%d:00",[SNSDateUtils componentsForDate:eventDate].hour, [SNSDateUtils componentsForDate:eventDate].hour+1];
    
    if ([SNSDateUtils componentsForDate:eventDate].hour>9 && ([SNSDateUtils componentsForDate:eventDate].hour+1)>9)
        self.eventTimeLabel.text=[NSString stringWithFormat:@"%d:00 - %d:00",[SNSDateUtils componentsForDate:eventDate].hour, [SNSDateUtils componentsForDate:eventDate].hour+1];
    
    if ([SNSDateUtils componentsForDate:eventDate].hour>9 && ([SNSDateUtils componentsForDate:eventDate].hour+1)<=9)
        self.eventTimeLabel.text=[NSString stringWithFormat:@"%d:00 - 0%d:00",[SNSDateUtils componentsForDate:eventDate].hour, [SNSDateUtils componentsForDate:eventDate].hour+1];
    if ([SNSDateUtils componentsForDate:eventDate].hour<=9 && ([SNSDateUtils componentsForDate:eventDate].hour+1)>9)
        self.eventTimeLabel.text=[NSString stringWithFormat:@"0%d:00 - %d:00",[SNSDateUtils componentsForDate:eventDate].hour, [SNSDateUtils componentsForDate:eventDate].hour+1];
    
    self.event.eventStartDate=eventDate;
    self.event.eventEndDate=[SNSDateUtils date:eventDate ByAddingHours:1];
    
    [self.eventStartTime setTitle:[SNSDateUtils timeFromNSDate:self.event.eventStartDate] forState:UIControlStateNormal];
    
    [self.eventEndTime setTitle:[SNSDateUtils timeFromNSDate:self.event.eventEndDate] forState:UIControlStateNormal];
    
    eventTitleField.text =  [[ModelTrackingClass sharedInstance]getModelObjectForKey:@"Title"];
  // RecipientArray =[[ModelTrackingClass sharedInstance]getModelObjectForKey:@"RecipientArrayReload"];
   // documentsArray =[[ModelTrackingClass sharedInstance]getModelObjectForKey:@"DocumentArrayReload"];
    NSLog(@"recipient: %@", RecipientArray);
    //[RecipientArray addObject:@"Add Recipient"];
    
    NSLog(@"event.eventStartDate: %@",self.event.eventStartDate);
    [recipientsTableView setEditing:YES animated:YES];
    [recipientsTableView reloadData];
    
    [self.purposeOfMeetingTextView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.purposeOfMeetingTextView.layer setBorderWidth:1.5];
    [self.purposeOfMeetingTextView.layer setCornerRadius:5];
    
    [self.view.layer setCornerRadius:5];
        
    [recipientsScrollView setContentSize:CGSizeMake(2000, 0)];

    self.closeEventCreationPage.hidden=YES;
    
    if(self.presentingViewController != nil)
    {
        self.closeEventCreationPage.hidden=NO;
        self.eventCancelButton.hidden=YES;
    }

    // Do any additional setup after loading the view from its nib.
}


-(void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [ThemeHelper applyCurrentThemeToView];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Add Appointment"];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


-(void)updateDocumentsScrollView
{
    
    for (UIView * tView in [self.selectedDocumentsScrollView subviews]) {
        if (![tView isKindOfClass:[UIImageView class ]]) {
            [tView removeFromSuperview];
        }
    }
    
    if ([[self.event.filesTaggedToEvent allObjects] count]==0) {
        
        [addDocumentButton setFrame:CGRectMake(20, 20, 80, 80)];
        [self.selectedDocumentsScrollView addSubview:addDocumentButton];
        
    }
    else
    {
        for(int i=0;i<[[self.event.filesTaggedToEvent allObjects] count];i++)
        {
            File *sFile=(File *)[[self.event.filesTaggedToEvent allObjects] objectAtIndex:i];
            UIView *sView=[[UIView alloc]initWithFrame:CGRectMake(50+ 120 *i, 10, 80, 80)];
            
            UIImageView *sFileIcon=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
            
         //   sFileIcon.image=[UIImage imageNamed:@"pdf"];
            
            NSString *pathString=[NSString stringWithFormat:@"%@",sFile .filePath];

            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            
            dispatch_async(queue, ^{
                
                UIImage *pdfThumbNailImage=[Utils generateThumbNailIconForFile:pathString WithSize:CGSizeMake(60, 60)];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    sFileIcon.image = pdfThumbNailImage;
                });
            });            [sView addSubview:sFileIcon];
            
            
            [sView addSubview:sFileIcon];
            
            
            UILabel *sFileNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, 100, 20)];
            sFileNameLabel.text=sFile.fileName;
            sFileNameLabel.font=[UIFont fontWithName:FONT_BOLD size:14];
            [sView addSubview:sFileNameLabel];
            
            [self.selectedDocumentsScrollView addSubview:sView];
            
            [addDocumentButton setFrame:CGRectMake(50+(i+1)*120, 10, 80, 80)];
            [self.selectedDocumentsScrollView addSubview:addDocumentButton];
        }
        
        [self.selectedDocumentsScrollView setContentSize:CGSizeMake([[self.event.filesTaggedToEvent allObjects] count] * 170, 0)];
        
    }
    
}

-(void)updateRecipientsSrollView
{
    
    [recipientsScrollView setContentSize:CGSizeMake(350 * ([self.event.customersTaggedToEvent count]+1), 0)];

    
    for (UIView * tView in [recipientsScrollView subviews]) {
        if (![tView isKindOfClass:[UIImageView class ]]) {
            [tView removeFromSuperview];
        }
    }
    
    if ([self.event.customersTaggedToEvent count]==0) {
        
        [addNewRecipientsButton setFrame:CGRectMake(20, 20, 80, 80)];
        [recipientsScrollView addSubview:addNewRecipientsButton];

    }
    else
    {
    for (int i =0;i<[self.event.customersTaggedToEvent count]; i++)
    {
        recipientView *recView=[[recipientView alloc]initWithFrame:CGRectMake(20+i*300, 20, 300, 150)];
        Customers *userObject = [[self.event.customersTaggedToEvent allObjects] objectAtIndex:i];
        
        if (i%2 == 0)
            recView.recipientIcon.image=[UIImage imageNamed:@"user_icon_3.png"];
        else
            recView.recipientIcon.image=[UIImage imageNamed:@"user_icon_4.png"];
        recView.recipientName.text= [NSString stringWithFormat:@"%@ %@",userObject.firstName, userObject.lastName];
        recView.recipientDesignation.text=userObject.mailingCity;
        recView.recipientCompany.text=userObject.mailingStreet;
       // recView.recipientContactNumber.text=userObject.phoneNumber;
        //recView.recipientLocation.text=userObject.userOrganisation;
        [recipientsScrollView addSubview:recView];
        [addNewRecipientsButton setFrame:CGRectMake(20+(i+1)*350, 20, 80, 80)];
        [recipientsScrollView addSubview:addNewRecipientsButton];


    }
    }
    
}

- (void)addUsers:(UIButton *)sender{
    
//    UITableView *UsersTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 100, 500, 300)];
//    UsersTable.dataSource = self;
//    UsersTable.delegate = self;
//    UsersTable.tag = 1;
//    
//    UIButton *temp=(UIButton *)sender;
//    CGRect tempFrame=temp.frame;
//
//    tempFrame.origin.y+=80;
//    UIViewController* popoverContent = [[UIViewController alloc] init];
////    popoverContent.contentSizeForViewInPopover=CGSizeMake(250,[SAppDelegateObject.masterUsersArray count]<5?([SAppDelegateObject.masterUsersArray count]*50):500);
////    popoverContent.view = UsersTable;
//    
//    tempPopOver = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
//    [tempPopOver presentPopoverFromRect:tempFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recipientsAddedToEvent:) name:@"RecipientsAddedToEvent" object:nil];
    
    
   // LeadsListViewController *vc=[[LeadsListViewController alloc]initWithNibName:@"LeadsListViewController" bundle:nil];
    
//    CGRect rct=self.view.frame;
//    
//    rct.size.height=500;
//    
//    vc.view.frame=rct;
    
    //UINavigationController *navForFileBrowser=[[UINavigationController alloc]initWithRootViewController:vc];
    
   // [SAppDelegateObject.viewController.stackVC pushViewController:navForFileBrowser fromViewController:self animated:YES];

    
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setAddDocumentButton:nil];
    [self setEventCancelButton:nil];
    [self setEventSaveButton:nil];
    [self setAddRecipientButton:nil];
    [self setSelectedDocumentsScrollView:nil];
    [self setAddDocumentsLabel:nil];
    [self setSendInviteButton:nil];
    [self setPurposeOfMettingLabel:nil];
    [self setRecipientsTableView:nil];
    [self setEventDateLabel:nil];
    [self setEventTimeLabel:nil];
    [self setEventTitleField:nil];
    [self setPurposeOfMeetingTextView:nil];
    [self setEventStartTime:nil];
    [self setEventEndTime:nil];
    [self setRecipientsScrollView:nil];
    [self setAddNewRecipientsButton:nil];
    [self setEndTimeLabel:nil];
    [self setStartTimeLabel:nil];
    [self setVenueLabel:nil];
    [self setAddDocumentsLabel:nil];
    [self setCloseEventCreationPage:nil];
    [super viewDidUnload];
}

- (IBAction)eventCreationPageClicked:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)eventStartButtonClicked:(id)sender
{
    if(datePicker)
        datePicker=nil;
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.frame=CGRectMake(20, 45.0, 240.0, 150.0);
    datePicker.minimumDate=[NSDate date];
    
    NSString *alertTitleString=@"";
    if(self.presentingViewController !=nil)
    {
        alertTitleString=@"Select Date and Time";
        [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    }
    else
    {
        alertTitleString=@"Select Time";
        [datePicker setDatePickerMode:UIDatePickerModeTime];
        
    }
    [datePicker setDate:[NSDate date]];
    
    UIView *view = [[datePicker subviews] objectAtIndex:0];
    [view setBackgroundColor:[UIColor clearColor]]; // hide the first and the last subviews
    [[[view subviews] objectAtIndex:0] setHidden:YES];
    [[[view subviews] lastObject] setHidden:YES];
    
    

    eventStartDateAlert = [[UIAlertView alloc] initWithTitle:alertTitleString message:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"Ok") otherButtonTitles:nil];
    eventStartDateAlert.delegate = self;
    [eventStartDateAlert addSubview:datePicker];
    [eventStartDateAlert show];
  
}

- (IBAction)eventEndTimeButtonClicked:(id)sender {
    
    if(datePicker)
        datePicker=nil;
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.frame=CGRectMake(20, 45.0, 240.0, 150.0);
    
    if (self.event.eventStartDate !=nil) {
        datePicker.minimumDate=self.event.eventStartDate;
    }
    
    else
    {
        datePicker.minimumDate= [NSDate date];
    }
    
    NSString *alertTitleString=@"";
    if(self.presentingViewController !=nil)
    {
        alertTitleString=@"Select Date and Time";
        [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    }
    else
    {
        alertTitleString=@"Select Time";
        [datePicker setDatePickerMode:UIDatePickerModeTime];
        
    }
    [datePicker setDate:[NSDate date]];
    
    UIView *view = [[datePicker subviews] objectAtIndex:0];
    [view setBackgroundColor:[UIColor clearColor]]; // hide the first and the last subviews
    [[[view subviews] objectAtIndex:0] setHidden:YES];
    [[[view subviews] lastObject] setHidden:YES];
    
    eventEndDateAlert = [[UIAlertView alloc] initWithTitle:alertTitleString message:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"Ok") otherButtonTitles:nil];
    eventEndDateAlert.delegate = self;
    [eventEndDateAlert addSubview:datePicker];
    [eventEndDateAlert show];
    
}

-(void)eventStartTimeChanged
{
    NSLog(@"datepicker time: %@",datePicker.date);
    self.event.eventStartDate=datePicker.date;
    [eventStartTime setTitle:[SNSDateUtils timeFromNSDate:datePicker.date] forState:UIControlStateNormal];
    [datePicker removeFromSuperview];
}

-(void)eventEndTimeChanged
{
    
    if ([SNSDateUtils isDate:self.event.eventStartDate smallerThanAnotherDate:self.event.eventEndDate]) {
        NSLog(@"datepicker time: %@",datePicker.date);
        self.event.eventEndDate=datePicker.date;
        [eventEndTime setTitle:[SNSDateUtils timeFromNSDate:datePicker.date] forState:UIControlStateNormal];
        [datePicker removeFromSuperview];

    }
// else
//{
//     [Utils showMessage:@"End time cannot be less then Start time" withTitle:@"Alert"];
//}
//    

}

- (IBAction)addDocumentButtonClicked:(id)sender {
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Add Event Screen" withAction:@"Add Document Clicked" withLabel:eventTitleField.text withValue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentsAddedToEvent:) name:@"FilesAddedToEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentsAddedToEvent:) name:@"PlaylistFilesAddedToEvent" object:nil];
    LocalFilesViewController *vc=[[LocalFilesViewController alloc]initWithNibName:@"LocalFilesViewController" bundle:nil];
    vc.isServerMode=NO;
    vc.contentSizeForViewInPopover=CGSizeMake(400, 500);

    UINavigationController *navForVC=[[UINavigationController alloc]initWithRootViewController:vc];
    UIAlertView *serverFilesAlert=[[UIAlertView alloc]initWithTitle:@"Connect to server" message:@"You wish to see server files too?" delegate:vc cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [serverFilesAlert show];

    if([popOverController isPopoverVisible])
        [popOverController dismissPopoverAnimated:YES];

    popOverController=[[UIPopoverController alloc]initWithContentViewController:navForVC];
    
    CGRect tFrame=((UIButton *)sender).frame;
    tFrame.origin.x=500;
    tFrame.origin.y=350;
    [popOverController presentPopoverFromRect:tFrame inView:self.view permittedArrowDirections:0 animated:YES];
    
}

- (IBAction)eventSaveButtonClicked:(id)sender {
    

    eventSaveAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INTEGRATE_TO",@"Integrate To")
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"CANCEL",@"Cancel")
                                              otherButtonTitles:NSLocalizedString(@"ONLY_CALENDAR", @"Only Calendar"),NSLocalizedString(@"CRM_AND_CALENDAR",@"CRM & Calendar"), nil];
    [eventSaveAlert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView == eventSaveAlert)
    {
    
    self.event.eventTitle=eventTitleField.text;
    self.event.eventVenue = self.VenueText.text;
    self.event.eventPurpose = self.purposeOfMeetingTextView.text;
        
    if(buttonIndex ==0)
    {
        NSLog(@"Button 1 was selected.");
        return;
    }
    else if(buttonIndex ==1)
    {
        NSError *error;

        self.event.eventSyncStatus= [NSNumber numberWithBool:NO];
        
        if(self.presentingViewController != nil)
        {
        self.event.relatedToID=self.eventRelatedToID;

        if(self.eventRelatedToModule == AccountsModule)
        {
            self.event.relatedToAccountID=self.eventRelatedToID;
        }
            
        else if(self.eventRelatedToModule == OpportunitiesModule)
        {
            self.event.relatedToPotentialID=self.eventRelatedToID;
            
        }
        
            
        [self.managedObjectContext insertObject:self.event];
            
        if (![self.managedObjectContext save:&error])
        {
                NSLog(@"Sorry, couldn't save Event %@", [error localizedDescription]);
        }

        
        CRMHelper * zohoAddEventActivity = [[CRMHelper alloc]init];
            
        if(self.eventRelatedToModule == AccountsModule)
        {
            [zohoAddEventActivity TagActivitiesToAccounts];
        }
        else if(self.eventRelatedToModule == CustomerModule)
            [zohoAddEventActivity TagActivitiesToContact];
        else if(self.eventRelatedToModule == OpportunitiesModule)
        {
            [zohoAddEventActivity TagActivitiesToOpportunities];            
        }
        else if (self.eventRelatedToModule == LeadModule)
        {
            [zohoAddEventActivity TagEventsToLead];
        }
                      
        [self.delegate eventSaved:self.event];

        [self dismissModalViewControllerAnimated:YES];

        }
        else
        {
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Add Event Screen" withAction:@"Added Event Locally" withLabel:eventTitleField.text withValue:nil];
        
        self.event.eventSyncStatus= [NSNumber numberWithBool:NO];
    
        
        [self.managedObjectContext insertObject:self.event];
        

        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Sorry, couldn't save Event %@", [error localizedDescription]);
        }
        
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        [self.navigationController popViewControllerAnimated:NO];
        [UIView setAnimationDuration:0.50];
        [UIView commitAnimations];
        }
    }
    else if(buttonIndex ==2)
    {
     
        NSMutableDictionary *eventItemsDict=[[NSMutableDictionary alloc]init];
        
        [eventItemsDict setObject:eventTitleField.text forKey:ZOHO_SUBJECT_PARAMETER];
        
       // [eventItemsDict setObject:[NSString stringWithFormat:@"%@ %@:00",dateString, eventStartTime.titleLabel.text ]  forKey:ZOHO_START_TIME_PARAMETER];
        
       // [eventItemsDict setObject:[NSString stringWithFormat:@"%@ %@:00",dateString, eventEndTime.titleLabel.text ] forKey:ZOHO_END_TIME_PARAMETER];
        
         [eventItemsDict setObject:self.event.eventStartDate  forKey:ZOHO_START_TIME_PARAMETER];
        
         [eventItemsDict setObject:self.event.eventEndDate  forKey:ZOHO_END_TIME_PARAMETER];
        
        [eventItemsDict setObject:purposeOfMeetingTextView.text forKey:ZOHO_PURPOSE_PARAMETER];
        
        [eventItemsDict setObject:self.VenueText.text forKey:ZOHO_VENUE_PARAMETER];
        
        [eventItemsDict setObject:self.eventRelatedToID forKey:ID_PARAMTER];

        if(self.presentingViewController != nil)
        {
            
            [eventItemsDict setObject:self.eventRelatedToID forKey:ZOHO_SEID_PARAMETER];

            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = NSLocalizedString(@"ADDING_EVENT_TO_CRM", @"Adding event to CRM...");

            [self performSelectorInBackground:@selector(AddEventToCRMAccordingToModuleSelected:) withObject:eventItemsDict];

        }
        
        else
        {
        
            //Remove this - send via dictionary.
        [[ModelTrackingClass sharedInstance] setModelObject:eventTitleField.text forKey:@"Subject"];
        [[ModelTrackingClass sharedInstance] setModelObject:[NSString stringWithFormat:@"%@ %@:00",dateString, eventStartTime.titleLabel.text ] forKey:@"StartDate"];
        [[ModelTrackingClass sharedInstance] setModelObject:purposeOfMeetingTextView.text forKey:@"Description"];
        [[ModelTrackingClass sharedInstance] setModelObject:[NSString stringWithFormat:@"%@ %@:00",dateString, eventEndTime.titleLabel.text ] forKey:@"EndDate"];
        [[ModelTrackingClass sharedInstance] setModelObject:self.VenueText.text forKey:@"Venue"];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = NSLocalizedString(@"ADDING_EVENT_TO_CRM", @"Adding event to CRM...");
    

            
            [self performSelectorInBackground:@selector(AddEventToCRM:) withObject:eventItemsDict];
        }
    }
}
    
    else if(alertView==eventStartDateAlert)
    {
        self.event.eventStartDate=datePicker.date;
        [eventStartTime setTitle:[SNSDateUtils timeFromNSDate:datePicker.date] forState:UIControlStateNormal];
    }
    
    else if(alertView==eventEndDateAlert)
    {
        
        self.event.eventEndDate=datePicker.date;
        [eventEndTime setTitle:[SNSDateUtils timeFromNSDate:datePicker.date] forState:UIControlStateNormal];
    }
}
-(void)AddEventToCRM:(NSMutableDictionary *)details {
    
    //Put CRM switching statement here.
    
   /* ZohoHelper * zohoAddEventActivity = [[ZohoHelper alloc]init];
    [zohoAddEventActivity AddActivityEventToZoho];
    [zohoAddEventActivity FetchActivitiesFromZoho];*/
    
    SalesForceHelper *sfdcObject=[[SalesForceHelper alloc]init];
    [sfdcObject addActivityWithDetails:details];
    //[sfdcObject fetchActivities];
    
    [self performSelectorOnMainThread:@selector(updateMainthread) withObject:Nil waitUntilDone:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


-(void)AddEventToCRMAccordingToModuleSelected:(NSMutableDictionary *)eventItems
{
    
    SalesForceHelper *sfdcObject = [[SalesForceHelper alloc]init];
    [sfdcObject addActivityWithDetails:eventItems forModule:self.eventRelatedToModule];
    
   /* ZohoHelper * zohoAddEventActivity = [[ZohoHelper alloc]init];
    [zohoAddEventActivity AddActivityEventToZohoForModule:self.eventRelatedToModule WithDetails:eventItems];*/
    
    switch (self.eventRelatedToModule) {
        case CustomerModule:
        {
            //[zohoAddEventActivity FetchRelatedActivitiesForEntity:CONTACTS_MODULE :self.eventRelatedToID ];
            [sfdcObject TagActivitiesToContact];

        }
            break;
            
        case LeadModule:
        {
            //[zohoAddEventActivity FetchRelatedActivitiesForEntity:LEADS_MODULE :self.eventRelatedToID ];
            [sfdcObject TagEventsToLead];

        }
            break;
            
        case AccountsModule:
        {
            //[zohoAddEventActivity FetchRelatedActivitiesForEntity:ACCOUNTS_ENTITY :self.eventRelatedToID ];
            [sfdcObject TagActivitiesToAccounts];

        }
            break;
            
        case OpportunitiesModule:
        {
            //[zohoAddEventActivity FetchRelatedActivitiesForEntity:POTENTIALS_MODULE :self.eventRelatedToID ];
            [sfdcObject TagActivitiesToOpportunities];

        }
            break;
        default:
            break;
    }
    
    
    [self performSelectorOnMainThread:@selector(updateMainthread) withObject:Nil waitUntilDone:YES];

}


-(void)updateMainthread{
    
    if(self.presentingViewController != nil)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissModalViewControllerAnimated:YES];
        [self.delegate eventSaved:self.event];

    }
    
    else
    {
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Add Event Screen" withAction:@"Add Event to CRM" withLabel:eventTitleField.text withValue:nil];
        
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView setAnimationDuration:0.50];
    [UIView commitAnimations];
    }
}


- (IBAction)eventCancelButtonClicked:(id)sender {
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView setAnimationDuration:0.50];
    [UIView commitAnimations];
}

-(void)documentsAddedToEvent:(NSNotification *)notification
{
    if ([[self.managedObjectContext objectWithID:(NSManagedObjectID *)notification.object ]isKindOfClass:[File class]])
    {
        File *file= (File *)[self.managedObjectContext objectWithID:(NSManagedObjectID *)notification.object];
        [self.event addFilesTaggedToEventObject:file];
    }
    
    else if ([[self.managedObjectContext objectWithID:(NSManagedObjectID *)notification.object ]isKindOfClass:[Playlist class]])
    {
        Playlist *playlist= (Playlist *)[self.managedObjectContext objectWithID:(NSManagedObjectID *)notification.object];
        for ( int i = 0; i< [[ playlist.playListDocuments allObjects]count];i++)
        {
            File* file =  [[playlist.playListDocuments allObjects] objectAtIndex:i];
            [self.event addFilesTaggedToEventObject:file];
        }
    }
    
    NSError *error=nil;
    
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"error in adding recipients: %@",[error localizedDescription]);
    }
    
    [self updateDocumentsScrollView];
   
}



-(void)recipientsAddedToEvent:(NSNotification *)notification
{

    [popOverController dismissPopoverAnimated:YES];
    
    NSLog(@"Customer ID: %@", notification.object);
    
    if (![[self.event.customersTaggedToEvent allObjects] containsObject:(Customers *)notification.object])
    {
        NSLog(@"self.event: %@",self.event);
        
        //NSManagedObjectContext *context = self.managedObjectContext;
        
        Customers *customer= (Customers *)[self.managedObjectContext objectWithID:(NSManagedObjectID *)notification.object];
        
        NSLog(@"customers: %@",customer);
            
        
        /*NSMutableArray *recipientArray=[[NSMutableArray alloc]init];
        
        [recipientArray addObjectsFromArray:[self.event.customersTaggedToEvent allObjects]];
        
        [recipientArray addObject:(Customers *)notification.object];
        
        self.event.customersTaggedToEvent=[NSSet setWithArray:recipientArray];
        
        [self.managedObjectContext updatedObjects];*/
        
        self.event.relatedToContactID =customer.customerID;
                                        
        [self.event addCustomersTaggedToEventObject:customer];
    
      //  [((Customers *) notification.object ) addEventsTaggedToCustomersObject:self.event];
        
//        if (![self.managedObjectContext obtainPermanentIDsForObjects:self.managedObjectContext.insertedObjects.allObjects error:&error])
//        {
//            NSLog(@"Error: %@",[error localizedDescription]);
//        }
        
 
        NSLog(@"event customers: %@", self.event.customersTaggedToEvent);

        
    }
    [self updateRecipientsSrollView];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [datePicker removeFromSuperview];
    [eventTitleField resignFirstResponder];
    [purposeOfMeetingTextView resignFirstResponder];
    [VenueText resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
        [self animateTextView: textView up: YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView: textView up: NO];
}

- (void) animateTextView: (UITextView *) textField up: (BOOL) up
{
    CGRect temp=self.view.frame;
    const int movementDistance = 150;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    if(!up)
    {
        if(self.view.frame.origin.y!=0)
        {
            self.view.frame=temp;
        }
    }
}

- (void) animateTextField: (UITextField *) textField up: (BOOL) up
{
    if (textField == self.VenueText)
    {
        CGRect temp=self.view.frame;
        const int movementDistance = 150;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
        if(!up)
        {
            if(self.view.frame.origin.y!=0)
            {
                self.view.frame=temp;
            }
        }
    }
}

-(IBAction)sendInviteClicked:(id)sender
{
     
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            MFMailComposeViewController *mailController= [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = self;
            
            [[mailController navigationBar] setTintColor:[UIColor blackColor]];
            
            NSMutableString *subject  = [NSMutableString string];
            [subject appendString:[NSString stringWithFormat:@"Meeting - %@ on %@",eventTitleField.text,eventDateLabel.text]];
            [mailController setSubject:subject];
            
            NSMutableString *mailbody  = [NSMutableString string];
            [mailbody appendString:[NSString stringWithFormat: @"Hi all we have an appointment on %@ from %@ .", eventDateLabel.text,eventTimeLabel.text]];
            [mailbody appendString:[NSString stringWithFormat: @" To discuss about %@",purposeOfMeetingTextView.text]];
            
            [mailController setMessageBody:mailbody isHTML:NO];
            
            NSMutableArray *toRecipients=[[NSMutableArray alloc]init];
            
            for (int i=0; i<[RecipientArray count]; i++) {
                if ([[RecipientArray objectAtIndex:i ] isKindOfClass:[Customers class]]) {
                    NSString *str = [NSString stringWithFormat:@"%@",((Customers *) [RecipientArray objectAtIndex:i]).emailID];
                    [toRecipients addObject:str];
                }
            }

            
            NSLog(@"recipients: %@",toRecipients);
            
            [mailController setToRecipients:toRecipients];
            [self presentModalViewController:mailController animated:YES];
            mailController = nil;
        }
        else
        {
            [self launchMailAppOnDeviceForShare];
        }
    }
    
}

- (IBAction)addNewRecipients:(id)sender {
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Add Event Screen" withAction:@"Add Recipient Clicked" withLabel:eventTitleField.text withValue:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recipientsAddedToEvent:) name:@"RecipientsAddedToEvent" object:nil];
    
    LeadsListViewController *vc=[[LeadsListViewController alloc]initWithNibName:@"LeadsListViewController" bundle:nil];
    
    vc.contentSizeForViewInPopover=CGSizeMake(400, 500);
    
    if([popOverController isPopoverVisible])
        [popOverController dismissPopoverAnimated:YES];

    popOverController=[[UIPopoverController alloc]initWithContentViewController:vc];
    
    CGRect tFrame=((UIButton *)sender).frame;
    tFrame.origin.x=500;
    tFrame.origin.y=200;
    [popOverController presentPopoverFromRect:tFrame inView:self.view permittedArrowDirections:0 animated:YES];

}

-(void)launchMailAppOnDeviceForShare
{
    
    NSMutableString *subject  = [NSMutableString string];
    [subject appendString:@"Meeting"];
    
    NSMutableString *mailbody  = [NSMutableString string];
    [mailbody appendString:@"You and I have an appointment on "];
    [mailbody appendString:@"To discuss about "];

    
    NSString *recipients = [NSString stringWithFormat:@"mailto:?&subject=%@!",subject];
    
    NSString *body = [NSString stringWithFormat:@"&body=%@!",mailbody];;
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result  error:(NSError*)error {
    UIAlertView *alert;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
			
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultSent:
        {
			NSLog(@"Result: sent");
            alert=[[UIAlertView alloc] initWithTitle: @"Mail sent" message:@"Mail successfully sent!!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
			alert = nil;
        }
            break;
        case MFMailComposeResultFailed:
		{
            
            NSLog(@"Result: Failed");
            alert=[[UIAlertView alloc] initWithTitle:@"Failure"  message:@"MAIL_SENDING_FAILURE_MESSAGE" delegate:self cancelButtonTitle: @"Ok" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
            break;
        default:
			NSLog(@"Result: not sent");
            break;
    }
    [self becomeFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}



@end
