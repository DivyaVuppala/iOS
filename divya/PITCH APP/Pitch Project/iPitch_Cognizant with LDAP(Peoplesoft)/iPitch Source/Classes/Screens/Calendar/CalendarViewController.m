//
//  CalendarViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 2/20/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "CalendarViewController.h"
#import "QuartzCore/CALayer.h"
#import "SWRevealViewController.h"
#import "ModelTrackingClass.h"
#import "Tasks.h"
#import "LandscapeViewController.h"
#import "ZohoHelper.h"
#import "SWRevealViewController.h"
#import "iPitchConstants.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "iPitchAnalytics.h"
#import "ThemeHelper.h"
#import "SalesForceHelper.h"

@interface CalendarViewController ()
{
    NSMutableArray * ToDoListArray;
    UINavigationController *sDayNavigaitonController;
    UIAlertView *toDoDueDateAlert;
    UIButton *selectDateButton;
    
}

@property(nonatomic, strong) NSDateFormatter *dateFormatterWidg;

@end

@implementation CalendarViewController
@synthesize Task;
@synthesize buttonToggle;
@synthesize ToDoListTableView;
@synthesize ToDoListView;
@synthesize toolBarView;
@synthesize sDayViewController;
@synthesize managedObjectContext;
@synthesize Searchbtn;
@synthesize UserIcon;
@synthesize NotificationIcon;
@synthesize horizontalLine;
@synthesize toDoListTitleLabel;
@synthesize titleLabel;
@synthesize calendarWidget;

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
    
    // self.Task=[[Tasks alloc]init];
    // [self.ToDoListTableView registerClass:[SHCTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.titleLabel.text = NSLocalizedString(@"MY_CALENDAR", @"My Calendar");
    self.toDoListTitleLabel.text = NSLocalizedString(@"TO_DO_LIST", @"To Do List");
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEvent:) name:@"EventClickedFromDashboard" object:nil];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Dashboard_bg.png"]];
    
    TaskArray=[[NSMutableArray alloc]init];
    
    self.managedObjectContext=SAppDelegateObject.managedObjectContext;
    
    dispatch_queue_t todo_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(todo_queue, ^{
    
        [self refreshTaskList];

        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [ToDoListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];

        });
    });
    
    
    sDayViewController=[[SDayViewController alloc]initWithNibName:@"SDayViewController" bundle:nil];
    
    sDayNavigaitonController=[[UINavigationController alloc]initWithRootViewController:sDayViewController];
    sDayNavigaitonController.navigationBarHidden=YES;
    [sDayNavigaitonController.view setFrame:CGRectMake(20, 70, 670, 680)];
    
    [sDayNavigaitonController.view.layer setCornerRadius:5];
    
    [ToDoListView.layer setCornerRadius:5];
    [ToDoListTableView.layer setCornerRadius:5];
    
    self.calendarWidget  = [[CKCalendarView alloc] initWithStartDay:startMonday frame:CGRectMake(704, 69, 300, 300)];
    self.calendarWidget.delegate = sDayViewController;
    
    self.dateFormatterWidg = [[NSDateFormatter alloc] init];
    [self.dateFormatterWidg setDateFormat:@"dd/MM/yyyy"];
    
    
    
    //calendar.selectedDate = [self.dateFormatter dateFromString:@"18/07/2012"];
    //calendar.minimumDate = [self.dateFormatter dateFromString:@"09/07/2012"];
    //calendar.maximumDate = [self.dateFormatter dateFromString:@"29/07/2012"];
    self.calendarWidget .shouldFillCalendar = YES;
    self.calendarWidget.adaptHeightToNumberOfWeeksInMonth = NO;
    
    //calendar.frame = CGRectMake(704,109, 300, 280);
    [self.view addSubview:self.calendarWidget];
    
    self.calendarWidget .backgroundColor = [UIColor whiteColor];
    [self.calendarWidget setInnerBorderColor:[UIColor clearColor]];
    
    [self.view addSubview:sDayNavigaitonController.view];
    
    
    //sending notification for Month Calendar widget to change accoring to the current day selected in calendat
    [[NSNotificationCenter defaultCenter] addObserver:self.calendarWidget selector:@selector(dateChangedInSday:) name:@"SDayDateChanged" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}



- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
}

- (void)viewDidUnload {
    [self setAddTodoList:nil];
    [self setToolBarView:nil];
    [self setTitleLabel:nil];
    [self setToDoListTitleLabel:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Calendar"];
    
    SWRevealViewController *revealController = self.revealViewController;
    [buttonToggle addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addGestureRecognizer:revealController.panGestureRecognizer];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [ThemeHelper applyCurrentThemeToView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}


- (BOOL)shouldAutorotate {
    
    return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation  == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"HI");
        return YES;
    }
    return NO;
}


#pragma mark CRM-CoreData Functions

-(void)refreshTaskList
{
    //NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    ToDoListArray =[[NSMutableArray alloc]initWithArray:fetchedObjects];
    
    NSLog(@"todoArray count: %d", [ToDoListArray count]);
}

#pragma mark TO DO List Methods

- (IBAction)addToDoClicked:(id)sender {
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Calendar Screen" withAction:@"Add Task Clicked" withLabel:nil withValue:nil];
    
    AddToDOEvent = [[ LandscapeViewController alloc] init];
    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] init];
    toolBar.frame = CGRectMake(0, 0, 500, 44);
    toolBar.barStyle = UIBarStyleDefault;
    
    // [toolBar sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE",@"Done") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModalVCToDoList)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *CancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CANCEL",@"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModalVCToEvent)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];;
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextAlignment:UITextAlignmentCenter];
    [title setText:NSLocalizedString(@"ADD_TO_DO_ITEM",@"Add To Do Item")];
    
    UIBarButtonItem *titleItem=[[UIBarButtonItem alloc]initWithCustomView:title];
    
    NSArray *barButton  =   [[NSArray alloc] initWithObjects:doneButton,flexibleSpace,titleItem,flexibleSpace,CancelButton, nil];
    [toolBar setItems:barButton];
    
    [AddToDOEvent.view addSubview:toolBar];
    

    //SSimpleCalculator *vc=[[SSimpleCalculator alloc]initWithNibName:@"SSimpleCalculator" bundle:nil];
    
    UIView *sView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 500, 500)];
    sView.backgroundColor=[UIColor whiteColor];
    [ AddToDOEvent.view addSubview: sView];
    
    UILabel * TitleTextContent = [[ UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 15)];
    TitleTextContent.backgroundColor = [UIColor clearColor];
    TitleTextContent.textAlignment= NSTextAlignmentLeft;
    TitleTextContent.text = NSLocalizedString(@"TO_DO_TITLE",@"To Do Title:");
    TitleTextContent.textColor= [UIColor darkGrayColor];
    TitleTextContent.font=[UIFont fontWithName:FONT_BOLD size:16];
    
    TextContentTitle = [[ UITextField alloc] initWithFrame:CGRectMake(20, 45, 460, 31)];
    [sView addSubview: TextContentTitle];
    [sView addSubview: TitleTextContent];
    [TextContentTitle.layer setCornerRadius:5];
    TextContentTitle.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    TextContentTitle.layer.borderWidth= 1.0f;
    TextContentTitle.font=[UIFont fontWithName:FONT_BOLD size:16];

    UILabel * Subject = [[ UILabel alloc] initWithFrame:CGRectMake(20, 95, 100, 15)];
    Subject.backgroundColor = [UIColor clearColor];
    Subject.textColor= [UIColor darkGrayColor];
    Subject.textAlignment= NSTextAlignmentLeft;
    Subject.text =NSLocalizedString(@"SUBJECT", @"Subject:");
    Subject.font=[UIFont fontWithName:FONT_BOLD size:16];
    
    TextSubject = [[ UITextView alloc] initWithFrame:CGRectMake(20, 120, 460, 100)];
    [sView addSubview: TextSubject];
    [sView addSubview: Subject];
    [TextSubject.layer setCornerRadius:5];
    TextSubject.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    TextSubject.layer.borderWidth= 1.0f;
    TextSubject.font=[UIFont fontWithName:FONT_BOLD size:16];
    
    
    
    UILabel *  Date = [[ UILabel alloc] initWithFrame:CGRectMake(20, 275, 150, 15)];
    Date.backgroundColor = [UIColor clearColor];
    Date.textColor= [UIColor darkGrayColor];
    Date.textAlignment= NSTextAlignmentLeft;
    Date.text = NSLocalizedString(@"SELECT_DUE_DATE", @"Select Date :");
    Date.font=[UIFont fontWithName:FONT_BOLD size:16];
    [sView addSubview: Date];
    
    selectDateButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectDateButton setFrame:CGRectMake(200, 260, 250, 40)];
    [selectDateButton setTitle:NSLocalizedString(@"CLICK_TO_CHANGE_DATE", @"Click To Change Date") forState:UIControlStateNormal];
    [selectDateButton setTitleColor:[Utils colorFromHexString:GRAY_COLOR_CODE] forState:UIControlStateNormal];
    [selectDateButton addTarget:self action:@selector(toDoDateSelected) forControlEvents:UIControlEventTouchUpInside];
    [sView addSubview:selectDateButton];
    
    AddToDOEvent.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentModalViewController:AddToDOEvent animated:YES];
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 250, self.view.bounds.size.height/2 - 200, 500, 400);
    r = [self.view convertRect:r toView:AddToDOEvent.view.superview.superview];
    AddToDOEvent.view.superview.frame = r;
    
    
}

- (void)toDoDateSelected
{
    if(datePicker)
        datePicker=nil;
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.frame=CGRectMake(20, 45.0, 240.0, 150.0);
    datePicker.minimumDate=[NSDate date];
    
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setDate:[NSDate date]];
    
    UIView *view = [[datePicker subviews] objectAtIndex:0];
    [view setBackgroundColor:[UIColor clearColor]]; // hide the first and the last subviews
    [[[view subviews] objectAtIndex:0] setHidden:YES];
    [[[view subviews] lastObject] setHidden:YES];
    
    
    toDoDueDateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SELECT_DUE_DATE", @"Select Date :") message:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"Ok") otherButtonTitles:nil];
    toDoDueDateAlert.delegate = self;
    [toDoDueDateAlert addSubview:datePicker];
    [toDoDueDateAlert show];
    
}



-(void)dismissModalVCToDoList
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INTEGRATE_TO", @"Integrate To")
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                                              otherButtonTitles:NSLocalizedString(@"TO_DO_LIST",@"To Do List"),NSLocalizedString(@"CRM_AND_TODO",@"CRM & To Do List") ,nil];
    [alertView show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView==toDoDueDateAlert)
    {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        [selectDateButton setTitle:[df stringFromDate:datePicker.date] forState:UIControlStateNormal];
    }
    else
    {
        
        if(buttonIndex ==1)
        {
            
          if(TextSubject.text.length >0 && TextContentTitle.text.length >0 && ![selectDateButton.titleLabel.text isEqualToString:NSLocalizedString(@"CLICK_TO_CHANGE_DATE", @"Click To Change Date")])
              {
            [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
            [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Calendar Screen" withAction:@"Add Task Locally Clicked" withLabel:nil withValue:nil];
            
            self.Task= [NSEntityDescription
                        insertNewObjectForEntityForName:@"Tasks"
                        inManagedObjectContext:self.managedObjectContext];
            
            self.Task.taskSubject=TextContentTitle.text;
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM/dd/yyyy"];
            
            self.Task.taskDueDate = [df dateFromString:selectDateButton.titleLabel.text];
            self.Task.taskDescription = TextSubject.text;
            self.Task.taskSyncType = [NSNumber numberWithBool:YES];
            
            NSError *error=nil;
            
            if (![self.managedObjectContext save:&error])
            {
                NSLog(@"Sorry, couldn't save Events %@", [error localizedDescription]);
            }
            
            
            
            [self refreshTaskList];
            
            [ToDoListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
            [AddToDOEvent dismissModalViewControllerAnimated:YES];
            }
            
            else
            {
                [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY",  @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            }
            
        }
        else if(buttonIndex ==2)
        {
            if(TextSubject.text.length >0 && TextContentTitle.text.length >0 && ![selectDateButton.titleLabel.text isEqualToString:NSLocalizedString(@"CLICK_TO_CHANGE_DATE", @"Click To Change Date")])
            {
                
            [AddToDOEvent dismissModalViewControllerAnimated:YES];

            [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
            [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Calendar Screen" withAction:@"Add Task To CRM Clicked" withLabel:nil withValue:nil];
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"Adding To Do...";
            
            NSMutableDictionary *taskDetails=[[NSMutableDictionary alloc]init];
            [taskDetails setObject:TextContentTitle.text forKey:ZOHO_DESCRIPTION_PARAMETER];
            [taskDetails setObject:datePicker.date forKey:START_DATE_PARAMTER];
            [taskDetails setObject:TextSubject.text forKey:ZOHO_SUBJECT_PARAMETER];
                
            [self performSelectorInBackground:@selector(AddedTask:) withObject:taskDetails];
                
            }
            
            else
            {
                [Utils showMessage:NSLocalizedString(@"FIELDS_CANNOT_BE_EMPTY",  @"Fields Cannot Be Empty") withTitle:NSLocalizedString(@"ALERT",@"Alert")];
            }
        }
    }
}



-(void)dismissModalVCToEvent
{
    [AddToDOEvent dismissModalViewControllerAnimated:YES];
}


-(void)AddedTask:(NSMutableDictionary *)details{
    
    /*ZohoHelper * zohoAddActivity = [[ZohoHelper alloc]init];
    [zohoAddActivity AddTasksToZoho];
    
    [zoho FetchTasksFromZoho];*/
    
    
    SalesForceHelper *sfdcObject = [[SalesForceHelper alloc]init];
    [sfdcObject addTaskWithDetails:details];
    
    [self refreshTaskList];
    
    NSLog(@"%@:", ToDoListArray);
    
    [self performSelectorOnMainThread:@selector(updateMainThreadAfterAddingToDoItem) withObject:Nil waitUntilDone:YES];
}

-(void)updateMainThreadAfterAddingToDoItem
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [ToDoListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle ];
    
}

-(void)dismissModalVCDetails
{
    
    [DetailPopoverController dismissModalViewControllerAnimated:YES];
}



#pragma mark - Tableview Data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [ToDoListArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell * cell = [tableView
                              dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SimpleTableIdentifier];
        
    }
    
    else
        
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    UIView * BackView = [[ UIView alloc] initWithFrame:CGRectMake(15, 0, 270, 80)];
    
    //  [cell addGestureRecognizer:self.swipeLeftRecognizer];
    // [cell addGestureRecognizer:self.swipeRightRecognizer];
    BackView.backgroundColor = [Utils colorFromHexString:@"f7f7f7"];
    
    UIImageView * Image = [[ UIImageView alloc] initWithFrame:CGRectMake(15, 25, 15, 15)];
    
    
    UIImageView * SeperatorImage = [[ UIImageView alloc] initWithFrame:CGRectMake(215, 15, 15, 15)];
    
    
    UILabel * DetailToDo = [[ UILabel alloc] initWithFrame:CGRectMake(50, 30, 200, 30)];
    DetailToDo.backgroundColor = [ UIColor clearColor];
    
    UILabel * ToDOTitle = [[ UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 16)];
    ToDOTitle.backgroundColor = [ UIColor clearColor];
    
    UILabel * ToDODate = [[ UILabel alloc] initWithFrame:CGRectMake(170, 60, 100, 15)];
    ToDODate.backgroundColor = [ UIColor clearColor];
    
    Tasks * taskobject = [ ToDoListArray objectAtIndex:indexPath.row];
    if ( [taskobject taskTypeRaw] == TaskTypeCall)
    {
        [Image setImage:[UIImage imageNamed:@"call_grey_icon.png"]];
    }
    else if ([taskobject taskTypeRaw] == TaskTypeMeeting)
    {
        [Image setImage:[UIImage imageNamed:@"user_grey_icon.png"]];
    }
    else
    {
        [Image setImage:[UIImage imageNamed:@"user_grey_icon.png"]];
        
    }
    
    if ( [taskobject.taskSyncType boolValue])
    {
        BackView.backgroundColor = [Utils colorFromHexString:@"eaeaea"];
    }
    else
    {
        BackView.backgroundColor = [Utils colorFromHexString:@"d4d4d4"];
    }
    
    //    Tasks * taskobject0 = [ ToDoListArray objectAtIndex:0];
    //     NSLog(@"%@:", taskobject0.Tasksubject);
    //    Tasks * taskobject1 = [ ToDoListArray objectAtIndex:1];
    //    NSLog(@"%@:", taskobject1.Tasksubject);
    
    
    ToDOTitle.text = taskobject.taskSubject;
    
    [ToDOTitle setTextAlignment:NSTextAlignmentLeft];
    ToDOTitle.font=[UIFont fontWithName:FONT_BOLD size:14];
    ToDOTitle.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    DetailToDo.text = taskobject.taskDescription;
    DetailToDo.textColor = [Utils colorFromHexString:@"6d6c6c"];
    [DetailToDo setTextAlignment:NSTextAlignmentLeft];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
    ToDODate.text= [dateFormatter stringFromDate:taskobject.taskDueDate];
    
    ToDODate.textColor = [Utils colorFromHexString:@"6d6c6c"];
    [ToDODate setTextAlignment:NSTextAlignmentLeft];
    ToDODate.font=[UIFont fontWithName:FONT_REGULAR size:12];
    [DetailToDo setNumberOfLines:0];
    [ BackView addSubview:DetailToDo];
    [BackView addSubview:ToDOTitle];
    [BackView addSubview:ToDODate];
    [BackView addSubview:Image];
    [BackView addSubview:SeperatorImage];
    [BackView.layer setCornerRadius:5];
    [cell.contentView addSubview:BackView];
    DetailToDo.font=[UIFont fontWithName:FONT_REGULAR size:14];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - Tableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Calendar Screen" withAction:@"Show Task Details Clicked" withLabel:nil withValue:nil];
    DetailPopoverController = [[ LandscapeViewController alloc] init];
    [DetailPopoverController.view.layer setCornerRadius:5];
    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] init];
    toolBar.frame = CGRectMake(0, 0, 500, 44);
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CLOSE",@"Close") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModalVCDetails)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];;
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextAlignment:UITextAlignmentCenter];
    [title setText:NSLocalizedString(@"TO_DO_DETAILS",@"To Do Details")];
    
    UIBarButtonItem *titleItem=[[UIBarButtonItem alloc]initWithCustomView:title];
    
    NSArray *barButton  =   [[NSArray alloc] initWithObjects:doneButton,flexibleSpace,titleItem,flexibleSpace, nil];
    [toolBar setItems:barButton];
    
       
    [DetailPopoverController.view addSubview:toolBar];
    DetailPopoverController.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentModalViewController:DetailPopoverController animated:YES];
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 250, self.view.bounds.size.height/2 - 150, 500, 300);
    r = [self.view convertRect:r toView:DetailPopoverController.view.superview.superview];
    DetailPopoverController.view.superview.frame = r;
    
    UIView *sView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 500, 300)];
    sView.backgroundColor=[UIColor whiteColor];
    [DetailPopoverController.view addSubview: sView];
    [DetailPopoverController.view.layer setCornerRadius:5];
    
    Tasks * task = [ ToDoListArray objectAtIndex:indexPath.row];
    
    UILabel * Date = [[ UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 30)];
    Date.backgroundColor = [UIColor clearColor];
    Date.textColor= [UIColor blackColor];
    Date.textAlignment= NSTextAlignmentLeft;
    Date.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"DATE", @"Date")];
    Date.font=[UIFont fontWithName:FONT_BOLD size:16];
    
    UILabel * dateValue = [[ UILabel alloc] initWithFrame:CGRectMake(200, 20, 200, 30)];
    dateValue.backgroundColor = [UIColor clearColor];
    dateValue.textColor= [UIColor blackColor];
    dateValue.textAlignment= NSTextAlignmentLeft;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
   	[df setDateFormat:@"MM/dd/yyyy"];
    dateValue.text = [NSString stringWithFormat:@"%@",[df stringFromDate:task.taskDueDate]];
    dateValue.font=[UIFont fontWithName:FONT_REGULAR size:14];
    
    UILabel * TitleText = [[ UILabel alloc] initWithFrame:CGRectMake(20, 120, 100, 30)];
    TitleText.backgroundColor = [UIColor clearColor];
    TitleText.textAlignment= NSTextAlignmentLeft;
    TitleText.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"TITLE", @"Title")];
    TitleText.textColor= [UIColor blackColor];
    TitleText.font=[UIFont fontWithName:FONT_BOLD size:16];
    
    
    UILabel * titleValue = [[ UILabel alloc] initWithFrame:CGRectMake(200, 120, 200, 100)];
    titleValue.backgroundColor = [UIColor clearColor];
    titleValue.textAlignment= NSTextAlignmentLeft;
    titleValue.text = [NSString stringWithFormat:@"  %@",task.taskSubject];
    titleValue.textColor= [UIColor blackColor];
    titleValue.baselineAdjustment=UIBaselineAdjustmentNone;
    titleValue.font=[UIFont fontWithName:FONT_REGULAR size:14];
    titleValue.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    titleValue.layer.borderWidth=2;
    titleValue.layer.cornerRadius=6.f;

    
    UILabel * SubjectDetails = [[ UILabel alloc] initWithFrame:CGRectMake(20, 70, 100, 30)];
    SubjectDetails.backgroundColor = [UIColor clearColor];
    SubjectDetails.textColor= [UIColor blackColor];
    SubjectDetails.textAlignment= NSTextAlignmentLeft;
    SubjectDetails.text =[NSString stringWithFormat:@"%@:",NSLocalizedString(@"SUBJECT", @"Subject")];
    SubjectDetails.font=[UIFont fontWithName:FONT_BOLD size:16];
    SubjectDetails.numberOfLines=0;

    
    
    
    UILabel * subjectTextLabel = [[ UILabel alloc] initWithFrame:CGRectMake(200, 70, 200, 30)];
    subjectTextLabel.backgroundColor = [UIColor clearColor];
    subjectTextLabel.textColor= [UIColor blackColor];
    subjectTextLabel.textAlignment= NSTextAlignmentLeft;
    subjectTextLabel.text = [NSString stringWithFormat:@"  %@",task.taskDescription];;
    subjectTextLabel.font=[UIFont fontWithName:FONT_REGULAR size:14];
    subjectTextLabel.numberOfLines=0;
    subjectTextLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    subjectTextLabel.layer.borderWidth=2;
    subjectTextLabel.layer.cornerRadius=6.f;

    [sView addSubview: TitleText];
    [sView addSubview: Date];
    [sView addSubview: SubjectDetails];
    [sView addSubview: dateValue];
    [sView addSubview: subjectTextLabel];
    [sView addSubview: titleValue];
    
}


#pragma mark Custom UI Methods

-(void)segmentedControlChangedValue:(id)sender
{
    
}

-(void)showEvent:(NSNotification *)notification
{
    [sDayViewController showAddedEvent:(Events *)notification.object];
}

- (IBAction)toggleButtonClicked:(id)sender {
}
@end
