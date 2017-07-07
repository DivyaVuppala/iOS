//
//  LeadDetailsViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 5/11/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Leads.h"
#import "MBProgressHUD.h"
#import "AddEventViewController.h"

@interface LeadDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,AddNewEventDelegate>{
    
    MBProgressHUD *HUD;
   
    NSMutableArray *SocialFeedsImagesArray;
    NSMutableArray *dummyArray;
    NSMutableArray *customersArray;
    NSMutableArray * socialFeedsArray;
    NSMutableArray * TaggedAccount;
}


@property (nonatomic,retain) IBOutlet UILabel *leadName;
@property (nonatomic,retain) IBOutlet UILabel *leadDesignation;
@property (nonatomic,retain) IBOutlet UILabel *leadAddress;
@property (nonatomic,retain) IBOutlet UILabel *leadPhone;
@property (strong, nonatomic) IBOutlet UIButton *Backbutton;
@property (weak, nonatomic) IBOutlet UIView *leadDetailView;
@property (weak, nonatomic) IBOutlet UIView * OtherleadView;
@property (weak, nonatomic) IBOutlet UIView * SocialLeadView;
@property (weak, nonatomic) IBOutlet UIButton *skypeButton;
@property(nonatomic, retain) Leads *LeadObject;

@property(nonatomic, strong) IBOutlet UITableView * tweetTable;
@property (weak, nonatomic) IBOutlet UIButton *addActivityToLeadsButton;

@property (weak, nonatomic) IBOutlet UIView *leadThirdView;
@property (weak, nonatomic) IBOutlet UITableView *ActivityTable;
@property(nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property(nonatomic, retain) IBOutlet UIButton *UserIcon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *socialFeedsActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalLine;
@property (weak, nonatomic) IBOutlet UILabel *socialFeedsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *relatedCustomersTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activitiesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *upcomingAppointmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leadIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *leadEditFieldsButton;
@property (weak, nonatomic) IBOutlet UILabel *leadEmail;
@property (weak, nonatomic) IBOutlet UILabel *leadStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadDescriptionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadSourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadSourceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadRatingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadStatusTitleLabel;

- (IBAction)BackbuttonClicked:(id)sender;
- (IBAction)SkypebuttonClicked:(id)sender;
- (IBAction)leadEditButtonClicked:(id)sender;
- (IBAction)addActivityToLeadsButton:(id)sender;


@end
