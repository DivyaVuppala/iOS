//
//  PersnoalDashboardViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/10/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "PersnoalDashboardViewController.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import <AVFoundation/AVFoundation.h>
#import "iCarousel.h"
#import "Twitter.h"
#import "AsyncImageView.h"
#import "MWFeedItem.h"
#import "MWFeedParser.h"
#import "NSString+HTML.h"
#import "NSString+XMLEntities.h"
#import "NSString+MD5Addition.h"


@interface PersnoalDashboardViewController ()<MWFeedParserDelegate>
{
    SystemSoundID audioEffect;
    NSMutableArray *socialFeedsArray;
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    NSArray *itemsToDisplay;
    NSDateFormatter *formatter;
    NSMutableDictionary *learningDict;

}
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property (nonatomic, retain) IBOutlet UIButton *UserIcon;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalLine;
@property (nonatomic, strong) IBOutlet UIButton *buttonToggle;
@property (weak, nonatomic) IBOutlet UIView *currentSelectionView;
@property (weak, nonatomic) IBOutlet UITableView *tweetsTable;
@property (weak, nonatomic) IBOutlet UITableView *rssFeedsTable;
@property (weak, nonatomic) IBOutlet UITableView *mandatoryLearningTable;
@property (weak, nonatomic) IBOutlet UITableView *recommendedLearningTable;
@property (weak, nonatomic) IBOutlet UITableView *industryReportsTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *rssLoadingActivity;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *socialActivityIndicator;

@property (weak, nonatomic) IBOutlet iCarousel *carouselView;
@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,retain) NSMutableArray *itemsArray;
@property (weak, nonatomic) IBOutlet UIView *goalView;
@property (weak, nonatomic) IBOutlet UIView *learningView;
@property (weak, nonatomic) IBOutlet UIView *interestView;
@end

@implementation PersnoalDashboardViewController
@synthesize buttonToggle,toolBarView,UserIcon,horizontalLine;
@synthesize goalView,learningView,interestView;

#define MANDATORY_LEARNING @"Mandatory"
#define RECOMMENDED_LEARNING @"Recommended"
#define INDUSTRY_REPORTS @"Industry reports"

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
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        buttonToggle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_view.png"]];
        self.horizontalLine.image = [UIImage imageNamed:@"horzontal_line.png"];

        
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        buttonToggle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_list_view.png"]];
        self.horizontalLine.image = [UIImage imageNamed:@"Theme2_horizontal_line.png"];
       
    }
    SWRevealViewController *revealController = self.revealViewController;
    [self.buttonToggle addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    self.imagesArray=[[NSMutableArray alloc]initWithObjects:@"goals.png",@"my_interest.png",@"training.png",@"goals.png",@"my_interest.png",@"training.png", nil];
    self.itemsArray=[[NSMutableArray alloc]initWithObjects:@"Goals",@"Interests",@"Learning",@"Goals",@"Interests",@"Learning", nil];
    NSString *plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"LearningInfo.plist"];

    learningDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];

    //[self animatePersonalDashBoardViews];

    
    [self.view bringSubviewToFront:self.carouselView];
    
     self.carouselView.type = iCarouselTypeRotary;
    [self.carouselView reloadData];
    
    
    [self.goalView.layer setCornerRadius:6.f];
    [self.goalView.layer setMasksToBounds:YES];
    [self.goalView setHidden:NO];
    
    [self.learningView.layer setCornerRadius:6.f];
    [self.learningView.layer setMasksToBounds:YES];
    
    [self.interestView.layer setCornerRadius:6.f];
    [self.interestView.layer setMasksToBounds:YES];
    
    self.tweetsTable.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    self.tweetsTable.layer.borderWidth=0.5f;
    [self.tweetsTable.layer setCornerRadius:6.f];
    [self.tweetsTable.layer setMasksToBounds:YES];
    self.tweetsTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];

    
    self.rssFeedsTable.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    self.rssFeedsTable.layer.borderWidth=0.5f;
    [self.rssFeedsTable.layer setCornerRadius:6.f];
    [self.rssFeedsTable.layer setMasksToBounds:YES];
    self.rssFeedsTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];

    self.mandatoryLearningTable.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    self.mandatoryLearningTable.layer.borderWidth=0.5f;
    [self.mandatoryLearningTable.layer setCornerRadius:6.f];
    [self.mandatoryLearningTable.layer setMasksToBounds:YES];
    self.mandatoryLearningTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
    
    self.recommendedLearningTable.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    self.recommendedLearningTable.layer.borderWidth=0.5f;
    [self.recommendedLearningTable.layer setCornerRadius:6.f];
    [self.recommendedLearningTable.layer setMasksToBounds:YES];
    self.recommendedLearningTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
    
    
    self.industryReportsTable.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    self.industryReportsTable.layer.borderWidth=0.5f;
    [self.industryReportsTable.layer setCornerRadius:6.f];
    [self.industryReportsTable.layer setMasksToBounds:YES];
    self.industryReportsTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
    
    socialFeedsArray = [[NSMutableArray alloc]init];

    
    formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [[NSMutableArray alloc] init];
	itemsToDisplay = [NSArray array];
    
    NSURL *feedURL = [NSURL URLWithString:@"http://www.techgig.com/newsfeed"];
     
     // NSURL *feedURL = [NSURL URLWithString:@"http://news.google.com/?output=rss"];
    
     feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
     feedParser.delegate = self;
     feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
     feedParser.connectionType = ConnectionTypeAsynchronously;

    // Do any additional setup after loading the view from its nib.
    
    
    
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
#pragma mark Loading SocialFeeds

- (void)loadSocialFeed
{
    [self.socialActivityIndicator startAnimating];
    [self performSelectorInBackground:@selector(startLoadingSocialFeeds) withObject:nil];
}

-(void)startLoadingSocialFeeds
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweetsLoaded:) name:@"tweetsLoaded" object:nil];
    [Twitter getTweetsFortwitterID:@"Satheeshwaran"];
}

-(void)tweetsLoaded:(NSNotification *)notification
{
    
    [socialFeedsArray addObjectsFromArray:notification.object];
    [self performSelectorOnMainThread:@selector(updateTweets) withObject:nil waitUntilDone:YES];
}


-(void)updateTweets
{
    NSLog(@"Tweets: %@", socialFeedsArray);
    [self.tweetsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    [self.socialActivityIndicator stopAnimating];
    [self.socialActivityIndicator setHidden:YES];
}


/*- (void)animatePersonalDashBoardViews
{
    CGFloat s = 0.10;
    
    CGAffineTransform tr = CGAffineTransformScale(self.userCenterView.transform, s, s);
    self.userCenterView.transform = tr;
    self.trainingView.transform=tr;
    self.interestsView.transform=tr;
    self.goalsView.transform=tr;
    
    self.goalsView.hidden=YES;
    self.trainingView.hidden=YES;
    self.interestsView.hidden=YES;
    
    
    s = 10.0;
    
    tr = CGAffineTransformScale(self.userCenterView.transform, s, s);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.userCenterView.transform = tr;
        //self.loginCircleView.center = self.view.center;
        self.userCenterView.frame=CGRectMake(406, 266, 213, 215);

    }completion:^(BOOL finished)
     {
         self.goalsView.hidden=NO;
         
         [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
             self.goalsView.transform=tr;
             //[self playSound:@"pop" :@"mp3"];

         }completion:^(BOOL goalsViewAnimationStatus)
          {
              self.trainingView.hidden=NO;
              
              [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
              self.trainingView.transform=tr;
             //[self playSound:@"pop" :@"mp3"];

              }completion:^(BOOL goalsViewAnimationStatus)
               {
                   self.interestsView.hidden=NO;
                   
                   
                   [UIView animateWithDuration:0.10 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                       self.interestsView.transform=tr;
                      // [self playSound:@"pop" :@"mp3"];

                   }completion:nil];
                   
               }
               ];
              
          }
          ];
     }
     ];
    
}*/

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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setCarouselView:nil];
    [self setCurrentSelectionView:nil];
    [self setLearningView:nil];
    [self setTweetsTable:nil];
    [self setRssFeedsTable:nil];
    [self setRssLoadingActivity:nil];
    [self setSocialActivityIndicator:nil];
    [self setMandatoryLearningTable:nil];
    [self setRecommendedLearningTable:nil];
    [self setIndustryReportsTable:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return 6;
}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    UIImageView *imageView;
    UILabel *label;
    
    //create new view if no view is available for recycling
    if (view == nil)
	{
        
         view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 215, 215)];
        
        if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
        {
            [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_light.png"]]];
            
        }
        else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
        {
         [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_dark.png"]]];
        }
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(85, 50, 45, 45)];
        imageView.image=[UIImage imageNamed:[self.imagesArray objectAtIndex:index]];
        imageView.tag=10200;
        [view addSubview:imageView];
        
         UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40, 101, 130, 31)];
        [view addSubview:label];
        label.tag=204576;
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont fontWithName:FONT_BOLD size:16];
        label.textColor=[UIColor whiteColor];
        label.text=[self.itemsArray objectAtIndex:index];
        
        }
    
    else
    {
        imageView=(UIImageView *)[view viewWithTag:10200];
        label=(UILabel *)[view viewWithTag:204576];
        imageView.image=[UIImage imageNamed:[self.imagesArray objectAtIndex:index]];
        label.text=[self.itemsArray objectAtIndex:index];
    }
    
    

    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionFadeMin:
            return -0.2;
        case iCarouselOptionFadeMax:
            return 0.2;
        case iCarouselOptionFadeRange:
            return 2.0;

        default:
            return value;
    }
}


- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    
    if(carousel.currentItemIndex == 0 || carousel.currentItemIndex == 3)
    {
        self.goalView.hidden=NO;
        self.interestView.hidden=YES;
        self.learningView.hidden=YES;
    }
    
    if(carousel.currentItemIndex == 1 || carousel.currentItemIndex == 4)
    {
        self.interestView.hidden=NO;
        self.goalView.hidden=YES;
        self.learningView.hidden=YES;

        [self.rssLoadingActivity setHidden:NO];
        [self.socialActivityIndicator setHidden:NO];

        [self.rssLoadingActivity startAnimating];
        
        [self loadSocialFeed];
        [feedParser parse];


    }
    
    if(carousel.currentItemIndex == 2 || carousel.currentItemIndex == 5)
    {
        self.learningView.hidden=NO;
        self.interestView.hidden=YES;
        self.goalView.hidden=YES;
    }
}

#pragma mark -
#pragma mark Parsing

// Reset and reparse
- (void)refresh {
    
	[parsedItems removeAllObjects];
	[feedParser stopParsing];
	[feedParser parse];
	self.rssFeedsTable.userInteractionEnabled = NO;
}

- (void)updateTableWithParsedItems {
	itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
						   [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO] ]];
	self.rssFeedsTable.userInteractionEnabled = YES;
    [self.rssFeedsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.rssLoadingActivity stopAnimating];
    [self.rssLoadingActivity setHidden:YES];
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    if (parsedItems.count == 0) {
        
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                         message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                        delegate:nil
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil] ;
        [alert show];
    }
    [self updateTableWithParsedItems];
}


#pragma mark TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tweetsTable)
        return 80;
    
    else if(tableView == self.rssFeedsTable)
        return 80;
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if(tableView == self.tweetsTable)
        return [socialFeedsArray count];
    
    else if(tableView == self.rssFeedsTable)
        return [itemsToDisplay count];

    else if(tableView == self.mandatoryLearningTable)
        return [[learningDict objectForKey:MANDATORY_LEARNING] count];
    
    else if(tableView == self.recommendedLearningTable)
        return [[learningDict objectForKey:RECOMMENDED_LEARNING] count];
    
    else if(tableView == self.industryReportsTable)
        return [[learningDict objectForKey:INDUSTRY_REPORTS] count];
    
    return 0;
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
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

     if (tableView == self.tweetsTable)
    {
        
        /* if ( indexPath.row %2 ==0)
         {
         cell.imageView.image = [UIImage imageNamed:@"linkedin_user1.png"];
         }
         else
         {
         cell.imageView.image = [UIImage imageNamed:@"linkedin_user2.png"];
         
         }*/
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.imageView setImage:[UIImage imageNamed:@"twitter_loading.png"]];
        [cell.imageView setImageURL:[NSURL URLWithString:[[socialFeedsArray objectAtIndex:indexPath.row] objectForKey:@"profile_image_url"]]];
        
        [cell.imageView.layer setCornerRadius:6.0];
        [cell.imageView.layer setMasksToBounds:YES];
        
        NSLog(@"url: %@",[[socialFeedsArray objectAtIndex:indexPath.row] objectForKey:@"profile_image_url"]);
        UIImageView *SocialImage = [[UIImageView alloc]init];
        SocialImage.frame = CGRectMake(tableView.frame.size.width - 30, 55, 18, 18);
        SocialImage.image = [UIImage imageNamed:@"twitter_icon.png"];
        
        [cell.textLabel setFont:[UIFont fontWithName:FONT_REGULAR size:16]];
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
    
    else if(tableView == self.rssFeedsTable)
    {
        // Configure the cell.
        MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];
        if (item) {
            
            // Process
            NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
            NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
            
            // Set
            [cell.textLabel setFont:[UIFont fontWithName:FONT_REGULAR size:16]];
            [cell.textLabel setTextAlignment:UITextAlignmentLeft];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            cell.textLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
            [cell.textLabel setNumberOfLines:2];
            cell.textLabel.text = itemTitle;
            NSMutableString *subtitle = [NSMutableString string];
            if (item.date) [subtitle appendFormat:@"%@: ", [formatter stringFromDate:item.date]];
            [subtitle appendString:itemSummary];
            [cell.detailTextLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
            cell.detailTextLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
            cell.detailTextLabel.text = subtitle;
    }
}
    
    
    else if (tableView == self.mandatoryLearningTable)
    {
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setFont:[UIFont fontWithName:FONT_REGULAR size:16]];
        [cell.textLabel setTextAlignment:UITextAlignmentLeft];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
        [cell.textLabel setNumberOfLines:2];
        
        cell.textLabel.text = [[learningDict objectForKey:MANDATORY_LEARNING] objectAtIndex:indexPath.row];
        
    }
    
    else if (tableView == self.industryReportsTable)
    {
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setFont:[UIFont fontWithName:FONT_REGULAR size:16]];
        [cell.textLabel setTextAlignment:UITextAlignmentLeft];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
        [cell.textLabel setNumberOfLines:2];
        
        cell.textLabel.text = [[learningDict objectForKey:INDUSTRY_REPORTS] objectAtIndex:indexPath.row];
        
    }
    
    
    else if (tableView == self.recommendedLearningTable)
    {
                
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setFont:[UIFont fontWithName:FONT_REGULAR size:16]];
        [cell.textLabel setTextAlignment:UITextAlignmentLeft];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
        [cell.textLabel setNumberOfLines:2];
        
        cell.textLabel.text = [[learningDict objectForKey:RECOMMENDED_LEARNING] objectAtIndex:indexPath.row];
        
    }
    return cell;

}

#pragma mark TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  if(tableView == self.rssFeedsTable)
  {
      // Show detail
      MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];

      if (item.link) {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.link]];
      }
}
}

@end
