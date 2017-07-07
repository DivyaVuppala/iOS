//
//  ShowCustomerDetails.h
//  iPitch V2
//
//  Created by Krishna Chaitanya on 13/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesProcessViewController.h"
#import "Customers.h"
#import "MBProgressHUD.h"
#import "Lead.h"
#import "AddEventViewController.h"


@interface ShowCustomerDetails : UIViewController<UITableViewDataSource, UITableViewDelegate,AddNewEventDelegate>{
    UIScrollView * CustomerScrollView;
    NSDate *date;
    MBProgressHUD *HUD;

    UIPopoverController *SendAppointmentPopoverController;
    
    UITextField *emailTextField;
    UITextField *dateTextField;
    UITextField *timeTextField;
    UITextField *locationTextField;
    UIButton *saveInvite;
    UIButton *sendInvite;
    
    NSMutableArray *SocialFeedsImagesArray;
    NSMutableArray *dummyArray;
    NSMutableArray *customersArray;
    NSMutableArray * socialFeedsArray;
    NSMutableArray * TaggedAccount;
}


@property (nonatomic,retain) IBOutlet UILabel *custName;
@property (nonatomic,retain) IBOutlet UILabel *custDesignation;
@property (nonatomic,retain) IBOutlet UILabel *custAddress;
@property (nonatomic,retain) IBOutlet UILabel *custPhone;
@property (nonatomic,retain) IBOutlet UIButton *sendAppointment;
@property (strong, nonatomic) UIButton *recipient360Button;
@property (strong, nonatomic) IBOutlet UIButton *profileIconBtn;
@property (strong, nonatomic) IBOutlet UIButton *Backbutton;
@property (weak, nonatomic) IBOutlet UIView *CustomerDetailView;
@property (weak, nonatomic) IBOutlet UIView * OtherCustomerView;
@property (weak, nonatomic) IBOutlet UIView * SocialCustomerView;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UIButton *skypeButton;
@property(nonatomic, retain) Customers *customerObject;
@property(nonatomic, retain) Lead *LeadObject;

@property(nonatomic, strong) IBOutlet UITableView * tweetTable;
@property (weak, nonatomic) IBOutlet UIButton *addActivityToCustomersButton;
- (IBAction)addActivityToCustomersButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addOpportunityToCustomerButton;
- (IBAction)addOpportunityButtonClicked:(id)sender;

- (IBAction)accountButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UITableView *ActivityTable;
@property (weak, nonatomic) IBOutlet UITableView *OpportunityTable;
@property(nonatomic, retain) SalesProcessViewController *cispview;
@property(nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property(nonatomic, retain) IBOutlet UIButton *UserIcon;
@property(nonatomic, retain) IBOutlet UIButton *Searchbtn;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *socialFeedsActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalLine;
@property (weak, nonatomic) IBOutlet UILabel *socialFeedsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *relatedCustomersTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activitiesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *upcomingAppointmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *CustomerDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *customerIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *customerEditFieldsButton;
@property (weak, nonatomic) IBOutlet UILabel *customerEmail;

-(IBAction)sendAppointment:(id)sender;
-(IBAction)BackbuttonClicked:(id)sender;
-(IBAction)SkypebuttonClicked:(id)sender;
-(IBAction)profileIconClicked:(id)sender;
- (IBAction)customerEditFieldsClicked:(id)sender;

@end
