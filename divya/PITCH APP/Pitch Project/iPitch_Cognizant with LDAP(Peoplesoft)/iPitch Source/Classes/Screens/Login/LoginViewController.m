//
//  LoginViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 1/24/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"

#import "SFHFKeychainUtils.h"

#import "ZohoHelper.h"

#import "Utils.h"

#import "iPitchConstants.h"

#import "iPitchAnalytics.h"

#import "LDAPAuthenticator.h"

#import "MainViewController_iPhone.h"



#import "SalesForceOAuthLoginHelper.h"

#import "ModelTrackingClass.h"
#import "Reachability.h"
#import <CommonCrypto/CommonCryptor.h>


@interface LoginViewController ()<SalesForceLoginDelegate>
{
    NSThread *CRMDataFetchThread;
    NSOperationQueue *CRMDataFetchQueue;
}
@end

@implementation LoginViewController

@synthesize loginLogo;
@synthesize loginButton;
@synthesize userNameField;
@synthesize passwordField;
@synthesize dashBoard;
@synthesize loginCircleImage;
@synthesize loginLineImage;
@synthesize loginCircleView;
@synthesize loginDummyImage;
@synthesize firstTimeLoad;

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
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:12.0/255.0 green:37.0/255.0 blue:60.0/255.0 alpha:1.0];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)                                                         forBarMetrics:UIBarMetricsDefault];
    
    userNameField.placeholder=NSLocalizedString(@"USER_NAME", @"User ID");
    passwordField.placeholder=NSLocalizedString(@"PASSWORD", @"Password");
    [loginButton setTitle:NSLocalizedString(@"LOGIN", @"Login") forState:UIControlStateNormal];
    
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Login"];
    
    self.firstTimeLoad=YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSalesForceLogin) name:TOKEN_EXPIRED_NOTIFICATION object:nil];
    
    self.navigationController.navigationBarHidden=YES;
    
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME]) {
        loginLogo.image = [UIImage imageNamed:@"logo_new.png"];
        loginCircleImage.image = [UIImage imageNamed:@"login_circle_theme1.png"];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_theme1.png"] forState:UIControlStateNormal];
        loginLineImage.image=[UIImage imageNamed:@"login_linestrip_theme1.png"];
        [loginButton setTitleColor:[Utils colorFromHexString:@"003750"] forState:UIControlStateNormal];
        loginDummyImage.image=[UIImage imageNamed:@"calander_icon.png"];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:IPITCH_THEME1_BG]];
        
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        loginLogo.image = [UIImage imageNamed:@"Theme2_logo.png"];
        loginCircleImage.image = [UIImage imageNamed:@"login_circle_theme2.png"];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_theme2.png"] forState:UIControlStateNormal];
        loginLineImage.image=[UIImage imageNamed:@"login_linestrip_theme2.png"];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginDummyImage.image=[UIImage imageNamed:@"Theme2_calander_icon.png"];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:IPITCH_THEME2_BG]];
        
    }
    
    if (!self.firstTimeLoad)
    {
        self.firstTimeLoad=YES;
        [self.loginDummyImage setHidden:YES];
        [self.loginCircleView setHidden:NO];
        self.loginDummyImage.center = self.view.center;
        self.passwordField.text = @"";
        [self.passwordField resignFirstResponder];
        self.userNameField.text = @"";
        [self.userNameField resignFirstResponder];
        
       
       
        CGFloat s = 10.0;
        CGAffineTransform tr = CGAffineTransformScale(self.loginCircleView.transform, s, s);
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.loginCircleView.transform = tr;
            self.loginCircleView.frame=CGRectMake(324, 185, 385, 385);
        }completion:nil];
       
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [self setPasswordField:nil];
    [self setUserNameField:nil];
    [self setLoginLogo:nil];
    [self setLoginCircleImage:nil];
    [self setLoginLineImage:nil];
    [self setLoginCircleView:nil];
    [self setLoginDummyImage:nil];
    [self setCollateralsHyperLink:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [super viewDidUnload];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark Login Events

- (IBAction)collateralsHyperLinkClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PITCH_COLLATERALS_URL]];
}


- (void)FetchFromZoho:(NSMutableDictionary *)credentials{
    
    [self performSelectorOnMainThread:@selector(animateLogin) withObject:Nil waitUntilDone:YES];
    
    HUD.labelText = @"Fetching Data...";
    
    
    
    //    [sfHelper fetchContacts];
    //
    //    [sfHelper fetchActivities];
    //
    //    [sfHelper fetchLeads];
    //
    //    [sfHelper fetchAccounts];
    //
    //    [sfHelper fetchTasks];
    
    HUD.labelText = @"Almost Done...";
    
    
    
    /*ZohoHelper * fetchDetails = [[ZohoHelper alloc]init];
     [fetchDetails FetchActivitiesFromZoho];
     [fetchDetails FetchAccountsFromZoho];
     [fetchDetails FetchOppOrtunitiesFromZoho];
     [fetchDetails FetchContactsFromZoho];
     [fetchDetails FetchLeadsFromZoho];
     [fetchDetails FetchTasksFromZoho];
     
     [fetchDetails TagActivitiesToContact];
     [fetchDetails TagOpportunitiesToAccounts];
     [fetchDetails TagActivitiesToAccounts];
     [fetchDetails TagActivitiesToOpportunities];
     [fetchDetails TagOpportunitiesToContact];*/
    
    [self schecduleNotificationsForFutureEventsAndTasks];
    
    SAppDelegateObject.isLoadingOtherModuleData=YES;
    
}


-(void)animateLogin
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
        {
            loginLineImage.image = [UIImage imageNamed:@"nod_backstrip_new.png"];
            
        }
        else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
        {
            loginLineImage.image = [UIImage imageNamed:@"Theme2_nod_backstrip.png"];
        }
        
        
        CGFloat s = 0.10;
        CGAffineTransform tr = CGAffineTransformScale(self.loginCircleView.transform, s, s);
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.loginCircleView.transform = tr;
            self.loginCircleView.center = self.view.center;
            
            
        }completion: ^ (BOOL finished)
         {
             if (finished)
             {
                 self.loginCircleView.hidden=YES;
                 self.loginDummyImage.hidden=NO;
                 
                 if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                 {
                     self.loginDummyImage.image = [UIImage imageNamed:@"calander_icon.png"];
                 }
                 else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                 {
                     self.loginDummyImage.image = [UIImage imageNamed:@"Theme2_calander_icon.png"];
                     
                 }
                 
                 //Line animation- Weird
                 
                 [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                     self.loginDummyImage.frame=CGRectMake(20, 345, 45, 45);
                     
                 }completion: ^ (BOOL finished1)
                  {
                      
                      if (finished1) {
                          [self updateMainthread];
                      }
                  }];
             }
         }];
    }
    
}


- (void)updateMainthread{
    
    
    
    dashBoard=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:nil];
    
    
    RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
    
    SWRevealViewController *mainRevealController =
    [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:dashBoard];
    
    mainRevealController.rearViewRevealWidth = 200;
    mainRevealController.rearViewRevealOverdraw = 150;
    mainRevealController.bounceBackOnOverdraw = NO;
    mainRevealController.stableDragOnOverdraw = YES;
    [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
    
    mainRevealController.delegate = self;
    
    
    //    if ([[SFHFKeychainUtils getPasswordForUsername:userNameField.text andServiceName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] error:nil] length]>0 )
    //    {
    //
    //        if ( [[SFHFKeychainUtils getPasswordForUsername:userNameField.text andServiceName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] error:nil] isEqualToString:passwordField.text])
    //        {
    //
    //            self.firstTimeLoad=NO;
    //
    //
    //            [self.navigationController pushViewController:mainRevealController animated:NO];
    //
    //            //[self.navigationController pushViewController:dashBoard animated:NO];
    //            [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    //            [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Login Screen" withAction:@"User Logged In" withLabel:userNameField.text withValue:nil];
    //
    //        }
    //
    //        else{
    //
    //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"user id password donot match" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //            [alert show];
    //
    //            return;
    //        }
    //    }
    
    //    else{
    
    self.firstTimeLoad=NO;
    
    
    [SFHFKeychainUtils storeUsername:userNameField.text andPassword:passwordField.text forServiceName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] updateExisting:YES error:nil];
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Login Screen" withAction:@"User Logged In" withLabel:userNameField.text withValue:nil];
    
    [Utils userDefaultsSetObject:userNameField.text forKey:IPITCH_CURRENT_USER_NAME];
    
    [self.navigationController pushViewController:mainRevealController animated:NO];
    
    
    //[self.navigationController pushViewController:dashBoard animated:NO];
    //   }
    
    
    
}


- (void)schecduleNotificationsForFutureEventsAndTasks
{
    
    [NotificationsHelper clearBadgeCount];
    
    [NotificationsHelper removePreviousNotifications];
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Events"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventStartDate >= %@)",  [NSDate date]];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (Events *event in fetchedObjects) {
        
        NSString *notificationTitle=@"";
        switch ([event.eventType integerValue]) {
            case EventTypeCall:
                notificationTitle = [NSString stringWithFormat:@"Call - %@",event.eventTitle];
                break;
                
            case EventTypeEmail:
                notificationTitle = [NSString stringWithFormat:@"Email - %@",event.eventTitle];
                break;
                
            case EventTypeMeeting:
                notificationTitle = [NSString stringWithFormat:@"Meeting - %@",event.eventTitle];
                break;
                
            case EventTypeProduct_Demo:
                notificationTitle = [NSString stringWithFormat:@"Meeting - %@",event.eventTitle];
                break;
                
            default:
                break;
        }
        
        [NotificationsHelper scheduleNotificationOn:event.eventStartDate text:notificationTitle action:event.eventDescType sound:nil launchImage:nil andInfo:nil];
        
    }
    
    context = SAppDelegateObject.managedObjectContext;
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Tasks"
                         inManagedObjectContext:context];
    predicate = [NSPredicate predicateWithFormat:@"taskDueDate >= %@",  [NSDate date]];
    
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (Tasks *taskObject in fetchedObjects) {
        [NotificationsHelper scheduleNotificationOn:taskObject.taskDueDate text:taskObject.taskSubject action:taskObject.taskDescription sound:nil launchImage:nil andInfo:nil];
        
    }
}


- (void)loadModuleDataAsynchronously
{
    ZohoHelper * fetchDetails = [[ZohoHelper alloc]init];
    
    [fetchDetails FetchTasksFromZoho];
    [fetchDetails FetchLeadsFromZoho];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOADED_MODULES_DATA_NOTIFICATION object:nil];
}

#pragma mark UITextFieldDelegateMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    userNameField.text = [userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    passwordField.text = [passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    [textField resignFirstResponder];
    
     if(textField == userNameField)
     {
     if  ([userNameField.text length]==0)
     {
     
     [Utils showMessage:@"Fields are empty" withTitle:@"Alert"];
     [userNameField becomeFirstResponder];
     
     }
     else {
     [userNameField resignFirstResponder];
     [passwordField becomeFirstResponder];
     }
     
     }
     
     else if(textField==passwordField)
     {
     if  ([userNameField.text length]==0 || [passwordField.text length] == 0)
     {
     [Utils showMessage:@"Fields are empty" withTitle:@"Alert"];
     [passwordField becomeFirstResponder];
     }
     else {
     [passwordField resignFirstResponder];
     [loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
     }
     }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}


/**
 *	This method animates the Login screen while entering user credentials
 */

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    CGRect temp=self.view.frame;
    const int movementDistance = 100;
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

#pragma mark SalesForceLoginDelegateMethods


-(void)showSalesForceLogin
{
    if(![CRMDataFetchQueue isSuspended])
    {
        [CRMDataFetchQueue cancelAllOperations];
        [CRMDataFetchQueue setSuspended:YES];
        [Utils removeLoading:self.view];
    }
    [self performSelectorOnMainThread:@selector(presentSalesForceLogin) withObject:nil waitUntilDone:YES];
    
    
    
}

-(void)presentSalesForceLogin
{
    SalesForceOAuthLoginHelper *loginHelper=[[SalesForceOAuthLoginHelper alloc]init];
    loginHelper.delegate=self;
    loginHelper.modalPresentationStyle=UIModalPresentationFormSheet;
    
    [self presentModalViewController:loginHelper animated:YES];
}
- (void)loginCancelled
{
    NSLog(@"Sales force login cancelled");
}

- (void)loginCompletedWithResult:(SalesForceOAuthLoginResultParamters)resultParamter
{
    if(resultParamter == SalesForceOAuthLoginResultSuccessParamter)
    {
        
        SAppDelegateObject.postedTokenExpiredNotification=NO;
        [Utils userDefaultsSetObject:[NSString stringWithFormat:@"%d",0] forKey:IPITCH_FIRST_RUN];
        
        NSMutableDictionary *credentials=[[NSMutableDictionary alloc]init];
        [credentials setObject:userNameField.text forKey:@"uname"];
        [credentials setObject:passwordField.text forKey:@"password"];
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"Authenticating User..";
        [self performSelectorInBackground:@selector(FetchFromZoho:) withObject:credentials];
        
    }
}


#pragma mark CHANGES BY SWARNAVA

// Once login Buton pressed,check for validations.If passed validations,LDAP Service called

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    if([userNameField.text isEqualToString:@""])
    {
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD hide:YES afterDelay:2];
        HUD.mode =MBProgressHUDModeText;
        HUD.labelText= PROVIDE_USER_ID;
    }
    else if([passwordField.text isEqualToString:@""])
    {
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD hide:YES afterDelay:2];
        HUD.mode =MBProgressHUDModeText;
        HUD.labelText= PROVIDE_PASWORD;
    }
    else{
        
        if([Reachability connected])
        {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = AUTHENTICATE;
            NSMutableDictionary *credentials=[NSMutableDictionary dictionary];
            [credentials setObject:userNameField.text forKey:@"uname"];
            [credentials setObject:passwordField.text forKey:@"password"];
            
            [self encryptCredentialsWithUserName:[credentials valueForKey:@"uname"] andPassword:[credentials valueForKey:@"password"]];
            
            ModelTrackingClass *resourceManager = [ModelTrackingClass sharedInstance];
            
            
            [NSThread detachNewThreadSelector:@selector(loginAction:) toTarget:self withObject:resourceManager];
        }
        else{
            HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HUD hide:YES afterDelay:3];
            HUD.mode =MBProgressHUDModeText;
            HUD.labelText= INTERNET_NOT_FOUND;
        }
    }
}


//On clicking LOGIN,it calls for service

-(void)loginAction:(ModelTrackingClass *)resourceManager
{
    [[ModelTrackingClass sharedInstance] setUserID:userNameField.text];

    [self performSelectorInBackground:@selector(getOpportunities) withObject:nil];

    /*LDAPAuthenticator *authenticator = [[LDAPAuthenticator alloc] init];
    [authenticator setDelegate:self];
    [authenticator authenticateLDAPUserWithUserName:resourceManager.userID andPassword:resourceManager.password];*/
}

//Call back LDAP SUCCESS Method

-(void)autenticationSuccess
{
    [[ModelTrackingClass sharedInstance] setUserID:userNameField.text];
    
    [self performSelectorInBackground:@selector(getOpportunities) withObject:nil];
}

//Call back LDAP FAILURE Method

-(void)ldapAuthenticationFailed
{
    [HUD hide:YES];
    [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:YES];
}

//Call back LDAP ERROR Method

-(void)requestFailed:(NSError *)error
{
    [HUD hide:YES];
    [self performSelectorOnMainThread:@selector(fail:) withObject:error waitUntilDone:YES];
}

//ERROR Method

-(void)fail:(NSError *)error
{
    [Utils showMessage:[error localizedDescription] withTitle:NSLocalizedString(@"ALERT",@"Alert")];
}

//ERROR Alert method

-(void)showAlert
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:3];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText= AUTHENTICATION_FAILED;
}


/**
 *The method to encrypt the given string using AES encryption. The encryption is
 * needed to send the user credentials to middleware
 */
-(void) encryptCredentialsWithUserName:(NSString *)userName andPassword:(NSString *)passWord{
    
    ModelTrackingClass *resourceManager = [ModelTrackingClass sharedInstance];
    
    //User name is encrypted
    
    NSMutableData *encryptedADUserName = [NSMutableData dataWithData:[userName dataUsingEncoding:NSUTF8StringEncoding]];
    
    encryptedADUserName = [LoginViewController EncryptAES:KEY_TO_ENCRYPT andForData:encryptedADUserName];
    
    /* Since the encrypted data contains spaces and special characters, hexRepresentationWithSpaces_AS is called to convert the data to HEX string which is the preferred format to send to middlware */
    
    NSString *encyptedUserNameAfterEncoding = [self hexRepresentationWithSpaces_AS:encryptedADUserName withSpaces:NO];
    
    resourceManager.userID = encyptedUserNameAfterEncoding;
    
    // password is encrypted
    
    NSMutableData *encryptedADPassword = [NSMutableData dataWithData:[passWord dataUsingEncoding:NSUTF8StringEncoding]];
    encryptedADPassword = [LoginViewController EncryptAES:KEY_TO_ENCRYPT andForData:encryptedADPassword];
    
    NSString *encyptedPasswordAfterEncoding = [self hexRepresentationWithSpaces_AS:encryptedADPassword withSpaces:NO];
    
    resourceManager.password = encyptedPasswordAfterEncoding;
    
}

/**
 *The method to encrypt the given string using AES encryption. The encryption is
 * needed to send the user credentials to middleware
 */

+(NSMutableData*)EncryptAES:(NSString *)key andForData:(NSMutableData *)objDataToEncrypt
{
	@try {
		char keyPtr[kCCKeySizeAES128+1];
		//bzero(key, sizeof(keyPtr));
		
		[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
		size_t numBytesEncrypted = 0;
		
		
		NSUInteger dataLength = [objDataToEncrypt length];
		
		size_t bufferSize = dataLength + kCCBlockSizeAES128;
		void *buffer = malloc(bufferSize);
		
		NSMutableData *output = [[NSMutableData alloc] init];
		
		CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES128, NULL, [objDataToEncrypt mutableBytes], [objDataToEncrypt length], buffer, bufferSize, &numBytesEncrypted);
		
		output = [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
		
		if (result == kCCSuccess) {
			return output;
		}
		return NULL;
	}
	@catch (NSException * e) {
		//_DBGPRINT_(@"Exception Caught %@: %@",[e name], [e reason]);
		return NULL;
	}
}




#pragma mark Encryption

/**
 *The method to convert the given data as string of hex value. If the spaces
 *parameter is TRUE, it returns the string with spaces. Else the string is returned
 *without spaces
 */
-(NSString*)hexRepresentationWithSpaces_AS:(NSData *)dataToEncode withSpaces:(BOOL)spaces
{
    const unsigned char* bytes = (const unsigned char*)[dataToEncode bytes];
    NSUInteger nbBytes = [dataToEncode length];
    
    //If spaces is true, insert a space every this many input bytes (twice this many output characters).
    static const NSUInteger spaceEveryThisManyBytes = 4UL;
    
    //If spaces is true, insert a line-break instead of a space every this many spaces.
    static const NSUInteger lineBreakEveryThisManySpaces = 4UL;
    const NSUInteger lineBreakEveryThisManyBytes = spaceEveryThisManyBytes * lineBreakEveryThisManySpaces;
    NSUInteger strLen = 2*nbBytes + (spaces ? nbBytes/spaceEveryThisManyBytes : 0);
    
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    for(NSUInteger i=0; i<nbBytes; ) {
        [hex appendFormat:@"%02x", bytes[i]];
        
        //We need to increment here so that the every-n-bytes computations are right.
        ++i;
        
        if (spaces) {
            if (i % lineBreakEveryThisManyBytes == 0) [hex appendString:@"\n"];
            else if (i % spaceEveryThisManyBytes == 0) [hex appendString:@" "];
        }
    }
    return hex;
}


/**
 *	This method fetches all Opportunity Details from PeopleSoft CRM
 */

-(void)getOpportunities
{
    [NSThread detachNewThreadSelector:@selector(callOpportunity) toTarget:self withObject:nil];
}

-(void)callOpportunity
{
    if([Reachability connected])
    {
        SalesForceHelper *sfHelper=[[SalesForceHelper alloc]init];
        NSError *error = [sfHelper fetchOpportunities:[[ModelTrackingClass sharedInstance] userID]];
        
        if(error)
        {
            [self performSelectorOnMainThread:@selector(Error:) withObject:error waitUntilDone:YES];
        }
        else
        {
            if(sfHelper.opportArray)
            {
                
               
                if([[sfHelper opportArray]count] > 0)
                {
                    NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc]initWithKey:@"CustomerName" ascending:YES];
                    SAppDelegateObject.opportArray = [[sfHelper.opportArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameSorter]] mutableCopy];
                }
            }
            if([Reachability connected])
            {
                [self getAccounts];
            }
            else{
                [self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:YES];
            }
        }
    }
    else{
        [self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:YES];
    }
}

-(void)Error:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils showMessage:@"Failed to fetch opportunities" withTitle:NSLocalizedString(@"ALERT",@"Alert")];
}

//Internet Checking Method for Opportunity Service

-(void)hideLoading
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:3];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText= INTERNET_NOT_FOUND;
}

/**
 *	This method fetches all Account Details from PeopleSoft CRM
 */

-(void)getAccounts
{
    SalesForceHelper *sfHelper=[[SalesForceHelper alloc]init];
    NSError *error = [sfHelper fetchAccounts:[[ModelTrackingClass sharedInstance] userID]];
    
    if(error)
    {
      [self performSelectorOnMainThread:@selector(Error1:) withObject:error waitUntilDone:YES];
    }
    else
    {
    if(sfHelper.acntArray)
    {
        if([[sfHelper acntArray]count] > 0)
        {
            SAppDelegateObject.acntArray = sfHelper.acntArray;
        }
    }
     
            if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            {
                [SFHFKeychainUtils storeUsername:userNameField.text andPassword:passwordField.text forServiceName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] updateExisting:YES error:nil];
                
                [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
                [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Login Screen" withAction:@"User Logged In" withLabel:userNameField.text withValue:nil];
                [Utils userDefaultsSetObject:userNameField.text forKey:IPITCH_CURRENT_USER_NAME];
                
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                MainViewController_iPhone *mvc=[[MainViewController_iPhone alloc]initWithNibName:@"MainViewController_iPhone" bundle:nil];
                [self.navigationController pushViewController:mvc animated:YES];
                
            }
        else
        {
             [self performSelectorOnMainThread:@selector(animateLogin) withObject:Nil waitUntilDone:YES];
        }
            
        
   
    }
    
}

-(void)Error1:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils showMessage:@"Failed to fetch accounts" withTitle:NSLocalizedString(@"ALERT",@"Alert")];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 2)
    {
        if(![NetworkServiceHandler NSStringIsValidatePhone:string])
		{
			return NO;
		}
    }
    return YES;
}



@end
