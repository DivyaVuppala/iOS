//
//  AccountsViewController.m
//  HiPitchProject
//
//  Created by priteesh on 03/04/2015.
//  Copyright (c) 2015 priteesh. All rights reserved.
//

#import "DetailAccountViewController_iPhone.h"

@interface DetailAccountViewController_iPhone ()

@end

@implementation DetailAccountViewController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
   [self.mytableview setDelegate:self];
  [self.mytableview setDataSource:self];
   
    self.navigationItem.title=@"Accounts";
    
   // [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    arry=[[NSArray alloc]initWithObjects:@"one",@"two",@"three",@"four", nil];
    SalesForceHelper *sfh=[[SalesForceHelper alloc]init];
    [sfh fetchOpportunitiesForID:@"101036"];
    NSLog(@"%@",((AppDelegate*)SAppDelegateObject).opportunitiesForAccounts);
   
    
    // Json serialization
//    NSString *urlString=[NSString stringWithFormat:@"%@",@"https://pscrmuat.cognizant.com/PSIGW/PeopleSoftServiceListeningConnector/1220983"];
//    
//    NSURL *converted=[NSURL URLWithString:urlString];
//    NSData *data=[NSData dataWithContentsOfURL:converted];
//    NSError *error;
//    NSMutableArray *array=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//    NSLog(@"%@",array);
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.accountIDLabel.text=self.receivedAccountID;
    self.accountNameLabel.text=self.receivedAccountName;
    
}
- (IBAction)AddButtonTapped:(id)sender {
    
    AddOpportunityViewController_iPhone *addOpp=[[AddOpportunityViewController_iPhone alloc]init];
    [self.navigationController pushViewController:addOpp animated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailAccountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"DetailAccountViewCell" bundle:nil] forCellReuseIdentifier:@"mycell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"mycell"];
            }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(DetailAccountViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.labelName.text=[arry objectAtIndex:indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountOpportunityViewController_iPhone *acv=[[AccountOpportunityViewController_iPhone alloc]init];
    [self.navigationController pushViewController:acv animated:YES];
}


@end
