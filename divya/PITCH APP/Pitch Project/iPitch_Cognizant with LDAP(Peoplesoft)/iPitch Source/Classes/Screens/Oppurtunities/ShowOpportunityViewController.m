//
//  ShowOpportunityViewController.m
//  iPitch V2
//
//  Created by Swarnava (376755) on 27/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "ShowOpportunityViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ShowCustomerDetails.h"
#import "AppDelegate.h"
#import "ModelTrackingClass.h"
#import "SWRevealViewController.h"
#import "QuartzCore/CALayer.h"
#import "iPitchConstants.h"
#import "AddedEventViewController.h"
#import "SalesProcessViewController.h"
#import "Twitter.h"
#import "Utils.h"
#import "AsyncImageView.h"
#import "iPitchAnalytics.h"
#import "iPitchConstants.h"
#import "Notes.h"
#import "ZohoHelper.h"
#import "AddEventViewController.h"
#import "AddNewOpportunityController.h"
#import "ThemeHelper.h"
#import "products.h"
#import "SalesForceHelper.h"
#import "NoteDetailViewController.h"
#import "SSimpleCalculator.h"
#import "GLGestureRecognizer.h"
#import "GLGestureRecognizer+JSONTemplates.h"


@interface ShowOpportunityViewController ()<AddEditOpportunityStatusDelegate>
{
    NSString *oppID;
    UIScrollView *scroll;
    GLGestureRecognizer *recognizer;
    CGPoint center;
    float score, angle;
}
@end

@implementation ShowOpportunityViewController

@synthesize productsDict, keysArray, OpportunityDescription, OpportunityName, custOrganization, sendAppointment, recipient360Button, Backbutton, OpportunityDetailView, OtherCustomerView, profileIconBtn,SocialCustomerView, PotentialObject, ProbabilityLabel, DealSizeLabel, Description,stageDetails,SocialtweetTableView, ActivityTable, OpportunityTable, Searchbtn, UserIcon, NotificationIcon, horizontalLine;

@synthesize socialFeedsTitleLabel,activitiesTitleLabel,contactsTitleLabel,upcomingAppointmentsLabel;
@synthesize titleLabel;
@synthesize oppAcumenLabel,oppDealSizeLabel,oppLiquidityScore,oppProbabilityLabel,oppRiskToleranceLabel,oppStatusLabel,debtLabel,descripitonLabel,equityLabel,OppDetailLabel,opportunityIconImageView;
@synthesize tcv,firstYear,client,closedate,duration,percentage,product,index;


#define PRODUCTS_SOLD 0
#define PRODUCTS_PITCHED 1
#define RECOMMENDED_PRODUCTS 2

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])


#pragma mark ViewLifeCycle

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    
    
    
    [self.opportunityIconImageView.layer setCornerRadius:6];
    [self.opportunityIconImageView.layer setMasksToBounds:YES];
    
    self.titleLabel.text=NSLocalizedString(@"OPP_OVERVIEW", @"Opportunity Detail");
    self.OppDetailLabel.text=NSLocalizedString(@"OPPORTUNITY_DETAIL", @"Opportunity Details");
    self.descripitonLabel.text=NSLocalizedString(@"DESCRIPTION", @"Description");
    self.debtLabel.text=NSLocalizedString(@"DEBT", @"Debt");
    //self.oppStatusLabel.text=NSLocalizedString(@"STATUS", @"Status");
    self.oppProbabilityLabel.text=NSLocalizedString(@"PROBABILITY", @"Probability");
    self.oppDealSizeLabel.text=NSLocalizedString(@"DEAL_SIZE", @"Deal Size");
    self.equityLabel.text=NSLocalizedString(@"EQUITY", @"Equity");
    self.oppRiskToleranceLabel.text=NSLocalizedString(@"RISK_TOLERNACE", @"Risk Tolerance");
    self.oppLiquidityScore.text=NSLocalizedString(@"LIQUIDITY_SCORE", @"Liquidity Score");
    self.oppAcumenLabel.text=NSLocalizedString(@"INVESTMENT_ACUMEN", @"Investment Acumen");
    self.contactsTitleLabel.text=NSLocalizedString(@"CONTACTS", @"Contacts");
    self.activitiesTitleLabel.text=NSLocalizedString(@"ACTIVITIES", @"Activities");
    self.socialFeedsTitleLabel.text=NSLocalizedString(@"SOCIAL_FEEDS", @"Social Feeds");
    self.upcomingAppointmentsLabel.text=NSLocalizedString(@"UPCOMING_APPOINTMENTS", @"Upcoming Appointments");
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"search_icon.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification_icon.png"]];
        horizontalLine.image = [UIImage imageNamed:@"horzontal_line.png"];
        Backbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_btn.png.png"]];
        
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_search_icon_1.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_notification_icon.png"]];
        horizontalLine.image = [UIImage imageNamed:@"Theme2_horizontal_line.png"];
        Backbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_back_btn.png"]];
    }
    
    
    socialFeedsArray = [[NSMutableArray alloc]init];
    
    self.ActivityTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
    self.OpportunityTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
    self.stagesBreadCrumbView.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
    
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stagesClicked)];
    [self.stagesBreadCrumbView addGestureRecognizer:tapGesture];
    
    
    [OpportunityDetailView.layer setCornerRadius:5];
    [self.stagesBreadCrumbView.layer setCornerRadius:5];
    [self.stagesBreadCrumbView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.stagesBreadCrumbView.layer setBorderWidth:0.4];
    
    [self.OpportunityTable.layer setCornerRadius:5];
    [OtherCustomerView.layer setCornerRadius:5];
    [SocialCustomerView.layer setCornerRadius:5];
    
    // [self.OpportunityName setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    // [self.OpportunityName setTextAlignment:UITextAlignmentLeft];
    [self.OpportunityName setBackgroundColor:[UIColor clearColor]];
    // self.OpportunityName.textColor = [Utils colorFromHexString:@"275d75"];
    
    
    [self.OpportunityDescription setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.OpportunityDescription setTextAlignment:UITextAlignmentLeft];
    [self.OpportunityDescription setBackgroundColor:[UIColor clearColor]];
    self.OpportunityDescription.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    
    [self.custOrganization setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.custOrganization setTextAlignment:UITextAlignmentLeft];
    [self.custOrganization setBackgroundColor:[UIColor clearColor]];
    self.custOrganization.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.ProbabilityLabel setFont:[UIFont fontWithName:FONT_BOLD size:24]];
    [self.ProbabilityLabel setTextAlignment:UITextAlignmentLeft];
    [self.ProbabilityLabel setBackgroundColor:[UIColor clearColor]];
    self.ProbabilityLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.DealSizeLabel setFont:[UIFont fontWithName:FONT_BOLD size:24]];
    [self.DealSizeLabel setTextAlignment:UITextAlignmentLeft];
    [self.DealSizeLabel setBackgroundColor:[UIColor clearColor]];
    self.DealSizeLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    
    [self.stageDetails setFont:[UIFont fontWithName:FONT_BOLD size:24]];
    [self.stageDetails setTextAlignment:UITextAlignmentLeft];
    [self.stageDetails setBackgroundColor:[UIColor clearColor]];
    self.stageDetails.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.Description setFont:[UIFont fontWithName:FONT_BOLD size:15]];
    [self.Description setTextAlignment:UITextAlignmentLeft];
    [self.Description setBackgroundColor:[UIColor clearColor]];
    self.Description.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Dashboard_bg.png"]];
    NSArray *arrTemp1 = [[NSArray alloc]initWithObjects:@"",nil];
	NSArray *arrTemp2 = [[NSArray alloc]initWithObjects:@"",nil];
	NSArray *arrTemp3 = [[NSArray alloc]initWithObjects:@"",nil];
    NSDictionary *temp =[[NSDictionary alloc]initWithObjectsAndKeys:arrTemp1,@"Products Sold",arrTemp2,@"Products Pitched",arrTemp3,@"Recommended Products",nil];
    self.productsDict =temp;
	NSLog(@"table %@",self.productsDict);
	NSLog(@"table with Keys %@",[self.productsDict allKeys]);
	self.keysArray =[self.productsDict allKeys];
	NSLog(@"sorted %@",self.keysArray);
    customersArray=[[ NSMutableArray alloc] init];
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(40,435,904,270)];
    [scroll setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:scroll];
    
    [self loadOpportunityData];
    
    self.stagesArray = [[NSMutableArray alloc]init];
    self.stagesDictionary=[[NSMutableDictionary alloc]init];
    stageIndicators= [[NSMutableArray alloc]init];
    
    if([Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN])
    {
        NSString *plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN_PLIST_FILE]];
        
        NSLog(@"[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN_PLIST_FILE]: %@",[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN_PLIST_FILE]);
        NSLog(@"plist path: %@",plistPath);
        self.stagesDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    }
    NSLog(@"stagesDictionary: %@", self.stagesDictionary);
    
    [self.stagesArray  addObjectsFromArray:[[self.stagesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] ];
    
    NSLog(@"no:%@", self.stagesArray);
    
    number_of_stages=[self.stagesArray count];
    
    current_stage=3;
    
    [self initializeAlphabeticGestures];
    
    //   / [self loadDomainSpecificStages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesAddedForOpportunity:) name:NOTES_ADDED_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesDeletedForOpportunity:) name:NOTES_DELETED_NOTIFICATION object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setOppStatusLabel:nil];
    [self setOppDealSizeLabel:nil];
    [self setOppProbabilityLabel:nil];
    [self setOppRiskToleranceLabel:nil];
    [self setOppLiquidityScore:nil];
    [self setOppAcumenLabel:nil];
    [self setDebtLabel:nil];
    [self setEquityLabel:nil];
    [self setAddEventToOpportunityButton:nil];
    [self setOpportunityIconImageView:nil];
    [self setOpportunityEditButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Opportunity Details"];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [ThemeHelper applyCurrentThemeToView];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
#pragma mark LoadingSocialFeeds

- (void)loadSocialFeed
{
    [self.socialFeedsActivityIndicator startAnimating];
    [self performSelectorInBackground:@selector(startLoadingSocialFeeds) withObject:nil];
}

-(void)startLoadingSocialFeeds
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweetsLoaded:) name:@"tweetsLoaded" object:nil];
    [Twitter getTweetsFortwitterID:@"vineet18iitr"];
}
-(void)tweetsLoaded:(NSNotification *)notification
{
    
    [socialFeedsArray addObjectsFromArray:notification.object];
    [self performSelectorOnMainThread:@selector(updateTweets) withObject:nil waitUntilDone:YES];
}


-(void)updateTweets
{
    NSLog(@"Tweets: %@", socialFeedsArray);
    [SocialtweetTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    [self.socialFeedsActivityIndicator stopAnimating];
    [self.socialFeedsActivityIndicator setHidden:YES];
}

#pragma mark Core Data Opportunity Helpers

- (void)refreshDataForCurretnOpportunityObjectFromCoreDataStore
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Opportunities"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"opportunityID == %@",oppID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if([fetchedObjects count]>0)
    {
        self.PotentialObject=(Opportunity *)[fetchedObjects objectAtIndex:0];
        [self loadOpportunityData];
        
    }
}



/*
 
 #pragma mark TableView Datasource
 
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (tableView.tag == 1)
 return 47;
 else if (tableView.tag == 2)
 return 47;
 else if (tableView.tag == 3)
 return 80;
 else if (tableView.tag == 4)
 return 100;
 else
 return 0;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 if (tableView.tag == 1)
 return [[PotentialObject.eventsTaggedToOpportunity allObjects] count];
 else if (tableView.tag == 2)
 return 3;
 else if (tableView.tag == 3)
 return [socialFeedsArray count];
 else if (tableView.tag == 4)
 return [customersArray count];
 else
 return 0;
 
 }
 
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 cell.backgroundColor = [UIColor clearColor];
 cell.backgroundView.backgroundColor = [UIColor clearColor];
 }
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
 {
 UIView *view = [[UIView alloc] init];
 return view;
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
 
 cell.selectionStyle=UITableViewCellSelectionStyleNone;
 
 if (tableView.tag == 4)
 {
 
 UIImageView *profileIcon = [[UIImageView alloc]init];
 profileIcon.frame = CGRectMake(15, 25, 50, 50);
 if (indexPath.row %2 == 0)
 profileIcon.image=[UIImage imageNamed:@"user_icon_3.png"];
 else
 profileIcon.image=[UIImage imageNamed:@"user_icon_4.png"];
 
 [profileIcon.layer setCornerRadius:6.0];
 [profileIcon.layer setMasksToBounds:YES];
 
 Customers *userObject = [customersArray objectAtIndex:indexPath.row];
 
 UILabel *custOmerName = [[UILabel alloc]init];
 custOmerName.frame = CGRectMake(80, 15, 150, 22);
 custOmerName.text = [NSString stringWithFormat:@"%@ %@",userObject.firstName, userObject.lastName];
 [custOmerName setFont:[UIFont fontWithName:FONT_BOLD size:18]];
 [custOmerName setTextAlignment:UITextAlignmentLeft];
 [custOmerName setBackgroundColor:[UIColor clearColor]];
 custOmerName.textColor = [Utils colorFromHexString:@"275d75"];
 
 
 UILabel *custDesig = [[UILabel alloc]init];
 custDesig.frame = CGRectMake(80, 40, 180, 18);
 custDesig.text = userObject.mailingCity;
 [custDesig setFont:[UIFont fontWithName:FONT_BOLD size:14]];
 [custDesig setTextAlignment:UITextAlignmentLeft];
 [custDesig setBackgroundColor:[UIColor clearColor]];
 custDesig.textColor = [Utils colorFromHexString:@"6d6c6c"];
 
 
 UILabel *custOrg = [[UILabel alloc]init];
 custOrg.frame = CGRectMake(80, 60, 180, 18);
 custOrg.text = userObject.mailingState;
 [custOrg setFont:[UIFont fontWithName:FONT_BOLD size:14]];
 [custOrg setTextAlignment:UITextAlignmentLeft];
 [custOrg setBackgroundColor:[UIColor clearColor]];
 custOrg.textColor = [Utils colorFromHexString:@"6d6c6c"];
 
 
 [cell.contentView addSubview:profileIcon];
 [cell.contentView addSubview:custOmerName];
 [cell.contentView addSubview:custDesig];
 [cell.contentView addSubview:custOrg];
 }
 
 else if (tableView.tag == 3)
 {
 
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
 
 cell.selectionStyle=UITableViewCellSelectionStyleNone;
 
 
 cell.selectionStyle=UITableViewCellSelectionStyleNone;
 [cell.imageView setImage:[UIImage imageNamed:@"twitter_loading.png"]];
 [cell.imageView setImageURL:[NSURL URLWithString:[[socialFeedsArray objectAtIndex:indexPath.row] objectForKey:@"profile_image_url"]]];
 
 [cell.imageView.layer setCornerRadius:6.0];
 [cell.imageView.layer setMasksToBounds:YES];
 
 
 UIImageView *SocialImage = [[UIImageView alloc]init];
 SocialImage.frame = CGRectMake(260, 55, 18, 18);
 SocialImage.image = [UIImage imageNamed:@"twitter_icon.png"];
 
 [cell.textLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
 [cell.textLabel setTextAlignment:UITextAlignmentLeft];
 [cell.textLabel setBackgroundColor:[UIColor clearColor]];
 cell.textLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
 [cell.textLabel setNumberOfLines:2];
 
 cell.textLabel.text = [[socialFeedsArray objectAtIndex:indexPath.row] objectForKey:@"text"];
 
 [cell.detailTextLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
 cell.detailTextLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
 cell.detailTextLabel.text = [[[socialFeedsArray objectAtIndex:indexPath.row] objectForKey:@"created_at"] substringToIndex:20];
 
 [cell.contentView addSubview:SocialImage];
 }
 
 else if (tableView.tag == 2)
 {
 UILabel *OppLabel = [[UILabel alloc]init];
 OppLabel.frame = CGRectMake(80, 20, 400, 18);
 [OppLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
 [OppLabel setTextAlignment:UITextAlignmentLeft];
 [OppLabel setBackgroundColor:[UIColor clearColor]];
 OppLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
 [OppLabel setNumberOfLines:0];
 
 UIView *sideViews = [[UIView alloc]init];
 sideViews.frame = CGRectMake(0, 0, 4, 47);
 
 cell.contentView.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
 
 {
 if (indexPath.row == 0)
 {
 OppLabel.text = @"To Sell Prima Fund To John";
 sideViews.backgroundColor = [Utils colorFromHexString: @"83a811"];
 }
 
 if (indexPath.row == 1)
 {
 OppLabel.text = @"To Sell Real Estate Fund To John";
 sideViews.backgroundColor = [Utils colorFromHexString: @"5e5e5e"];
 
 UIImageView *medalImage = [[UIImageView alloc]init];
 medalImage.frame= CGRectMake(540, 10, 16, 23);
 medalImage.image = [UIImage imageNamed:@"medal_icon.png"];
 [cell.contentView addSubview:medalImage];
 }
 
 if (indexPath.row == 2)
 {
 OppLabel.text = @"To Sell FMCG Growth Index Fund To John";
 sideViews.backgroundColor = [Utils colorFromHexString: @"5e5e5e"];
 }
 
 }
 [cell.contentView addSubview:OppLabel];
 [cell.contentView addSubview:sideViews];
 }
 
 else if (tableView.tag == 1)
 {
 UILabel *ActivityLabel = [[UILabel alloc]init];
 ActivityLabel.frame = CGRectMake(80, 20, 400, 18);
 [ActivityLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
 [ActivityLabel setTextAlignment:UITextAlignmentLeft];
 [ActivityLabel setBackgroundColor:[UIColor clearColor]];
 ActivityLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
 [ActivityLabel setNumberOfLines:0];
 
 UIView *sideViews = [[UIView alloc]init];
 sideViews.frame = CGRectMake(0, 0, 4, 47);
 
 cell.contentView.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
 Events *ActivityObject = [[PotentialObject.eventsTaggedToOpportunity allObjects] objectAtIndex:indexPath.row];
 ActivityLabel.text =ActivityObject.eventTitle;
 
 {
 if (indexPath.row == 0)
 {
 sideViews.backgroundColor = [Utils colorFromHexString: @"83a811"];
 }
 
 else
 
 {
 sideViews.backgroundColor = [Utils colorFromHexString: @"5e5e5e"];
 }
 
 
 }
 [cell.contentView addSubview:ActivityLabel];
 [cell.contentView addSubview:sideViews];
 }
 return cell;
 }
 
 
 #pragma mark TableView delegate
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
 UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
 
 cell.selectionStyle=UITableViewCellSelectionStyleNone;
 
 if (tableView.tag ==1)
 {
 Events *event = [[self.PotentialObject.eventsTaggedToOpportunity allObjects] objectAtIndex:indexPath.row];
 [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
 
 [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Opportunity Detail Screen" withAction:@"Activity Clicked" withLabel:event.eventTitle withValue:nil];
 CalendarViewController *calendarViewController=[[CalendarViewController alloc]initWithNibName:@"CalendarViewController" bundle:nil];
 
 calendarViewController.sDayViewController.events=event;
 [[ModelTrackingClass sharedInstance] setModelObject:event.eventStartDate forKey:@"currentDay"];
 
 RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
 
 SWRevealViewController *mainRevealController =
 [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:calendarViewController];
 
 mainRevealController.rearViewRevealWidth = 200;
 mainRevealController.rearViewRevealOverdraw = 150;
 mainRevealController.bounceBackOnOverdraw = NO;
 mainRevealController.stableDragOnOverdraw = YES;
 [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
 
 
 [self.navigationController pushViewController:mainRevealController animated:YES];
 
 [[NSNotificationCenter defaultCenter]postNotificationName:@"EventClickedFromDashboard" object:event];
 }
 if (tableView.tag ==2)
 {
 [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
 
 [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Opportunity Screen" withAction:@"Form Workflow Clicked" withLabel:nil withValue:nil];
 SalesProcessViewController *salesProcess=[[SalesProcessViewController alloc]initWithNibName:@"SalesProcessViewController" bundle:nil];
 [self.navigationController pushViewController:salesProcess animated:YES];
 }
 }
 */

#pragma mark Custom UI Methods

-(void)stagesClicked
{
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Opportunity Screen" withAction:@"Form Workflow Clicked" withLabel:nil withValue:nil];
    SalesProcessViewController *salesProcess=[[SalesProcessViewController alloc]initWithNibName:@"SalesProcessViewController" bundle:nil];
    [self.navigationController pushViewController:salesProcess animated:YES];
    
}

-(IBAction)profileIconClicked:(id)sender
{
    SalesProcessViewController *cispview = [[SalesProcessViewController alloc] init];
    [self.navigationController pushViewController:cispview animated:YES];
}



-(IBAction)BackbuttonClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 
 -(IBAction)sendAppointment:(id)sender
 {
 UIViewController* popoverContent = [[UIViewController alloc] init];
 popoverContent.contentSizeForViewInPopover=CGSizeMake(500, 400);
 if([SendAppointmentPopoverController isPopoverVisible])
 [SendAppointmentPopoverController dismissPopoverAnimated:YES];
 SendAppointmentPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
 [SendAppointmentPopoverController presentPopoverFromRect:sendAppointment.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
 
 emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 60, 300, 40)];
 emailTextField.borderStyle = UITextBorderStyleRoundedRect;
 emailTextField.font = [UIFont systemFontOfSize:15];
 emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
 emailTextField.keyboardType = UIKeyboardTypeDefault;
 emailTextField.returnKeyType = UIReturnKeyDone;
 //emailTextField.text = emailID;
 
 dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 110, 300, 40)];
 dateTextField.borderStyle = UITextBorderStyleRoundedRect;
 dateTextField.font = [UIFont systemFontOfSize:15];
 dateTextField.autocorrectionType = UITextAutocorrectionTypeNo;
 dateTextField.keyboardType = UIKeyboardTypeDefault;
 dateTextField.returnKeyType = UIReturnKeyDone;
 
 date = [NSDate date];
 NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
 [dateFormat setDateFormat:@"MM/dd/yyyy"];
 NSString *dateString = [dateFormat stringFromDate:date];
 dateTextField.text = dateString;
 
 timeTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 160, 300, 40)];
 timeTextField.borderStyle = UITextBorderStyleRoundedRect;
 timeTextField.font = [UIFont systemFontOfSize:15];
 timeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
 timeTextField.keyboardType = UIKeyboardTypeDefault;
 timeTextField.returnKeyType = UIReturnKeyDone;
 
 NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
 [timeFormat setDateFormat:@"h:mm a"];
 NSString *timeString = [timeFormat stringFromDate:date];
 timeTextField.text = timeString;
 
 locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 210, 300, 40)];
 locationTextField.borderStyle = UITextBorderStyleRoundedRect;
 locationTextField.font = [UIFont systemFontOfSize:15];
 locationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
 locationTextField.keyboardType = UIKeyboardTypeDefault;
 locationTextField.returnKeyType = UIReturnKeyDone;
 locationTextField.text = @"Chennai";
 
 saveInvite = [[UIButton alloc]init];
 [saveInvite setTitle:@"Save Invite" forState:UIControlStateNormal];
 [saveInvite setBackgroundColor:[UIColor grayColor]];
 [saveInvite addTarget:self action:@selector(saveInvite:) forControlEvents:UIControlEventTouchUpInside];
 saveInvite.frame = CGRectMake(100, 300, 110, 30);
 
 sendInvite = [[UIButton alloc]init];
 [sendInvite setTitle:@"Send Invite" forState:UIControlStateNormal];
 [sendInvite setBackgroundColor:[UIColor grayColor]];
 [sendInvite addTarget:self action:@selector(sendInvite:) forControlEvents:UIControlEventTouchUpInside];
 sendInvite.frame = CGRectMake(270, 300, 110, 30);
 
 
 [popoverContent.view addSubview:emailTextField];
 [popoverContent.view addSubview:dateTextField];
 [popoverContent.view addSubview:timeTextField];
 [popoverContent.view addSubview:locationTextField];
 [popoverContent.view addSubview:saveInvite];
 [popoverContent.view addSubview:sendInvite];
 }
 
 
 
 -(void)sendInvite:(id)sender
 {
 
 }
 
 -(void)saveInvite:(id)sender
 {
 
 }
 
 
 
 
 -(void)loadDomainSpecificStages
 {
 int offset=10;
 
 for (int i=0; i<[self.stagesArray count]; i++)
 {
 UIButton *stageButton=[UIButton buttonWithType:UIButtonTypeCustom];
 
 if (i==current_stage)
 [stageButton setBackgroundImage:[UIImage imageNamed:@"inprogress_state.png"] forState:UIControlStateNormal];
 else if(i<current_stage)
 [stageButton setBackgroundImage:[UIImage imageNamed:@"selected_state.png"] forState:UIControlStateNormal];
 else
 [stageButton setBackgroundImage:[UIImage imageNamed:@"circle_plain.png"] forState:UIControlStateNormal];
 
 [stageButton setFrame:CGRectMake(offset, 7, 30, 30)];
 [self.stagesBreadCrumbView addSubview:stageButton];
 [stageIndicators addObject:stageButton];
 
 
 UILabel *stageName=[[UILabel alloc]init];
 stageName.frame = CGRectMake(offset, 40, 80, 60);
 [stageName setTextAlignment:UITextAlignmentLeft];
 
 if (i==[self.stagesArray count]-1)
 {
 stageName.frame = CGRectMake(offset-35, 40, 80, 60);
 [stageName setTextAlignment:UITextAlignmentRight];
 
 }
 stageName.numberOfLines=3;
 stageName.text = [[self.stagesArray objectAtIndex:i] substringFromIndex:3];
 [stageName setFont:[UIFont fontWithName:FONT_BOLD size:14]];
 [stageName setBackgroundColor:[UIColor clearColor]];
 stageName.textColor = [Utils colorFromHexString:@"5e5e5e"];
 stageName.baselineAdjustment=UIBaselineAdjustmentAlignBaselines;
 stageName.lineBreakMode=NSLineBreakByWordWrapping;
 [self.stagesBreadCrumbView addSubview:stageName];
 
 offset= ((570/(number_of_stages -1)) * (i+1)) ;
 }
 }
 */


/*
 - (void)addNotesToOpportunity:(NSDictionary *)notesDict
 {
 ZohoHelper *zohoHelper=[[ZohoHelper alloc]init];
 [zohoHelper addNotesToRecordID:self.PotentialObject.opportunityID withNoteTitle:[notesDict objectForKey:NOTES_TITLE] andNoteContent:[notesDict objectForKey:NOTES_CONTENT]];
 [self.PotentialObject addNotesTaggedToOpportunity:[zohoHelper fetchNotesForRecordID:self.PotentialObject.opportunityID inModule:@"Potentials"]];
 NSError *error = nil;
 
 [SAppDelegateObject.managedObjectContext save:&error];
 
 
 [self performSelectorOnMainThread:@selector(updateAfterAddingNotesForOpportunity) withObject:nil waitUntilDone:YES];
 }
 
 - (void)deleteNotesForOpportunity:(NSString *)noteID
 {
 ZohoHelper *zohoHelper=[[ZohoHelper alloc]init];
 [zohoHelper deleteNotesFromZoho:noteID];
 [self.PotentialObject removeNotesTaggedToOpportunity:self.PotentialObject.notesTaggedToOpportunity];
 [self.PotentialObject addNotesTaggedToOpportunity:[zohoHelper fetchNotesForRecordID:self.PotentialObject.opportunityID inModule:@"Potentials"]];
 NSError *error = nil;
 
 [SAppDelegateObject.managedObjectContext save:&error];
 
 [self performSelectorOnMainThread:@selector(updateAfterAddingNotesForOpportunity) withObject:nil waitUntilDone:YES];
 
 }
 - (void)updateAfterAddingNotesForOpportunity
 {
 SAppDelegateObject.notesArray = [[NSMutableArray alloc]initWithArray:[self.PotentialObject.notesTaggedToOpportunity allObjects]];
 
 NSLog(@"Notes for this opportunity: %@",self.PotentialObject.notesTaggedToOpportunity);
 [HUD hide:YES];
 
 }
 - (IBAction)addEventToOpportunityClicked:(id)sender {
 
 AddEventViewController *addNewEventController=[[AddEventViewController alloc]initWithNibName:@"AddEventViewController" bundle:nil];
 addNewEventController.eventRelatedToModule=OpportunitiesModule;
 addNewEventController.eventRelatedToID=self.PotentialObject.opportunityID;
 addNewEventController.delegate=self;
 
 addNewEventController.modalPresentationStyle=UIModalPresentationFormSheet;
 [self presentModalViewController:addNewEventController animated:YES];
 CGRect r = CGRectMake(self.view.bounds.size.width/2 - 335,
 self.view.bounds.size.height/2 - 320,
 670, 640);
 r = [self.view convertRect:r toView:addNewEventController.view.superview.superview];
 addNewEventController.view.superview.frame = r;
 }
 
 -(void)eventSaved:(Events *)event
 {
 [self.ActivityTable reloadData];
 }
 
 -(void)eventCancelled
 {
 }
 */







#pragma mark CHANGES BY SWARNAVA


//Displays data in UI during showing Opportunity Details

- (void)loadOpportunityData
{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.OpportunityName.text = self.PotentialObject.CustomerName;
    self.tcv.text = [formatter stringFromNumber:      [NSNumber numberWithDouble:[self.PotentialObject.TCV doubleValue]]];
    self.firstYear.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[self.PotentialObject.Firstyear doubleValue]]];
    self.closedate.text = self.PotentialObject.EstimatedClosedate;
    self.duration.text = self.PotentialObject.DealDuration;
    self.Description.text = self.PotentialObject.OpportunityName;
    
    //add Product Fields
    
    
    int y = 2;
    
    if(PotentialObject.productArray)
    {
        for (int i=0; i<[PotentialObject.productArray count]; i++) {
            
            products *obj = [PotentialObject.productArray objectAtIndex:i];
            
            UIView *productView = [[UIView alloc]init];
            [productView setFrame:CGRectMake(10,y,824,40)];
            [productView setBackgroundColor:[UIColor clearColor]];
            
            //Add Subviews
            
            //Primary
            UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [checkBtn setFrame:CGRectMake(104,5,28,28)];
            [checkBtn setUserInteractionEnabled:FALSE];
            [checkBtn setBackgroundColor:[UIColor clearColor]];
            if([obj.Primaryflag isEqualToString:@"Y"])
            {
                [checkBtn setBackgroundImage:[UIImage imageNamed:@"Cognizant_button_selectd.png"] forState:UIControlStateNormal];
                [checkBtn setBackgroundImage:[UIImage imageNamed:@"Cognizant_button_selectd.png"] forState:UIControlStateSelected];
            }
            else
            {
                [checkBtn setBackgroundImage:[UIImage imageNamed:@"Cognizant_button_unselect.png"] forState:UIControlStateNormal];
                [checkBtn setBackgroundImage:[UIImage imageNamed:@"Cognizant_button_unselect.png"] forState:UIControlStateSelected];
            }
            
            [productView addSubview:checkBtn];
            
            
            //Product Group
            UITextField *txtProduct = [[UITextField alloc]initWithFrame:CGRectMake(275,5,268,30)];
            [txtProduct setBackgroundColor:[UIColor clearColor]];
            [txtProduct setBorderStyle:UITextBorderStyleNone];
            [txtProduct setUserInteractionEnabled:NO];
            [txtProduct setText:[obj Productdescription]];
            [txtProduct setFont:[UIFont fontWithName:FONT_BOLD size:17]];
            [txtProduct setTextColor:[Utils colorFromHexString:@"6d6c6c"]];
            [txtProduct setTextAlignment:UITextAlignmentCenter];
            [productView addSubview:txtProduct];
            
            
            //Percentage
            UITextField *txtPercentage = [[UITextField alloc]initWithFrame:CGRectMake(620,5,176,30)];
            [txtPercentage setBackgroundColor:[UIColor clearColor]];
            [txtPercentage setBorderStyle:UITextBorderStyleNone];
            [txtPercentage setText:[obj Splitpercentage]];
            [txtPercentage setTextAlignment:UITextAlignmentCenter];
            [txtPercentage setUserInteractionEnabled:NO];
            [txtPercentage setFont:[UIFont fontWithName:FONT_BOLD size:17]];
            [txtPercentage setTextColor:[Utils colorFromHexString:@"6d6c6c"]];
            [productView addSubview:txtPercentage];
            
            [scroll addSubview:productView];
            
            y+= 40;
            if(y > 270)
                [scroll setContentSize:CGSizeMake(654,y+20)];
            else
                scroll.frame = CGRectMake(40,435,854,y);
            
        }
    }
    
}


//Gets called on Clicking Edit button

- (IBAction)opportunityEditButtonClicked:(id)sender {
    
    AddNewOpportunityController *editVC=[[AddNewOpportunityController alloc]initWithNibName:@"AddNewOpportunityController" bundle:nil];
    editVC.delegate=self;
    editVC.opportunityObject=self.PotentialObject;
    editVC.edit = TRUE;
    oppID=self.PotentialObject.OpportunityId;
    editVC.modalPresentationStyle=UIModalPresentationPageSheet;
    [self presentViewController:editVC animated:YES completion:NULL];
    CGRect r = CGRectMake(0,0,640, 640);
    r = [self.view convertRect:r toView:editVC.view.superview.superview];
    editVC.view.superview.superview.frame = r;
}

#pragma mark Notes Notificaiton Methods

//Gets called for Add Notes

- (void)notesAddedForOpportunity:(NSNotification *)notification
{
    [notification.object setValue:self.PotentialObject.OpportunityId forKey:@"ID"];
    
    if ([[notification.object objectForKey:NOTES_STATUS] boolValue]) {
        // HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //  HUD.labelText = NSLocalizedString(@"ADDING_NOTES", @"Adding Notes...");
        //  [self performSelectorInBackground:@selector(addNotesToOpportunity:) withObject:notification.object];
    }
    
    else
    {
        /*
         NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
         NSFetchRequest *request = [[NSFetchRequest alloc] init];
         [request setEntity:[NSEntityDescription entityForName:@"Opportunities" inManagedObjectContext:context]];
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"opportunityID == %@", self.PotentialObject.opportunityID];
         [request setPredicate:predicate];
         
         NSError *error = nil;
         NSArray *results = [context executeFetchRequest:request error:&error];
         
         if ([results count]>0)
         {
         Notes *notesObject=[NSEntityDescription
         insertNewObjectForEntityForName:@"Notes"
         inManagedObjectContext:context];
         notesObject.noteTitle=[notification.object objectForKey:NOTES_TITLE];
         notesObject.noteContent=[notification.object objectForKey:NOTES_CONTENT];
         notesObject.noteCreationDate=[[NSDate alloc]init];
         notesObject.notesCRMSyncStatus=[NSNumber numberWithBool:NO];
         
         Opportunities *oppObject=[results objectAtIndex:0];
         [oppObject addNotesTaggedToOpportunityObject:notesObject];
         
         if (![context save:&error])
         {
         NSLog(@"Sorry, couldn't save notes for customer %@", [error localizedDescription]);
         }
         
         SAppDelegateObject.notesArray = [[NSMutableArray alloc]initWithArray:[oppObject.notesTaggedToOpportunity allObjects]];
         
         }
         */
        
        HUD = [[MBProgressHUD alloc]init];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = NSLocalizedString(@"ADDING_NOTES", @"Adding Note...");
        
        [NSThread detachNewThreadSelector:@selector(addNote:) toTarget:self withObject:notification];
        
    }
}

//Call ADD NOTE Service

-(void)addNote:(NSNotification *)notification
{
    SalesForceHelper *objForce = [[SalesForceHelper alloc]init];
    [objForce addNote:notification.object];
    [self performSelectorOnMainThread:@selector(hideLoad) withObject:nil waitUntilDone:NO];
}


//call Back methods for adding NOTE

-(void)hideLoad
{
    [HUD hide:YES afterDelay:2];
    [self performSelector:@selector(noteAdded) withObject:nil afterDelay:2];
}

//call Back methods for adding NOTE

-(void)noteAdded
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:1.5];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText = NOTE_ADDED;
}



//Shows Alert on successfull updation of an opportunity

#pragma mark AddEditOpportunituesViewController Delgates

-(void)opportunitySavedSuccessfully:(Opportunity *)object
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText= [NSString stringWithFormat:@"Opportunity id %@ saved",object.OpportunityId];
    self.PotentialObject = object;
    [[SAppDelegateObject opportArray] replaceObjectAtIndex:index withObject:self.PotentialObject];
    for(UIView *view in scroll.subviews)
        [view removeFromSuperview];
    [self loadOpportunityData];
}

//Shows Alert on Failed updation of an opportunity

-(void)opportunityDataSaveFailedWithError:(NSError *)error
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText = OPPORTUNITY_FAILURE;
    
}

#pragma mark Gesture Recognition For Notes, Calculator and other Utilities

//************************************************************************
// Method for Initializing Alphabetic gesture recognition on all screens
//************************************************************************

-(void)initializeAlphabeticGestures
{
    NSError *gesturesError;
    recognizer = [[GLGestureRecognizer alloc] init];
	NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Gestures" ofType:@"json"]];
    
	BOOL ok;
	ok = [recognizer loadTemplatesFromJsonData:jsonData error:&gesturesError];
	if (!ok)
	{
		NSLog(@"Error loading gestures: %@", gesturesError);
	}
    
}

//************************************************************************
// Method for processing Alphabetic gesture recognition on all screens
//************************************************************************

- (void)processGestureData
{
	NSString *gestureName = [recognizer findBestMatchCenter:&center angle:&angle score:&score];
    NSLog(@"gesture Name: %@",gestureName);
    
    
    if ([gestureName isEqualToString:@"N"] || [gestureName isEqualToString:@"n"]) {
        
        NoteDetailViewController *vc=[[NoteDetailViewController alloc]initWithNibName:@"NoteDetailViewController" bundle:nil];
        
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
        
        nav.modalPresentationStyle=UIModalPresentationFormSheet;
        nav.navigationBarHidden = YES;
        [self presentModalViewController:nav animated:YES];
        vc.navigationController.view.backgroundColor=[UIColor clearColor];
        
        CGRect r = CGRectMake(self.view.bounds.size.width/2 - 250,
                              self.view.bounds.size.height/2 - 250,
                              500, 500);
        r = [self.view convertRect:r toView:vc.view.superview.superview];
        vc.view.superview.frame = r;
        
    }
    
    
    if ([gestureName isEqualToString:@"C"]) {
        
        SSimpleCalculator *vc=[[SSimpleCalculator alloc]initWithNibName:@"SSimpleCalculator" bundle:nil];
        
        vc.modalPresentationStyle=UIModalPresentationFormSheet;
        
        [self presentModalViewController:vc animated:YES];
        
        CGRect r = CGRectMake(self.view.bounds.size.width/2 - 250,
                              self.view.bounds.size.height/2 - 250,
                              500, 500);
        r = [self.view convertRect:r toView:vc.view.superview.superview];
        vc.view.superview.frame = r;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[recognizer resetTouches];
	[recognizer addTouches:touches fromView:self.view];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[recognizer addTouches:touches fromView:self.view];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[recognizer addTouches:touches fromView:self.view];
	
	[self processGestureData];
}




@end
