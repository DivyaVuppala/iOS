//
//  AddEditCustomerViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/7/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "AddEditCustomerViewController.h"
#import "iPitchConstants.h"
#import "AppDelegate.h"
#import "AsyncImageView.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "ZohoHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "ThemeHelper.h"
#import "SalesForceHelper.h"

@interface AddEditCustomerViewController ()<UITextFieldDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic,retain)UIImagePickerController *imgPickerController;
@property (nonatomic,retain)UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UIScrollView *customerDetailsScrollView;

@property (retain, nonatomic) UITextField *customerFirstNameField;
@property (retain, nonatomic) UITextField *customerLastNameField;
@property (retain, nonatomic) UITextField *customerDepartmentField;
@property (retain, nonatomic) UITextField *customerEmailIDField;
@property (retain, nonatomic) UITextField *customerPhoneField;
@property (retain, nonatomic) UITextField *customerSkypeIDField;
@property (retain, nonatomic) UITextField *customerTwitterIDField;
@property (retain, nonatomic) UITextField *customerLinkedInIDField;
@property (retain, nonatomic) UITextField *customerMailingStreetNameField;
@property (retain, nonatomic) UITextField *customerMailingCityNameField;
@property (retain, nonatomic) UITextField *customerMailingStateNameField;
@property (retain, nonatomic) UITextField *customerMailingCountryNameField;
@property (retain, nonatomic) UITextField *customerMailingZIPField;

@property (weak, nonatomic) IBOutlet UIImageView *customerIconImageView;


@end

@implementation AddEditCustomerViewController

@synthesize imgPickerController,customerFirstNameField,customerLastNameField,customerDepartmentField,customerEmailIDField,customerObject,customerPhoneField,customerSkypeIDField,customerTwitterIDField,delegate;

#define FIELD_VERTICAL_OFFSET 80.0
#define FIELD_HORIZONTAL_OFFSET 100.0
#define LABEL_WIDTH 150.0
#define LABEL_HEIGHT 20.0
#define TEXT_FIELD_WIDTH 250.0

#pragma mark View Life Cycle

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
    
    if(self.customerObject)
    {
        self.customerFirstNameField.text=self.customerObject.firstName;
        self.customerLastNameField.text=self.customerObject.lastName;
        self.customerEmailIDField.text=self.customerObject.emailID;
        self.customerPhoneField.text=self.customerObject.phoneNumber;
        self.customerSkypeIDField.text=self.customerObject.skypeID;
        self.customerTwitterIDField.text=self.customerObject.twitterID;
        self.customerMailingCityNameField.text =   self.customerObject.mailingCity;
        self.customerMailingCountryNameField.text =   self.customerObject.mailingCountry;
        self.customerMailingStreetNameField.text =   self.customerObject.mailingStreet;
        self.customerMailingZIPField.text =   self.customerObject.mailingZIP;

        [self.customerIconImageView setImageURL:[NSURL URLWithString:self.customerObject.customerImageURL]];
        [self.customerIconImageView.layer setCornerRadius:6];
        [self.customerIconImageView.layer setMasksToBounds:YES];
        
    }
    
    [self.customerDetailsScrollView.layer setCornerRadius:6];
    [self.customerDetailsScrollView.layer setMasksToBounds:YES];
    
    [self.customerDetailsScrollView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.05]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [ThemeHelper applyCurrentThemeToView];
}

-(BOOL)validateFields
{
    
    if(self.customerFirstNameField.text.length == 0)
        return NO;
    else if(self.customerLastNameField.text.length ==0)
        return NO;
    else if(self.customerEmailIDField.text.length ==0)
        return NO;
    else if (self.customerPhoneField.text.length==0)
        return NO;
    else if(self.customerSkypeIDField.text.length==0)
        return NO;
    else if (self.customerTwitterIDField.text.length ==0)
        return NO;
    else if (self.customerLinkedInIDField.text.length ==0)
        return NO;
    else if (self.customerMailingCityNameField.text.length ==0)
        return NO;
    else if (self.customerMailingCountryNameField.text.length ==0)
        return NO;
    else if (self.customerMailingStreetNameField.text.length ==0)
        return NO;
    else if (self.customerMailingZIPField.text.length ==0)
        return NO;
    else if (self.customerMailingStateNameField.text.length ==0)
        return NO;
    else
        return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCancelButton:nil];
    [self setSaveButton:nil];
    [self setCustomerLastNameField:nil];
    [self setCustomerDepartmentField:nil];
    [self setCustomerEmailIDField:nil];
    [self setCustomerPhoneField:nil];
    [self setCustomerSkypeIDField:nil];
    [self setCustomerTwitterIDField:nil];
    [self setCustomerDetailsScrollView:nil];
    [self setCustomerIconImageView:nil];
    [super viewDidUnload];
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


- (void)loadCustomerFields
{
    //Add extra fields if needed here.
    
    CGFloat xFrame = 40.0;
    CGFloat yFrame = 30.0;
    
    self.customerFirstNameField =[[UITextField alloc]init];
    self.customerLastNameField =[[UITextField alloc]init];
    self.customerDepartmentField =[[UITextField alloc]init];
    self.customerEmailIDField =[[UITextField alloc]init];
    self.customerTwitterIDField =[[UITextField alloc]init];
    self.customerLinkedInIDField =[[UITextField alloc]init];
    self.customerSkypeIDField =[[UITextField alloc]init];
    self.customerPhoneField =[[UITextField alloc]init];
    self.customerMailingStreetNameField =[[UITextField alloc]init];
    self.customerMailingZIPField =[[UITextField alloc]init];
    self.customerMailingCountryNameField =[[UITextField alloc]init];
    self.customerMailingCityNameField =[[UITextField alloc]init];
    self.customerMailingStateNameField =[[UITextField alloc]init];

    
    [self addLabelWithText:@"First Name" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    [self addTextField:self.customerFirstNameField withText:self.customerObject.firstName andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Last Name" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerLastNameField withText:self.customerObject.lastName andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Department Name" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerDepartmentField withText:self.customerObject.department andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Email ID" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerEmailIDField withText:self.customerObject.emailID andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Twitter ID" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerTwitterIDField withText:self.customerObject.twitterID andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"LinkedIn ID" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerLinkedInIDField withText:self.customerObject.linkedinID andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Skype ID" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerSkypeIDField withText:self.customerObject.skypeID andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Phone Number" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerPhoneField withText:self.customerObject.phoneNumber andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing Street" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerMailingStreetNameField withText:self.customerObject.mailingStreet andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing City" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerMailingCityNameField withText:self.customerObject.mailingCity andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing State" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerMailingStateNameField withText:self.customerObject.mailingState andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing Country" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerMailingCountryNameField withText:self.customerObject.mailingCountry andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
    
    
    yFrame=yFrame+FIELD_VERTICAL_OFFSET;
    
    [self addLabelWithText:@"Mailing ZIP" andFrame:CGRectMake(xFrame, yFrame, LABEL_WIDTH, LABEL_HEIGHT)];
    
    [self addTextField:self.customerMailingZIPField withText:self.customerObject.mailingZIP andFrame:CGRectMake(200,yFrame-2 ,TEXT_FIELD_WIDTH, 31)];
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
    [self.customerDetailsScrollView addSubview:label];
    [self.customerDetailsScrollView setContentSize:CGSizeMake(0, frame.size.height + frame.origin.y+FIELD_VERTICAL_OFFSET)];
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
    [self.customerDetailsScrollView addSubview:tField];
    [self.customerDetailsScrollView setContentSize:CGSizeMake(0, frame.size.height + frame.origin.y+FIELD_VERTICAL_OFFSET)];
}

- (IBAction)customerIconButtonClicked:(id)sender {
    
    
    //camera part commented for now..
    /*UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:NSLocalizedString(@"IMAGE_FROM", nil)
                            delegate:self
                            cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                            destructiveButtonTitle:nil
                            otherButtonTitles:NSLocalizedString(@"PHOTO_ALBUM", nil), NSLocalizedString(@"CAPTURE", nil), nil];
    
	[sheet showFromRect:self.customerIconButton.frame inView:self.view animated:YES];*/
}


#pragma mark UIImagePicker Delegate Methods and supporting Methods

/*- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
	switch (buttonIndex) {
		case 0:
		{
			NSLog(@"Photo Album");
            [self showSavedPhotoAlbumButtonClicked];
			break;
		}
		case 1:
		{
			NSLog(@"Capture");
            [self captureImageButtonClicked];
			break;
		}
            
	}
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    NSLog(@"Cancel button pressed");
    [picker dismissModalViewControllerAnimated: YES];
    
}

- (IBAction)showSavedPhotoAlbumButtonClicked
{
    if (self.imgPickerController) {
		[self.imgPickerController dismissModalViewControllerAnimated:NO];
		[self.imgPickerController.view removeFromSuperview];
        //[self.imgPickerController release];
	}
	if (_popover) {
		[_popover dismissPopoverAnimated:NO];
	}
    
	UIImagePickerController *temp = [[UIImagePickerController alloc] init];
    self.imgPickerController = temp;
	self.imgPickerController.delegate = self;
	self.imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	self.imgPickerController.wantsFullScreenLayout = YES;
    
    [self.imgPickerController setContentSizeForViewInPopover:CGSizeMake(1000, 1000)];
	_popover = [[UIPopoverController alloc] initWithContentViewController:self.imgPickerController] ;
	[_popover setDelegate:self];
    
	[_popover presentPopoverFromRect:self.customerIconImageView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    
}
- (IBAction)captureImageButtonClicked
{
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		UIImagePickerController *temp = [[UIImagePickerController alloc] init];
        self.imgPickerController = temp;
		self.imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		self.imgPickerController.delegate = self;
        [SAppDelegateObject.window.rootViewController presentModalViewController:self.imgPickerController animated:YES];
	}
	else {
		
		//[self showErrorNote:@"No Source Available to Capture Image"];
	}
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *tempImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.customerIconImageView setImage:[self imageWithImage:tempImage scaledToSize:CGSizeMake(100,100)]];
    
    
	[picker dismissModalViewControllerAnimated:YES];
    if (_popover.isPopoverVisible) {
		[_popover dismissPopoverAnimated:NO];
		//[_popover release];
	}
    self.imgPickerController = nil;
}*/

- (IBAction)saveButtonPressed:(id)sender {
    
    if([self validateFields])
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"Saving Customer Details...";
        [self performSelectorInBackground:@selector(saveCustomerDetailsBackgroundCall) withObject:nil];
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

- (void)saveCustomerDetailsBackgroundCall
{
     NSMutableDictionary *cusomterDetails=[[NSMutableDictionary alloc]init];
     
     [cusomterDetails setObject:self.customerFirstNameField.text forKey:ZOHO_FIRST_NAME_PARAMETER];
     [cusomterDetails setObject:self.customerLastNameField.text forKey:ZOHO_LAST_NAME_PARAMETER];
     [cusomterDetails setObject:self.customerDepartmentField.text forKey:ZOHO_DEPARTMENT_PARAMETER];
     [cusomterDetails setObject:self.customerPhoneField.text forKey:ZOHO_PHONE_PARAMETER];
     [cusomterDetails setObject:self.customerEmailIDField.text forKey:ZOHO_EMAIL_PARAMETER];
     [cusomterDetails setObject:self.customerTwitterIDField.text forKey:ZOHO_TWITTER_ID_PARAMETER];
     [cusomterDetails setObject:self.customerLinkedInIDField.text forKey:ZOHO_LINKEDIN_PARAMETER];
     [cusomterDetails setObject:self.customerSkypeIDField.text forKey:ZOHO_SKYPE_PARAMETER];
     [cusomterDetails setObject:self.customerMailingStreetNameField.text forKey:ZOHO_MAILING_STREET_PARAMETER];
     [cusomterDetails setObject:self.customerMailingCityNameField.text forKey:ZOHO_MAILING_CITY_PARAMETER];
     [cusomterDetails setObject:self.customerMailingStateNameField.text forKey:ZOHO_MAILING_STATE_PARAMETER];
     [cusomterDetails setObject:self.customerMailingCountryNameField.text forKey:ZOHO_MAILING_COUNTRY_PARAMETER];
     [cusomterDetails setObject:self.customerMailingZIPField.text forKey:ZOHO_MAILING_ZIP_PARAMETER];

    BOOL addStatus=NO;

    SalesForceHelper *sfdcObject=[[SalesForceHelper alloc]init];

    if(self.customerObject)
    {
    /*ZohoHelper *zohoObject=[[ZohoHelper alloc]init];
    
    BOOL addStatus=NO;
    addStatus= [zohoObject updateDetailsForZohoEntity:CustomerModule WithID:self.customerObject.customerID withDetails:cusomterDetails];
    if(addStatus)
    {
        [zohoObject FetchContactsFromZoho];
        [zohoObject FetchRelatedActivitiesForEntity: CONTACTS_MODULE :self.customerObject.customerID];
        [zohoObject TagActivitiesToContact];
        [zohoObject FetchRelatedOpportunitiesForEntity:CONTACTS_MODULE :self.customerObject.customerID];
        [zohoObject TagOpportunitiesToContact];
    }*/
    
    
    
    addStatus= [sfdcObject editContactForContactID:self.customerObject.customerID withDetails:cusomterDetails];
    if(addStatus)
    {
        
       /* [zohoObject FetchContactsFromZoho];
        [zohoObject FetchRelatedActivitiesForEntity: CONTACTS_MODULE :self.customerObject.customerID];
        [zohoObject TagActivitiesToContact];
        [zohoObject FetchRelatedOpportunitiesForEntity:CONTACTS_MODULE :self.customerObject.customerID];
        [zohoObject TagOpportunitiesToContact];*/
        
    }
    }
    
    else
    {
       addStatus= [sfdcObject addContactWithDetails:cusomterDetails];
    }
    
    [self performSelectorOnMainThread:@selector(updateAfterCustomerBackgroundCall:) withObject:[NSNumber numberWithBool:addStatus] waitUntilDone:YES];
}

- (void)updateAfterCustomerBackgroundCall :(NSNumber *)status
{
    
    [HUD hide:YES];
    
    if([status boolValue])
    {
        if([self.delegate respondsToSelector:@selector(customerDataSavedSuccessfully)])
        {
            [self.delegate customerDataSavedSuccessfully];
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(customerDataSaveFailedWithError:)])
        {
            [self.delegate customerDataSaveFailedWithError:[NSError errorWithDomain:@"Could not save Customer data try again" code:110 userInfo:nil]];
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
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
    const int movementDistance = 90;
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
