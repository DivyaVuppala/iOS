//
//  CalendarViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 2/20/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDayViewController.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "Tasks.h"
#import "Events.h"
#import "CKCalendarView.h"

@interface CalendarViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

{
    SDayViewController *sDayViewController;
    UIViewController * AddToDOEvent;
    UIDatePicker *datePicker;
    UILabel  *datelabel;
    UITextField * TextContentTitle;
    UITextView * TextSubject;
    MBProgressHUD *HUD;
    UIViewController *DetailPopoverController;
    NSMutableArray *TaskArray;
}

@property (nonatomic, retain) SDayViewController *sDayViewController;
@property (weak, nonatomic) IBOutlet UITableView *ToDoListTableView;
@property (weak, nonatomic) IBOutlet UIView *ToDoListView;
@property (nonatomic, strong) IBOutlet UIButton *buttonToggle;
@property (weak, nonatomic) IBOutlet UIButton *addTodoList;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property (strong, nonatomic) Tasks *Task;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property (nonatomic, retain) IBOutlet UIButton *UserIcon;
@property (nonatomic, retain) IBOutlet UIButton *Searchbtn;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalLine;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDoListTitleLabel;
@property (nonatomic, strong) CKCalendarView *calendarWidget;

- (IBAction)addToDoClicked:(id)sender;
- (IBAction)toggleButtonClicked:(id)sender;

@end
