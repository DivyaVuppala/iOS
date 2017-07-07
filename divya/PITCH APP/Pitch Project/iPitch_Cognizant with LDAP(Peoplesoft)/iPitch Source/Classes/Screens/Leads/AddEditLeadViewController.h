//
//  AddEditLeadViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 5/14/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Leads.h"

@protocol AddEditLeadStatusDelegate <NSObject>

@optional

-(void)leadDataSavedSuccessfully;

-(void)leadDataSaveFailedWithError:(NSError *)error;

@end
@interface AddEditLeadViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIToolbar *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic,retain) Leads *leadObject;
@property (nonatomic,weak) id <AddEditLeadStatusDelegate> delegate;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
