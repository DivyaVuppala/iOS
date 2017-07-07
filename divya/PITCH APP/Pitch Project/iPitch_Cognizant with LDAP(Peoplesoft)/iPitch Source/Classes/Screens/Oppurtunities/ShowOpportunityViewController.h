//
//  ShowOpportunityViewController.h
//  iPitch V2
//
//  Created by Vineet on 27/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opportunities.h"
#import "MBProgressHUD.h"
#import "AddEventViewController.h"
#import "Opportunity.h"

@interface ShowOpportunityViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,AddNewEventDelegate>{
	NSDictionary *productsDict;
	NSArray *keysArray;
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
    NSMutableArray * customersArray;
    NSMutableArray * socialFeedsArray;
    int number_of_stages;
    int current_stage;
    NSMutableArray *stageIndicators;
    MBProgressHUD *HUD;
    int index;

}
@property (nonatomic)int index;
@property (nonatomic,retain) NSDictionary *productsDict;
@property (nonatomic,retain) NSArray *keysArray;
@property (nonatomic,retain) IBOutlet UILabel *OpportunityName;
@property (nonatomic,retain) IBOutlet UILabel *ProbabilityLabel;
@property (nonatomic,retain) IBOutlet UILabel *DealSizeLabel;
@property (nonatomic,retain) IBOutlet UILabel *Description;
@property (nonatomic,retain) IBOutlet UILabel *stageDetails;
@property (nonatomic,retain) IBOutlet UILabel *OpportunityDescription;
@property (nonatomic,retain) IBOutlet UILabel *custOrganization;
@property (nonatomic,retain) IBOutlet UILabel *client;
@property (nonatomic,retain) IBOutlet UILabel *tcv;
@property (nonatomic,retain) IBOutlet UILabel *firstYear;
@property (nonatomic,retain) IBOutlet UILabel *closedate;
@property (nonatomic,retain) IBOutlet UILabel *duration;
@property (nonatomic,retain) IBOutlet UILabel *percentage;
@property (nonatomic,retain) IBOutlet UILabel *product;
@property (nonatomic,retain) IBOutlet UIButton *sendAppointment;
@property (strong, nonatomic) UIButton *recipient360Button;
@property (strong, nonatomic) IBOutlet UIButton *profileIconBtn;
@property (strong, nonatomic) IBOutlet UIButton *Backbutton;
@property (weak, nonatomic) IBOutlet UIView *OpportunityDetailView;
@property (weak, nonatomic) IBOutlet UIView * OtherCustomerView;
@property (weak, nonatomic) IBOutlet UIView * SocialCustomerView;
@property (weak, nonatomic) IBOutlet UITableView * SocialtweetTableView;
@property (weak, nonatomic) IBOutlet UITableView *ActivityTable;
@property (weak, nonatomic) IBOutlet UITableView *OpportunityTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *socialFeedsActivityIndicator;

@property(nonatomic, retain)Opportunity * PotentialObject;
@property(nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property(nonatomic, retain) IBOutlet UIButton *UserIcon;
@property(nonatomic, retain) IBOutlet UIButton *Searchbtn;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalLine;

@property (weak, nonatomic) IBOutlet UILabel *socialFeedsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descripitonLabel;
@property (weak, nonatomic) IBOutlet UILabel *activitiesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *upcomingAppointmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppDealSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppProbabilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppRiskToleranceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppLiquidityScore;
@property (weak, nonatomic) IBOutlet UILabel *oppAcumenLabel;
@property (weak, nonatomic) IBOutlet UILabel *debtLabel;
@property (weak, nonatomic) IBOutlet UILabel *equityLabel;
@property (weak, nonatomic) IBOutlet UILabel *OppDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *addEventToOpportunityButton;
- (IBAction)addEventToOpportunityClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *stagesBreadCrumbView;
@property (strong, nonatomic) NSMutableDictionary *stagesDictionary;
@property (strong, nonatomic) NSMutableArray *stagesArray;
@property (weak, nonatomic) IBOutlet UIButton *opportunityEditButton;

@property (weak, nonatomic) IBOutlet UIImageView *opportunityIconImageView;
-(IBAction)sendAppointment:(id)sender;
-(IBAction)BackbuttonClicked:(id)sender;

-(IBAction)profileIconClicked:(id)sender;
- (IBAction)opportunityEditButtonClicked:(id)sender;


@end


