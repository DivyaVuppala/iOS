//
//  SDayViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 1/25/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Events.h"
#import "CKCalendarView.h"


@interface SDayViewController : UIViewController<CKCalendarDelegate>
{
    NSArray *HOURS_AM_PM;
    NSArray * HOURS_24;
    NSMutableDictionary *sDayTimeSource;
    NSDate *currentDay;
    NSMutableArray *masterEventsArray;
    int selectedIndex1;
}

@property (weak, nonatomic) IBOutlet UITableView *sDayTableView;
@property (weak, nonatomic) IBOutlet UIView *CalenderView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextDayLabel;
@property (strong, nonatomic) Events * events;

-(void)showAddedEvent:(Events *)event;

@end


