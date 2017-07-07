//
//  LoginViewController.m
//  Pitch
//
//  Created by Divya Vuppala on 03/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "LoginViewController_iPhone.h"
#import "MainViewController_iPhone.h"

@interface LoginViewController_iPhone ()

@end

@implementation LoginViewController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButton:(UIButton *)sender
{
    MainViewController_iPhone *mvc=[[MainViewController_iPhone alloc]initWithNibName:@"MainViewController_iPhone" bundle:nil];
    [self presentViewController:mvc animated:YES completion:nil];
}

@end
