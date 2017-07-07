//
//  LeadsListViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 2/4/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeadsListViewController : UITableViewController


@property (nonatomic,strong) NSMutableArray *tableSource;
@property (retain, nonatomic) NSMutableArray *filteredArray;

@end
