//
//  LeadsViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/11/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "LeadsViewController.h"
#import "SWRevealViewController.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import "ZohoConstants.h"
#import <QuartzCore/QuartzCore.h>
#import "Leads.h"
#import "AsyncImageView.h"
#import "CustomerViewCell.h"
#import "iPitchAnalytics.h"
#import "ZohoConstants.h"
#import "ZohoHelper.h"
#import "LeadDetailsViewController.h"
#import "AppDelegate.h"
#import "AddEditLeadViewController.h"
#import "ThemeHelper.h"
#import "SalesForceHelper.h"

@interface LeadsViewController ()<UITableViewDataSource, UITableViewDelegate,AddEditLeadStatusDelegate>{
    NSMutableArray * leadsArray;
    UIPopoverController *SearchPopoverController;
    UITableView *leadsSearchtable;
    NSMutableArray * leadSearchDetails;
    NSMutableArray *leadSearchDisplay;
    MBProgressHUD *HUD;
}


@end

@implementation LeadsViewController

@synthesize Searchbtn,titleLabel,NotificationIcon,UserIcon,buttonToggle,horizontalLine,leadSearch;

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
    
    [self.toolBarView bringSubviewToFront:Searchbtn];
    
    self.titleLabel.text=NSLocalizedString(@"MY_LEADS", @"My Leads");
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    
    
    leadsArray = [[ NSMutableArray alloc] init];
    leadSearchDetails = [[NSMutableArray alloc] init];
    leadSearchDisplay = [[NSMutableArray alloc] init];

    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Dashboard_bg.png"]];
    // Do any additional setup after loading the view from its nib.
    
    SWRevealViewController *revealController = self.revealViewController;
    [buttonToggle addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addGestureRecognizer:revealController.panGestureRecognizer];
    

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{

    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Leads"];
    
    [self refreshLeadsDataFromCoreDataStore];
    [self loadLeadsGridView];
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:TRUE];
    [ThemeHelper applyCurrentThemeToView];

    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"search_icon.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification_icon.png"]];
        buttonToggle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_view.png"]];
        horizontalLine.image = [UIImage imageNamed:@"horzontal_line.png"];
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_search_icon_1.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_notification_icon.png"]];
        buttonToggle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_list_view.png"]];
        horizontalLine.image = [UIImage imageNamed:@"Theme2_horizontal_line.png"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


#pragma mark Custom UI Methods
- (IBAction)searchButtonClicked:(id)sender{
    [leadSearch resignFirstResponder];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = NSLocalizedString(@"SEARCHING", @"Searching...");
    [self performSelectorInBackground:@selector(searchBGFunction) withObject:nil];
    
    
}


- (void)searchBGFunction{
    
    
    [leadSearchDetails removeAllObjects];
    [leadSearchDisplay removeAllObjects];
    
    ZohoHelper * zoho = [[ ZohoHelper alloc] init];
    [leadSearchDetails addObjectsFromArray:[zoho searchLeadsFromZoho:leadSearch.text]];
    
    for (int i=0; i<[leadSearchDetails count]; i++) {
        
        NSArray *flArray=[leadSearchDetails objectAtIndex:i];
        NSMutableDictionary *searchDisplayDict=[[NSMutableDictionary alloc]init];
        for (int j=0; j<[flArray count]; j++) {
            
            NSMutableDictionary* dictionary=[flArray objectAtIndex:j];
            
            if([[dictionary objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FIRST_NAME_PARAMETER])
            {
                [searchDisplayDict setObject:[dictionary objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_FIRST_NAME_PARAMETER];
            }
            
            if([[dictionary objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LAST_NAME_PARAMETER])
            {
                [searchDisplayDict setObject:[dictionary objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_LAST_NAME_PARAMETER];
            }
        
           if([[dictionary objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_COMPANY_PARAMETER])
           {
            [searchDisplayDict setObject:[dictionary objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_COMPANY_PARAMETER];
           }
            
            if([[dictionary objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_ID_PARAMETER])
            {
                [searchDisplayDict setObject:[dictionary objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_LEAD_ID_PARAMETER];
            }
        
    }
        
        [leadSearchDisplay addObject:searchDisplayDict];
    }

    if([SearchPopoverController isPopoverVisible])
        [SearchPopoverController dismissPopoverAnimated:YES];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(300, 350);
    SearchPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [SearchPopoverController presentPopoverFromRect:leadSearch.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    leadsSearchtable =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 300, 350) style:UITableViewStylePlain];
    leadsSearchtable.dataSource=self;
    leadsSearchtable.delegate=self;
    [popoverContent.view addSubview:leadsSearchtable];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


-(void)refreshLeadsDataFromCoreDataStore
{
    [leadsArray removeAllObjects];

    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:LEADS_MODULE
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    [leadsArray addObjectsFromArray:[context executeFetchRequest:fetchRequest error:&error]];
    
    NSLog(@"customersArray :%@", leadsArray);
}

-(void)loadLeadsGridView
{   
    int row = 0;
    int column = 0;
    CGFloat contentSize=155;
    
    for(UIView *tView in self.leadsListScrollView.subviews)
    {
        if (![tView isKindOfClass:[UIImageView class]]) {
            [tView removeFromSuperview];
        }
    }
    
    [self.leadsListScrollView setContentSize:CGSizeMake(0, contentSize)];
    
    [self.leadsListScrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    self.leadsListScrollView.showsHorizontalScrollIndicator=YES;
    
    
    for(int i = 0; i <[leadsArray count] + 1; ++i)
    {
        if(i<[leadsArray count])
        {
        CustomerViewCell * innerView = [[CustomerViewCell alloc]init];
        
        innerView.backgroundColor=[UIColor whiteColor];
        
        innerView.frame = CGRectMake(column*320+40, row*130+50, 300, 100);
        
        [innerView.layer setCornerRadius:5];
        
        UIButton *dummyBtn = [[UIButton alloc]init];
        dummyBtn.frame = CGRectMake(0,0, 300, 100);
        dummyBtn.tag = i;
        
        [dummyBtn setBackgroundColor:[UIColor clearColor]];
        [dummyBtn addTarget:self action:@selector(showLeadDetails:)forControlEvents:UIControlEventTouchUpInside];
        
        [innerView addSubview:dummyBtn];
        
        Leads *leadObject = [leadsArray objectAtIndex:i];
        
        /* if (i%2 == 0)
         innerView.customerIcon.image=[UIImage imageNamed:@"user_icon_3.png"];
         else*/
        
        innerView.customerIcon.image=[UIImage imageNamed:DEFAULT_USER_ICON];
        if(leadObject.leadImageURL.length >0)
        {
        [innerView.customerIcon setImageURL:[NSURL URLWithString:leadObject.leadImageURL]];
        }
        [innerView.customerIcon.layer setMasksToBounds:YES];
        [innerView.customerIcon.layer setCornerRadius:6];
        
        innerView.customerName.text=[NSString stringWithFormat:@"%@ %@", leadObject.leadFirstName, leadObject.leadLastName];
        innerView.customerDesignation.text =leadObject.leadTitle;
        innerView.customerCompany.text = leadObject.leadCompany;
        
        if (column == 2)
        {
            column = 0;
            row++;
            contentSize=contentSize+155;
            [self.leadsListScrollView setContentSize:CGSizeMake(0, contentSize)];
            
        }
        else {
            column++;
        }
        [self.leadsListScrollView addSubview:innerView];
        }
        
        else
        {
            
            UIView *innerView=[self addNewLeadViewWithFrame:CGRectMake(column*320+40, row*130+50, 300, 100)];
            [self.leadsListScrollView addSubview:innerView];
        }
        
    }
    
}

- (UIView *)addNewLeadViewWithFrame:(CGRect)tRect
{
    UIView *addNewLeadView=[[UIView alloc]initWithFrame:tRect];
    [addNewLeadView.layer setCornerRadius:5];

    [addNewLeadView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.2]];
    
    UIImageView *addNewLeadImage=[[UIImageView alloc]initWithFrame:CGRectMake((tRect.size.width -80)/2,(tRect.size.height -80)/2, 80, 80)];
    [addNewLeadImage.layer setCornerRadius:5];
    [addNewLeadImage.layer setMasksToBounds:YES];

    [addNewLeadImage setImage:[UIImage imageNamed:@"add_user_icon.png"]];
    [addNewLeadView addSubview:addNewLeadImage];

    UIButton *dummyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    dummyButton.frame = CGRectMake(0,0, 300, 100);
    [dummyButton setBackgroundColor:[UIColor clearColor]];
    [dummyButton addTarget:self action:@selector(addNewLeadClicked)forControlEvents:UIControlEventTouchUpInside];
    
    [addNewLeadView addSubview:dummyButton];
    
    return addNewLeadView;
}

- (void)addNewLeadClicked
{
    AddEditLeadViewController *editVC=[[AddEditLeadViewController alloc]initWithNibName:@"AddEditLeadViewController" bundle:nil];
    editVC.delegate=self;
    editVC.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentModalViewController:editVC animated:YES];
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 325,
                          self.view.bounds.size.height/2 - 325,
                          650, 650);
    r = [self.view convertRect:r toView:editVC.view.superview.superview];
    editVC.view.superview.frame = r;
}

- (void)showLeadDetails:(id)sender
{
        
    UIButton *temp=(UIButton*)sender;
    NSLog(@"temp tag: %d", temp.tag);
    Leads *leadObject = [leadsArray objectAtIndex:temp.tag];
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Leads Screen" withAction:@"Lead Clicked" withLabel:leadObject.leadFirstName withValue:nil];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = NSLocalizedString(@"LOADING", @"Loading...");
    
    [self performSelectorInBackground:@selector(getLeadDetailsFromZoho:) withObject:leadObject.leadID];
    
}



-(void)getLeadDetailsFromZoho:(NSString *)leadID
{   
    NSMutableSet *notes;
    
    /*ZohoHelper * zohocheck = [[ZohoHelper alloc] init];
    [zohocheck FetchRelatedActivitiesForEntity: LEADS_MODULE :leadID];
    [zohocheck TagEventsToLead];
    notes= [zohocheck fetchNotesForRecordID:leadID inModule:LEADS_MODULE];*/
    
    SalesForceHelper *salesForceHelper=[[SalesForceHelper alloc]init];
    [salesForceHelper fetchActivitiesForID:leadID parentModuleType:WhoModuleType];
    [salesForceHelper TagEventsToLead];
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:LEADS_MODULE inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"leadID == %@", leadID];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if ([results count]>0)
        {
            Leads *leadObject=(Leads *)[results objectAtIndex:0];
            [leadObject addNotesTaggedToLead:notes];
            if (![context save:&error]) {
                NSLog(@"Sorry could note save notes for customer: %@",[error localizedDescription]);
            } ;
            [self performSelectorOnMainThread:@selector(udpateAfterFetchingLeadDetails:) withObject:leadObject waitUntilDone:YES];
            
        }
        
    });
    
}


-(void)udpateAfterFetchingLeadDetails:(Leads *)leadObject
{
    [HUD hide:YES];
    
    LeadDetailsViewController *viewController = [[LeadDetailsViewController alloc] initWithNibName:@"LeadDetailsViewController" bundle:Nil];
    viewController.LeadObject=leadObject;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark TableView DataSource & Delegates
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [leadSearchDisplay count];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    else
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
   
    
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@",[[leadSearchDisplay objectAtIndex:indexPath.row] objectForKey:ZOHO_FIRST_NAME_PARAMETER],[[leadSearchDisplay objectAtIndex:indexPath.row] objectForKey:ZOHO_LAST_NAME_PARAMETER]]];
    
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",[[leadSearchDisplay objectAtIndex:indexPath.row] objectForKey:ZOHO_COMPANY_PARAMETER]]];
   
    
    cell.imageView.image=[UIImage imageNamed:DEFAULT_USER_ICON];
    NSString *imageURL=[NSString stringWithFormat:@"https://crm.zoho.com/crm/private/json/Leads/downloadPhoto?authtoken=%@&scope=crmapi&id=%@",[Utils userDefaultsGetObjectForKey:ZOHO_CRM_API_KEY],[[leadSearchDisplay objectAtIndex:indexPath.row] objectForKey:ZOHO_LEAD_ID_PARAMETER]];
    [cell.imageView setImageURL:[NSURL URLWithString:imageURL]];
    
    [cell.imageView.layer setCornerRadius:6];
    [cell.imageView.layer setMasksToBounds:YES];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [cell.textLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [cell.textLabel setTextAlignment:UITextAlignmentLeft];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[Utils colorFromHexString:@"275d75"]];
    
    
    [cell.detailTextLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [cell.detailTextLabel setTextAlignment:UITextAlignmentLeft];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [SearchPopoverController dismissPopoverAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSString *leadID = [[leadSearchDisplay objectAtIndex:indexPath.row] objectForKey:ZOHO_LEAD_ID_PARAMETER];
    
    ZohoHelper * zohocheck = [[ZohoHelper alloc] init];
    Leads  *leadObject;
    if (![zohocheck checkAttributeWithAttributeName:@"leadID" InEntityWithEntityName:@"Leads" ForPreviousItems:leadID inContext:context] )
    {
        
       leadObject  = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Leads"
                          inManagedObjectContext:context];
        
        NSArray *leadArray=[leadSearchDetails objectAtIndex:indexPath.row];
        
        for (int j=0; j<[leadArray count]; j++)
        {
            NSMutableDictionary* dictionary1=[leadArray objectAtIndex:j];
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_PHONE_PARAMETER])
            {
                leadObject.leadPhone = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FIRST_NAME_PARAMETER])
            {
                leadObject.leadFirstName = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LAST_NAME_PARAMETER])
            {
                leadObject.leadLastName = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_ID_PARAMETER]) {
                leadObject.leadID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                
                
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_EMAIL_PARAMETER]) {
                
                leadObject.leadEmailID=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_OWNER_PARAMETER]) {
                
                leadObject.leadOwner = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_COMPANY_PARAMETER]) {
                
                leadObject.leadCompany = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_DESIGNATION_PARAMETER]) {
                
                leadObject.leadTitle = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FAX_PARAMETER]) {
                
                leadObject.leadIndustry = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_INDUSTRY_PARAMETER]) {
                
                leadObject.annualRevenue = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FAX_PARAMETER]) {
                
                leadObject.leadFax = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_MOBILE_PARAMETER]) {
                
                leadObject.leadMobileNo = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_WEBSITE_PARAMETER]) {
                
                leadObject.leadWebsite = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_STATUS_PARAMETER]) {
                
                leadObject.leadStatus = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_SOURCE_PARAMETER]) {
                
                leadObject.leadSource = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_NUMBER_OF_EMPLOYEES_PARAMETER]) {
                
                leadObject.numberOfEmployees = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_RATING_PARAMETER]) {
                
                leadObject.leadRating = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_SALUTATION_PARAMETER]) {
                
                leadObject.leadSalutation = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FAVOURITE_PARAMETER]) {
                
                leadObject.favouriteStatus = [NSNumber numberWithBool: [[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER]boolValue ]];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_SKYPE_PARAMETER]) {
                
                leadObject.leadSkypeID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_TWITTER_ID_PARAMETER]) {
                
                leadObject.leadTwitterID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LINKEDIN_PARAMETER]) {
                
                leadObject.leadLinkedInID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_DESCRIPTION_PARAMETER]) {
                
                leadObject.leadDescription = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_CITY_PARAMETER]) {
                
                leadObject.mailingCity = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_COUNTRY_PARAMETER]) {
                
                leadObject.mailingCountry = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_STATE_PARAMETER]) {
                
                leadObject.mailingState = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_STREET_PARAMETER]) {
                
                leadObject.mailingStreet = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_ZIP_CODE_PARAMETER]) {
                
                leadObject.mailingZIP = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
            }
            
            leadObject.leadImageURL=[NSString stringWithFormat:@"https://crm.zoho.com/crm/private/json/Leads/downloadPhoto?authtoken=%@&scope=crmapi&id=%@",[Utils userDefaultsGetObjectForKey:ZOHO_CRM_API_KEY],leadObject.leadID];
        }
        
    }
    
    else
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Leads" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"leadID == %@", leadID];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if ([results count]>0)
        {
            
            leadObject=[results objectAtIndex:0];
            
            NSArray *leadArray=[leadSearchDetails objectAtIndex:indexPath.row];
            
            for (int j=0; j<[leadArray count]; j++)
            {
                NSMutableDictionary* dictionary1=[leadArray objectAtIndex:j];
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_PHONE_PARAMETER])
                {
                    leadObject.leadPhone = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FIRST_NAME_PARAMETER])
                {
                    leadObject.leadFirstName = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LAST_NAME_PARAMETER])
                {
                    leadObject.leadLastName = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_ID_PARAMETER]) {
                    leadObject.leadID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                    
                    
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_EMAIL_PARAMETER]) {
                    
                    leadObject.leadEmailID=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_OWNER_PARAMETER]) {
                    
                    leadObject.leadOwner = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_COMPANY_PARAMETER]) {
                    
                    leadObject.leadCompany = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_DESIGNATION_PARAMETER]) {
                    
                    leadObject.leadTitle = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FAX_PARAMETER]) {
                    
                    leadObject.leadIndustry = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_INDUSTRY_PARAMETER]) {
                    
                    leadObject.annualRevenue = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FAX_PARAMETER]) {
                    
                    leadObject.leadFax = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_MOBILE_PARAMETER]) {
                    
                    leadObject.leadMobileNo = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_WEBSITE_PARAMETER]) {
                    
                    leadObject.leadWebsite = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_STATUS_PARAMETER]) {
                    
                    leadObject.leadStatus = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_SOURCE_PARAMETER]) {
                    
                    leadObject.leadSource = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_NUMBER_OF_EMPLOYEES_PARAMETER]) {
                    
                    leadObject.numberOfEmployees = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_RATING_PARAMETER]) {
                    
                    leadObject.leadRating = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_SALUTATION_PARAMETER]) {
                    
                    leadObject.leadSalutation = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FAVOURITE_PARAMETER]) {
                    
                    leadObject.favouriteStatus = [NSNumber numberWithBool: [[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER]boolValue ]];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_SKYPE_PARAMETER]) {
                    
                    leadObject.leadSkypeID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_TWITTER_ID_PARAMETER]) {
                    
                    leadObject.leadTwitterID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LINKEDIN_PARAMETER]) {
                    
                    leadObject.leadLinkedInID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_DESCRIPTION_PARAMETER]) {
                    
                    leadObject.leadDescription = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_CITY_PARAMETER]) {
                    
                    leadObject.mailingCity = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_COUNTRY_PARAMETER]) {
                    
                    leadObject.mailingCountry = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_STATE_PARAMETER]) {
                    
                    leadObject.mailingState = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_STREET_PARAMETER]) {
                    
                    leadObject.mailingStreet = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_ZIP_CODE_PARAMETER]) {
                    
                    leadObject.mailingZIP = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                leadObject.leadImageURL=[NSString stringWithFormat:@"https://crm.zoho.com/crm/private/json/Leads/downloadPhoto?authtoken=%@&scope=crmapi&id=%@",[Utils userDefaultsGetObjectForKey:ZOHO_CRM_API_KEY],leadObject.leadID];
            }
        }
    }
    
    
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Sorry, couldn't save Customers %@", [error localizedDescription]);
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = NSLocalizedString(@"LOADING", @"Loading...");
    
    [self performSelectorInBackground:@selector(getLeadDetailsFromZoho:) withObject:leadObject.leadID];
}

#pragma mark AddEditLeadViewController Delegates

- (void)leadDataSavedSuccessfully
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText= @"Lead Details Saved Successfully!!";
    [self refreshLeadsDataFromCoreDataStore];
    [self loadLeadsGridView];
    
    
}

- (void)leadDataSaveFailedWithError:(NSError *)error
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText=@"Sorry could not Save Lead Details";
    
    NSLog(@"errod: %@",error.localizedDescription);
}

@end
