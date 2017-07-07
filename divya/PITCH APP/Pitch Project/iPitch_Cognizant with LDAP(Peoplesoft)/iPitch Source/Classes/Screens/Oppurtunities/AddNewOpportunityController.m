//
//  AddNewOpportunityController.m
//  iPitch V2
//
//  Created by Swarnava(376755) on 4/29/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

/*
 
 THIS CLASS IS USED FOR SHOWING EXISTING ACCOUNT DETAILS
 
 */

#import "AddNewOpportunityController.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import "MBProgressHUD.h"
#import "Customers.h"
#import "AppDelegate.h"
#import "ZohoConstants.h"
#import "ZohoHelper.h"
#import "SalesForceHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "NetworkServiceHandler.h"
#import "products.h"

@implementation UINavigationController (DelegateAutomaticDismissKeyboard)

- (BOOL)disablesAutomaticKeyboardDismissal {
    return [self.topViewController disablesAutomaticKeyboardDismissal];
}

@end

@interface AddNewOpportunityController ()
{
    UIDatePicker *datePicker;
    UIAlertView *oppClosingDateAlert;
    
    NSMutableArray *accountsArray;
    NSMutableArray *oppTypesArray;
    NSMutableArray *oppStagesArray;
    
    UIPopoverController *oppsCommonPopOver;
    MBProgressHUD *HUD;
    
    BOOL editMode;
    NSMutableArray *productArray;
    int initialY;
    UIScrollView *scrollProduct;
    NSMutableDictionary *differentProducts;
    UITableView *productTable;
    UIPopoverController *SearchPopoverController;
    int clickedButton;
    NSString *strTVC;
    NSString *strYear;
    BOOL keyBoardVisible;
    int currentY;
    __weak IBOutlet UIBarButtonItem *cancelButton;
    __weak IBOutlet UIBarButtonItem *saveButton;
    __weak IBOutlet UIToolbar *toolBar;
}
@end


#define TYPES_TABLE_TAG 2
#define STAGES_TABLE_TAG 3

#define EXISTING_BUSINESS_TYPE @"Existing Business"
#define NEW_BUSINESS_TYPE @"New Business"

#define QUALIFICATION_STAGE @"Qualification"
#define NEEDS_ANALYSIS_STAGE @"Needs Analysis"
#define VALUE_PROPOSITION_STAGE @"Value Proposition"
#define DECISION_MAKER_STAGE @"Id. Decision Makers"
#define PROPOSAL_STAGE @"Proposal/Price Quote"
#define NEGOTIATION_STAGE @"Negotiation/Review"
#define CLOSED_WON_STAGE @"Closed Won"
#define CLOSED_LOST_STAGE @"Closed Lost"
#define CLOSED_LOST_TO_COMPETITION_STAGE @"Closed Lost to Competition"

@implementation AddNewOpportunityController

@synthesize saveButton,cancelButton,opportunityObject,delegate,txtSubject,formatter;
@synthesize txtTVC,txtClosedate,txtDeal,txtFirstYear,btnDate,edit,accountObject,titleLbl,addBtn,sucessDelegate,lblID,txtID;

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
    
    [toolBar setBarTintColor:[UIColor whiteColor]];
    
    [cancelButton setTintColor:[UIColor whiteColor]];
    [saveButton setTintColor:[UIColor whiteColor]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resizePopUpWhenKeyboardVisible) name:@"resizePopUpWhenKeyboardVisible" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resizePopUpWhenKeyboardHidden) name:@"resizePopUpWhenKeyboardHidden" object:nil];
    
    oppStagesArray=[[NSMutableArray alloc]initWithObjects:QUALIFICATION_STAGE, NEEDS_ANALYSIS_STAGE,
                    VALUE_PROPOSITION_STAGE,
                    DECISION_MAKER_STAGE,
                    PROPOSAL_STAGE,
                    NEGOTIATION_STAGE,
                    CLOSED_WON_STAGE,
                    CLOSED_LOST_STAGE,
                    CLOSED_LOST_TO_COMPETITION_STAGE, nil];
    
    
    oppTypesArray=[[NSMutableArray alloc]initWithObjects:EXISTING_BUSINESS_TYPE, NEW_BUSINESS_TYPE,nil];
    
    
    if(self.opportunityRelatedToModule == CustomerModule)
    {
        self.contactNameLabel.text=[NSString stringWithFormat:@"%@ %@",  self.customerObject.firstName , self.customerObject.lastName];
        self.accountNameLabel.text=self.customerObject.accountName;
    }
    
    else if(self.opportunityRelatedToModule == AccountsModule)
    {
        //self.accountNameLabel.text=self.accountObject.accountName;
        self.contactNameLabel.text=NOTAPPLICABLE_PARAMETER;
    }
    
    txtSubject.layer.cornerRadius =10.0f;
    txtSubject.layer.borderWidth=2.0;
    txtSubject.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    
    if(edit)
    {
        lblID.hidden = FALSE;
        txtID.hidden = FALSE;
        //txtSubject.frame = CGRectMake(385,119,270,79);
        
        [self loadValuesEdit];
        [self editOpportunity];
        titleLbl.text = @"Edit Opportunity Details";
        addBtn.hidden = TRUE;
    }
    else
    {
        lblID.hidden = TRUE;
        txtID.hidden = TRUE;
        //txtSubject.frame = CGRectMake(385,119,270,119);
        
        scrollProduct = [[UIScrollView alloc]initWithFrame:CGRectMake(10,535,654,90)];//80
        [scrollProduct setBackgroundColor:[UIColor clearColor]];
        [scrollProduct setDelegate:self];
        [self.view addSubview:scrollProduct];
        
        productArray = [[NSMutableArray alloc]init];
        
        //LOADING ALL PRODUCTS
        
        differentProducts = [[NSMutableDictionary alloc]init];
        
        [differentProducts setValue:@"Analytics" forKey:@"ANALYTICS"];
        [differentProducts setValue:@"Application Development" forKey:@"APP_DEV"];
        [differentProducts setValue:@"Advanced Solution Practice" forKey:@"ASG"];
        [differentProducts setValue:@"Application Outsoucing/AVM" forKey:@"AVM"];
        [differentProducts setValue:@"BPaaS" forKey:@"BPAAS"];
        [differentProducts setValue:@"BPO" forKey:@"BPO"];
        [differentProducts setValue:@"CBC" forKey:@"CBC"];
        [differentProducts setValue:@"CLOUD" forKey:@"CLOUD"];
        [differentProducts setValue:@"CLOUD ONE" forKey:@"CLOUDONE"];
        [differentProducts setValue:@"Consulting Sevices" forKey:@"CONSULT"];
        [differentProducts setValue:@"Corp. Reputation & Compliance" forKey:@"CRC"];
        [differentProducts setValue:@"DA CoE" forKey:@"DACOE"];
        [differentProducts setValue:@"Data Warehousing" forKey:@"DAT_WAR"];
        [differentProducts setValue:@"EAS - BPM" forKey:@"EAS - BPM"];
        [differentProducts setValue:@"EAS - CBC" forKey:@"EAS - CBC"];
        [differentProducts setValue:@"EAS - Cloud" forKey:@"EAS - CLOU"];
        [differentProducts setValue:@"EAS - CRM" forKey:@"EAS - CRM"];
        [differentProducts setValue:@"EAS - EDM" forKey:@"EAS - EDM"];
        [differentProducts setValue:@"EAS - Oracle" forKey:@"EAS - ORAC"];
        [differentProducts setValue:@"EAS - SAP" forKey:@"EAS - SAP"];
        [differentProducts setValue:@"EAS - Supply chain Management" forKey:@"EAS-SCM"];
        [differentProducts setValue:@"Engineering & Manufacturing Solns" forKey:@"EMS"];
        [differentProducts setValue:@"External Communities" forKey:@"EXCOM"];
        [differentProducts setValue:@"Filenet" forKey:@"FNET"];
        [differentProducts setValue:@"Global Technology Office" forKey:@"GTO"];
        [differentProducts setValue:@"IT infrastructure (ITIS)" forKey:@"ITIS"];
        [differentProducts setValue:@"Mobility" forKey:@"MBT"];
        [differentProducts setValue:@"Others" forKey:@"OTHER"];
        [differentProducts setValue:@"Program Management Consulting" forKey:@"PMC"];
        [differentProducts setValue:@"Process Quality Consultancy" forKey:@"PQC"];
        [differentProducts setValue:@"SAP / DWBI" forKey:@"SAPDW"];
        [differentProducts setValue:@"Social Consulting & Stratedgy" forKey:@"SCS"];
        [differentProducts setValue:@"Enterprise Social" forKey:@"SENTPRISE"];
        [differentProducts setValue:@"Silvers" forKey:@"SLIVERS"];
        [differentProducts setValue:@"Quality Engineering & Assurance" forKey:@"TESTING"];
        
        initialY = 2;
        [self loadValuesAdd];
        titleLbl.text = @"Add Opportunity";
        addBtn.hidden = FALSE;
    }
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCancelButton:nil];
    [self setSaveButton:nil];
    [self setOpportunityNameField:nil];
    [self setOpportunityAmountField:nil];
    [self setOpportunityClosingDateButton:nil];
    [self setOpportunityProbabilityField:nil];
    [self setOpportunityNextStepField:nil];
    [self setOpportunityDescriptionField:nil];
    [self setOpportunityTypeButton:nil];
    [self setOpportunityTypeButton:nil];
    [self setAccountNameLabel:nil];
    [self setContactNameLabel:nil];
    [super viewDidUnload];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)opportunityStageButtonPressed:(id)sender {
    
    if([oppsCommonPopOver isPopoverVisible])
        [oppsCommonPopOver dismissPopoverAnimated:YES];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(200, 200);
    oppsCommonPopOver = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [oppsCommonPopOver presentPopoverFromRect:((UIButton *)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    UITableView *tblView =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 200, 200) style:UITableViewStylePlain];
    tblView.tag=STAGES_TABLE_TAG;
    tblView.dataSource=self;
    tblView.delegate=self;
    [popoverContent.view addSubview:tblView];
    
}

- (IBAction)opportunityTypeButtonPressed:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if([oppsCommonPopOver isPopoverVisible])
        [oppsCommonPopOver dismissPopoverAnimated:YES];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(200, 200);
    oppsCommonPopOver = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [oppsCommonPopOver presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    UITableView *tblView =[[UITableView alloc]initWithFrame:CGRectMake(0, btn.frame.origin.y, 200, 200) style:UITableViewStylePlain];
    tblView.tag=TYPES_TABLE_TAG;
    tblView.dataSource=self;
    tblView.delegate=self;
    [popoverContent.view addSubview:tblView];
}




#pragma mark TxtField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}




/**
 *	This method animates the Login screen while entering user credentials
 */

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    CGRect temp=self.view.frame;
    const int movementDistance = 250;
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




#pragma mark CHANGES BY SWARNAVA



// Design product section for Edit Opportunity which is not editable

-(void)editOpportunity
{
    //add Product Fields
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(10,535,654,80)];
    [scroll setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:scroll];
    
    int y = 15;
    
    if(opportunityObject.productArray)
    {
        for (int i=0; i<[opportunityObject.productArray count]; i++) {
            
            products *obj = [opportunityObject.productArray objectAtIndex:i];
            UIView *productView = [[UIView alloc]init];
            [productView setFrame:CGRectMake(10,y,654,40)];
            [productView setBackgroundColor:[UIColor clearColor]];
            
            //Add Subviews
            
            //Primary
            UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [checkBtn setUserInteractionEnabled:FALSE];
            checkBtn.tag = 100;
            [checkBtn setFrame:CGRectMake(63,5,28,28)];
            [checkBtn setBackgroundColor:[UIColor clearColor]];
            if([obj.Primaryflag isEqualToString:@"Y"])
            {
                [checkBtn setBackgroundImage:[UIImage imageNamed:CHECK_SELECT] forState:UIControlStateNormal];
                [checkBtn setBackgroundImage:[UIImage imageNamed:CHECK_SELECT] forState:UIControlStateSelected];
            }
            else
            {
                [checkBtn setBackgroundImage:[UIImage imageNamed:CHECK_DESELECT] forState:UIControlStateNormal];
                [checkBtn setBackgroundImage:[UIImage imageNamed:CHECK_DESELECT] forState:UIControlStateSelected];
            }
            [productView addSubview:checkBtn];
            
            
            //Product Group
            UITextField *txtProduct = [[UITextField alloc]initWithFrame:CGRectMake(137,5,266,30)];
            [txtProduct setBackgroundColor:[UIColor clearColor]];
            [txtProduct setBorderStyle:UITextBorderStyleRoundedRect];
            [txtProduct setUserInteractionEnabled:NO];
            txtProduct.tag = 101;
            [txtProduct setTextAlignment:UITextAlignmentCenter];
            [txtProduct setText:[obj Productdescription]];
            [txtProduct setFont:[UIFont fontWithName:FONT_BOLD size:17]];
            [txtProduct setTextColor:[UIColor lightGrayColor]];
            [productView addSubview:txtProduct];
            
            
            //Percentage
            UITextField *txtPercentage = [[UITextField alloc]initWithFrame:CGRectMake(430,5,176,30)];
            [txtPercentage setBackgroundColor:[UIColor clearColor]];
            [txtPercentage setBorderStyle:UITextBorderStyleRoundedRect];
            [txtPercentage setUserInteractionEnabled:NO];
            txtPercentage.tag = 102;
            [txtPercentage setText:[obj Splitpercentage]];
            [txtPercentage setFont:[UIFont fontWithName:FONT_BOLD size:17]];
            [txtPercentage setTextColor:[UIColor lightGrayColor]];
            [txtPercentage setTextAlignment:UITextAlignmentCenter];
            [productView addSubview:txtPercentage];
            
            [scroll addSubview:productView];
            
            y+= 40;
        }
    }
    
    [scroll setContentSize:CGSizeMake(654,y+20)];
}


// Display values in the UI during ADD opportunity

-(void)loadValuesAdd
{
    _opportunityNameField.text = accountObject.companyName;
}

// Display values in the UI during edit opportunity

-(void)loadValuesEdit
{
    strTVC = opportunityObject.TCV;
    strYear = opportunityObject.Firstyear;
    txtID.text = opportunityObject.OpportunityId;
    
    formatter = [[NSNumberFormatter alloc]init];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    _opportunityNameField.text = opportunityObject.CustomerName;
    txtSubject.text = opportunityObject.OpportunityName;
    txtTVC.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[opportunityObject.TCV  doubleValue]]];
    txtFirstYear.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[opportunityObject.Firstyear doubleValue]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *closeDate = [dateFormatter dateFromString:opportunityObject.EstimatedClosedate];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];

    NSLog(@"close date: %@",[dateFormatter stringFromDate:closeDate]);
    
    txtClosedate.text = [dateFormatter stringFromDate:closeDate];
    txtDeal.text = opportunityObject.DealDuration;
}


//It checks all the validations and if passed,allows users to edit or ADD oppotunities

- (IBAction)saveButtonClicked:(id)sender {
    
    if([self validateFields])
    {
        if(edit)
        {
            if([Reachability connected])
            {
                HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                HUD.labelText = UPDATE_OPPORTUNITY;
                [self performSelectorInBackground:@selector(saveOppBackgroundCall) withObject:nil];
            }
            else{
                HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [HUD hide:YES afterDelay:3];
                HUD.mode =MBProgressHUDModeText;
                HUD.labelText=INTERNET_NOT_FOUND ;
            }
        }
        else
        {
            if([Reachability connected])
            {
                if(!accountObject.companyID.length >0)
                {
                    [Utils showMessage:@"Cannot Create Opportunity For Account Without Primary Contact!" withTitle:@"Error"];
                    return;
                }
                HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                HUD.labelText = ADD_OPPORTUNITY;
                [NSThread detachNewThreadSelector:@selector(addOpportunityService:) toTarget:self withObject:[self createXML]];
            }
            else{
                HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [HUD hide:YES afterDelay:3];
                HUD.mode =MBProgressHUDModeText;
                HUD.labelText= INTERNET_NOT_FOUND ;
            }
        }
    }
}


//In ADD Opportunity,it creates the input XML before sending it to the server ,based on user inputs.

-(NSMutableDictionary *)createXML
{
    
    NSMutableString *xml = [[NSMutableString alloc]init];
    [xml setString:@""];
    for(UIView *view in productArray)
    {
        NSString *PrimaryProduct;
        UITextField *txtProduct =  (UITextField *) [view viewWithTag:201];
        UITextField *txtProd =  (UITextField *) [view viewWithTag:202];
        UIButton *check = (UIButton *) [view viewWithTag:200];
        if(check.imageView.tag == 1)
            PrimaryProduct = @"Y";
        else   if(check.imageView.tag == 0)
            PrimaryProduct = @"N";
        
        [xml appendString:@"<ProductDetails>"];
        [xml appendString:[NSString stringWithFormat:@"<ServiceLine>%@</ServiceLine>",[[differentProducts allKeysForObject:txtProduct.text] objectAtIndex:0]]];
        [xml appendString:[NSString stringWithFormat:@"<Product></Product>"]];
        [xml appendString:[NSString stringWithFormat:@"<HBDM></HBDM>"]];
        [xml appendString:[NSString stringWithFormat:@"<SplitPercentage>%d</SplitPercentage>",[txtProd.text intValue]]];
        [xml appendString:[NSString stringWithFormat:@"<PrimaryProduct>%@</PrimaryProduct>",PrimaryProduct]];
        [xml appendString:@"</ProductDetails>"];
    }
    
    NSMutableDictionary *detailsDictionary=[[NSMutableDictionary alloc]init];
    
    [detailsDictionary setObject:accountObject.companyID forKey:@"CustomerID"];
    [detailsDictionary setObject:[[ModelTrackingClass sharedInstance]userID] forKey:@"OppOwner"];
    [detailsDictionary setObject:txtSubject.text forKey:@"OpportunityName"];
    [detailsDictionary setObject:txtTVC.text forKey:@"TCV"];
    [detailsDictionary setObject:txtFirstYear.text forKey:@"firstYear"];
    [detailsDictionary setObject:txtClosedate.text forKey:@"closeDate"];
    [detailsDictionary setObject:txtDeal.text forKey:@"Deal"];
    [detailsDictionary setObject:xml forKey:@"productXML"];
    
    return detailsDictionary;
}

//Call Back method for Opportunity Creation

-(void)addOpportunityService:(NSMutableDictionary *)detailsDictionary
{
    
    SalesForceHelper *sfdcObject=[[SalesForceHelper alloc]init];
    NSError *error = [sfdcObject createOpportunity:detailsDictionary];
    
    if(error)
    {
        [self performSelectorOnMainThread:@selector(showError:) withObject:error waitUntilDone:NO];
    }
    else
    {
        if([[[ModelTrackingClass sharedInstance] oppID] isEqualToString:@"Error 1"])
            [self performSelectorOnMainThread:@selector(noPrimaryContact) withObject:nil waitUntilDone:YES];
        else
        {
            [detailsDictionary setObject:[[ModelTrackingClass sharedInstance] oppID] forKey:@"OppID"];
            [self performSelectorOnMainThread:@selector(success:) withObject:detailsDictionary waitUntilDone:YES];
        }
    }
}

// SUCCESS Method for Opportunity Creation

-(void)success:(NSMutableDictionary *)dic
{
    [HUD hide:YES];
    
    Opportunity *obj = [[Opportunity alloc]init];
    obj.OpportunityId = [dic valueForKey:@"OppID"];
    obj.OpportunityName = [dic valueForKey:@"OpportunityName"];
    obj.CustomerName = accountObject.companyName;
    obj.EstimatedClosedate = [dic valueForKey:@"closeDate"];
    obj.Firstyear = [dic valueForKey:@"firstYear"];
    obj.TCV = [dic valueForKey:@"TCV"];
    obj.DealDuration = [dic valueForKey:@"Deal"];
    obj.productArray = [[NSMutableArray alloc]init];
    
    for(UIView *view in productArray)
    {
        products *objproduct = [[products alloc]init];
        
        UIButton *btn = (UIButton *)[view viewWithTag:200];
        objproduct.Primaryflag = (btn.imageView.tag == 1 ? @"Y" : @"N");
        objproduct.Productid = @"";
        objproduct.Productdescription = [(UITextField *)[view viewWithTag:201]text];
        objproduct.Splitpercentage = [NSString stringWithFormat:@"%d",[[(UITextField *)[view viewWithTag:202]text] intValue]];
        [obj.productArray addObject:objproduct];
        objproduct = nil;
    }
    
    if([self.sucessDelegate respondsToSelector:@selector(showSuccess:)])
    {
        [self.sucessDelegate showSuccess:obj];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

// If no contacts are there against the Opportunity ownermhe is not allowed to add opportunity.The below method checks that

-(void)noPrimaryContact
{
    [HUD hide:YES];
    
    if([self.sucessDelegate respondsToSelector:@selector(showNoPrimaryContact)])
    {
        [self.sucessDelegate showNoPrimaryContact];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

//Its the Background running method for updating existing opportunity purpose

- (void)saveOppBackgroundCall
{
    NSMutableDictionary *detailsDictionary=[[NSMutableDictionary alloc]init];
    
    [detailsDictionary setObject:opportunityObject.OpportunityId forKey:@"oppID"];
    [detailsDictionary setObject:txtSubject.text forKey:@"oppName"];
    [detailsDictionary setObject:strTVC forKey:@"TVC"];
    [detailsDictionary setObject:strYear forKey:@"firstYear"];
    [detailsDictionary setObject:txtClosedate.text forKey:@"closeDate"];
    [detailsDictionary setObject:txtDeal.text forKey:@"Deal"];
    
    
    SalesForceHelper *sfdcObject=[[SalesForceHelper alloc]init];
    NSError *error = [sfdcObject updateOpportunity:detailsDictionary];
    
    if(error)
    {
        [self performSelectorOnMainThread:@selector(showError1:) withObject:error waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(updateAfterOppBackgroundCall:) withObject:detailsDictionary waitUntilDone:YES];
    }
}

//called on ERROR

-(void)showError1:(NSError *)error
{
    [HUD hide:YES];
    [Utils showMessage:@"Failed to update opportunity" withTitle:NSLocalizedString(@"ALERT",@"Alert")];
}

-(void)showError:(NSError *)error
{
    [HUD hide:YES];
    [Utils showMessage:@"Failed to create opportunity" withTitle:NSLocalizedString(@"ALERT",@"Alert")];
}

//Call back Method or Opportunity Update

- (void)updateAfterOppBackgroundCall :(NSMutableDictionary *)dic
{
    [HUD hide:YES];
    
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
    HUD.mode =MBProgressHUDModeText;
    
    HUD.labelText= OPPORTUNITY_SUCCESS ;
    
    opportunityObject.TCV = [dic valueForKey:@"TVC"];
    opportunityObject.Firstyear = [dic valueForKey:@"firstYear"];
    opportunityObject.EstimatedClosedate = [dic valueForKey:@"closeDate"];
    opportunityObject.DealDuration = [dic valueForKey:@"Deal"];
    opportunityObject.OpportunityName = [dic valueForKey:@"oppName"];
    
    
    
    if([self.delegate respondsToSelector:@selector(opportunitySavedSuccessfully:)])
    {
        [self.delegate opportunitySavedSuccessfully:opportunityObject];
    }
    
    else
        if([self.delegate respondsToSelector:@selector(opportunityDataSaveFailedWithError:)])
        {
            [self.delegate opportunityDataSaveFailedWithError:[NSError errorWithDomain:OPPORTUNITY_UNEXPECTED_ERROR code:110 userInfo:nil]];
        }
    
    
    [self dismissModalViewControllerAnimated:YES];
}

//During ADD Opportunity,it checks all the validations and returns YES or NO according to it

-(BOOL)validateFields
{
    if(!edit)
    {
        int total = 0;
        BOOL primary   = FALSE;
        BOOL duplicate = FALSE;
        
        NSMutableArray *nameArr = [NSMutableArray array];
        
        for(UIView *view in productArray)
        {
            UITextField *txt = (UITextField *) [view viewWithTag:202];
            total = total + [txt.text intValue];
            UITextField *txtpr = (UITextField *) [view viewWithTag:201];
            [nameArr addObject:[NSString stringWithFormat:@"%@",txtpr.text]];
        }
        
        NSString *s1 = [[NSString alloc]init];
        NSString *temp = [[NSString alloc]init];
        for(int i=0;i<[nameArr count];i++)
        {
            s1 = [nameArr objectAtIndex:i];
            for (int j=0; j<[nameArr count];j++) {
                temp = [nameArr objectAtIndex:j];
                if(j!=i)
                {
                    if([s1 isEqualToString:temp])
                    {
                        duplicate = YES;
                    }
                    
                }
            }
            
        }
        
        for(UIView *view in productArray)
        {
            UIButton *pimaryBtn = (UIButton *) [view viewWithTag:200];
            if(pimaryBtn.imageView.tag == 1)
            {
                primary = TRUE;
            }
        }
        UITextField *txtPod;
        UITextField *txtPer;
        if([productArray count] != 0)
        {
            UIView *prodView = (UIView *)[productArray lastObject];
            txtPod = (UITextField *) [prodView viewWithTag:201];
            txtPer = (UITextField *) [prodView viewWithTag:202];
        }
        
        
        
        if(self.txtSubject.text.length == 0)
        {
            [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY", @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if(self.txtTVC.text.length ==0)
        {
            [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY", @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([[self.txtTVC.text componentsSeparatedByString:@"."] count] > 2)
        {
            [Utils showMessage:TCV_VALID withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if(self.txtTVC.text.length ==0)
        {
            [Utils showMessage:TCV_NONZERO withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([[self.txtFirstYear.text componentsSeparatedByString:@"."] count] > 2)
        {
            [Utils showMessage:FIRST_YEAR_VALID withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([self.txtFirstYear.text doubleValue] == 0)
        {
            [Utils showMessage:FIRST_YEAR_NONZERO withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if (self.txtClosedate.text.length==0)
        {
            [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY", @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if(self.txtDeal.text.length==0)
        {
            [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY", @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if(txtPod.text.length==0)
        {
            [Utils showMessage:ADD_PRODUCT withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([strYear doubleValue] > [strTVC doubleValue])
        {
            [Utils showMessage:FIRST_YEAR_CANT_BE_GREATER withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if(!primary)
        {
            [Utils showMessage:PRIMARY withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if(total > 100)
        {
            [Utils showMessage:SUM withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([self.txtDeal.text intValue] < 1)
        {
            [Utils showMessage:DURATION withTitle:NSLocalizedString(@"ALERT",@"Alert")];
        }
        else if(duplicate)
        {
            [Utils showMessage:SAME_PRODUCTS withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if(!([txtPod.text isEqualToString:@"Application Development"] || [txtPod.text isEqualToString:@"Application Outsoucing/AVM"]))
        {
            if(txtPer.text.length==0)
            {
                [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY", @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
                return NO;
            }
            else if([txtPer.text intValue] == 0)
            {
                [Utils showMessage:RANGE withTitle:NSLocalizedString(@"ALERT",@"Alert")];
                return NO;
            }
            else if([txtDeal.text intValue] <= 12)
            {
                if([strYear doubleValue] != [strTVC doubleValue])
                {
                    [Utils showMessage:SAME_IF_GREATER_12 withTitle:NSLocalizedString(@"ALERT",@"Alert")];
                    return NO;
                }
                else
                    return YES;
            }
            else
                return YES;
            
        }
        else if([txtDeal.text intValue] <= 12)
        {
            if([strYear doubleValue] != [strTVC doubleValue])
            {
                [Utils showMessage:SAME_IF_GREATER_12 withTitle:NSLocalizedString(@"ALERT",@"Alert")];
                return NO;
            }
            else
                return YES;
        }
        else
            return YES;
    }
    
    else if(edit)
    {
        if(self.txtSubject.text.length == 0)
        {
            [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY", @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if(self.txtTVC.text.length ==0)
        {
            [Utils showMessage:TCV_NONZERO withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([[self.txtTVC.text componentsSeparatedByString:@"."] count] > 2)
        {
            [Utils showMessage:TCV_VALID withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([self.txtFirstYear.text doubleValue] == 0)
        {
            [Utils showMessage:FIRST_YEAR_NONZERO withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([[self.txtFirstYear.text componentsSeparatedByString:@"."] count] > 2)
        {
            [Utils showMessage:FIRST_YEAR_VALID withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if (self.txtClosedate.text.length==0)
        {
            [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY", @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if(self.txtDeal.text.length==0)
        {
            [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY", @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([self.txtDeal.text intValue] < 1)
        {
            [Utils showMessage:DURATION withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([strYear doubleValue] > [strTVC doubleValue])
        {
            [Utils showMessage:FIRST_YEAR_CANT_BE_GREATER withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            return NO;
        }
        else if([txtDeal.text intValue] <= 12)
        {
            if([strYear doubleValue] != [strTVC doubleValue])
            {
                [Utils showMessage:SAME_IF_GREATER_12 withTitle:NSLocalizedString(@"ALERT",@"Alert")];
                return NO;
            }
            else
                return YES;
        }
        else
            return YES;
    }
    
    return NO;
}

// Gets called on click of Estimated Close date Field

- (IBAction)opportunityClosingDateButtonPressed:(id)sender {
    
    [txtTVC resignFirstResponder];
    [txtFirstYear resignFirstResponder];
    [txtDeal resignFirstResponder];
    
    
    if(datePicker)
        datePicker=nil;
    
    /*datePicker = [[UIDatePicker alloc] init];
    datePicker.frame=CGRectMake(20, 45.0, 240.0, 150.0);
    datePicker.minimumDate=[NSDate date];
    
    NSString *alertTitleString=@"";
    alertTitleString=SELECT_DATE;
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate date]];
    
    UIView *view = [[datePicker subviews] objectAtIndex:0];
    [view setBackgroundColor:[UIColor clearColor]]; // hide the first and the last subviews
    [[[view subviews] objectAtIndex:0] setHidden:YES];
    [[[view subviews] lastObject] setHidden:YES];
    
    
    
    oppClosingDateAlert = [[UIAlertView alloc] initWithTitle:alertTitleString message:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"Ok") otherButtonTitles:nil];
    oppClosingDateAlert.delegate = self;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    v.backgroundColor = [UIColor yellowColor];
    [v addSubview:datePicker];
    [oppClosingDateAlert setValue:v forKey:@"accessoryView"];
    [oppClosingDateAlert show];*/
    
    if([oppsCommonPopOver isPopoverVisible])
        [oppsCommonPopOver dismissPopoverAnimated:YES];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView *popoverView = [[UIView alloc] init];
    UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,250 ,40)];
    toolbar.barStyle =UIBarStyleBlackTranslucent;
    NSMutableArray *ButtonArray=[[NSMutableArray alloc ]init];
    UIBarButtonItem *Save=[[UIBarButtonItem alloc ]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(save_pressed)];
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancel=[[UIBarButtonItem alloc ]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel_pressed)];
    
    //for iOS7
    
    if([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)
    {
        [Save setTintColor:[UIColor whiteColor]];
        [cancel setTintColor:[UIColor whiteColor]];
    }
    
    [ButtonArray addObject:cancel];
    [ButtonArray addObject:space];
    [ButtonArray addObject:Save];
    [toolbar setItems:ButtonArray];
    [popoverView addSubview:toolbar];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(250, 200);
    
    oppsCommonPopOver = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [oppsCommonPopOver presentPopoverFromRect:((UIButton *)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, 250, 200-44)];
    datePicker.tag=TYPES_TABLE_TAG;
    datePicker.datePickerMode=UIDatePickerModeDate;
    [popoverView addSubview:datePicker];
    popoverContent.view = popoverView;
}

-(void)save_pressed
{
    NSDateFormatter *dFormatter=[[NSDateFormatter alloc]init];
    
    if(edit)
        dFormatter.dateFormat = @"dd/MM/yyyy";
    else
        dFormatter.dateFormat = @"MM/dd/yyyy";
    
    [self.txtClosedate setText:[dFormatter stringFromDate:datePicker.date]];
    
    if([oppsCommonPopOver isPopoverVisible])
        [oppsCommonPopOver dismissPopoverAnimated:YES];
}

-(void)cancel_pressed
{
    if([oppsCommonPopOver isPopoverVisible])
        [oppsCommonPopOver dismissPopoverAnimated:YES];
}

//Gets called on click of Alert during filling Estimated Close date Field

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView==oppClosingDateAlert)
    {
        NSDateFormatter *dFormatter=[[NSDateFormatter alloc]init];
        
        if(edit)
        dFormatter.dateFormat = @"dd/MM/yyyy";
        else
        dFormatter.dateFormat = @"MM/dd/yyyy";
        
        [self.txtClosedate setText:[dFormatter stringFromDate:datePicker.date]];
        [self.txtClosedate resignFirstResponder];
    }
    
}

//Used for Resigning keypad in Form Sheet

- (BOOL)disablesAutomaticKeyboardDismissal {
    
    return NO;
}

// Product List tableView

#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[differentProducts allKeys] count];
    
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
    
    NSArray* keys = [[differentProducts allValues]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    cell.textLabel.text = [keys objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:16];
    cell.textLabel.textColor=[Utils colorFromHexString:@"868686"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *v = [scrollProduct viewWithTag:clickedButton];
    UITextField *txt = (UITextField *) [v viewWithTag:201];
    txt.text = [[[differentProducts allValues]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:indexPath.row];
    
    if(([txt.text isEqualToString:@"Application Development"] || [txt.text isEqualToString:@"Application Outsoucing/AVM"]))
    {
        UITextField *txt1 = (UITextField *) [v viewWithTag:202];
        [txt1 setUserInteractionEnabled:FALSE];
        [txt1 setText:@"0"];
        [txt1 setTextColor:[UIColor lightGrayColor]];
    }
    else{
        UITextField *txt1 = (UITextField *) [v viewWithTag:202];
        [txt1 setUserInteractionEnabled:TRUE];
        //[txt1 setText:@""];
        [txt1 setTextColor:[UIColor darkGrayColor]];
    }
    [SearchPopoverController dismissPopoverAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
    if(textField.tag == 2)
    {
        strTVC = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    else if(textField.tag == 3)
    {
        strYear = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    if(textField.tag == 202)
    {
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"resizePopUpWhenKeyboardHidden" object:nil];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 2 | textField.tag == 3 )
    {
        if((![NetworkServiceHandler isAllowAmount:textField.text]) && ![string isEqualToString:[NSString string]])
		{
			return NO;
			
		}
        
        if(![NetworkServiceHandler NSStringIsValidateDecimal:string])
		{
			return NO;
		}
    }
    
    else if(textField.tag == 202)
    {
        if(![NetworkServiceHandler NSStringIsValidatePhone:string])
		{
			return NO;
		}
    }
    
    else if(textField.tag == 5)
    {
        if((![NetworkServiceHandler isAllowPinNumber:textField.text]) && ![string isEqualToString:[NSString string]])
		{
			return NO;
			
		}
		
		if(![NetworkServiceHandler NSStringIsValidatePhone:string])
		{
			return NO;
		}
        
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView == txtSubject)
    {
        if(![NetworkServiceHandler isAllowDesc:textView.text] && ![text isEqualToString:[NSString string]])
		{
			return NO;
		}
    }
    
    return YES;
}

- (IBAction)addOpportunity:(id)sender
{
    //add Product Fields
    
    [txtSubject resignFirstResponder];
    [txtTVC resignFirstResponder];
    [txtFirstYear resignFirstResponder];
    [txtDeal resignFirstResponder];
    [txtClosedate resignFirstResponder];
    
    if([self validateField])
    {
        UIView *productView = [[UIView alloc]init];
        [productView setFrame:CGRectMake(10,initialY+10,654,40)];
        [productView setBackgroundColor:[UIColor clearColor]];
        [productView setTag:[productArray count] + 1];
        //Add Subviews
        
        //Primary
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBtn setFrame:CGRectMake(52,5,28,28)];
        [checkBtn setBackgroundColor:[UIColor clearColor]];
        [checkBtn setBackgroundImage:[UIImage imageNamed:CHECK_DESELECT] forState:UIControlStateNormal];
        [checkBtn setBackgroundImage:[UIImage imageNamed:CHECK_DESELECT] forState:UIControlStateSelected];
        [checkBtn addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.tag = 200;
        [productView addSubview:checkBtn];
        
        
        //Product Group
        UITextField *txtProduct = [[UITextField alloc]initWithFrame:CGRectMake(137,5,290,30)];
        [txtProduct setBackgroundColor:[UIColor clearColor]];
        [txtProduct setBorderStyle:UITextBorderStyleRoundedRect];
        [txtProduct setTextAlignment:UITextAlignmentCenter];
        [txtProduct setFont:[UIFont fontWithName:FONT_BOLD size:17]];
        [txtProduct setTextColor:[UIColor darkGrayColor]];
        txtProduct.tag = 201;
        txtProduct.delegate = self;
        [productView addSubview:txtProduct];
        
        
        UIButton *btnProduct = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnProduct setFrame:CGRectMake(137,5,290,30)];
        [btnProduct addTarget:self action:@selector(clickProduct:) forControlEvents:UIControlEventTouchUpInside];
        [btnProduct setTag:203];
        [btnProduct setBackgroundColor:[UIColor clearColor]];
        [productView addSubview:btnProduct];
        
        
        
        //Percentage
        UITextField *txtPercentage = [[UITextField alloc]initWithFrame:CGRectMake(440,5,166,30)];
        [txtPercentage setBackgroundColor:[UIColor clearColor]];
        [txtPercentage setBorderStyle:UITextBorderStyleRoundedRect];
        [txtPercentage setTextAlignment:UITextAlignmentCenter];
        [txtPercentage setKeyboardType:UIKeyboardTypeNumberPad];
        txtPercentage.tag = 202;
        [txtPercentage setFont:[UIFont fontWithName:FONT_BOLD size:17]];
        [txtPercentage setTextColor:[UIColor darkGrayColor]];
        txtPercentage.delegate = self;
        [productView addSubview:txtPercentage];
        
        //Delete
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setFrame:CGRectMake(618,2,23,27)];
        [deleteBtn setBackgroundColor:[UIColor clearColor]];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:DELETE] forState:UIControlStateNormal];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:DELETE] forState:UIControlStateSelected];
        [deleteBtn addTarget:self action:@selector(delOpportunity:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.tag = 400;
        [productView addSubview:deleteBtn];
        
        [scrollProduct addSubview:productView];
        [productArray addObject:productView];
        
        initialY+= 40;
        
        [scrollProduct setContentSize:CGSizeMake(654,initialY+20)];
    }
}

//It validates the last added Product section .If it passes,then only it allows users to add another product section by use of + button

-(BOOL)validateField
{
    if(![productArray count] == 0)
    {
        UIView *prodView = (UIView *)[scrollProduct viewWithTag:[productArray count]];
        UITextField *txtPod = (UITextField *) [prodView viewWithTag:201];
        UITextField *txtPer = (UITextField *) [prodView viewWithTag:202];
        if(txtPod.text.length == 0)
        {
            [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY", @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            
            return NO;
        }
        else if(!([txtPod.text isEqualToString:@"Application Development"] || [txtPod.text isEqualToString:@"Application Outsoucing/AVM"]))
        {
            if(txtPer.text.length == 0)
            {
                [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY", @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
                
                return NO;
            }
            else if([txtPer.text intValue] == 0)
            {
                [Utils showMessage:PERCENTAGE_NONZERO withTitle:NSLocalizedString(@"ALERT",@"Alert")];
                return NO;
            }
            else
            {
                [txtPer resignFirstResponder];
                [scrollProduct setContentOffset:CGPointMake(0,initialY) animated:YES];
                return YES;
            }
        }
        else
        {
            [txtPer resignFirstResponder];
            [scrollProduct setContentOffset:CGPointMake(0,initialY) animated:YES];
            return YES;
        }
    }
    else
        return YES;
    
    return YES;
}


//Used for Deleting a perticular opportunity

- (IBAction)delOpportunity:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    int index = [[productArray mutableCopy] indexOfObject:[btn superview]];
    [[btn superview] removeFromSuperview];
    for(int i=index + 1 ; i<[productArray count] ; i++)
    {
        UIView *prod = [productArray objectAtIndex:i];
        prod.frame = CGRectMake(10,prod.frame.origin.y - 40,654,40);
        [prod setTag:[prod tag] - 1];
    }
    [productArray removeObject:[btn superview]];
    initialY-=40;
}

//Used for Primary Button functionality

-(IBAction)check:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.imageView.tag == 0)
    {
        for(UIView *view in productArray)
        {
            UIButton *pimaryBtn = (UIButton *) [view viewWithTag:200];
            if(pimaryBtn != btn)
            {
                [pimaryBtn setBackgroundImage:[UIImage imageNamed:CHECK_DESELECT] forState:UIControlStateNormal];
                pimaryBtn.imageView.tag = 0;
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:CHECK_SELECT] forState:UIControlStateNormal];
                btn.imageView.tag=1;
            }
        }
    }
    else if(btn.imageView.tag == 1)
    {
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_DESELECT] forState:UIControlStateNormal];
        btn.imageView.tag=0;
    }
}

//Gets called once tap on the Product field in the product section

-(IBAction)clickProduct:(id)sender
{
    
    UIButton *btn = (UIButton *) sender;
    UITextField *currentTextField;
    for(UITextField *txt in [[btn superview] subviews])
    {
        if(txt.tag == 201)
        {
            currentTextField = txt;
        }
        else if(txt.tag == 202)
        {
            [txt resignFirstResponder];
        }
    }
    
    clickedButton = [[btn superview] tag];
    
    if([SearchPopoverController isPopoverVisible])
        [SearchPopoverController dismissPopoverAnimated:YES];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    
    SearchPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    
    [SearchPopoverController presentPopoverFromRect:CGRectMake(0,0,250,350) inView:currentTextField permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    popoverContent.contentSizeForViewInPopover=CGSizeMake(250, 350);
    
    productTable =[[UITableView alloc]initWithFrame:CGRectMake(0,0, 250, 350) style:UITableViewStylePlain];
    productTable.dataSource=self;
    productTable.delegate=self;
    [popoverContent.view addSubview:productTable];
}

//Not Used

#pragma mark NSNotificationKeyboard

-(void)resizePopUpWhenKeyboardVisible
{
    // keyBoardVisible = YES;
}

-(void)resizePopUpWhenKeyboardHidden
{
    //keyBoardVisible = NO;
}


@end