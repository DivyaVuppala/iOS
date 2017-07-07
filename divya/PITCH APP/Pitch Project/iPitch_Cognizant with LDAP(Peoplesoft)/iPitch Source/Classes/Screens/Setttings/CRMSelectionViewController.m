//
//  CRMSelectionViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 2/28/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "CRMSelectionViewController.h"

#import "ASIHTTPRequest.h"

#import "Utils.h"

#import "iPitchConstants.h"

#import "AppDelegate.h"

#import "LoginViewController.h"

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])


@interface CRMSelectionViewController ()

@end

@implementation CRMSelectionViewController

@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize loginButton;


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
    self.title=NSLocalizedString(@"LOGIN_TO_ZOHO",  @"Login to Zoho");
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
}
- (IBAction)zohoLoginButtonPressed:(id)sender {
    
    userNameTextField.text=[userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    passwordTextField.text=[passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (passwordTextField.text.length >0 && userNameTextField.text.length>0)
    {
        
        [userNameTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
        [self.view endEditing:YES];
        
        [Utils showLoading:self.view];
        
        [self performSelectorInBackground:@selector(authenticateZohoUser) withObject:nil];
    }

    else{
        [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY",  @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
    }
           
}

-(void)authenticateZohoUser
{
    
    NSString *zohoAuthenticationTokenURL = @"https://accounts.zoho.com/apiauthtoken/nb/create?SCOPE=ZohoCRM/crmapi&EMAIL_ID=";
    NSString *extension = @"&PASSWORD=";
    NSString * loginURL = [NSString stringWithFormat:@"%@%@%@%@", zohoAuthenticationTokenURL, userNameTextField.text,extension,passwordTextField.text];
    loginURL=[loginURL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];;
    NSURL *urlnew =[NSURL URLWithString: loginURL];
    
    ASIHTTPRequest *requestLogin=[[ASIHTTPRequest alloc]initWithURL:urlnew];
    [requestLogin setRequestMethod:@"GET"];
    [requestLogin setTimeOutSeconds:30];
    [requestLogin startSynchronous];
    NSError *errorLogin = [requestLogin error];
    NSString *responseLogin=@"";
    
    if (!errorLogin){
        responseLogin = [requestLogin responseString];
        NSLog(@"response: %@",responseLogin);
    }
    else {
        NSLog(@"Error : %@",[errorLogin localizedDescription]);
    }
    
    if ([responseLogin length]>0)
    {
        
        NSString *str2 = @"AUTHTOKEN=";
        
        NSRange result = [responseLogin rangeOfString:str2];
        
        if(result.length >0)
        {
            //user authenticated by Zoho - Wow!!
            
            NSString *newStr = [responseLogin substringFromIndex:(result.location+result.length)];
            NSLog(@"Token = %@",[newStr substringToIndex:32]);
            
            if ([[newStr substringFromIndex:32] length]>0)
            {
                [Utils userDefaultsSetObject:[newStr substringToIndex:32] forKey:ZOHO_CRM_API_KEY];
                [Utils userDefaultsSetObject:userNameTextField.text forKey:ZOHO_CRM_USERNAME];
                [Utils userDefaultsSetObject:passwordTextField.text forKey:ZOHO_CRM_PASSWORD];

            }
            
            [SAppDelegateObject resetDatastore];
            //Deleting all data of current account
            
        }
    }
    
    [self performSelectorOnMainThread:@selector(updateAfterZohoAuthentication) withObject:nil waitUntilDone:YES];
}

-(void)updateAfterZohoAuthentication
{
    [Utils removeLoading:self.view];

    UIAlertView *logoutAlert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"CONFIRM", @"Confirm") message:NSLocalizedString(@"DELETE_NOTE_MESSAGE", @"You will have to logout now") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"Ok")otherButtonTitles:Nil, nil];
    [logoutAlert show];
    
    //[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark AlertView Delegate Methods
    
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if(buttonIndex==0)
   {
       [SAppDelegateObject.viewController.dashBoard.navigationController popToRootViewControllerAnimated:YES];

   }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    userNameTextField.text=[userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    passwordTextField.text=[passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (textField==userNameTextField) {
        
        if (userNameTextField.text.length>0)
        {
            
        [userNameTextField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
        }
        
        else
        {
            [userNameTextField becomeFirstResponder];
            [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY",  @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
        }
        
    }
    
    if (textField==passwordTextField) {
        
        if (passwordTextField.text.length>0)
        {
            [textField resignFirstResponder];
            [self zohoLoginButtonPressed:nil];
            return YES;
        }
        
        else
        {
            [userNameTextField becomeFirstResponder];
            [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY",  @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
        }
        
    }
    
    return NO;
}
@end
