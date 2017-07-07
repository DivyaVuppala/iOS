//
//  PDFPreviewViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/17/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "PDFPreviewViewController.h"
#import "ThemeHelper.h"
#import "AppDelegate.h"
#import "iPitchConstants.h"
#import "ModelTrackingClass.h"
#import "iPitchAnalytics.h"
#import "Utils.h"

@interface PDFPreviewViewController ()<UIAlertViewDelegate>

@end

@implementation PDFPreviewViewController
@synthesize documentWebView;
@synthesize pdfFile;

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
    
    self.navigationController.navigationBarHidden=NO;
    self.PDFNameLabel.text=self.pdfFile.fileName;
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:self.pdfFile.filePath isDirectory:FALSE]) {
        [self.documentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.pdfFile.filePath isDirectory:NO]]];
    }


    self.toolBar.frame=CGRectMake(0, 0, self.view.frame.size.width, 44);
    
    [ThemeHelper applyCurrentThemeToView];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)viewDidUnload {
    [self setDoneButton:nil];
    [self setEmailButton:nil];
    [self setSaveButton:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
}
- (IBAction)doneButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];

}
- (IBAction)emailButtonPressed:(id)sender {
    
    
     NSMutableData *pdfData = [NSMutableData dataWithContentsOfFile:self.pdfFile.filePath];
     [[ModelTrackingClass sharedInstance] setModelObject:pdfData forKey:@"PDFDataToMail"];
     [[ModelTrackingClass sharedInstance] setModelObject:self.pdfFile.fileName forKey:@"PDFMailName"];
     
     [self dismissViewControllerAnimated:YES completion:^
     {
     
     [SAppDelegateObject sendMailToRecipients:nil withSubject:[NSString stringWithFormat:@"Mailing PDF - %@",self.pdfFile.fileName] andMessage:@"Hi, PFA." WithAttachmentsIfAny:[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"PDFDataToMail"] andAttachmentType:@"application/pdf" andAttachmentName:[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"PDFMailName"]];
     
     }];

}

- (IBAction)saveButtonPressed:(id)sender {
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Document Screen" withAction:@"Saved Generated PDF" withLabel:nil withValue:nil];
    
    UIAlertView *createNewPlaylistAlert=[[UIAlertView alloc]initWithTitle:@"Enter File Name \n" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",@"Cancel") otherButtonTitles:NSLocalizedString(@"OK",@"Ok"), nil];
    createNewPlaylistAlert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [createNewPlaylistAlert show];
}


#pragma mark AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==0)
    {
        
    }
    
    else if(buttonIndex==1)
    {
        //creating new playlist
        NSString *newPDFName= [alertView textFieldAtIndex:0].text;
        
        NSFileManager *fileMgr=[NSFileManager defaultManager];
        NSString *destinationFilePath=[[Utils applicationDocumentsDirectory] stringByAppendingPathComponent:[newPDFName stringByAppendingString:@".pdf"]];
        NSError *error;
        
        if(![fileMgr copyItemAtPath:self.pdfFile.filePath toPath:destinationFilePath error:&error])
        {
            NSLog(@"Could not save file: %@",[error localizedDescription]);
            [Utils showToastWithText:@"Sorry could not save pdf try again" inView:self.view hideAfter:HUD_ALERT_TIMING];
        }
        
        else
        {
            [Utils showToastWithText:@"File Saved Successfully!!" inView:self.view hideAfter:HUD_ALERT_TIMING];

        }
        
    }
}
@end
