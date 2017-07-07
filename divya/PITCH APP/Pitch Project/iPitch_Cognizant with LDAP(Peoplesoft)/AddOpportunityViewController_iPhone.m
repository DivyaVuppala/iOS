//
//  AddOpportunityViewController.m
//  Pitch
//
//  Created by Divya Vuppala on 03/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "AddOpportunityViewController_iPhone.h"
#import "AddProductTableViewCell_iPhone.h"

@interface AddOpportunityViewController_iPhone ()

@end

@implementation AddOpportunityViewController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationItem.title=@"Accounts";
    
    self.productsGroupTableView.delegate=self;
    self.productsGroupTableView.dataSource=self;
    
    UINib *nib=[UINib nibWithNibName:@"AddProductTableViewCell_iPhone" bundle:nil];
    [self.productsGroupTableView registerNib:nib forCellReuseIdentifier:@"productCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddProductTableViewCell_iPhone *cell=[tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
      
    return cell;
}


- (IBAction)addProductButton:(UIButton *)sender
{
    self.addProductView.hidden=NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.addProductView.hidden=YES;
}

@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


