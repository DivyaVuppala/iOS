//
//  DashboardViewController.h
//  iPitch V2
//
//  Created by Krishna Chaitanya on 18/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RearMasterTableViewController.h"
#import "SWRevealViewController.h"
#import "CalendarViewController.h"
#import "BoxUser.h"
#import "BoxCommonUISetup.h"
#import "BoxLoginViewController.h"
#import "MBProgressHUD.h"
#import "AddedEventViewController.h"
#import "SalesProcessViewController.h"
#import "OCCalendarViewController.h"
#import "SettingsViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface DashboardViewController : UIViewController<SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,BoxLoginViewControllerDelegate,OCCalendarDelegate>
{
    UIPopoverController *EventDashboardPopoverCont;
    
    NSMutableArray *TableViewArray;
    CalendarViewController *calendarViewController;
    MBProgressHUD *HUD;
    NSString *currentFolderpath;
    BoxLoginViewController * vc;
    UIView *calendarEventBGView;
    
    UILabel *dashboardDate;
    UILabel *dashboardMonth;
    UILabel *dashboardYear;
    
    UILabel *dashboardNextDate;
    UILabel *dashboardNextDateMonth;
    UILabel *dashboardNextDateYear;
    
    UIView *dashboardDateView;
    UIView *dashboardNextDateView;
    
    NSDate *currentDay;
    NSMutableArray *masterEventsArray;
    NSMutableArray *eventArray;
    NSArray *HOURS_AM_PM;
    NSMutableDictionary *sDayTimeSource;
    NSMutableArray *eventBtnsPopUpArray;
    NSMutableArray *eventLabelsPopUpArray;
    UIView *calendarEventView;
    NSMutableArray * AccountArray;
    NSMutableArray * OpportunityArray;
    NSMutableArray *customersArray;
    
    BOOL eventVisible;
    OCCalendarViewController *calVC;
    SettingsViewController *settingsViewController;
    SystemSoundID audioEffect;
    NSString *currentScreenTheme;
    BOOL firstTimeLoad;
}

@property (nonatomic, retain) UILabel *dashboardDate;
@property (nonatomic, retain) UILabel *dashboardNextDate;
@property (nonatomic, retain) UIView *circleView;

@property (nonatomic, retain) IBOutlet UIView *belowView;

@property (nonatomic, retain) IBOutlet UIView *CustDashboardView;
@property (nonatomic, retain) IBOutlet UIView *oppDashboardView;
@property (nonatomic, retain) IBOutlet UIView *DocsDashboardView;

@property (nonatomic, retain) IBOutlet UIView *custBGView;
@property (nonatomic, retain) IBOutlet UIView *oppBGView;
@property (nonatomic, retain) IBOutlet UIView *DocsBGView;

@property (nonatomic, retain) IBOutlet UITableView *CustomersTable;
@property (nonatomic, retain) IBOutlet UITableView *OppurtunitiesTable;
@property (nonatomic, retain) IBOutlet UITableView *DocumentsTable;
@property (nonatomic, retain) UIScrollView *animationScroll;

@property (nonatomic, retain) IBOutlet UIButton *calendarOpenBtn;
@property (nonatomic, retain) IBOutlet UIButton *CustClose;
@property (nonatomic, retain) IBOutlet UIButton *oppClose;
@property (nonatomic, retain) IBOutlet UIButton *DocsClose;

@property (nonatomic, retain) IBOutlet UIButton *CustOpen;
@property (nonatomic, retain) IBOutlet UIButton *oppOpen;
@property (nonatomic, retain) IBOutlet UIButton *DocsOpen;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;


@property (nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property (nonatomic, retain) IBOutlet UIButton *UserIcon;

@property (nonatomic, retain) IBOutlet UIButton *CustMoreBtn;
@property (nonatomic, retain) IBOutlet UIButton *OppMoreBtn;
@property (nonatomic, retain) IBOutlet UIButton *DocsMoreBtn;

@property (nonatomic, retain) IBOutlet UIImageView *belowDivider;
@property (weak, nonatomic) IBOutlet UIButton *logoToogleButton;

@property (nonatomic, retain) NSMutableArray *tableSource;
@property (nonatomic, retain) Folder *currentFolder;
@property (nonatomic, retain) NSString *currentFolderpath;

@property (nonatomic, retain) AddedEventViewController *moreEventVC;
@property (nonatomic, retain) SalesProcessViewController *cispview;

@property (nonatomic, retain) IBOutlet UIButton *Searchbtn;
@property (weak, nonatomic) IBOutlet UILabel *myCustomersLabel;
@property (weak, nonatomic) IBOutlet UILabel *myOpportunitiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *myAccountsLabel;

-(IBAction)OppurtunitiesButtonClick:(id)sender;
-(IBAction)CustomersButtonClick:(id)sender;
-(IBAction)DocumentsButtonClick:(id)sender;

-(IBAction)CustMoreClick:(id)sender;
-(IBAction)DocsMoreClick:(id)sender;
-(IBAction)OppMoreClick:(id)sender;

-(IBAction)calendarClicked:(id)sender;
-(IBAction)userIconClicked:(id)sender;

@end
