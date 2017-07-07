
//
//  NoteDetailViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 4/3/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "NoteDetailViewController.h"

#import "iPitchConstants.h"

#import <QuartzCore/QuartzCore.h>

#import "iPitchAnalytics.h"
#import "Utils.h"
#import "Reachability.h"

@implementation UINavigationController (DelegateAutomaticDismissKeyboard)

- (BOOL)disablesAutomaticKeyboardDismissal {
    return [self.topViewController disablesAutomaticKeyboardDismissal];
}

@end
@interface NoteDetailViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addNoteTitle;

@end

@implementation NoteDetailViewController
@synthesize noteTitleTextField,noteContentTextView,noteContent,noteTitle,noteCancelButton,noteSaveButton,existingNote,delegate;

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
    self.noteContentTextView.font=[UIFont fontWithName:FONT_REGULAR size:16];
    self.noteTitleTextField.font=[UIFont fontWithName:FONT_REGULAR size:16];
    
    self.noteContentTextView.layer.cornerRadius =5;
    self.noteContentTextView.layer.borderColor=[[UIColor grayColor] CGColor];
    self.noteContentTextView.layer.borderWidth=1.5;
    
    self.noteTitleTextField.layer.cornerRadius =5;
    self.noteTitleTextField.layer.borderColor=[[UIColor grayColor] CGColor];
    self.noteTitleTextField.layer.borderWidth=1.5;
    
    self.noteSaveButton.tintColor = [UIColor whiteColor];
    self.noteCancelButton.tintColor = [UIColor whiteColor];
    self.addNoteTitle.tintColor = [UIColor whiteColor];
    
    if (self.existingNote)
    {
        self.noteTitleTextField.text=self.noteTitle;
        self.noteContentTextView.text=self.noteContent;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNoteTitleTextField:nil];
    [self setNoteContentTextView:nil];
    [self setNoteCancelButton:nil];
    [self setNoteSaveButton:nil];
    [super viewDidUnload];
}
- (IBAction)noteSaveButtonClicked:(id)sender
{
    [self.noteTitleTextField resignFirstResponder];
    [self.noteContentTextView resignFirstResponder];
    if([Reachability connected])
    {
        if([self validateFields])
        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INTEGRATE_TO",@"Integrate To")
//                                                                message:nil
//                                                               delegate:self
//                                                      cancelButtonTitle:NSLocalizedString(@"CANCEL",@"Cancel")
//                                                      otherButtonTitles:@"CRM", nil];
//            [alertView show];
            
            NSMutableDictionary *notesDict=[[NSMutableDictionary alloc]init];
            [notesDict setObject:self.noteTitleTextField.text forKey:NOTES_TITLE];
            [notesDict setObject:self.noteContentTextView.text forKey:NOTES_CONTENT];
            
            [self dismissModalViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTES_ADDED_NOTIFICATION object:notesDict];
        }
    }
    else{
        MBProgressHUD *HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD hide:YES afterDelay:3];
        HUD.mode =MBProgressHUDModeText;
        HUD.labelText= @"No Internet Connection Found";
    }
}

-(BOOL)validateFields
{
    if(self.noteTitleTextField.text.length == 0)
    {
        [Utils showMessage:@"Note Subject cannot be blank" withTitle:NSLocalizedString(@"ALERT",@"Alert")];
        
        return NO;
    }
    else if(self.noteContentTextView.text.length ==0)
    {
        [Utils showMessage:@"Note Details cannot be blank" withTitle:NSLocalizedString(@"ALERT",@"Alert")];
        
        return NO;
    }
    else
        return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL localSave=NO;
    if(buttonIndex ==0)
    {
        return;
    }
    else if(buttonIndex ==1)
    {
        localSave=NO;
    }
    
    NSMutableDictionary *notesDict=[[NSMutableDictionary alloc]init];
    [notesDict setObject:self.noteTitleTextField.text forKey:NOTES_TITLE];
    [notesDict setObject:self.noteContentTextView.text forKey:NOTES_CONTENT];
    [notesDict setObject:[NSNumber numberWithBool:localSave] forKey:NOTES_STATUS];
    
    [self dismissModalViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTES_ADDED_NOTIFICATION object:notesDict];
//    if ([self.delegate respondsToSelector:@selector(noteSaveClicked:)])
//        [self.delegate noteSaveClicked:localSave];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTES_ADDED_NOTIFICATION object:notesDict];
    
}

- (IBAction)noteCancelButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


@end
