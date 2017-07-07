//
//  AddNewOpportunityController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 4/29/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPitchConstants.h"
#import "Accounts.h"
#import "Customers.h"
#import "Opportunity.h"
#import "SearchAccounts.h"

@protocol AddEditOpportunityStatusDelegate <NSObject>

@optional

-(void)opportunitySavedSuccessfully:(Opportunity *)object;

-(void)opportunityDataSaveFailedWithError:(NSError *)error;


@end


@protocol Success <NSObject>

@required

-(void)showSuccess:(Opportunity *)object;
-(void)showFaiure;
-(void)showNoPrimaryContact;

@end


@interface AddNewOpportunityController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *opportunityNameField;
@property (weak, nonatomic) IBOutlet UITextField *opportunityAmountField;
@property (weak, nonatomic) IBOutlet UIButton *opportunityClosingDateButton;
@property (weak, nonatomic) IBOutlet UITextField *opportunityProbabilityField;
@property (weak, nonatomic) IBOutlet UITextField *opportunityNextStepField;
@property (weak, nonatomic) IBOutlet UITextField *opportunityDescriptionField;
@property (weak, nonatomic) IBOutlet UITextField *txtTVC;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstYear;
@property (weak, nonatomic) IBOutlet UITextField *txtClosedate;
@property (weak, nonatomic) IBOutlet UITextField *txtDeal;
@property (weak, nonatomic) IBOutlet UIButton *opportunityTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *opportunityStageButton;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *txtSubject;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UILabel *lblID;
@property (weak, nonatomic) IBOutlet UITextField *txtID;
@property (nonatomic,retain)SearchAccounts *accountObject;
@property (nonatomic,retain)Customers *customerObject;
@property (nonatomic,retain)Opportunity *opportunityObject;
@property (nonatomic,retain)NSNumberFormatter *formatter;
@property (nonatomic,assign) ModuleType opportunityRelatedToModule;
@property (nonatomic,weak) id <AddEditOpportunityStatusDelegate> delegate;
@property (nonatomic,weak) id <Success> sucessDelegate;
@property (nonatomic) BOOL edit;
@property (nonatomic,retain)IBOutlet UILabel *titleLbl;
@property (weak,nonatomic) IBOutlet UIButton *addBtn;

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;

- (IBAction)opportunityStageButtonPressed:(id)sender;
- (IBAction)opportunityTypeButtonPressed:(id)sender;
- (IBAction)opportunityClosingDateButtonPressed:(id)sender;
- (IBAction)addOpportunity:(id)sender;
- (IBAction)delOpportunity:(id)sender;
- (void)loadValuesEdit;
- (void)loadValuesAdd;
- (void)editOpportunity;
- (BOOL)validateFields;
- (BOOL)validateField;
- (NSMutableDictionary *)createXML;

@end
