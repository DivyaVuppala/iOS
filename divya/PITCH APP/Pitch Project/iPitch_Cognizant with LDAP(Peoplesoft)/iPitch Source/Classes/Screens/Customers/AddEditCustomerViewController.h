//
//  AddEditCustomerViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 5/7/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customers.h"

@protocol AddEditCustomerStatusDelegate <NSObject>

@optional

-(void)customerDataSavedSuccessfully;

-(void)customerDataSaveFailedWithError:(NSError *)error;

@end

@interface AddEditCustomerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIToolbar *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic,retain) Customers *customerObject;
@property (nonatomic,weak) id <AddEditCustomerStatusDelegate> delegate;

- (IBAction)customerIconButtonClicked:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
