//
//  AccountOpportunityViewController.m
//  HiPitchProject
//
//  Created by priteesh on 03/04/2015.
//  Copyright (c) 2015 priteesh. All rights reserved.
//

#import "AccountOpportunityViewController_iPhone.h"

@interface AccountOpportunityViewController_iPhone ()

@end

@implementation AccountOpportunityViewController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    productGroupArray=[[NSArray alloc]initWithObjects:@"one",@"two",@"three",nil];
    
    self.navigationItem.title=@"Accounts";

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
    return productGroupArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductGroupCustomTableViewCell_iPhone *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ProductGroupCustomTableViewCell_iPhone" bundle:nil] forCellReuseIdentifier:@"mycell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"mycell"];
    }
    
    cell.groupNameLabel.text=[productGroupArray objectAtIndex:indexPath.row];
    return cell;
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(ProductGroupCustomTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell..text=[arry objectAtIndex:indexPath.row];
//}


@end
