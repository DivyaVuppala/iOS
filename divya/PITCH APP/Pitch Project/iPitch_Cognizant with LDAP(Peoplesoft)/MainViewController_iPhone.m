//
//  MainViewController.m
//  Pitch
//
//  Created by Divya Vuppala on 03/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "MainViewController_iPhone.h"
#import "AccountListTableViewController_iPhone.h"
#import "OpportunityListViewController_iPhone.h"

@interface MainViewController_iPhone ()

@end

@implementation MainViewController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    
    
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(accountsTapped)];
    [self.accountsImageView setUserInteractionEnabled:YES];
    [self.accountsImageView addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contactsTapped)];
    [self.contactsImageView setUserInteractionEnabled:YES];
    [self.contactsImageView addGestureRecognizer:tapGesture2];
    
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(opportunitiesTapped)];
    [self.opportunitiesImageView setUserInteractionEnabled:YES];
    [self.opportunitiesImageView addGestureRecognizer:tapGesture3];
    
    UITapGestureRecognizer *tapGesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reportsTapped)];
    [self.reportsImageView setUserInteractionEnabled:YES];
    [self.reportsImageView addGestureRecognizer:tapGesture4];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)accountsTapped
{
    AccountListTableViewController_iPhone *altvc=[[AccountListTableViewController_iPhone alloc]initWithNibName:@"AccountListTableViewController_iPhone" bundle:nil];
   // UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:altvc];
   // [self presentViewController:navigation animated:YES completion:nil];
    [self.navigationController pushViewController:altvc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)contactsTapped
{
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

-(void)opportunitiesTapped
{
    OpportunityListViewController_iPhone *oltvc=[[OpportunityListViewController_iPhone alloc]initWithNibName:@"AccountListTableViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController:oltvc animated:YES];
}

-(void)reportsTapped
{
    
    NSLog(@"reports Tapped");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutButton:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    

}
@end
