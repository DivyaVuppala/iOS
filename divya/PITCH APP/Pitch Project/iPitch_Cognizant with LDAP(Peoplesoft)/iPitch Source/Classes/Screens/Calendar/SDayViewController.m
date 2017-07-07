//
//  SDayViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 1/25/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "SDayViewController.h"
#import "SDayViewCell.h"
#import "SNSDateUtils.h"
#import "Events.h"
#import "AppDelegate.h"
#import "LocalFilesViewController.h"
#import "LoginViewController.h"
#import "AddEventViewController.h"
#import "AddedEventViewController.h"
#import "ModelTrackingClass.h"
#import "QuartzCore/CALayer.h"
#import "iPitchConstants.h"
#import "Utils.h"
#import "iPitchAnalytics.h"

@interface SDayViewController ()
@property (readonly) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (readonly) UISwipeGestureRecognizer *swipeRightRecognizer;
@end

@implementation SDayViewController
@synthesize swipeLeftRecognizer=_swipeLeftRecognizer;
@synthesize swipeRightRecognizer=_swipeRightRecognizer;
@synthesize sDayTableView;
@synthesize dateLabel;
@synthesize nextDayLabel;
@synthesize CalenderView;
@synthesize events;

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

NSMutableArray * eventArray;
NSMutableArray *FinalHourArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedIndex1 = -1;

    masterEventsArray =[[NSMutableArray alloc]init];
    
    
   // [masterEventsArray addObjectsFromArray:[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"MasterEventsArray"]];
    eventArray = [[NSMutableArray alloc] init];
    HOURS_AM_PM=[[NSArray alloc]  initWithObjects: @"0" ,@"1" ,@"2" ,@"3" ,@"4" ,@"5" ,@"6" ,@"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", nil];
    
    HOURS_24=[[NSArray alloc]  initWithObjects: @" 0:00", @" 1:00", @" 2:00", @" 3:00",@" 8:00", @" 4:00", @" 5:00", @" 6:00",@" 7:00",@" 8:00", @" 9:00", @" 10:00", @" 11:00",@" 12:00", @" 13:00", @" 14:00", @" 15:00", @" 16:00", @" 17:00", @" 18:00",@" 19:00",@" 20:00",@" 21:00",@" 22:00",@" 23:00", nil];
    
    sDayTimeSource=[[NSMutableDictionary alloc]init];
    
    
    [self.view.layer setCornerRadius:5];
    [CalenderView.layer setCornerRadius:5];
    [sDayTableView.layer setCornerRadius:5];
    
    if ([[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"currentDay"] != nil)
    {
        currentDay = [[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"currentDay"];
        [[ModelTrackingClass sharedInstance] removeModelObjectForKey:@"currentDay"];
    }
    else
    currentDay=[[NSDate alloc]init];

    [self setUpDateLabelForDate:currentDay];
    [self addEventsToTimeSource];
    [self getEventsForCurrentDate];
    
    
    [self.view addGestureRecognizer:self.swipeLeftRecognizer];
    [self.view addGestureRecognizer:self.swipeRightRecognizer];
    
    self.sDayTableView.separatorColor=[UIColor lightGrayColor];
    //see this lateer
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SDayDateChanged" object:currentDay];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload {
    [self setSDayTableView:nil];
    [self setDateLabel:nil];
    [self setNextDayLabel:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //[self addEventsToTimeSource];
    [self getEventsForCurrentDate];

    [sDayTableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

#pragma mark Calendar Support Methods

-(void)addEventsToTimeSource
{
       
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Events"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [masterEventsArray addObjectsFromArray:fetchedObjects];
    //NSLog(@"masterEventsArray:%@", masterEventsArray);
    
}

-(void)setUpDateLabelForDate:(NSDate *)date
{
    NSDateFormatter *dateForamtter=[[NSDateFormatter alloc]init];
    [dateForamtter setDateFormat:@"dd-MMM-yy"];
    
    self.dateLabel.text=[NSString stringWithFormat:@"%@ %@",[dateForamtter stringFromDate:date],[SNSDateUtils dayNameForWeekDay:[[SNSDateUtils componentsForDate:date] weekday]]];
    
    self.nextDayLabel.text=[NSString stringWithFormat:@"%d",[[SNSDateUtils componentsForDate:[SNSDateUtils date:date ByAddingDays:1]] day]];
}
-(void)getEventsForCurrentDate
{
    
    NSMutableArray * interVal=[[NSMutableArray alloc]init];
    
    [eventArray removeAllObjects];
    [sDayTimeSource removeAllObjects];
    
    [masterEventsArray removeAllObjects];
    //[masterEventsArray addObjectsFromArray:[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"MasterEventsArray"]];
    [self addEventsToTimeSource];
    for (int i=0; i<[masterEventsArray count]; i++) {
        Events *evnt=(Events *)[masterEventsArray objectAtIndex:i];
                
        if ( [SNSDateUtils date:currentDay IsEqualTo:evnt.eventStartDate]) {
            
            [eventArray addObject:evnt];
            
            [sDayTimeSource setObject:evnt forKey:[NSString stringWithFormat:@"%d", [[SNSDateUtils componentsForDate:evnt.eventStartDate ] hour]]];
            
        }
    }
    
    NSMutableArray *NewArray = [[NSMutableArray alloc]init];
    
    for ( int j=0;j<[eventArray count];j++)
    {
        Events * Object = (Events *) [eventArray objectAtIndex:j];
        
        [interVal addObject: [NSString stringWithFormat:@"%d",[[SNSDateUtils componentsForDate:Object.eventEndDate] hour]-[[SNSDateUtils componentsForDate:Object.eventStartDate] hour]]];
    }
    
    for (int i=0; i< [HOURS_AM_PM count];i++)
    {
        for ( int j=0;j<[eventArray count];j++)
        {
            Events * Object = (Events *) [eventArray objectAtIndex:j];
            
            if ([[HOURS_AM_PM objectAtIndex:i]intValue]==[[SNSDateUtils componentsForDate:Object.eventStartDate] hour]) {
                
                
                for ( int k=[[HOURS_AM_PM objectAtIndex:i]intValue];k<[[HOURS_AM_PM objectAtIndex:i]intValue]+[[interVal objectAtIndex:j]intValue]-1;k++)
                    
                {
                    NSLog(@"index: %d",1+i+k-[[HOURS_AM_PM objectAtIndex:i]intValue] );
                    int index=1+i+k-[[HOURS_AM_PM objectAtIndex:i]intValue];
                    if(index < [HOURS_AM_PM count])
                    {
                    [NewArray addObject:[HOURS_AM_PM objectAtIndex:1+i+k-[[HOURS_AM_PM objectAtIndex:i]intValue]]];
                    }
                }
                
            }
            
        }
    }
    
    [FinalHourArray removeAllObjects];
    FinalHourArray = [NSMutableArray arrayWithArray:HOURS_AM_PM];
    [FinalHourArray removeObjectsInArray:NewArray];
    
    
}
-(void)showAddedEvent:(Events *)event
{
    [self performSelector:@selector(showAddedVC:) withObject:event afterDelay:0.20];
}

-(void)showAddedVC:(Events *)event
{
    AddedEventViewController *showEventVC=[[AddedEventViewController alloc]initWithNibName:@"AddedEventViewController" bundle:nil];
    
    NSManagedObjectID *customerID=event.objectID ;
    showEventVC.eventID=customerID;
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [self.navigationController pushViewController:showEventVC animated:NO];
    [UIView setAnimationDuration:0.50];
    [UIView commitAnimations];
    
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==1)
    {
    if(selectedIndex1 == indexPath.row)
    {
        return 250;
    }
    return 60;
    }
  

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag ==1)
    {
       return [FinalHourArray count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==1)
    {
    static NSString *CellIdentifier = @"Cell";
    SDayViewCell *cell = (SDayViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SDayViewCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (SDayViewCell *)currentObject;
                break;
            }
        }
        
    }
    
    else
        
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    [cell.DetailButton addTarget:self action:@selector(expandCell:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
        if ([[FinalHourArray objectAtIndex:indexPath.row] intValue]<=9) {
            cell.timeOfDay.text= [NSString stringWithFormat:@"0%@%@",[FinalHourArray objectAtIndex:indexPath.row], @":00"];
            cell.timeOfDay.textColor= [ UIColor colorWithWhite:0 alpha:0.6];
            
        }
        else
            
            cell.timeOfDay.text= [NSString stringWithFormat:@"%@%@",[FinalHourArray objectAtIndex:indexPath.row], @":00"];
        cell.timeOfDay.textColor= [ UIColor colorWithWhite:0 alpha:0.6];
        

    
        
    for ( int k =0; k<[FinalHourArray count]; k++)
    {
        
        Events *event=[sDayTimeSource objectForKey:[FinalHourArray objectAtIndex:k]];
        if ( [[NSString stringWithFormat:@"%d" ,[[SNSDateUtils componentsForDate:event.eventStartDate] hour] ]isEqualToString:  [FinalHourArray objectAtIndex:indexPath.row]])
        {
            NSLog(@"title: %@",event.eventTitle);
            
            if ([Events isValidEvent:event]) {
                
                if (selectedIndex1 == indexPath.row)
                {
                    cell.CellDocumentsView.hidden = NO;
                    cell.PastAppointmentsView.hidden = NO;
                    
                    
                    [cell.addDocumentButton addTarget:self action:@selector(addDocuments:) forControlEvents: UIControlEventTouchUpInside];
                    
                    for(int i=0;i<[[event.filesTaggedToEvent allObjects]
                                   count];i++)
                    {
                        File *sFile=(File *)[[event.filesTaggedToEvent allObjects] objectAtIndex:i];
                        UIView *sView=[[UIView alloc]initWithFrame:CGRectMake(10+ 100 *i, 10, 80, 80)];
                        sView.backgroundColor=[UIColor whiteColor];
                        UIImageView *sFileIcon=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
                        
                        sFileIcon.image=[UIImage imageNamed:@"pdf"];
                        
                        [sView addSubview:sFileIcon];
                        
                        
                        UILabel *sFileNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 80, 20)];
                        sFileNameLabel.text=sFile.fileName;
                        sFileNameLabel.backgroundColor=[UIColor clearColor];
                        sFileNameLabel.textColor=[UIColor blackColor];
                        [sView addSubview:sFileNameLabel];
                        
                        
                        [cell.lblScrollDocuments addSubview:sView];
                        [cell.lblScrollDocuments setContentSize:CGSizeMake([[event.filesTaggedToEvent allObjects] count] * 100, 0)];
                        
                    }
                    
                    
                }
                else
                {
                    cell.CellDocumentsView.hidden = YES;
                    cell.PastAppointmentsView.hidden = YES;
                }
                if ([[FinalHourArray objectAtIndex:indexPath.row] intValue]<=9) {
                    cell.timeOfDay.text= [NSString stringWithFormat:@"0%@%@",[FinalHourArray objectAtIndex:indexPath.row], @":00"];
                    cell.timeOfDay.textColor= [ UIColor colorWithWhite:0 alpha:0.6];
                    
                }
                else
                    
                    cell.timeOfDay.text= [NSString stringWithFormat:@"%@%@",[FinalHourArray objectAtIndex:indexPath.row], @":00"];
                
                cell.timeOfDay.textColor= [ UIColor colorWithWhite:0 alpha:0.6];
                cell.appointmentTitle.hidden=NO;
                cell.AppointmenteventVenue.hidden=NO;
                cell.appointmentIcon.hidden=NO;
                cell.DetailButton.hidden = YES;
                cell.BackGroundViewEvent.hidden=NO;
                
               
                if( ![event.eventSyncStatus boolValue])
                {
                    cell.BackGroundViewEvent.backgroundColor = [Utils colorFromHexString:@"ffebde"];
                }
                else 
                {
                    cell.BackGroundViewEvent.backgroundColor = [Utils colorFromHexString:@"effcff"];
                }
                
                cell.appointmentTime.hidden = NO;
                cell.DetailButton.tag = indexPath.row;
                cell.appointmentTitle.text=event.eventTitle;
                cell.AppointmenteventVenue.text=event.eventVenue;
                cell.appointmentTime.text = [NSString stringWithFormat:@"%@-%@",[SNSDateUtils timeFromNSDate:event.eventStartDate],[SNSDateUtils timeFromNSDate:event.eventEndDate]];
                NSLog(@"event Purpose: %@",event.eventVenue);
                
                if ( [event eventTypeRaw] == EventTypeCall)
                { cell.appointmentIcon.image =[UIImage imageNamed:@"call_grey_icon.png"];
                }
                else if ( [event eventTypeRaw] == EventTypeMeeting)
                { cell.appointmentIcon.image =[UIImage imageNamed:@"user_grey_icon.png"];
                }
                else
                { cell.appointmentIcon.image =[UIImage imageNamed:@"user_grey_icon.png"];
                }
                backgroundView.backgroundColor = [UIColor clearColor];
            }
            
                        cell.backgroundView = backgroundView;
        }
    }
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
    }
    
    return nil;
}

#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( tableView.tag==1)
    {
        Events *event=[sDayTimeSource objectForKey:[FinalHourArray objectAtIndex:indexPath.row]];
        NSLog(@"event: %@",event);
        if (![Events isValidEvent:event])
        {
            [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
            
            [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Calendar Screen" withAction:@"Add New Event Clicked" withLabel:nil withValue:nil];
            
            AddEventViewController *addEventVC=[[AddEventViewController alloc]initWithNibName:@"AddEventViewController" bundle:nil];
            
            NSString *CurrHourString=@"";
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init]; [dateFormatter1 setDateFormat:@"yyyy-MMM-dd"];
            
            if([[FinalHourArray objectAtIndex:indexPath.row] intValue] <= 9) { CurrHourString = [NSString stringWithFormat:@"%@ 0%@:00",[dateFormatter1 stringFromDate: [SNSDateUtils dateWithOutTime:currentDay] ] ,[FinalHourArray objectAtIndex:indexPath.row]]; }
            else { CurrHourString = [NSString stringWithFormat:@"%@ %@:00",[dateFormatter1 stringFromDate: [SNSDateUtils dateWithOutTime:currentDay] ] ,[FinalHourArray objectAtIndex:indexPath.row]]; }
            
            NSLog(@"CurrHour: %@", CurrHourString); [dateFormatter1 setDateFormat:@"yyyy-MMM-dd HH:mm"];
            addEventVC.eventDate = [dateFormatter1 dateFromString:CurrHourString];
            [UIView beginAnimations:@"animation" context:nil];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
            [self.navigationController pushViewController:addEventVC animated:NO];
            [UIView setAnimationDuration:0.50];
            [UIView commitAnimations];
            
        }
        
        else {
            
            
            AddedEventViewController *showEventVC=[[AddedEventViewController alloc]initWithNibName:@"AddedEventViewController" bundle:nil];
            
            NSManagedObjectID *customerID=((Events *)[sDayTimeSource objectForKey:[FinalHourArray objectAtIndex:indexPath.row]]).objectID ;
            [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
            
            [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Calendar Screen" withAction:@"Added Event Clicked" withLabel:event.eventTitle withValue:nil];
            
            showEventVC.eventID=customerID;
            
            //showEventVC.event=event;
            [UIView beginAnimations:@"animation" context:nil];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
            [self.navigationController pushViewController:showEventVC animated:NO];
            [UIView setAnimationDuration:0.50];
            [UIView commitAnimations];
            
            UIButton * dummyButton = [[UIButton alloc] init];
            dummyButton.tag = indexPath.row;
            //[self expandCell:dummyButton];
            return;
            
            /*  UIButton * dummyButton = [[UIButton alloc] init];
             dummyButton.tag = indexPath.row;
             [self expandCell:dummyButton];
             return;*/
        }
        //SAppDelegateObject.viewController.stackVC
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.sDayTableView reloadData];
    }
}

-(void)expandCell:(id)sender
{
    UIButton *temp=(UIButton*)sender;
    NSIndexPath *index=[NSIndexPath indexPathForRow:temp.tag inSection:0];
    
    if(selectedIndex1 == index.row)
    {
        selectedIndex1 = -1;
        [[self sDayTableView] beginUpdates];
        [sDayTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
        [[self sDayTableView] endUpdates];
        
        return;
    }
    
    if(selectedIndex1 >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex1 inSection:0];
        selectedIndex1 = index.row;
        [[self sDayTableView] beginUpdates];
        [sDayTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
        [[self sDayTableView] endUpdates];
    }
    
    selectedIndex1 = index.row;
    
    
    
    [[self sDayTableView] beginUpdates];
    [sDayTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
    [[self sDayTableView] endUpdates];
}

#pragma mark Documents Support Methods

- (IBAction)addDocuments:(id)sender {
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentsAddedToEvent:) name:@"FilesAddedToEvent" object:nil];
//    
//    LocalFilesViewController *vc=[[LocalFilesViewController alloc]initWithNibName:@"LocalFilesViewController" bundle:nil];
//        
//    UINavigationController *navForFileBrowser=[[UINavigationController alloc]initWithRootViewController:vc];
//    
//    [SAppDelegateObject.viewController.navigationController pushViewController:navForFileBrowser fromViewController:self animated:YES];
    
}


-(void)documentsAddedToEvent:(NSNotification *)notification
{
    
    SDayViewCell *cell=(SDayViewCell*)[sDayTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex1 inSection:0]];

    for (UIView *sView in [cell.lblScrollDocuments subviews]) {
        if (![sView isKindOfClass:[UIImageView class ]]) {
            [sView removeFromSuperview];
        }
    }
    
    Events *eventDocs=[sDayTimeSource objectForKey:[FinalHourArray objectAtIndex:selectedIndex1]];
    
    if (![File fileWithPath:((File *)notification.object).filePath IsInArray:[eventDocs.filesTaggedToEvent allObjects]])
        [eventDocs addFilesTaggedToEventObject:(File *)notification.object];
    NSLog(@"doc array: %@",[eventDocs.filesTaggedToEvent allObjects]);
    for(int i=0;i<[[eventDocs.filesTaggedToEvent allObjects] count];i++)
    {
        File *sFile=(File *)[[eventDocs.filesTaggedToEvent allObjects] objectAtIndex:i];
        UIView *sView=[[UIView alloc]initWithFrame:CGRectMake(10+ 100 *i, 10, 80, 80)];
        
        UIImageView *sFileIcon=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        
        sFileIcon.image=[UIImage imageNamed:@"pdf"];
        
        [sView addSubview:sFileIcon];
        
        
        UILabel *sFileNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 80, 20)];
        sFileNameLabel.text=sFile.fileName;
        sFileNameLabel.font=[UIFont fontWithName:FONT_BOLD size:14];
        [sView addSubview:sFileNameLabel];
        
        
        
        [cell.lblScrollDocuments addSubview:sView];
        [cell.lblScrollDocuments setContentSize:CGSizeMake([[eventDocs.filesTaggedToEvent allObjects] count] * 100, 0)];
        
    }
    
    
}


#pragma mark Gesture Initialization

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
    selectedIndex1 = -1;
    NSLog(@"current Day: %@",currentDay);
	if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        currentDay=[SNSDateUtils nextDayFromDate:currentDay];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
        NSString *dateText = [dateFormatter2 stringFromDate:currentDay];
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Calendar Screen" withAction:@"Day Changed" withLabel:dateText withValue:nil];
        [self setUpDateLabelForDate:currentDay];
        [self getEventsForCurrentDate];
        [self.sDayTableView reloadData];
        
        //notifying the month calendar to change selected date according to the current date selected
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SDayDateChanged" object:currentDay];

	}
    else  if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        currentDay=[SNSDateUtils previousDayFromDate:currentDay];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; 
        NSString *dateText = [dateFormatter2 stringFromDate:currentDay];
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Calendar Screen" withAction:@"Day Changed" withLabel:dateText withValue:nil];
        [self setUpDateLabelForDate:currentDay];
        [self getEventsForCurrentDate];
        [self.sDayTableView reloadData];

        //notifying the month calendar to change selected date according to the current date selected
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SDayDateChanged" object:currentDay];
	}

    [self.sDayTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


#pragma mark Custom UI Methods

-(void)segmentedControlChangedValue:(id)sender
{
    
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {  
    
    currentDay=date;
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    
    [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; 
    NSString *dateText = [dateFormatter2 stringFromDate:currentDay];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Calendar Screen" withAction:@"Day Changed" withLabel:dateText withValue:nil];
    
    [self setUpDateLabelForDate:currentDay];
    [self getEventsForCurrentDate];
    [self.sDayTableView reloadData];

}

@end
