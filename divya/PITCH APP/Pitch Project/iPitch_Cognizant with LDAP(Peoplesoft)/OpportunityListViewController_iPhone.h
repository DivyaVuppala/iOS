//
//  OpportunityListViewController.h
//  Pitch
//
//  Created by Divya Vuppala on 08/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iPitchConstants.h"
#import "AppDelegate.h"
#import "Opportunity.h"
#import "AddMyOpportunityViewController_iPhone.h"

@interface OpportunityListViewController_iPhone : UITableViewController
{
    NSMutableArray *opportunitiesArray;
}
@end
