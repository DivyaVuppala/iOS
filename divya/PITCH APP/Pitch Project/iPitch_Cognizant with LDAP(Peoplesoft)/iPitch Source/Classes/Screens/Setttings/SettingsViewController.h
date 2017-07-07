//
//  SettingsViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 2/28/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BoxLoginViewController.h"

#import "BoxCommonUISetup.h"

@interface SettingsViewController : UIViewController<BoxLoginViewControllerDelegate>
{
    BoxLoginViewController * vc;

}
@property (nonatomic,retain) NSMutableDictionary *settingsTableContents;
@property (nonatomic,retain) NSArray *sortedKeys;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end
