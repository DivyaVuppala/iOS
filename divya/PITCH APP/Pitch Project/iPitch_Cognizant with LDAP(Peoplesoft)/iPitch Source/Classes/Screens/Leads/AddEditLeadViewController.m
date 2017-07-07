//
//  AddEditLeadViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/14/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "AddEditLeadViewController.h"
#import "iPitchConstants.h"
#import "AppDelegate.h"
#import "AsyncImageView.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "ZohoHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "ThemeHelper.h"
#import "SalesForceHelper.h"


@interface AddEditLeadViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *HUD;
    
    NSMutableArray *leadSourceListArray;
    NSMutableArray *leadStatusArray;
    NSMutableArray *leadRatingsArray;
    
    UIPopoverController *leadsCommonPopOver;
}

@property (nonatomic,retain)UIImagePickerController *imgPickerController;
@property (nonatomic,retain)UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UIScrollView *leadDetailsScrollView;

@property (retain, nonatomic) UITextField *leadFirstNameField;
@property (retain, nonatomic) UITextField *leadLastNameField;
@property (retain, nonatomic) UITextField *leadCompanyField;
@property (retain, nonatomic) UITextField *leadDepartmentField;
@property (retain, nonatomic) UITextField *leadEmailIDField;
@property (retain, nonatomic) UITextField *leadPhoneField;
@property (retain, nonatomic) UITextField *leadSkypeIDField;
@property (retain, nonatomic) UITextField *leadTwitterIDField;
@property (retain, nonatomic) UITextField *leadLinkedInIDField;
@property (retain, nonatomic) UITextField *leadMailingStreetNameField;
@property (retain, nonatomic) UITextField *leadMailingCityNameField;
@property (retain, nonatomic) UITextField *leadMailingStateNameField;
@property (retain, nonatomic) UITextField *leadMailingCountryNameField;
@property (retain, nonatomic) UITextField *leadMailingZIPField;
@property (retain, nonatomic) UIButton *leadRatingButton;
@property (retain, nonatomic) UIButton *leadStatusButotn;
@property (retain, nonatomic) UIButton *leadSourceButton;
@property (retain, nonatomic) UISwitch *leadFavouriteStatus;

@property (weak, nonatomic) IBOutlet UIImageView *leadIconImageView;
@end

@implementation AddEditLeadViewController

@synthesize leadFirstNameField;
@synthesize leadLastNameField;
@synthesize leadDepartmentField;
@synthesize leadEmailIDField;
@synthesize leadPhoneField;
@synthesize leadSkypeIDField;
@synthesize leadTwitterIDField;
@synthesize leadLinkedInIDField;
@synthesize leadMailingStreetNameField;
@synthesize leadMailingCityNameField;
@synthesize leadMailingStateNameField;
@synthesize leadMailingCountryNameField;
@synthesize leadMailingZIPField;
@synthesize leadDetailsScrollView;
@synthesize leadIconImageView;
@synthesize leadObject;


#define FIELD_VERTICAL_OFFSET 80.0
#define FIELD_HORIZONTAL_OFFSET 100.0
#define LABEL_WIDTH 150.0
#define LABEL_HEIGHT 20.0
#define TEXT_FIELD_WIDTH 250.0

//Lead Source Options
#define ADVERTISEMENT_PARAMETER @"Advertisement"
#define COLD_CALL_PARAMETER @"Cold Call"
#define EMPLOYEE_REFERRAL_PARAMETER @"Employee Referral"
#define EXTERNAL_REFERRAL_PARAMETER @"External Referral"
#define ONLINE_STORE_PARAMETER @"OnlineStore"
#define PARTNER_PARAMTER @"Partner"
#define PUBLIC_RELATIONS_PARAMTER @"Public Relations"
#define SALES_MAIL_ALIAS_PARAMTER @"Sales Mail Alias"
#define SEMINAR_PARTNER_PARAMTER @"Seminar Partner"
#define SEMINAR_INTERNAL_PARAMETER @"Seminar-Internal"
#define TRADE_SHOW_PARAMTER @"Trade Show"
#define WEB_DOWNLOAD_PARAMTER @"Web Download"
#define WEB_RESEARCH_PARAMTER @"Web Research"
#define CHAT_PARAMTER @"Chat"

//Lead Status
#define ATTEMPTED_TO_CONTACT @"Attempted to Contact"
#define CONTACT_IN_FUTURE @"Contact in Future"
#define CONTACTED @"Contacted"
#define JUNK_LEAD @"Junk Lead"
#define LOST_LEAD @"Lost Lead"
#define NOT_CONTACTED @"Not Contacted"
#define PRE_QUALIFIED @"Pre Qualified"

//Lead Rating

#define ACQUIRED @"Acquired"
#define ACTIVE @"Active"
#define MARKET_FAILED @"Market Failed"
#define PROJECT_CANCELLED @"Project Cancelled"
#define SHUTDOWN @"Shutdown"

#define LEAD_STATUS_TAG 2
#define LEAD_RATING_TAG 3
#define LEAD_SOURCE_TAG 4

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
        
    leadStatusArray=[[NSMutableArray alloc]initWithObjects:ATTEMPTED_TO_CONTACT,CONTACT_IN_FUTURE,CONTACTED,LOST_LEAD,NOT_CONTACTED,PRE_QUALIFIED, nil];
    leadRatingsArray=[[NSMutableArray alloc]initWithObjects:ACQUIRED,ACTIVE,MARKET_FAILED,PROJECT_CANCELLED,SHUTDOWN, nil];
    leadSourceListArray=[[NSMutableArray alloc]initWithObjects:ADVERTISEMENT_PARAMETER,EMPLOYEE_REFERRAL_PARAMETER,EXTERNAL_REFERRAL_PARAMETER,ONLINE_STORE_PARAMETER,PARTNER_PARAMTER,PUBLIC_RELATIONS_PARAMTER,SALES_MAIL_ALIAS_PARAMTER,SEMINAR_PARTNER_PARAMTER,SEMINAR_INTERNAL_PARAMETER,TRADE_SHOW_PARAMTER,WEB_DOWNLOAD_PARAMTER,WEB_RESEARCH_PARAMTER,CHAT_PARAMTER, nil];

    
    [self loadLeadDetails];
    
    self.leadIconImageView.image=[UIImage imageNamed:DEFAULT_USER_ICON];

    if(self.leadObject)
    {
        self.leadFirstNameField.text=self.leadObject.leadFirstName;
        self.leadLastNameField.text=self.leadObject.leadLastName;
        self.leadEmailIDField.text=self.leadObject.leadEmailID;
        self.leadPhoneField.text=self.leadObject.leadPhone;
        self.leadSkypeIDField.text=self.leadObject.leadSkypeID;
        self.leadTwitterIDField.text=self.leadObject.leadTwitterID;
        self.leadMailingCityNameField.text =   self.leadObject.mailingCity;
        self.leadMailingCountryNameField.text =   self.leadObject.mailingCountry;
        self.leadMailingStreetNameField.text =   self.leadObject.mailingStreet;
        self.leadMailingZIPField.text =   self.leadObject.mailingZIP;
        [self.leadRatingButton setTitle:self.leadObject.leadRating forState:UIControlStateNormal];
        [self.leadStatusButotn setTitle:self.leadObject.leadStatus forState:UIControlStateNormal];
        [self.leadSourceButton setTitle:self.leadObject.leadSource forState:UIControlStateNormal];
        
        if(self.leadObject.leadImageURL.length>0)
        [self.leadIconImageView setImageURL:[NSURL URLWithString:self.leadObject.leadImageURL]];
        [self.leadIconImageView.layer setCornerRadius:6];
        [self.leadIconImageView.layer setMasksToBounds:YES];
        
    }
    
    else
        
    {
        //adding new lead case
    }
    
    [self.leadDetailsScrollView.layer setCornerRadius:6];
    [self.leadDetailsScrollView.layer setMasksToBounds:YES];
    
    [self.leadDetailsScrollView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.05]];

    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [ThemeHelper applyCurrentThemeToView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}


- (BOOL)shouldAutorotate {
    
    return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation  == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

#pragma mark Custom UI Methods


- (void)loadLeadDetails
{
    //Add extra fields if needed here.
    
    CGFloat xFrame = 40.0;
    CGFloat yFrame = 30.0;
    
    self.leadFirstNameField =[[UITextField alloc]init];
    self.leadLastNameField =[[UITextField alloc]init];
    self.leadDepartmentField =[[UITextField alloc]init];
    self.leadEmailIDField =[[UITextField alloc]init];
    self.leadPhoneField =[[UITextField alloc]init];
    self.leadSkypeIDField =[[UITextField alloc]init];
    self.leadTwitterIDField =[[UITextField alloc]init];
    self.leadLinkedInIDField =[[UITextField alloc]init];
    self.leadMailingStreetNameField =[[UITextField alloc]init];
    self.leadMailingCityNameField =[[UITextField alloc]init];
    self.leadMailingStateNameField =[[UITextField alloc]init];
    self.leadMailingCountryNameField =[[UITextField alloc]init];
    self.leadMailingZIPField =[[UITextField alloc]init];
    self.leadCompanyField=[[UITextField alloc]init];

    
    [self addLabelWithText:@"First Name" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    [self addTextField:self.leadFirstNameField withText:self.leadObject.leadFirstName andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Last Name" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadLastNameField withText:self.leadObject.leadLastName andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Lead Title" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadDepartmentField withText:self.leadObject.leadTitle andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Lead Company" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadCompanyField withText:self.leadObject.leadCompany andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Lead Status" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    self.leadStatusButotn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.leadStatusButotn setFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    [self.leadStatusButotn setTitle:@"Click To Change" forState:UIControlStateNormal];
    [self.leadStatusButotn setTitleColor:[Utils colorFromHexString:GRAY_COLOR_CODE] forState:UIControlStateNormal];
    [self.leadStatusButotn addTarget:self action:@selector(popOverNeeded:) forControlEvents:UIControlEventTouchUpInside];
    [self.leadDetailsScrollView addSubview:self.leadStatusButotn];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Lead Rating" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    self.leadRatingButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.leadRatingButton setFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    [self.leadRatingButton setTitle:@"Click To Change" forState:UIControlStateNormal];
    [self.leadRatingButton setTitleColor:[Utils colorFromHexString:GRAY_COLOR_CODE] forState:UIControlStateNormal];
    [self.leadRatingButton addTarget:self action:@selector(popOverNeeded:) forControlEvents:UIControlEventTouchUpInside];
    [self.leadDetailsScrollView addSubview:self.leadRatingButton];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Lead Source" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    self.leadSourceButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.leadSourceButton setFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    [self.leadSourceButton setTitle:@"Click To Change" forState:UIControlStateNormal];
    [self.leadSourceButton setTitleColor:[Utils colorFromHexString:GRAY_COLOR_CODE] forState:UIControlStateNormal];
    [self.leadSourceButton addTarget:self action:@selector(popOverNeeded:) forControlEvents:UIControlEventTouchUpInside];
    [self.leadDetailsScrollView addSubview:self.leadSourceButton];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    
    [self addLabelWithText:@"Email ID" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadEmailIDField withText:self.leadObject.leadEmailID andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Twitter ID" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadTwitterIDField withText:self.leadObject.leadTwitterID andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"LinkedIn ID" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadLinkedInIDField withText:self.leadObject.leadLinkedInID andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Skype ID" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadSkypeIDField withText:self.leadObject.leadSkypeID andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Phone Number" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadPhoneField withText:self.leadObject.leadPhone andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing Street" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadMailingStreetNameField withText:self.leadObject.mailingStreet andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing City" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadMailingCityNameField withText:self.leadObject.mailingCity andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing State" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadMailingStateNameField withText:self.leadObject.mailingState andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing Country" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadMailingCountryNameField withText:self.leadObject.mailingCountry andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing ZIP" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.leadMailingZIPField withText:self.leadObject.mailingZIP andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
}


-(void)addLabelWithText:(NSString *)text andFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    [label setText:text];
    [label setTextAlignment:UITextAlignmentLeft];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:0];
    [label setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    label.textColor= [Utils colorFromHexString:ORANGE_COLOR_CODE];
    [self.leadDetailsScrollView addSubview:label];
    [self.leadDetailsScrollView setContentSize:CGSizeMake(0, frame.size.height + frame.origin.y+FIELD_VERTICAL_OFFSET)];
}

-(void)addTextField:(UITextField *)tField withText:(NSString *)text andFrame:(CGRect)frame
{
    [tField setFrame:frame];
    [tField setTextColor:[Utils colorFromHexString:GRAY_COLOR_CODE]];
    [tField setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [tField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tField setText:text];
    [tField setBorderStyle:UITextBorderStyleBezel];
    [tField setDelegate:self];
    [self.leadDetailsScrollView addSubview:tField];
    [self.leadDetailsScrollView setContentSize:CGSizeMake(0, frame.size.height + frame.origin.y+FIELD_VERTICAL_OFFSET)];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    if([self validateFields])
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"Saving Lead Details...";
        [self performSelectorInBackground:@selector(saveLeadDetailsBackgroundCall) withObject:nil];
    }
    else
    {
        [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY",  @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)popOverNeeded:(UIButton *) sender
{
    if([leadsCommonPopOver isPopoverVisible])
        [leadsCommonPopOver dismissPopoverAnimated:YES];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(200, 200);
    leadsCommonPopOver = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    
    [leadsCommonPopOver presentPopoverFromRect:sender.frame inView:self.leadDetailsScrollView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    UITableView *tblView =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 200, 200) style:UITableViewStylePlain];
    if (sender == self.leadRatingButton) {
        tblView.tag=LEAD_RATING_TAG;
        
    }
    else if(sender == self.leadSourceButton)
    {
        tblView.tag=LEAD_SOURCE_TAG;
        
    }
    else if(sender == self.leadStatusButotn)
    {
        tblView.tag=LEAD_STATUS_TAG;
        
    }
    tblView.dataSource=self;
    tblView.delegate=self;
    [popoverContent.view addSubview:tblView];

    
 
}

#pragma mark CRM Calls

- (void)saveLeadDetailsBackgroundCall
{
    BOOL addStatus=NO;

    
    NSMutableDictionary *leadDetails=[[NSMutableDictionary alloc]init];
    
    [leadDetails setObject:self.leadFirstNameField.text forKey:ZOHO_FIRST_NAME_PARAMETER];
    [leadDetails setObject:self.leadLastNameField.text forKey:ZOHO_LAST_NAME_PARAMETER];
    [leadDetails setObject:self.leadDepartmentField.text forKey:ZOHO_DESIGNATION_PARAMETER];
    [leadDetails setObject:self.leadCompanyField.text forKey:ZOHO_COMPANY_PARAMETER];
    [leadDetails setObject:self.leadPhoneField.text forKey:ZOHO_PHONE_PARAMETER];
    [leadDetails setObject:self.leadEmailIDField.text forKey:ZOHO_EMAIL_PARAMETER];
    [leadDetails setObject:self.leadTwitterIDField.text forKey:ZOHO_TWITTER_ID_PARAMETER];
    [leadDetails setObject:self.leadLinkedInIDField.text forKey:ZOHO_LINKEDIN_PARAMETER];
    [leadDetails setObject:self.leadSkypeIDField.text forKey:ZOHO_SKYPE_PARAMETER];
    [leadDetails setObject:self.leadMailingStreetNameField.text forKey:ZOHO_STREET_PARAMETER];
    [leadDetails setObject:self.leadMailingCityNameField.text forKey:ZOHO_CITY_PARAMETER];
    [leadDetails setObject:self.leadMailingStateNameField.text forKey:ZOHO_STAGE_PARAMETER];
    [leadDetails setObject:self.leadMailingStateNameField.text forKey:ZOHO_STATE_PARAMETER];

    [leadDetails setObject:self.leadMailingCountryNameField.text forKey:ZOHO_COUNTRY_PARAMETER];
    [leadDetails setObject:self.leadMailingZIPField.text forKey:ZOHO_ZIP_CODE_PARAMETER];
    [leadDetails setObject:self.leadStatusButotn.titleLabel.text forKey:ZOHO_LEAD_STATUS_PARAMETER];
    [leadDetails setObject:self.leadRatingButton.titleLabel.text forKey:ZOHO_RATING_PARAMETER];
    [leadDetails setObject:self.leadSourceButton.titleLabel.text forKey:ZOHO_LEAD_SOURCE_PARAMETER];
    

    if(self.leadObject)
    {
        
        /*ZohoHelper *zohoObject=[[ZohoHelper alloc]init];
        
        addStatus= [zohoObject updateDetailsForZohoEntity:LeadModule WithID:self.leadObject.leadID withDetails:leadDetails];
        if(addStatus)
        {
            [zohoObject FetchLeadsFromZoho];
            [zohoObject FetchRelatedActivitiesForEntity: LEADS_MODULE :self.leadObject.leadID];
            [zohoObject TagEventsToLead];
        }*/
        
        
        SalesForceHelper *sfdcObject=[[SalesForceHelper alloc]init];
        addStatus = [sfdcObject editLeadWithLeadID:self.leadObject.leadID andDetails:leadDetails];

    }
    else
    {
        
        /*ZohoHelper *zohoObject=[[ZohoHelper alloc]init];
        
        addStatus= [zohoObject addLeadToZohoWithDetails:leadDetails];
        if(addStatus)
        {
            [zohoObject FetchLeadsFromZoho];
        }*/
        
        SalesForceHelper *sfdcObject=[[SalesForceHelper alloc]init];
        addStatus = [sfdcObject addLeadWithDetails:leadDetails];


    }
    [self performSelectorOnMainThread:@selector(updateAfterLeadBackgroundCall:) withObject:[NSNumber numberWithBool:addStatus] waitUntilDone:YES];
}

- (void)updateAfterLeadBackgroundCall :(NSNumber *)status
{
    
    [HUD hide:YES];
    
    if([status boolValue])
    {
        if([self.delegate respondsToSelector:@selector(leadDataSavedSuccessfully)])
        {
            [self.delegate leadDataSavedSuccessfully];
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(leadDataSaveFailedWithError:)])
        {
            [self.delegate leadDataSaveFailedWithError:[NSError errorWithDomain:@"Could not save Lead data try again" code:110 userInfo:nil]];
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)validateFields
{
    
    if(self.leadFirstNameField.text.length == 0)
        return NO;
    else if(self.leadLastNameField.text.length ==0)
        return NO;
    else if(self.leadEmailIDField.text.length ==0)
        return NO;
    else if (self.leadPhoneField.text.length==0)
        return NO;
    else if(self.leadSkypeIDField.text.length==0)
        return NO;
    else if (self.leadTwitterIDField.text.length ==0)
        return NO;
    else if (self.leadLinkedInIDField.text.length ==0)
        return NO;
    else if (self.leadMailingCityNameField.text.length ==0)
        return NO;
    else if (self.leadMailingCountryNameField.text.length ==0)
        return NO;
    else if (self.leadMailingStreetNameField.text.length ==0)
        return NO;
    else if (self.leadMailingZIPField.text.length ==0)
        return NO;
    else if (self.leadMailingStateNameField.text.length ==0)
        return NO;
    else if (self.leadCompanyField.text.length ==0)
        return NO;
    else if(self.leadSourceButton.titleLabel.text.length == 0 || [self.leadSourceButton.titleLabel.text isEqualToString:@"Click To Change"])
        return NO;
    else if(self.leadRatingButton.titleLabel.text.length == 0 || [self.leadRatingButton.titleLabel.text isEqualToString:@"Click To Change"])
        return NO;
    else if(self.leadStatusButotn.titleLabel.text.length == 0 || [self.leadStatusButotn.titleLabel.text isEqualToString:@"Click To Change"])
        return NO;

    else
        return YES;
}

#pragma mark TextField Delegates and Other Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void) animateTextField: (BOOL) up
{
    CGRect temp=self.view.frame;
    const int movementDistance = 80;
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


#pragma mark TableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == LEAD_RATING_TAG)
        return [leadRatingsArray count];
    else if (tableView.tag == LEAD_SOURCE_TAG)
        return [leadSourceListArray count];
    else if (tableView.tag == LEAD_STATUS_TAG)
        return [leadStatusArray count];
    else
        return 0;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    else
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    if (tableView.tag == LEAD_RATING_TAG)
    {
        cell.textLabel.text=[leadRatingsArray objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:16];
        cell.textLabel.textColor=[Utils colorFromHexString:@"868686"];
        
    }
    
    else if(tableView.tag == LEAD_SOURCE_TAG)
    {
        cell.textLabel.text=[leadSourceListArray objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:16];
        cell.textLabel.textColor=[Utils colorFromHexString:@"868686"];
    }
    else if(tableView.tag == LEAD_STATUS_TAG)
    {
        cell.textLabel.text=[leadStatusArray objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:16];
        cell.textLabel.textColor=[Utils colorFromHexString:@"868686"];
    }
    
    return cell;
}


#pragma mark TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([leadsCommonPopOver isPopoverVisible])
        [leadsCommonPopOver dismissPopoverAnimated:YES];
    
    if(tableView.tag==LEAD_RATING_TAG)
        [self.leadRatingButton setTitle:[leadRatingsArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    else if(tableView.tag==LEAD_SOURCE_TAG)
        [self.leadSourceButton setTitle:[leadSourceListArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    else if(tableView.tag==LEAD_STATUS_TAG)
        [self.leadStatusButotn setTitle:[leadStatusArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
}

@end
