//
//  AddEditAccountsViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/10/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "AddEditAccountsViewController.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import "ZohoConstants.h"
#import <QuartzCore/QuartzCore.h>
#import "ZohoHelper.h"
#import "MBProgressHUD.h"
#import "ThemeHelper.h"
#import "SalesForceHelper.h"

@interface AddEditAccountsViewController ()<UITextFieldDelegate>
{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIImageView *accountIconImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *accountDetailsScrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, retain) UITextField *accountNameField;
@property (nonatomic, retain) UITextField *acconuntPhoneNoField;
@property (nonatomic, retain) UITextField *accountWebSiteField;
@property (nonatomic, retain) UITextField *annualRevenueField;
@property (nonatomic, retain) UITextField *mailingCityField;
@property (nonatomic, retain) UITextField *mailingCountryField;
@property (nonatomic, retain) UITextField *mailingStateField;
@property (nonatomic, retain) UITextField *mailingStreetField;
@property (nonatomic, retain) UITextField *mailingZIPField;
@property (nonatomic, retain) UITextField *numberOfEmployeesField;


- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

#define FIELD_VERTICAL_OFFSET 80.0
#define FIELD_HORIZONTAL_OFFSET 100.0
#define LABEL_WIDTH 150.0
#define LABEL_HEIGHT 20.0
#define TEXT_FIELD_WIDTH 250.0


@implementation AddEditAccountsViewController

@synthesize accountObject,delegate;
@synthesize accountDetailsScrollView,accountIconImageView,cancelButton,saveButton;
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
    
    
    [self loadCustomerFields];
    
    if(self.accountObject)
    {
            
        self.accountNameField.text=self.accountObject.accountName;
        self.acconuntPhoneNoField.text=self.accountObject.acconuntPhoneNo;
        self.accountWebSiteField.text=self.accountObject.accountWebSite;
        self.annualRevenueField.text=self.accountObject.annualRevenue;
        self.mailingCityField.text=self.accountObject.mailingCity;
        self.mailingCountryField.text =   self.accountObject.mailingCountry;
        self.mailingStateField.text =   self.accountObject.mailingState;
        self.mailingStreetField.text =   self.accountObject.mailingStreet;
        self.mailingZIPField.text =   self.accountObject.mailingZIP;
        self.numberOfEmployeesField.text =   self.accountObject.numberOfEmployees;


        [self.accountIconImageView.layer setCornerRadius:6];
        [self.accountIconImageView.layer setMasksToBounds:YES];
        
    }
    
    [self.accountDetailsScrollView.layer setCornerRadius:6];
    [self.accountDetailsScrollView.layer setMasksToBounds:YES];
    
    [self.accountDetailsScrollView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.05]];

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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation  == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

- (void)viewDidUnload {
    [self setAccountIconImageView:nil];
    [self setAccountDetailsScrollView:nil];
    [self setCancelButton:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
}

-(BOOL)validateFields
{
    if(self.accountNameField.text.length == 0)
        return NO;
    else if(self.acconuntPhoneNoField.text.length ==0)
        return NO;
    else if(self.accountWebSiteField.text.length ==0)
        return NO;
    else if (self.annualRevenueField.text.length==0)
        return NO;
    else if(self.mailingCityField.text.length==0)
        return NO;
    else if (self.mailingCountryField.text.length ==0)
        return NO;
    else if (self.mailingStreetField.text.length ==0)
        return NO;
    else if (self.mailingZIPField.text.length ==0)
        return NO;
    else if (self.numberOfEmployeesField.text.length ==0)
        return NO;
    else if (self.mailingStateField.text.length ==0)
        return NO;
    else
        return YES;
}
- (void)loadCustomerFields
{
    //Add extra fields if needed here.
    
    CGFloat xFrame = 40.0;
    CGFloat yFrame = 30.0;
        
    self.accountNameField =[[UITextField alloc]init];
    self.acconuntPhoneNoField =[[UITextField alloc]init];
    self.accountWebSiteField =[[UITextField alloc]init];
    self.annualRevenueField =[[UITextField alloc]init];
    self.mailingCityField =[[UITextField alloc]init];
    self.mailingCountryField =[[UITextField alloc]init];
    self.mailingStateField =[[UITextField alloc]init];
    self.mailingZIPField =[[UITextField alloc]init];
    self.mailingStreetField =[[UITextField alloc]init];
    self.numberOfEmployeesField =[[UITextField alloc]init];
    
    [self addLabelWithText:@"Account Name" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    [self addTextField:self.accountNameField withText:self.accountObject.accountName andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Phone Number" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.acconuntPhoneNoField withText:self.accountObject.acconuntPhoneNo andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Account Website" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.accountWebSiteField withText:self.accountObject.accountWebSite andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Annual Revenue" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.annualRevenueField withText:self.accountObject.annualRevenue andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Number Of Employees" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.numberOfEmployeesField withText:self.accountObject.numberOfEmployees andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];

    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing Street" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.mailingStreetField withText:self.accountObject.mailingStreet andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing City" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.mailingCityField withText:self.accountObject.mailingCity andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing State" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.mailingStateField withText:self.accountObject.mailingState andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing Country" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.mailingCountryField withText:self.accountObject.mailingCountry andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing ZIP" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.mailingZIPField withText:self.accountObject.mailingZIP andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
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
    [self.accountDetailsScrollView addSubview:label];
    [self.accountDetailsScrollView setContentSize:CGSizeMake(0, frame.size.height + frame.origin.y+FIELD_VERTICAL_OFFSET)];
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
    [self.accountDetailsScrollView addSubview:tField];
    [self.accountDetailsScrollView setContentSize:CGSizeMake(0, frame.size.height + frame.origin.y+FIELD_VERTICAL_OFFSET)];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    if([self validateFields])
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"Saving Customer Details...";
        [self performSelectorInBackground:@selector(saveAccountDetailsBackgroundCall) withObject:nil];
    }
    
    else
    {
        [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY",  @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark CRM Calls

- (void)saveAccountDetailsBackgroundCall
{
    NSMutableDictionary *accoutnDetails=[[NSMutableDictionary alloc]init];
    
    [accoutnDetails setObject:self.accountNameField.text forKey:ZOHO_ACCOUNT_NAME_PARAMETER];
    [accoutnDetails setObject:self.acconuntPhoneNoField.text forKey:ZOHO_PHONE_PARAMETER];
    [accoutnDetails setObject:self.accountWebSiteField.text forKey:ZOHO_WEBSITE_PARAMETER];
    [accoutnDetails setObject:self.annualRevenueField.text forKey:ZOHO_ACCOUNT_REVENUE_PARAMETER];
    [accoutnDetails setObject:self.mailingCityField.text forKey:ZOHO_MAILING_CITY_PARAMETER];
    [accoutnDetails setObject:self.mailingCountryField.text forKey:ZOHO_MAILING_COUNTRY_PARAMETER];
    [accoutnDetails setObject:self.mailingStateField.text forKey:ZOHO_MAILING_STATE_PARAMETER];
    [accoutnDetails setObject:self.mailingZIPField.text forKey:ZOHO_MAILING_ZIP_PARAMETER];
    [accoutnDetails setObject:self.mailingStreetField.text forKey:ZOHO_MAILING_STREET_PARAMETER];
    [accoutnDetails setObject:self.numberOfEmployeesField.text forKey:ZOHO_EMPLOYESS_PARAMETER];

    /*ZohoHelper *zohoObject=[[ZohoHelper alloc]init];
    
    BOOL addStatus=NO;
    addStatus= [zohoObject updateDetailsForZohoEntity:AccountsModule WithID:self.accountObject.accountID withDetails:accoutnDetails];*/
    SalesForceHelper *sfdcObject = [[SalesForceHelper alloc]init];
    BOOL addStatus= [sfdcObject editAccountWithID:self.accountObject.accountID withDetails:accoutnDetails];
    
    /*if(addStatus)
    {
        [zohoObject FetchAccountsFromZoho];
        [zohoObject FetchRelatedActivitiesForEntity: ACCOUNTS_ENTITY :self.accountObject.accountID];
        [zohoObject TagActivitiesToAccounts];
        [zohoObject FetchRelatedOpportunitiesForEntity:ACCOUNTS_ENTITY :self.accountObject.accountID];
        [zohoObject TagOpportunitiesToAccounts];


    }*/
    
    [self performSelectorOnMainThread:@selector(updateAfterAccountBackgroundCall:) withObject:[NSNumber numberWithBool:addStatus] waitUntilDone:YES];
}

- (void)updateAfterAccountBackgroundCall :(NSNumber *)status
{
    
    [HUD hide:YES];
    
    if([status boolValue])
    {
        if([self.delegate respondsToSelector:@selector(accountDataSavedSuccessfully)])
        {
            [self.delegate accountDataSavedSuccessfully];
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(accountDataSaveFailedWithError:)])
        {
            [self.delegate accountDataSaveFailedWithError:[NSError errorWithDomain:@"Could not save Customer data save again" code:110 userInfo:nil]];
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


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
@end
