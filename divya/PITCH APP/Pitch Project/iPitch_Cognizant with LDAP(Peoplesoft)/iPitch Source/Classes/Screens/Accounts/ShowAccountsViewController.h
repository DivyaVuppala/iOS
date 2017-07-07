//
//  ShowAccountsViewController.h
//  iPitch V2
//
//  Created by Vineet on 27/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accounts.h"
#import "MBProgressHUD.h"
#import "AddEventViewController.h"
#import "AddEditAccountsViewController.h"
#import "SearchAccounts.h"
#import "AddNewOpportunityController.h"


@interface ShowAccountsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,AddNewEventDelegate,AddEditAccountStatusDelegate,Success>{
    UIScrollView * CustomerScrollView;

    NSDate *date;
    
    UIPopoverController *SendAppointmentPopoverController;
    
    UITextField *emailTextField;
    UITextField *dateTextField;
    UITextField *timeTextField;
    UITextField *locationTextField;
    UIButton *saveInvite;
    UIButton *sendInvite;
    
    NSMutableArray *SocialFeedsImagesArray;
    NSMutableArray * dummyArray;
    NSMutableArray * customersArray;
    NSMutableArray * socialFeedsArray;
    MBProgressHUD *HUD;

}

@property (nonatomic,retain) IBOutlet UILabel *accountName;
@property (nonatomic,retain) IBOutlet UILabel *accountIndustry;
@property (nonatomic,retain) IBOutlet UILabel *accountType;
@property (nonatomic,retain) IBOutlet UIButton *sendAppointment;
@property (strong, nonatomic) UIButton *recipient360Button;
@property (strong, nonatomic) IBOutlet UIButton *profileIconBtn;
@property (strong, nonatomic) IBOutlet UIButton *Backbutton;
@property (weak, nonatomic) IBOutlet UIView *AccountDetailView;
@property (weak, nonatomic) IBOutlet UIView * OtherCustomerView;
@property (weak, nonatomic) IBOutlet UIView * SocialCustomerView;
@property (weak, nonatomic) IBOutlet UITableView * SocialCustomerTableView;
@property (weak, nonatomic) IBOutlet UITableView *ActivityTable;
@property (weak, nonatomic) IBOutlet UITableView *OpportunityTable;
@property(nonatomic, retain)  SearchAccounts *AccObject;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *socialFeedsActivityIndicator;
@property (weak,nonatomic)IBOutlet UILabel *name;
@property (weak,nonatomic)IBOutlet UILabel *ID;
@property (weak,nonatomic)IBOutlet UILabel *nameValue;
@property (weak,nonatomic)IBOutlet UILabel *IDValue;
@property(nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property(nonatomic, retain) IBOutlet UIButton *UserIcon;
@property(nonatomic, retain) IBOutlet UIButton *Searchbtn;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalLine;

@property (weak, nonatomic) IBOutlet UILabel *socialFeedsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activitiesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *upcomingAppointmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *AccountDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *addEventToAccountButton;
@property (weak, nonatomic) IBOutlet UIImageView *accountIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *accountEditButton;
@property (weak, nonatomic) IBOutlet UILabel *accountAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNumberOfEmployees;
@property (weak, nonatomic) IBOutlet UILabel *companyID;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIButton *addOpportunityToAccountButton;
- (IBAction)addOpportunityToAccountButtonPressed:(id)sender;

- (IBAction)addEventToAccountButtonPressed:(id)sender;

-(IBAction)sendAppointment:(id)sender;
-(IBAction)BackbuttonClicked:(id)sender;

-(IBAction)profileIconClicked:(id)sender;
- (IBAction)accountEditButtonClicked:(id)sender;

@end


