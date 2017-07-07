//
//  AddedEventViewController.m
//  iPitch V2
//
//  Created by Vineet on 20/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "AddedEventViewController.h"
#import "SNSDateUtils.h"
#import "recipientView.h"
#import "LocalFilesViewController.h"
#import "LeadsListViewController.h"
#import "Customers.h"
#import "QuartzCore/CALayer.h"
#import "iPitchConstants.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "LoginViewController.h"
#import "iPitchAnalytics.h"
#import "ThemeHelper.h"

@interface AddedEventViewController ()

@end

@implementation AddedEventViewController

@synthesize eventCancelButton;
@synthesize addDocumentButton;
@synthesize selectedDocumentsScrollView;
@synthesize purposeOfMettingLabel;
@synthesize eventTimeLabel;
@synthesize purposeOfMeetingTextView;
@synthesize selectedUsersScrollView;
@synthesize event;
@synthesize addUsersButton, RescheduleButton, RemindMeButton, AddNotesButton, DocumentButton, ProductButton, RecentActivityButton;
@synthesize managedObjectContext,eventID;
@synthesize pptPaneView;

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
    
    self.managedObjectContext =SAppDelegateObject.managedObjectContext;

    self.event= (Events *)[self.managedObjectContext objectWithID:(NSManagedObjectID *)self.eventID];
        
    self.purposeOfMettingLabel.text=NSLocalizedString(@"PURPOSE_OF_MEETING", @"Purpose Of Meeting");
    [self.ProductButton setTitle:NSLocalizedString(@"PRODUCTS", @"Products") forState:UIControlStateNormal];
    [self.DocumentButton setTitle:NSLocalizedString(@"DOCUMENTS", @"Documents") forState:UIControlStateNormal];
    [self.RecentActivityButton setTitle:NSLocalizedString(@"RECENT_ACTIVITIES", @"Recent Activities") forState:UIControlStateNormal];
    [self.AddNotesButton setTitle:NSLocalizedString(@"ADD_NOTES", @"Add Notes") forState:UIControlStateNormal];
    [self.RemindMeButton setTitle:NSLocalizedString(@"REMIND_ME", @"Remind Me") forState:UIControlStateNormal];
    [self.RescheduleButton setTitle:NSLocalizedString(@"RE_SCHEDULE", @"Re-Schedule") forState:UIControlStateNormal];

    NSLog(@"self.event: %@",self.event);
    
    purposeOfMettingLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
    purposeOfMeetingTextView.text = event.eventDescType;
    RescheduleButton.titleLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
    RemindMeButton.titleLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
    AddNotesButton.titleLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
    [ProductButton setTitleColor:[Utils colorFromHexString:@"868686"] forState:UIControlStateNormal];
    [RecentActivityButton setTitleColor:[Utils colorFromHexString:@"868686"] forState:UIControlStateNormal];
    
     self.eventTimeLabel.text=[NSString stringWithFormat:@"%@ - %@", [SNSDateUtils timeFromNSDate:self.event.eventStartDate],[SNSDateUtils timeFromNSDate:self.event.eventEndDate]];
    
    self.purposeOfMeetingTextView.text=self.event.eventPurpose;
    
    [self updateRecipientsSrollView];
    [self updateDocumentsScrollView];
   // [self.purposeOfMeetingTextView.layer setBorderColor:[[UIColor grayColor] CGColor]];
   // [self.purposeOfMeetingTextView.layer setBorderWidth:1.5 ];
   // [self.purposeOfMeetingTextView.layer setCornerRadius:5];
    [self.view.layer setCornerRadius:5];
    
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Added Appointment"];
    [super viewWillAppear:animated];
    [SAppDelegateObject.viewController.dashBoard.navigationController setNavigationBarHidden:TRUE];
    [ThemeHelper applyCurrentThemeToView];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateRecipientsSrollView
{
    
    NSLog(@"cusromer: %@",[self.event.customersTaggedToEvent allObjects]);
    
    [self.selectedUsersScrollView setContentSize:CGSizeMake(350 * ([[self.event.customersTaggedToEvent allObjects] count]+1), 0)];
    
    
    for (UIView * tView in [self.selectedUsersScrollView subviews]) {
        if (![tView isKindOfClass:[UIImageView class ]]) {
            [tView removeFromSuperview];
        }
    }
    
    if ([[self.event.customersTaggedToEvent allObjects] count]==0) {
        
        [addUsersButton setFrame:CGRectMake(20, 20, 80, 80)];
        [self.selectedUsersScrollView addSubview:addUsersButton];
        
    }
    else
    {
        for (int i =0;i<[[self.event.customersTaggedToEvent allObjects] count]; i++)
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
            //recView.recipientContactNumber.text=userObject.phoneNumber;
           // recView.recipientLocation.text=userObject.userOrganisation;
            [self.selectedUsersScrollView addSubview:recView];
            [addUsersButton setFrame:CGRectMake(20+(i+1)*350, 20, 80, 80)];
            [self.selectedUsersScrollView addSubview:addUsersButton];
            
            
        }
    }
    
}



-(void)updateDocumentsScrollView
{   
    
    for (UIView * tView in [self.selectedDocumentsScrollView subviews]) {
        if (![tView isKindOfClass:[UIImageView class ]]) {
            [tView removeFromSuperview];
        }
    }
    
    if ([[self.event.filesTaggedToEvent allObjects] count]==0) {
        
        [addDocumentButton setFrame:CGRectMake(20, 20, 100, 100)];
        [self.selectedDocumentsScrollView addSubview:addDocumentButton];
        
    }
    else
    {
        for(int i=0;i<[[self.event.filesTaggedToEvent allObjects] count];i++)
        {
            File *sFile=(File *)[[self.event.filesTaggedToEvent allObjects] objectAtIndex:i];
            UIView *sView=[[UIView alloc]initWithFrame:CGRectMake(50+ 120 *i, 10, 100, 100)];
            
            UIImageView *sFileIcon=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
            
         //   sFileIcon.image=[UIImage imageNamed:@"pdf"];
            
            NSString *pathString=[NSString stringWithFormat:@"%@",sFile .filePath];

            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            
            dispatch_async(queue, ^{
                
               UIImage *pdfThumbNailImage=[Utils generateThumbNailIconForFile:pathString WithSize:CGSizeMake(60, 60)];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                 sFileIcon.image = pdfThumbNailImage;
                });
            });
            
            
            [sView addSubview:sFileIcon];
            
            UILabel *sFileNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 80, 100, 20)];
            sFileNameLabel.text=sFile.fileName;
            sFileNameLabel.font=[UIFont fontWithName:FONT_BOLD size:14];
            [sView addSubview:sFileNameLabel];
            
            [self.selectedDocumentsScrollView addSubview:sView];
            
            [addDocumentButton setFrame:CGRectMake(50+(i+1)*120, 20, 80, 80)];
            [self.selectedDocumentsScrollView addSubview:addDocumentButton];
        }
        
        [self.selectedDocumentsScrollView setContentSize:CGSizeMake([[self.event.filesTaggedToEvent allObjects] count] * 170, 0)];

    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addDocumentButtonClicked:(id)sender{
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Added Event Screen" withAction:@"Add Document Clicked" withLabel:event.eventTitle withValue:nil];
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

- (IBAction)addNewRecipients:(id)sender {
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Added Event Screen" withAction:@"Add Recipients Clicked" withLabel:event.eventTitle withValue:nil];
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


- (IBAction)eventCancelButtonClicked:(id)sender{
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView setAnimationDuration:0.50];
    [UIView commitAnimations];
    
}

- (IBAction)RemindMeButtonClicked:(id)sender{
    
}

- (IBAction)RescheduleButtonClicked:(id)sender{
    
}

- (IBAction)AddNotesButtonClicked:(id)sender{
    
}

- (IBAction)PlayButtonClicked:(id)sender{
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Added Event Screen" withAction:@"Play Button Clicked" withLabel:event.eventTitle withValue:nil];
    pptPaneView = [[PresentationPaneViewController alloc] initWithNibName:@"PresentationPaneViewController" bundle:nil];
    pptPaneView.pptEvent = self.event;
    
    [SAppDelegateObject.viewController.dashBoard.navigationController pushViewController:pptPaneView animated:YES];
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
         
        */
        
        self.event.relatedToContactID =customer.customerID;
        
        [self.event addCustomersTaggedToEventObject:customer];
        
        NSError *error=nil;
        
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Sorry, couldn't save Event %@", [error localizedDescription]);
        }
        
        NSLog(@"event customers: %@", self.event.customersTaggedToEvent);
        
        
    }
    [self updateRecipientsSrollView];
}


- (IBAction)DocumentButtonClicked:(id)sender{
    
    [ProductButton setTitleColor:[Utils colorFromHexString:@"868686"] forState:UIControlStateNormal];
    [RecentActivityButton setTitleColor:[Utils colorFromHexString:@"868686"] forState:UIControlStateNormal];
    [DocumentButton setTitleColor:[Utils colorFromHexString:ORANGE_COLOR_CODE] forState:UIControlStateNormal];

    [ProductButton setBackgroundImage:nil forState:UIControlStateNormal];
    [RecentActivityButton setBackgroundImage:nil forState:UIControlStateNormal];
    [DocumentButton setBackgroundImage: [UIImage imageNamed:@"tab_btn_new.png" ] forState:UIControlStateNormal];
}
- (IBAction)ProductButtonClicked:(id)sender{
    
    [ProductButton setTitleColor:[Utils colorFromHexString:ORANGE_COLOR_CODE] forState:UIControlStateNormal];
    [RecentActivityButton setTitleColor:[Utils colorFromHexString:@"868686"] forState:UIControlStateNormal];
    [DocumentButton setTitleColor:[Utils colorFromHexString:@"868686"] forState:UIControlStateNormal];
    [DocumentButton setBackgroundImage:nil forState:UIControlStateNormal];
    [RecentActivityButton setBackgroundImage:nil forState:UIControlStateNormal];
  [ProductButton setBackgroundImage: [UIImage imageNamed:@"tab_btn_new.png" ] forState:UIControlStateNormal];
}
- (IBAction)RecentActivityButtonClicked:(id)sender{
    [ProductButton setTitleColor:[Utils colorFromHexString:@"868686"] forState:UIControlStateNormal];
    [RecentActivityButton setTitleColor:[Utils colorFromHexString:ORANGE_COLOR_CODE] forState:UIControlStateNormal];
    [DocumentButton setTitleColor:[Utils colorFromHexString:@"868686"] forState:UIControlStateNormal];
    [ProductButton setBackgroundImage:nil forState:UIControlStateNormal];
    [DocumentButton setBackgroundImage:nil forState:UIControlStateNormal];
    [RecentActivityButton setBackgroundImage: [UIImage imageNamed:@"tab_btn_new.png" ] forState:UIControlStateNormal];
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
