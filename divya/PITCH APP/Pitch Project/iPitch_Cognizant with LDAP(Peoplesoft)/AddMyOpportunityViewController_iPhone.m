//
//  AddMyOpportunityViewController.m
//  iPitch V2
//
//  Created by Divya Vuppala on 10/04/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "AddMyOpportunityViewController_iPhone.h"
#import "AddProductTableViewCell_iPhone.h"

@interface AddMyOpportunityViewController_iPhone ()

@end

@implementation AddMyOpportunityViewController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.addProductTableView.delegate=self;
    self.addProductTableView.dataSource=self;
    
    UINib *nib=[UINib nibWithNibName:@"AddProductTableViewCell_iPhone" bundle:nil];
    [self.addProductTableView registerNib:nib forCellReuseIdentifier:@"productCell"];
    
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

- (IBAction)addProductButton:(UIButton *)sender
{
    self.addProductGroupView.hidden=NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.addProductGroupView.hidden=YES;
}
@end
