//
//  DashboardViewController.m
//  iPitch V2
//
//  Created by Krishna Chaitanya on 18/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "ZohoHelper.h"
#import "BoxUser.h"
#import "LoginViewController.h"
#import "ModelTrackingClass.h"
#import "PDFViewController.h"
#import "SNSDateUtils.h"
#import <QuartzCore/CABase.h>
#import <QuartzCore/CAMediaTiming.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/QuartzCore.h>
#import "AddedEventViewController.h"
#import "iPitchConstants.h"
#import "UIView+Genie.h"
#import "ShowCustomerDetails.h"
#import "ShowAccountsViewController.h"
#import "ShowOpportunityViewController.h"
#import "Accounts.h"
#import "Events.h"
#import "Customers.h"
#import "Utils.h"
#import "iPitchAnalytics.h"
#import "AsyncImageView.h"
#import "PersnoalDashboardViewController.h"
#import "ThemeHelper.h"
#import "SalesForceHelper.h"

BOOL oppurtunitiesOpened;
BOOL customersOpened;
BOOL documentsOpened;

@interface DashboardViewController()

@property (readonly) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (readonly) UISwipeGestureRecognizer *swipeRightRecognizer;
@end

@implementation DashboardViewController
@synthesize belowView, Searchbtn, cispview;
@synthesize CustomersTable;
@synthesize OppurtunitiesTable;
@synthesize DocumentsTable;
@synthesize animationScroll;
@synthesize calendarOpenBtn;
@synthesize CustClose;
@synthesize DocsClose;
@synthesize oppClose;
@synthesize CustOpen;
@synthesize DocsOpen;
@synthesize oppOpen, tableSource, currentFolder,currentFolderpath;
@synthesize CustDashboardView, DocsDashboardView, oppDashboardView;
@synthesize swipeLeftRecognizer=_swipeLeftRecognizer;
@synthesize swipeRightRecognizer=_swipeRightRecognizer;
@synthesize dashboardDate, dashboardNextDate;
@synthesize circleView;
@synthesize moreEventVC;
@synthesize CustMoreBtn, DocsMoreBtn, OppMoreBtn;
@synthesize custBGView, oppBGView, DocsBGView, UserIcon, NotificationIcon, belowDivider, logoToogleButton;
@synthesize myCustomersLabel;
@synthesize myAccountsLabel;
@synthesize myOpportunitiesLabel;
@synthesize toolBarView;

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#pragma mark View Life Cycle

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
    
    oppurtunitiesOpened = FALSE;
    customersOpened = FALSE;
    documentsOpened = FALSE;
    
    self.myAccountsLabel.text=NSLocalizedString(@"MY_ACCOUNTS", @"My Accounts");
    self.myOpportunitiesLabel.text=NSLocalizedString(@"MY_OPPORTUNITIES", @"My Opportunities");
    self.myCustomersLabel.text=NSLocalizedString(@"MY_CUSTOMERS", @"My Customers");
    
    
    animationScroll = [[UIScrollView alloc]init];
    animationScroll.frame = CGRectMake(0, 250, 1024, 230);
    calendarOpenBtn.frame = CGRectMake(20, 345, 45, 46);
    
    masterEventsArray =[[NSMutableArray alloc]init];
    eventArray = [[NSMutableArray alloc] init];
    
    //array with total hours in a 24hrs day
    HOURS_AM_PM=[[NSArray alloc] initWithObjects:  @"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18",@"19",@"20",@"21",@"22",@"23",@"24", nil];
    
    sDayTimeSource=[[NSMutableDictionary alloc]init];
    calendarEventBGView = [[UIView alloc]init];
    calendarEventBGView.frame = CGRectMake(0, 110, 1024, 17);
    
    
    calendarEventView = [[UIView alloc]init];
    calendarEventView.frame = CGRectMake(0, 115, 0, 7);
    calendarEventView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nod_strip.png"]];
    
    dashboardDate = [[UILabel alloc]init];
    dashboardDate.frame = CGRectMake(10, 0, 45, 54);
    dashboardDate.backgroundColor = [UIColor clearColor];
    dashboardDate.textColor = [UIColor whiteColor];
    [dashboardDate setFont:[UIFont fontWithName:FONT_BOLD size:46]];
    
    dashboardMonth = [[UILabel alloc]init];
    dashboardMonth.frame = CGRectMake(70, 2, 45, 25);
    dashboardMonth.backgroundColor = [UIColor clearColor];
    dashboardMonth.textColor = [UIColor whiteColor];
    [dashboardMonth setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    
    dashboardYear = [[UILabel alloc]init];
    dashboardYear.frame = CGRectMake(70, 27, 45, 25);
    dashboardYear.backgroundColor = [UIColor clearColor];
    dashboardYear.textColor = [UIColor whiteColor];
    [dashboardYear setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    
    
    
    dashboardDateView =[[UIView alloc]initWithFrame:CGRectMake(60, 20, 120, 54)];
    
    [dashboardDateView addSubview:dashboardDate];
    [dashboardDateView addSubview:dashboardMonth];
    [dashboardDateView addSubview:dashboardYear];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dashboardCurrentDateClicked)];
    [dashboardDateView addGestureRecognizer:tapGesture];
    
    dashboardNextDate = [[UILabel alloc]init];
    dashboardNextDate.frame = CGRectMake(10, 0, 45, 54);
    dashboardNextDate.backgroundColor = [UIColor clearColor];
    dashboardNextDate.textColor = [UIColor whiteColor];
    [dashboardNextDate setFont:[UIFont fontWithName:FONT_BOLD size:46]];
    
    dashboardNextDateMonth = [[UILabel alloc]init];
    dashboardNextDateMonth.frame = CGRectMake(70, 2, 45, 25);
    dashboardNextDateMonth.backgroundColor = [UIColor clearColor];
    dashboardNextDateMonth.textColor = [UIColor whiteColor];
    [dashboardNextDateMonth setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    
    dashboardNextDateYear = [[UILabel alloc]init];
    dashboardNextDateYear.frame = CGRectMake(70, 27, 45, 25);
    dashboardNextDateYear.backgroundColor = [UIColor clearColor];
    dashboardNextDateYear.textColor = [UIColor whiteColor];
    [dashboardNextDateYear setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    
    dashboardNextDateView =[[UIView alloc]initWithFrame:CGRectMake(940, 20, 120, 54)];
    
    
    [dashboardNextDateView addSubview:dashboardNextDate];
    [dashboardNextDateView addSubview:dashboardNextDateMonth];
    [dashboardNextDateView addSubview:dashboardNextDateYear];
    
    //initializing current day as today.
    currentDay = [[NSDate alloc]init];
    
    [self.animationScroll addSubview:dashboardDateView];
    [self.animationScroll addSubview:dashboardNextDateView];
    [self.animationScroll addSubview:calendarEventBGView];
    [self.animationScroll addSubview:calendarEventView];
    
    masterEventsArray =[[NSMutableArray alloc]init];
    
    [self.animationScroll addGestureRecognizer:self.swipeLeftRecognizer];
    [self.animationScroll addGestureRecognizer:self.swipeRightRecognizer];
    
    [self setUpDateLabelForDate:currentDay];
    [self addEventsToTimeSource];
    [self getEventsForCurrentDate];
    //  [self loadCalendar];   commented.. check after
    
    CustomersTable.backgroundColor = [UIColor clearColor];
    OppurtunitiesTable.backgroundColor = [UIColor clearColor];
    DocumentsTable.backgroundColor = [UIColor clearColor];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Dashboard_bg.png"]];
    
    [self.view addSubview:calendarOpenBtn];
    
    TableViewArray = [[NSMutableArray alloc]initWithObjects: nil];
    [CustDashboardView removeFromSuperview];
    [oppDashboardView removeFromSuperview];
    [DocsDashboardView removeFromSuperview];
    
    [self.view addSubview: animationScroll];
    [self.view bringSubviewToFront:calendarOpenBtn];
    
    
    //To check whether user has already logged in to Box.
    BoxUser* userModel = [BoxUser savedUser];
    
    if(/*![self.dBHelper checkForSession:self]*//*for dropBox*/  /*||*/ !userModel/*for box*/)
    {
        //ask user to login.
        
        // self.view.userInteractionEnabled=NO;
        // [self performSelector:@selector(BoxLogin) withObject:nil afterDelay:0];
        
    }
    else
    {
    }
    
    AccountArray = [[ NSMutableArray alloc] init];
    OpportunityArray = [[NSMutableArray alloc] init];
    customersArray=[[ NSMutableArray alloc] init];
    
    eventVisible=NO;
    
    //[self loadCalendar];
    firstTimeLoad=YES;
    [self rearrangeTableViews];
    
    currentScreenTheme=[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME];
    [self adjustScreenToThemeName:currentScreenTheme];
    
    SWRevealViewController *revealController = self.revealViewController;
    [self.toolBarView addGestureRecognizer:revealController.panGestureRecognizer];
    [self.logoToogleButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self refreshDataSourceFromCoreDataStore];
    });
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDataSourceFromCoreDataStore) name:LOADED_MODULES_DATA_NOTIFICATION object:nil];
    
}


- (void)viewDidUnload
{
    [self setMyCustomersLabel:nil];
    [self setMyOpportunitiesLabel:nil];
    [self setMyAccountsLabel:nil];
    [self setToolBarView:nil];
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    SAppDelegateObject.revealStatus=YES;
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"DashBoard"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    
    
    if(![currentScreenTheme isEqualToString:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME]])
    {
        currentScreenTheme=[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME];
        [self adjustScreenToThemeName:currentScreenTheme];
    }
    
    //Checking for the current theme from NSUserDefaults and assigning background image accordingly
    //[self updateAfterRefresh];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [ThemeHelper applyCurrentThemeToView];
    
    
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

#pragma mark Theme Methods

- (void)adjustScreenToThemeName:(NSString *)themeName
{
    if ([themeName isEqualToString:IPITCH_THEME1_NAME])
    {
        [self.logoToogleButton setBackgroundImage:[UIImage imageNamed:@"login_logo.png"] forState:UIControlStateNormal];
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"search_icon.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification_icon.png"]];
        calendarOpenBtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"calander_icon.png"]];
        
        self.belowDivider.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"divider.png"]];
        calendarEventBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nod_backstrip_new.png"]];
        dashboardDateView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashboard_date_BG_strip.png"]];
        self.belowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"divider_new.png"]];
        
        
        self.CustDashboardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"box_shadow1.png"]];
        self.oppDashboardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"box_shadow1.png"]];
        self.DocsDashboardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"box_shadow1.png"]];
        dashboardNextDateView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashboard_date_BG_strip.png"]];
        
        custBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"single_stripbox.png"]];
        oppBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"single_stripbox.png"]];
        DocsBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"single_stripbox.png"]];
        
        [CustOpen setBackgroundImage:[UIImage imageNamed:@"customers_normal_new.png"] forState:UIControlStateNormal];
        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"documents_normal_new.png"] forState:UIControlStateNormal];
        [oppOpen setBackgroundImage:[UIImage imageNamed:@"oppourtinites_normal_new.png"] forState:UIControlStateNormal];
        
    }
    
    else if ([themeName isEqualToString:IPITCH_THEME2_NAME])
    {
        [self.logoToogleButton setBackgroundImage:[UIImage imageNamed:@"login_logo.png"] forState:UIControlStateNormal];
        
        
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_search_icon_1.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_notification_icon.png"]];
        calendarOpenBtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_calander_icon.png"]];
        calendarEventBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_nod_backstrip.png"]];
        
        self.belowDivider.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_divider.png"]];
        // need dis
        dashboardDateView.backgroundColor= [UIColor clearColor];
        dashboardNextDateView.backgroundColor= [UIColor clearColor];
        self.belowView.backgroundColor = [UIColor clearColor];
        
        self.CustDashboardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2-box_shadow.png"]];
        self.oppDashboardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2-box_shadow.png"]];
        self.DocsDashboardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2-box_shadow.png"]];
        
        custBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2-box_divider_1.png"]];
        oppBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2-box_divider_1.png"]];
        DocsBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2-box_divider_1.png"]];
        
        [CustOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_customers_normal.png"] forState:UIControlStateNormal];
        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_documents_normal.png"] forState:UIControlStateNormal];
        [oppOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_oppourtinites_normal.png"] forState:UIControlStateNormal];
    }
    
    [self loadCalendar];
}

#pragma mark refresh Data Source

- (void)refreshDataSourceFromCoreDataStore
{
    [AccountArray removeAllObjects];
    [OpportunityArray removeAllObjects];
    [customersArray removeAllObjects];
    
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [AccountArray addObjectsFromArray:fetchedObjects];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Opportunities"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [OpportunityArray addObjectsFromArray:fetchedObjects];
    
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Customers"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [customersArray addObjectsFromArray:fetchedObjects];
    
    context = SAppDelegateObject.managedObjectContext;
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Events"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [masterEventsArray addObjectsFromArray:fetchedObjects];
    
    //[self performSelectorOnMainThread:@selector(updateAfterRefresh) withObject:nil waitUntilDone:YES];
    
}

-(void)updateAfterRefresh
{
    [CustomersTable reloadData];
    [OppurtunitiesTable reloadData];
    [DocumentsTable reloadData];
    
    self.view.userInteractionEnabled=YES;
}
#pragma mark TableView DataSource

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    [view setBackgroundColor:[UIColor whiteColor]];
//    return view;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag ==3)
        return [SAppDelegateObject.acntArray count];
    else if (tableView.tag ==1)
    {
        return [customersArray count];
    }
    else
        return [SAppDelegateObject.opportArray count];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    else
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"box_divider.png"]];
        [cell.contentView addSubview: separator];
        
    }
    
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Theme2_box_divider.png"]];
        [cell.contentView addSubview: separator];
        
    }
    
    if (tableView.tag ==1)
    {
        
        UIImageView *profileIcon = [[UIImageView alloc]init];
        profileIcon.frame = CGRectMake(20, 20, 50, 50);
        profileIcon.image=[UIImage imageNamed:DEFAULT_USER_ICON];
        [profileIcon.layer setCornerRadius:6.0];
        [profileIcon.layer setMasksToBounds:YES];
        
        Customers *customerObject = [customersArray objectAtIndex:indexPath.row];
        
        if(customerObject.customerImageURL.length>0)
            [profileIcon setImageURL:[NSURL URLWithString:customerObject.customerImageURL]];
        
        UILabel *custName = [[UILabel alloc]init];
        custName.frame = CGRectMake(80, 15, 150, 22);
        custName.text = [NSString stringWithFormat:@"%@ %@",customerObject.firstName, customerObject.lastName];
        custName.backgroundColor = [UIColor clearColor];
        custName.textColor = [UIColor whiteColor];
        [custName setFont:[UIFont fontWithName:FONT_BOLD size:16]];
        
        UILabel *custDesig = [[UILabel alloc]init];
        custDesig.frame = CGRectMake(80, 40, 180, 18);
        custDesig.text = customerObject.mailingCity;
        custDesig.backgroundColor = [UIColor clearColor];
        [custDesig setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
        
        UILabel *custOrg = [[UILabel alloc]init];
        custOrg.frame = CGRectMake(80, 60, 180, 18);
        custOrg.text = customerObject.mailingStreet;
        custOrg.backgroundColor = [UIColor clearColor];
        [custOrg setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
        
        
        if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
        {
            custDesig.textColor = [UIColor blackColor];
            custOrg.textColor = [UIColor blackColor];
        }
        
        else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
        {
            custDesig.textColor = [Utils colorFromHexString:@"7dc0ff"];
            custOrg.textColor = [Utils colorFromHexString:@"7dc0ff"];
        }
        
        
        
        [cell.contentView addSubview:profileIcon];
        [cell.contentView addSubview:custName];
        [cell.contentView addSubview:custDesig];
        [cell.contentView addSubview:custOrg];
        
    }
    
    else if (tableView.tag ==2)
    {
        
           
        Opportunity *opportunityObject = [SAppDelegateObject.opportArray objectAtIndex:indexPath.row];
        
        UILabel *OpportunityName = [[UILabel alloc]init];
        OpportunityName.frame = CGRectMake(20, 15, 270, 22);
        OpportunityName.text = opportunityObject.OpportunityName;
        OpportunityName.backgroundColor = [UIColor clearColor];
        OpportunityName.textColor = [UIColor whiteColor];
        [OpportunityName setFont:[UIFont fontWithName:FONT_BOLD size:16]];
        [OpportunityName setUserInteractionEnabled:YES];
        
         [cell.contentView addSubview:OpportunityName];
        
    }
    
    else if (tableView.tag==3)
    {
        UIImageView *AccountIcon = [[UIImageView alloc]init];
        AccountIcon.frame = CGRectMake(18, 20, 40, 40);
        [AccountIcon.layer setCornerRadius:6.0];
        [AccountIcon.layer setMasksToBounds:YES];
        
        if (indexPath.row %2 == 0)
            AccountIcon.image=[UIImage imageNamed:@"account2.png"];
        else
            AccountIcon.image=[UIImage imageNamed:@"account1.png"];
        
        
        SearchAccounts *userObject = [SAppDelegateObject.acntArray objectAtIndex:indexPath.row];
        
        UILabel *custName = [[UILabel alloc]init];
        custName.frame = CGRectMake(20, 15, 270, 22);
        custName.text = userObject.companyName;
        custName.backgroundColor = [UIColor clearColor];
        custName.textColor = [UIColor whiteColor];
        [custName setFont:[UIFont fontWithName:FONT_BOLD size:16]];
        
        UILabel *custDesig = [[UILabel alloc]init];
        custDesig.frame = CGRectMake(80, 40, 180, 18);
        // custDesig.text = userObject.accountIndustry;
        custDesig.backgroundColor = [UIColor clearColor];
        [custDesig setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
        
        UILabel *custOrg = [[UILabel alloc]init];
        custOrg.frame = CGRectMake(80, 60, 180, 18);
        // custOrg.text = userObject.accountType;
        custOrg.backgroundColor = [UIColor clearColor];
        [custOrg setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
        
        if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
        {
            custDesig.textColor = [UIColor blackColor];
            custOrg.textColor = [UIColor blackColor];
        }
        
        else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
        {
            custDesig.textColor = [Utils colorFromHexString:@"7dc0ff"];
            custOrg.textColor = [Utils colorFromHexString:@"7dc0ff"];
        }
        
        [cell.contentView addSubview:custName];
        // [cell.contentView addSubview:custDesig];
        // [cell.contentView addSubview:custOrg];
        // [cell.contentView addSubview:AccountIcon];
    }
    
    //    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    //        separator.image =[UIImage imageNamed:@"box_divider.png"];
    //
    //
    //    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    //        separator.image =[UIImage imageNamed:@"Theme2_box_divider.png"];
    
    return cell;
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [circleView removeFromSuperview];
    if(tableView.tag ==1)
    {
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Dashboard Screen" withAction:@"Customer Clicked" withLabel:nil withValue:nil];
        Customers *userObject = [customersArray objectAtIndex:indexPath.row];
        ShowCustomerDetails *viewController = [[ShowCustomerDetails alloc] initWithNibName:@"ShowCustomerDetails" bundle:Nil];
        viewController.customerObject = userObject;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    
    if(tableView.tag ==2)
    {

        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Dashboard Screen" withAction:@"Opportunity Clicked" withLabel:nil withValue:nil];
        ShowOpportunityViewController *viewController = [[ShowOpportunityViewController alloc] initWithNibName:@"ShowOpportunityViewController" bundle:nil];
       // viewController.index = indexPath.row;
        viewController.PotentialObject=(Opportunity *)[SAppDelegateObject.opportArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if(tableView.tag ==3)
    {
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Dashboard Screen" withAction:@"Account Clicked" withLabel:nil withValue:nil];
        ShowAccountsViewController *viewController = [[ShowAccountsViewController alloc] initWithNibName:@"ShowAccountsViewController" bundle:nil];
        viewController.AccObject=(SearchAccounts *)[SAppDelegateObject.acntArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}


#pragma mark Calendar Support Methods

/*********************  Animation Scroll  ************************/

/**
 *	This method sets the date label with corresponding date at all points of the apps execution.
 */

-(void)setUpDateLabelForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    
    
    //Current day label on left
    if ([SNSDateUtils componentsForDate:date].day <=9)
        dashboardDate.text=[NSString stringWithFormat:@"0%d",[SNSDateUtils componentsForDate:date].day];
    else
        dashboardDate.text=[NSString stringWithFormat:@"%d",[SNSDateUtils componentsForDate:date].day];
    
    dashboardMonth.text=[NSString stringWithFormat:@"%@",[SNSDateUtils monthNameForMonthInNumber:[SNSDateUtils componentsForDate:date].month withFullMonthName:NO]] ;
    dashboardYear.text=[NSString stringWithFormat:@"%d",[SNSDateUtils componentsForDate:date].year];
    
    
    //next day label on right
    if ([SNSDateUtils componentsForDate:[SNSDateUtils date:date ByAddingDays:1]].day <=9)
        
        dashboardNextDate.text=[NSString stringWithFormat:@"0%d",[[SNSDateUtils componentsForDate:[SNSDateUtils date:date ByAddingDays:1]] day]];
    else
        dashboardNextDate.text=[NSString stringWithFormat:@"%d",[[SNSDateUtils componentsForDate:[SNSDateUtils date:date ByAddingDays:1]] day]];
    
    dashboardNextDateMonth.text=[NSString stringWithFormat:@"%@",[SNSDateUtils monthNameForMonthInNumber:[SNSDateUtils componentsForDate:[SNSDateUtils date:date ByAddingDays:1]].month withFullMonthName:NO]] ;
    
    dashboardNextDateYear.text=[NSString stringWithFormat:@"%d",[SNSDateUtils componentsForDate:[SNSDateUtils date:date ByAddingDays:1]].year];
    
}

/**
 *	This method populates the local array from Core Data DB - to refresh if new events were synced.
 */

-(void)addEventsToTimeSource
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Events"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [masterEventsArray addObjectsFromArray:fetchedObjects];
    
    //[masterEventsArray addObjectsFromArray:[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"MasterEventsArray"]];
}


/**
 *	This method seperates events that fall on the current date from the entire array of events.
 */

-(void)getEventsForCurrentDate
{
    [eventArray removeAllObjects];
    [sDayTimeSource removeAllObjects];
    
    [masterEventsArray removeAllObjects];
    [self addEventsToTimeSource];
    for (int i=0; i<[masterEventsArray count]; i++) {
        Events *evnt=(Events *)[masterEventsArray objectAtIndex:i];
        
        if ( [SNSDateUtils date:currentDay IsEqualTo:evnt.eventStartDate]) {
            
            [eventArray addObject:evnt];
            
            [sDayTimeSource setObject:evnt forKey:[NSString stringWithFormat:@"%d", [[SNSDateUtils componentsForDate:evnt.eventStartDate] hour]]];
            
        }
    }
}


/**
 *	This method creates the time line and draws it with animation.
 */

- (void)loadCalendar
{
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
    NSString *dateText = [dateFormatter2 stringFromDate:currentDay];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Dashboard Screen" withAction:@"Day Changed" withLabel:dateText withValue:nil];
    for(UIView *tView in self.animationScroll.subviews)
    {
        if ([tView isKindOfClass:[UIButton class]]) {
            [tView removeFromSuperview];
        }
    }
    
    for(UILabel *tView in self.animationScroll.subviews)
    {
        if ([tView isKindOfClass:[UILabel class]]) {
            if ((tView != self.dashboardDate) && (tView != self.dashboardNextDate))
                [tView removeFromSuperview];
        }
    }
    
    int width = (calendarEventBGView.frame.size.width - 100) / ([HOURS_AM_PM count]-1);
    
    self.animationScroll.showsHorizontalScrollIndicator=YES;
    
    eventBtnsPopUpArray = [[NSMutableArray alloc]init];
    eventLabelsPopUpArray = [[NSMutableArray alloc]init];
    
    [eventBtnsPopUpArray removeAllObjects];
    [eventLabelsPopUpArray removeAllObjects];
    
    if(firstTimeLoad)
    {
        calendarEventView.frame = CGRectMake(0, 115, 0, 7);
        firstTimeLoad=NO;
    }
    
    else
        calendarEventView.frame = CGRectMake(0, 115, 1024, 7);
    
    for (int j = 0; j < ([HOURS_AM_PM count]-1); j++) {
        Events *event=[sDayTimeSource objectForKey:[HOURS_AM_PM objectAtIndex:j]];
        if ( [[NSString stringWithFormat:@"%d" ,[[SNSDateUtils componentsForDate:event.eventStartDate] hour] ]isEqualToString:  [HOURS_AM_PM objectAtIndex:j]])
            if ([Events isValidEvent:event])
            {
                calendarEventView.frame = CGRectMake(0, 115, 0, 7);
                
                UIButton *eventBtn = [[UIButton alloc]init];
                eventBtn.frame = CGRectMake(((width*j)+100), 95, 47, 46);
                
                if ( [event eventTypeRaw] == EventTypeCall)
                {
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                    {
                        [eventBtn setBackgroundImage:[UIImage imageNamed:@"dashboard_call_icon.png"] forState:UIControlStateNormal];
                    }
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                    {
                        [eventBtn setBackgroundImage:[UIImage imageNamed:@"Theme2_call1_icon.png"] forState:UIControlStateNormal];
                    }
                    
                }
                else if ([event eventTypeRaw] == EventTypeMeeting)
                {
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                    {
                        [eventBtn setBackgroundImage:[UIImage imageNamed:@"dashboard_metting_icon.png"] forState:UIControlStateNormal];
                    }
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                    {
                        [eventBtn setBackgroundImage:[UIImage imageNamed:@"Theme2_meeting_icon_new.png"] forState:UIControlStateNormal];
                    }
                    
                }
                
                else if([event eventTypeRaw] == EventTypeEmail)
                {
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                    {
                        
                        [eventBtn setBackgroundImage:[UIImage imageNamed:@"email_icon@2x.png"] forState:UIControlStateNormal];
                    }
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                    {
                        [eventBtn setBackgroundImage:[UIImage imageNamed:@"Theme2_email_icon.png"] forState:UIControlStateNormal];
                    }
                    
                    
                }
                else
                {
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                    {
                        
                        [eventBtn setBackgroundImage:[UIImage imageNamed:@"dashboard_metting_icon.png"] forState:UIControlStateNormal];
                    }
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                    {
                        [eventBtn setBackgroundImage:[UIImage imageNamed:@"Theme2_meeting_icon_new.png"] forState:UIControlStateNormal];
                    }
                    //Default Image for events in timeline.
                    
                }
                
                
                UILabel *timeLabel = [[UILabel alloc]init];
                timeLabel.frame = CGRectMake(((width*j)+100), 150, 100, 46);
                [timeLabel setBackgroundColor:[UIColor clearColor]];
                [timeLabel setTextColor:[UIColor whiteColor]];
                [timeLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
                
                eventBtn.tag = j;
                [eventBtn addTarget:self action:@selector(eventClick:) forControlEvents: UIControlEventTouchUpInside];
                
                [eventBtnsPopUpArray addObject: eventBtn];
                [eventLabelsPopUpArray addObject:timeLabel];
                
                timeLabel.text = [SNSDateUtils timeFromNSDate:event.eventStartDate];
                
            }
    }
    
    [self.animationScroll setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:1.10 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        calendarEventView.frame = CGRectMake(0, 115, 1024, 7);
    }completion:^(BOOL finished) {
        [self performSelector:@selector(timeLineAnimation:) withObject:[NSString stringWithFormat:@"0"] afterDelay:0];
    }];
}


#pragma mark Dashboard TimeLine Animation Methods
/**
 *	These methods adds the events in the time line with animation and pop sound effect.
 */

- (void)timeLineAnimation:(NSString *)index
{
    if ([eventBtnsPopUpArray count]>[index intValue])
    {
        UIButton *btn = [eventBtnsPopUpArray objectAtIndex:[index intValue]];
        UILabel *lbl = [eventLabelsPopUpArray objectAtIndex:[index intValue]];
        
        [self.animationScroll addSubview:btn];
        [self.animationScroll addSubview:lbl];
        
        
        [UIView animateWithDuration:0 delay:0 options:UIViewAnimationCurveLinear animations:^{
            [self playSound:@"pop" :@"mp3"];
            [self popOutAnimationFor:btn duration:0.10];
            [self popOutAnimationFor:lbl duration:0.10];
        }
                         completion:^(BOOL finished) {
                             [self performSelector:@selector(timeLineAnimation:) withObject:[NSString stringWithFormat:@"%d",[index intValue]+1] afterDelay:0.25];
                         }];
    }
    
    else
    {
        [self.animationScroll setUserInteractionEnabled:YES];
        return;
    }
}

- (void)popOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration
{
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.removedOnCompletion = NO;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.f],
                    [NSNumber numberWithFloat:1.2f],[NSNumber numberWithFloat:1.0f],
                    nil];
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    fadeOut.duration = duration * .4f;
    fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fadeOut.beginTime = duration * .6f;
    fadeOut.fillMode = kCAFillModeBoth;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:scale, nil]];
    group.duration = 0.7f;
    group.delegate = self;
    [group setValue:view forKey:@"imageViewBeingAnimated"];
    
    [view.layer addAnimation:group forKey:@"savingAnimation"];
}

/**
 *	This method plays the 'pop' sound during the animation.
 */

-(void) playSound : (NSString *) fName : (NSString *) ext
{
    NSString *path  = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
}

#pragma mark Custom UI Methods

/**
 *	This method is called on clicking a event in the timeline.
 */

- (void)eventClick:(id)sender
{
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Dashboard Screen" withAction:@"Event Clicked" withLabel:nil withValue:nil];
    
    UIButton *temp=(UIButton*)sender;
    
    if (eventVisible) {
        [circleView removeFromSuperview];
    }
    eventVisible=YES;
    circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 350)];
    [circleView setCenter:temp.center];
    CGRect tRcet=circleView.frame;
    
    if (TableViewArray.count == 0)
        tRcet.origin.y=+200;
    else
        tRcet.origin.y=+0;
    
    circleView.frame=tRcet;
    
    Events *event=[sDayTimeSource objectForKey:[HOURS_AM_PM objectAtIndex:temp.tag]];
    
    UILabel *eventTitlePop = [[UILabel alloc]init];
    eventTitlePop.text = event.eventTitle;
    eventTitlePop.frame = CGRectMake(80, 42, 180, 60);
    eventTitlePop.numberOfLines=0;
    [eventTitlePop setTextColor:[UIColor blackColor]];
    [eventTitlePop setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [eventTitlePop setTextColor:[Utils colorFromHexString:@"868686"]];
    [eventTitlePop setTextAlignment: UITextAlignmentCenter];
    [eventTitlePop setBackgroundColor:[UIColor clearColor]];
    
    UILabel *eventLocation = [[UILabel alloc]init];
    eventLocation.text = event.eventVenue;
    eventLocation.frame = CGRectMake(167, 110, 120, 30);
    [eventLocation setTextColor:[Utils colorFromHexString:@"868686"]];
    [eventLocation setFont:[UIFont fontWithName:FONT_REGULAR size:16]];
    [eventLocation setBackgroundColor:[UIColor clearColor]];
    
    UILabel *eventPhoneNumber = [[UILabel alloc]init];
    eventPhoneNumber.text = @"+91 9770714582";
    eventPhoneNumber.frame = CGRectMake(189, 151, 150, 30);
    [eventPhoneNumber setTextColor:[Utils colorFromHexString:@"868686"]];
    [eventPhoneNumber setFont:[UIFont fontWithName:FONT_REGULAR size:16]];
    [eventPhoneNumber setBackgroundColor:[UIColor clearColor]];
    
    UILabel *eventPurpose = [[UILabel alloc]init];
    eventPurpose.text = event.eventPurpose;
    eventPurpose.frame = CGRectMake(193, 197, 120, 30);
    [eventPurpose setTextColor:[Utils colorFromHexString:@"868686"]];
    [eventPurpose setFont:[UIFont fontWithName:FONT_REGULAR size:16]];
    [eventPurpose setBackgroundColor:[UIColor clearColor]];
    
    UILabel *FromDate = [[UILabel alloc]init];
    FromDate.text = [NSString stringWithFormat:@"%@-%@",[SNSDateUtils timeFromNSDate:event.eventStartDate], [SNSDateUtils timeFromNSDate:event.eventEndDate]];
    FromDate.frame = CGRectMake(163, 245, 120, 30);
    [FromDate setTextColor:[Utils colorFromHexString:@"868686"]];
    [FromDate setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
    [FromDate setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *locationImage = [[UIImageView alloc]init];
    locationImage.frame = CGRectMake(130, 117, 15, 25);
    
    UIImageView *phoneImage = [[UIImageView alloc]init];
    
    phoneImage.frame = CGRectMake(155, 155, 15, 25);
    
    UIImageView *purposeImage = [[UIImageView alloc]init];
    
    purposeImage.frame = CGRectMake(155, 197, 25, 25);
    
    UIImageView *timeImage = [[UIImageView alloc]init];
    timeImage.frame = CGRectMake(128, 245, 20, 20);
    
    /*    UILabel *ToDate = [[UILabel alloc]init];
     ToDate.text = [SNSDateUtils timeFromNSDate:event.eventEndDate];;
     ToDate.frame = CGRectMake(100, 100, 120, 30);
     [ToDate setTextColor:[UIColor blackColor]];
     [ToDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
     [ToDate setBackgroundColor:[UIColor clearColor]];   */
    
    UIImageView *UserImage = [[UIImageView alloc]init];
    UserImage.frame = CGRectMake(20, 136, 80, 80);
    
    UIButton *moreBtn = [[UIButton alloc]init];
    moreBtn.frame = CGRectMake(150, 300, 50, 20);
    moreBtn.tag = temp.tag;
    [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents: UIControlEventTouchUpInside];
    
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        circleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay_image.png"]];
        [moreBtn setImage:[UIImage imageNamed:@"more_icon.png"] forState:UIControlStateNormal];
        locationImage.image = [UIImage imageNamed:@"location_icon1@2x.png"];
        purposeImage.image = [UIImage imageNamed:@"purpose_icon@2x.png"];
        timeImage.image = [UIImage imageNamed:@"time_icon.png"];
        UserImage.image = [UIImage imageNamed:@"dashboard_user.png"];
        phoneImage.image = [UIImage imageNamed:@"call_icon1_1@2x.png"];
        
        
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        circleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_overlay_image.png"]];
        // need dis
        [moreBtn setImage:[UIImage imageNamed:@"Theme2_more_overlay.png"] forState:UIControlStateNormal];
        locationImage.image = [UIImage imageNamed:@"Theme2_location_icon.png"];
        purposeImage.image = [UIImage imageNamed:@"Theme2_purpose_icon.png"];
        timeImage.image = [UIImage imageNamed:@"Theme2_time_icon.png"];
        UserImage.image = [UIImage imageNamed:@"dashboard_user.png"];
        phoneImage.image = [UIImage imageNamed:@"Theme2_call_icon.png"];
        
        
    }
    
    if([[event.customersTaggedToEvent allObjects] count]>0)
    {
        Customers *customer=[[event.customersTaggedToEvent allObjects] objectAtIndex:0];
        if(customer.customerImageURL.length>0)
            [UserImage setImageURL:[NSURL URLWithString:customer.customerImageURL]];
        [UserImage.layer setCornerRadius:6];
        [UserImage.layer setMasksToBounds:YES];
    }
    
    
    [circleView addSubview:eventTitlePop];
    [circleView addSubview:eventPurpose];
    [circleView addSubview:UserImage];
    [circleView addSubview:FromDate];
    [circleView addSubview:moreBtn];
    [circleView addSubview:locationImage];
    [circleView addSubview:phoneImage];
    [circleView addSubview:purposeImage];
    [circleView addSubview:timeImage];
    [circleView addSubview:eventPhoneNumber];
    [circleView addSubview:eventLocation];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(350, 350);
    
    if([EventDashboardPopoverCont isPopoverVisible])
        [EventDashboardPopoverCont dismissPopoverAnimated:YES];
    
    EventDashboardPopoverCont = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    // [EventDashboardPopoverCont presentPopoverFromRect:temp.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    
    [popoverContent.view addSubview:circleView];
    UIView * border = [[popoverContent.view.superview.superview.superview subviews] objectAtIndex:0];
    border.hidden = YES;
    
    [self.view addSubview:circleView];
    
}

/**
 *	This method is called when more button is clicked within a event pop up.
 */

- (void)moreClick:(id)sender
{
    SAppDelegateObject.revealStatus=NO;
    [circleView removeFromSuperview];
    [EventDashboardPopoverCont dismissPopoverAnimated:NO];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Dashboard Screen" withAction:@"Event Details Clicked" withLabel:nil withValue:nil];
    
    
    UIButton *tempMore=(UIButton*)sender;
    Events *event=[sDayTimeSource objectForKey:[HOURS_AM_PM objectAtIndex:tempMore.tag]];
    
    [[ModelTrackingClass sharedInstance] setModelObject:event.eventStartDate forKey:@"currentDay"];
    
    calendarViewController=[[CalendarViewController alloc]initWithNibName:@"CalendarViewController" bundle:nil];
    
    NSDateFormatter *dateForamtter=[[NSDateFormatter alloc]init];
    [dateForamtter setDateFormat:@"dd-MMM-yy"];
    
    calendarViewController.sDayViewController.events=event;
    
    
    RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
    
    SWRevealViewController *mainRevealController =
    [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:calendarViewController];
    
    mainRevealController.rearViewRevealWidth = 200;
    mainRevealController.rearViewRevealOverdraw = 150;
    mainRevealController.bounceBackOnOverdraw = NO;
    mainRevealController.stableDragOnOverdraw = YES;
    [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
    
    mainRevealController.delegate = self;
    
    [self.navigationController pushViewController:mainRevealController animated:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EventClickedFromDashboard" object:event];
    
    //   [calendarViewController.sDayViewController showAddedEvent:event];
    
}


-(IBAction)userIconClicked:(id)sender{
    /*settingsViewController=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
     
     UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:settingsViewController];
     navController.modalPresentationStyle=UIModalPresentationFormSheet;
     navController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
     [SAppDelegateObject.window.rootViewController presentModalViewController:navController animated:YES];*/
    
    PersnoalDashboardViewController *personalDashBoard=[[PersnoalDashboardViewController alloc]initWithNibName:@"PersnoalDashboardViewController" bundle:nil];
    
    [self.navigationController pushViewController:personalDashBoard animated:YES];
    
}

-(void)dashboardCurrentDateClicked
{
    CGPoint datePnt=self.animationScroll.center;
    datePnt.x-=400;
    datePnt.y-=40;
    
    calVC = [[OCCalendarViewController alloc] initAtPoint:datePnt inView:self.view arrowPosition:OCArrowPositionLeft selectionMode:OCSelectionSingleDate];
    calVC.delegate = self;
    [self.view addSubview:calVC.view];
}

- (IBAction)calendarClicked:(id)sender
{
    
    return;
    
    [circleView removeFromSuperview];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Dashboard Screen" withAction:@"Calendar Button Clicked" withLabel:nil withValue:nil];
    SAppDelegateObject.revealStatus=NO;
    
    [[ModelTrackingClass sharedInstance] setModelObject:currentDay forKey:@"currentDay"];
    
    calendarViewController=[[CalendarViewController alloc]initWithNibName:@"CalendarViewController" bundle:nil];
    
    RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
    
    SWRevealViewController *mainRevealController =
    [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:calendarViewController];
    
    mainRevealController.rearViewRevealWidth = 200;
    mainRevealController.rearViewRevealOverdraw = 150;
    mainRevealController.bounceBackOnOverdraw = NO;
    mainRevealController.stableDragOnOverdraw = YES;
    [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
    
    mainRevealController.delegate = self;
    
    
    [self.navigationController pushViewController:mainRevealController animated:YES];
    
    
}

-(IBAction)OppurtunitiesButtonClick:(id)sender
{
    if(SAppDelegateObject.opportArray)
    {
        if([SAppDelegateObject.opportArray count] > 0)
        {
            if (oppurtunitiesOpened == FALSE)
                [self OppurtunitiesOpenClick];
            else
                [self OppurtunitiesCloseClick];
        }
        else{
            HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
            HUD.mode =MBProgressHUDModeText;
            
            HUD.labelText= @"No Opportunities";
        }
    }
}

-(IBAction)CustomersButtonClick:(id)sender
{
    if (customersOpened == FALSE)
        [self CustomerOpenClick];
    else
        [self CustomerCloseClick];
}

-(IBAction)DocumentsButtonClick:(id)sender
{
    if(SAppDelegateObject.acntArray)
    {
        if([SAppDelegateObject.acntArray count] > 0)
        {
            if (documentsOpened == FALSE)
                [self DocumentsOpenClick];
            else
                [self DocumentsCloseClick];
        }
        else{
            HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
            HUD.mode =MBProgressHUDModeText;
            
            HUD.labelText= @"No Accounts";
        }
    }
}


-(void)CustomerCloseClick{
    customersOpened = FALSE;
    [circleView removeFromSuperview];
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
        [CustOpen setBackgroundImage:[UIImage imageNamed:@"customers_normal_new.png"] forState:UIControlStateNormal];
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
        [CustOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_customers_normal.png"] forState:UIControlStateNormal];
    
    CGRect endRect = CGRectInset(CustOpen.frame, 5.0, 5.0);
    
    self.CustDashboardView.userInteractionEnabled = NO;
    
    [self.CustDashboardView genieInTransitionWithDuration:0.75 destinationRect:endRect destinationEdge:BCRectEdgeBottom completion:
     ^{
         CustOpen.enabled = YES;
     }];
    
    [CustDashboardView removeFromSuperview];
    [TableViewArray removeObject:CustDashboardView];
    
    [self rearrangeTableViews];
    
}

-(void)OppurtunitiesCloseClick{
    oppurtunitiesOpened = FALSE;
    [circleView removeFromSuperview];
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
        [oppOpen setBackgroundImage:[UIImage imageNamed:@"oppourtinites_normal_new.png"] forState:UIControlStateNormal];
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
        [oppOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_oppourtinites_normal.png"] forState:UIControlStateNormal];
    
    CGRect endRect2 = CGRectInset(oppOpen.frame, 5.0, 5.0);
    
    self.oppDashboardView.userInteractionEnabled = NO;
    
    [self.oppDashboardView genieInTransitionWithDuration:0.75 destinationRect:endRect2 destinationEdge:BCRectEdgeBottom completion:
     ^{
         oppOpen.enabled = YES;
     }];
    
    [oppDashboardView removeFromSuperview];
    [TableViewArray removeObject:oppDashboardView];
    
    [self rearrangeTableViews];
}

-(void)DocumentsCloseClick{
    
    documentsOpened = FALSE;
    [circleView removeFromSuperview];
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"documents_normal_new.png"] forState:UIControlStateNormal];
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_documents_normal.png"] forState:UIControlStateNormal];
    
    CGRect endRect3 = CGRectInset(DocsOpen.frame, 5.0, 5.0);
    
    self.DocsDashboardView.userInteractionEnabled = NO;
    
    [self.DocsDashboardView genieInTransitionWithDuration:0.75 destinationRect:endRect3 destinationEdge:BCRectEdgeBottom completion:
     ^{
         DocsOpen.enabled = YES;
     }];
    
    [DocsDashboardView removeFromSuperview];
    [TableViewArray removeObject:DocsDashboardView];
    
    [self rearrangeTableViews];
}

-(void)CustomerOpenClick{
    
    
    customersOpened = TRUE;
    [circleView removeFromSuperview];
    if (![TableViewArray containsObject:CustDashboardView]){
        
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Dashboard Screen" withAction:@"Show Customer Clicked" withLabel:nil withValue:nil];
        [TableViewArray addObject:CustDashboardView];
        
        if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
        {
            [CustOpen setBackgroundImage:[UIImage imageNamed:@"customers_hover_new.png"] forState:UIControlStateNormal];
        }
        else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
        {
            [CustOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_customers_hover.png"] forState:UIControlStateNormal];
        }
        
        
    }
    
    [self rearrangeTableViews];
    
    [self.view addSubview:CustDashboardView];
    
    
    
    [CustDashboardView genieOutTransitionWithDuration:0.75 startRect:self.CustOpen.frame startEdge:BCRectEdgeTop completion:^{
        self.CustDashboardView.userInteractionEnabled = YES;
        CustOpen.enabled = YES;
    }];
    
    
}

-(void)OppurtunitiesOpenClick{
    
    oppurtunitiesOpened = TRUE;
    [circleView removeFromSuperview];
    if (![TableViewArray containsObject:oppDashboardView]){
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Dashboard Screen" withAction:@"Show Opportunity Clicked" withLabel:nil withValue:nil];
        [TableViewArray addObject:oppDashboardView];
        
        if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
        {
            [oppOpen setBackgroundImage:[UIImage imageNamed:@"oppourtinites_hover_new.png"] forState:UIControlStateNormal];
        }
        else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
        {
            [oppOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_oppourtinites_hover.png"] forState:UIControlStateNormal];
        }
        
        
    }
    
    [self rearrangeTableViews];
    
    [self.view addSubview:oppDashboardView];
       
    CGRect endRect2 = CGRectInset(oppOpen.frame, 5.0, 5.0);
    
    [self.oppDashboardView genieOutTransitionWithDuration:0.75 startRect:endRect2 startEdge:BCRectEdgeTop completion:^{
        self.oppDashboardView.userInteractionEnabled = YES;
        oppOpen.enabled = YES;
    }];
    
    
}

-(void)DocumentsOpenClick{
    documentsOpened = TRUE;
    
    [circleView removeFromSuperview];
    if (![TableViewArray containsObject:DocsDashboardView]){
        
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Dashboard Screen" withAction:@"Show Accounts Clicked" withLabel:nil withValue:nil];
        [TableViewArray addObject:DocsDashboardView];
        
        if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
        {
            [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Documents_hover_new.png"] forState:UIControlStateNormal];
        }
        else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
        {
            [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_docs1.png"] forState:UIControlStateNormal];
        }
        
    }
    
    [self rearrangeTableViews];
    
    [self.view addSubview:DocsDashboardView];
    
    CGRect endRect3 = CGRectInset(DocsOpen.frame, 5.0, 5.0);
    
    [self.DocsDashboardView genieOutTransitionWithDuration:0.75 startRect:endRect3 startEdge:BCRectEdgeTop completion:^{
        self.DocsDashboardView.userInteractionEnabled = YES;
        DocsOpen.enabled = YES;
    }];
}


-(void)rearrangeTableViews
{
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        [CustOpen setBackgroundImage:[UIImage imageNamed:@"customers_normal_new.png"] forState:UIControlStateNormal];
        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"documents_normal_new.png"] forState:UIControlStateNormal];
        [oppOpen setBackgroundImage:[UIImage imageNamed:@"oppourtinites_normal_new.png"] forState:UIControlStateNormal];
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        [CustOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_customers_normal.png"] forState:UIControlStateNormal];
        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_documents_normal.png"] forState:UIControlStateNormal];
        [oppOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_oppourtinites_normal.png"] forState:UIControlStateNormal];
    }
    
    switch (TableViewArray.count) {
            
        case 0:
        {
            [belowView setHidden:YES];
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                animationScroll.frame = CGRectMake(0, 250, 1024, 230);
                calendarOpenBtn.frame = CGRectMake(20, 345, 45, 46);
            }completion:nil];
        }
            break;
            
        case 1:
        {
            [belowView setHidden:YES];
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveLinear animations:^{
                animationScroll.frame = CGRectMake(0, 118, 1024, 230);
                calendarOpenBtn.frame = CGRectMake(20, 213, 45, 46);
            }completion:nil];
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveLinear animations:^{
                if ([[TableViewArray objectAtIndex:0] isEqual:CustDashboardView])
                {
                    CustDashboardView.frame=CGRectMake(344, 319, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"customers_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_customers_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:0] isEqual:oppDashboardView])
                {
                    oppDashboardView.frame=CGRectMake(344, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"oppourtinites_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_oppourtinites_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:0] isEqual:DocsDashboardView])
                {
                    DocsDashboardView.frame=CGRectMake(344, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Documents_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_docs1.png"] forState:UIControlStateNormal];
                }
            }completion:nil];
            
            
        }
            break;
            
        case 2:
        {
            [belowView setHidden:YES];
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveLinear animations:^{
                if ([[TableViewArray objectAtIndex:0] isEqual:CustDashboardView])
                {
                    CustDashboardView.frame=CGRectMake(132, 319, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"customers_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_customers_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:0] isEqual:oppDashboardView])
                {
                    oppDashboardView.frame=CGRectMake(132, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"oppourtinites_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_oppourtinites_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:0] isEqual:DocsDashboardView])
                {
                    DocsDashboardView.frame=CGRectMake(132, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Documents_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_docs1.png"] forState:UIControlStateNormal];
                }
                
                if ([[TableViewArray objectAtIndex:1] isEqual:CustDashboardView])
                {
                    CustDashboardView.frame=CGRectMake(593, 319, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"customers_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_customers_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:1] isEqual:oppDashboardView])
                {
                    oppDashboardView.frame=CGRectMake(593, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"oppourtinites_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_oppourtinites_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:1] isEqual:DocsDashboardView])
                {
                    DocsDashboardView.frame=CGRectMake(593, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Documents_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_docs1.png"] forState:UIControlStateNormal];
                }
            }completion:nil];
            
            
        }
            break;
            
        case 3:
        {
            [belowView setHidden:NO];
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveLinear animations:^{
                if ([[TableViewArray objectAtIndex:0] isEqual:CustDashboardView])
                {
                    CustDashboardView.frame=CGRectMake(3, 319, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"customers_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_customers_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:0] isEqual:oppDashboardView])
                {
                    oppDashboardView.frame=CGRectMake(3, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"oppourtinites_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_oppourtinites_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:0] isEqual:DocsDashboardView])
                {
                    DocsDashboardView.frame=CGRectMake(3, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Documents_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_docs1.png"] forState:UIControlStateNormal];
                }
                
                if ([[TableViewArray objectAtIndex:1] isEqual:CustDashboardView])
                {
                    CustDashboardView.frame=CGRectMake(344, 319, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"customers_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_customers_hover.png"] forState:UIControlStateNormal];
                }
                
                else if ([[TableViewArray objectAtIndex:1] isEqual:oppDashboardView])
                {
                    oppDashboardView.frame=CGRectMake(344, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"oppourtinites_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_oppourtinites_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:1] isEqual:DocsDashboardView])
                {
                    DocsDashboardView.frame=CGRectMake(344, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Documents_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_docs1.png"] forState:UIControlStateNormal];
                }
                
                if ([[TableViewArray objectAtIndex:2] isEqual:CustDashboardView])
                {
                    CustDashboardView.frame=CGRectMake(684, 319, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"customers_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [CustOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_customers_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:2] isEqual:oppDashboardView])
                {
                    oppDashboardView.frame=CGRectMake(684, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"oppourtinites_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [oppOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_oppourtinites_hover.png"] forState:UIControlStateNormal];
                }
                else if ([[TableViewArray objectAtIndex:2] isEqual:DocsDashboardView])
                {
                    DocsDashboardView.frame=CGRectMake(684, 371, 339, 300);
                    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Documents_hover_new.png"] forState:UIControlStateNormal];
                    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
                        [DocsOpen setBackgroundImage:[UIImage imageNamed:@"Theme2_docs1.png"] forState:UIControlStateNormal];
                }
            }completion:nil];
            
        }
            break;
            
        default:
            break;
    }
}

-(IBAction)CustMoreClick:(id)sender
{
    
    [circleView removeFromSuperview];
    CustomerViewController *viewController = [[CustomerViewController alloc]initWithNibName:@"CustomerViewController" bundle:nil];
    
    RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
    
    SWRevealViewController *mainRevealController =
    [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:viewController];
    
    mainRevealController.rearViewRevealWidth = 200;
    mainRevealController.rearViewRevealOverdraw = 150;
    mainRevealController.bounceBackOnOverdraw = NO;
    mainRevealController.stableDragOnOverdraw = YES;
    [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
    
    mainRevealController.delegate = self;
    
    SAppDelegateObject.revealStatus=NO;
    
    [ self.navigationController pushViewController:mainRevealController animated:YES];
}

-(IBAction)DocsMoreClick:(id)sender
{
    
    [circleView removeFromSuperview];
    AccountsViewController *viewController = [[AccountsViewController alloc]initWithNibName:@"AccountsViewController" bundle:nil];
    
    RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
    
    SWRevealViewController *mainRevealController =
    [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:viewController];
    
    mainRevealController.rearViewRevealWidth = 200;
    mainRevealController.rearViewRevealOverdraw = 150;
    mainRevealController.bounceBackOnOverdraw = NO;
    mainRevealController.stableDragOnOverdraw = YES;
    [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
    
    mainRevealController.delegate = self;
    
    SAppDelegateObject.revealStatus=NO;
    
    [ self.navigationController pushViewController:mainRevealController animated:YES];
}



-(IBAction)OppMoreClick:(id)sender
{
    SAppDelegateObject.revealStatus=NO;
    
    [self pushView];
}

-(void)pushView
{
    [circleView removeFromSuperview];
    OpportunitiesViewController *viewController = [[OpportunitiesViewController alloc]initWithNibName:@"OpportunitiesViewController" bundle:nil];
    RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
    
    SWRevealViewController *mainRevealController =
    [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:viewController];
    
    mainRevealController.rearViewRevealWidth = 200;
    mainRevealController.rearViewRevealOverdraw = 150;
    mainRevealController.bounceBackOnOverdraw = NO;
    mainRevealController.stableDragOnOverdraw = YES;
    [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
    
    mainRevealController.delegate = self;
    
    
    [ self.navigationController pushViewController:mainRevealController animated:YES];
}


#pragma mark Gesture Reconition For Dashboard TimeLine

- (UISwipeGestureRecognizer *)swipeLeftRecognizer {
	if (!_swipeLeftRecognizer) {
		_swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
		_swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	}
	return _swipeLeftRecognizer;
}

- (UISwipeGestureRecognizer *)swipeRightRecognizer {
	if (!_swipeRightRecognizer) {
		_swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
		_swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	}
	return _swipeRightRecognizer;
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    [EventDashboardPopoverCont dismissPopoverAnimated:NO];
	if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        currentDay=[SNSDateUtils nextDayFromDate:currentDay];
        [self setUpDateLabelForDate:currentDay];
        [self getEventsForCurrentDate];
        [self loadCalendar];
        [circleView removeFromSuperview];
	}
    else  if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        currentDay=[SNSDateUtils previousDayFromDate:currentDay];
        [self setUpDateLabelForDate:currentDay];
        [self getEventsForCurrentDate];
        [self loadCalendar];
        [circleView removeFromSuperview];
	}
}

#pragma mark Box CMS Support Methods

-(void)BoxLogin
{
    self.view.userInteractionEnabled=YES;
    
    vc = [BoxLoginViewController loginViewControllerWithNavBar:YES];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    
    [BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:vc.navigationController andNavItem:vc.navigationItem]; //Adds the box styling to the navigation item of the view. This is optional.
    vc.boxLoginDelegate = self;
    
    [self presentModalViewController:vc animated:YES];
    
    /*CGRect r = CGRectMake(self.view.bounds.size.width/2 - 250, self.view.bounds.size.height/2 - 325, 650, 500);
     r = [self.view convertRect:r toView:vc.view.superview.superview];
     vc.view.superview.frame = r;*/
    
    //[promptForDropBoxCredentials removeFromSuperview];
    
    
}

- (void)boxLoginViewController:(BoxLoginViewController *)boxLoginViewController didFinishWithResult:(LoginResult)result {
    
    if(result==LoginSuccess)
    {
        //        BoxDownloadActionViewController * inputController = [[BoxDownloadActionViewController alloc] initWithFolderID:@"0"];
        //
        //        [viewTail buildBoxFolderListAfterLogin:inputController];
        
        [vc dismissModalViewControllerAnimated:YES];
        
    }
    
    
    if (result==LoginCancelled)
    {
        [vc dismissModalViewControllerAnimated:YES];
    }
    
    
    //  [self.navigationController popViewControllerAnimated:YES]; //Only one of these lines should actually be used depending on how you choose to present it.
}


#pragma mark -
#pragma mark OCCalendarDelegate Methods

- (void)completedWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    
    NSLog(@"startDate:%@, endDate:%@", startDate, endDate);
    
    currentDay=startDate;
    [self setUpDateLabelForDate:currentDay];
    [self getEventsForCurrentDate];
    [self loadCalendar];
    
    
    [calVC.view removeFromSuperview];
    calVC.delegate = nil;
}

-(void) completedWithNoSelection{
    [calVC.view removeFromSuperview];
    calVC.delegate = nil;
}


#pragma mark Touch Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (eventVisible) {
        UITouch *touch = [touches anyObject];;
        if (touch.view != circleView)
        {
            [circleView removeFromSuperview];
            eventVisible=NO;
        }
    }
}
- (void)showPleaseWaitDisplay
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Loading...";
}

@end
