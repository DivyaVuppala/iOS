//
//  ReviewClientViewController.m
//  iPitch V2
//
//  Created by Vineet on 26/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "ReviewClientViewController.h"
#import "iPitchConstants.h"
#import "Utils.h"

@interface ReviewClientViewController ()

@end

@implementation ReviewClientViewController
 
@synthesize customerName;
@synthesize customerDesignation;
@synthesize customerOrganization;
@synthesize labelCell=_labelCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [customerName setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [customerName setTextAlignment:UITextAlignmentLeft];
    [customerName setBackgroundColor:[UIColor clearColor]];
    customerName.textColor = [Utils colorFromHexString:@"275d75"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReviewClientCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = currentObject;
                break;
            }
        }
        
    }
    
    if (indexPath.row%2==0)
        cell.contentView.backgroundColor=[Utils colorFromHexString:@"f6f6f6"];
    else
        cell.contentView.backgroundColor=[UIColor whiteColor];

    
    UILabel *label1 = (UILabel *)[cell viewWithTag:100];
    UILabel *label2 = (UILabel *)[cell viewWithTag:101];
    UILabel *label3 = (UILabel *)[cell viewWithTag:102];
    UILabel *label4 = (UILabel *)[cell viewWithTag:103];
    label4.text = @"USD";
    UILabel *label5 = (UILabel *)[cell viewWithTag:104];
    
    
    if (indexPath.row==0) {
        label1.text=@"AC";
        label2.text=@"789746";
        label3.text=@"Dery Dixon projetcs";
        label5.text=@"$978,123,246";
    }
    
    if (indexPath.row==1) {
        label1.text=@"MM";
        label2.text=@"S78964513";
        label3.text=@"10/01/2013 - 20/01/2013";
        label5.text=@"$193,789";
    }
    
    if (indexPath.row==2) {
        label1.text=@"LD";
        label2.text=@"SM1234569";
        label3.text=@"Rick 10/01/2031 - 26/02/2013 ";
        label5.text=@"$300,000";
    }

    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}



@end
