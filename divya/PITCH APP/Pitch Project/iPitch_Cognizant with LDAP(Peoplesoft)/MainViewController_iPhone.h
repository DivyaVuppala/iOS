//
//  MainViewController.h
//  Pitch
//
//  Created by Divya Vuppala on 03/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController_iPhone : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *accountsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contactsImageView;

@property (weak, nonatomic) IBOutlet UIImageView *opportunitiesImageView;
@property (weak, nonatomic) IBOutlet UIImageView *reportsImageView;
- (IBAction)logoutButton:(UIButton *)sender;

@end
