//
//  cispViewController.m
//  iPitch V2
//
//  Created by Krishna Chaitanya on 26/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "InsuranceFirstViewController.h"
#import "iPitchConstants.h"
#import "Utils.h"

@interface InsuranceFirstViewController ()

@end

@implementation InsuranceFirstViewController
@synthesize tableContents, sortedKeys,selectedValues,plistName;

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
    NSString *plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:self.plistName];
    
    self.tableContents=[NSDictionary dictionaryWithContentsOfFile:plistPath];
    
	NSLog(@"table %@",self.tableContents);
	NSLog(@"table with Keys %@",[self.tableContents allKeys]);
    
    self.sortedKeys =  [[self.tableContents allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    self.selectedValues=[[NSMutableArray alloc]init];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table Methods

-(CGFloat)getLabelHeightForIndex:(NSIndexPath *)index
{
    NSArray *listData =[self.tableContents objectForKey:[self.sortedKeys objectAtIndex:[index section]]];
    CGSize maximumSize = CGSizeMake(900, 200);
    CGSize labelHeighSize = [[[listData objectAtIndex:index.row] objectForKey:@"Name"] sizeWithFont: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0f] constrainedToSize:maximumSize];
    // NSLog(@"label size in fn:%f",labelHeighSize.height);
    return labelHeighSize.height;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tempHeight = [self getLabelHeightForIndex:indexPath];
    NSLog(@"tempHeight : %d",tempHeight);
    
    if (tempHeight<=19) {
        return 44;
    }
    
    else{
        return 100;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sortedKeys count];
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44.0)];
    //headerView.contentMode = UIViewContentModeScaleToFill;
    
    // Add the label
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, -5.0, 700, 44)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    
    headerLabel.text = [[self.sortedKeys objectAtIndex:section] substringFromIndex:3];
    
    
    headerLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
    headerLabel.highlightedTextColor = [UIColor blackColor];
    
    //this is what you asked
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18];
    
    headerLabel.shadowColor = [UIColor clearColor];
    headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    headerLabel.numberOfLines = 0;
    [headerView addSubview: headerLabel];
    
    
    // Return the headerView
    return headerView;
}
/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 return [[self.sortedKeys objectAtIndex:section] substringFromIndex:3];
 }*/

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	NSArray *listData =[self.tableContents objectForKey:[self.sortedKeys objectAtIndex:section]];
	return [listData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView setBackgroundView:nil];
    
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	NSArray *listData =[self.tableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]];
	
	UITableViewCell * cell = [tableView
							  dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	if(cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
	NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [NSString stringWithFormat:@" %@",[[listData objectAtIndex:row] objectForKey:@"Name"]];
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14];
    cell.textLabel.textColor=[Utils colorFromHexString:@"868686"];
    
    if ([[[listData objectAtIndex:row] objectForKey:@"Type"] isEqualToString:@"Text"]) {
        UITextField  *tField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 31)];
        tField.borderStyle=UITextBorderStyleRoundedRect;
        [tField setClearButtonMode:UITextFieldViewModeWhileEditing];
        cell.accessoryView = tField ;
        
        return cell;
    }
    
    else     if ([[[listData objectAtIndex:row] objectForKey:@"Type"] isEqualToString:@"Segment"]) {
        UISegmentedControl  *tSegment = [[UISegmentedControl alloc] initWithItems:[[listData objectAtIndex:row] objectForKey:@"Values"]];
        [tSegment setSelectedSegmentIndex:0];
        [tSegment setFrame:CGRectMake(5, 0, 300, 31)];
        cell.accessoryView = tSegment ;
        return cell;
        
    }
    
    else     if ([[[listData objectAtIndex:row] objectForKey:@"Type"] isEqualToString:@"Switch"]) {
        UISwitch  *tSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(5, 0, 280, 31)];
        cell.accessoryView = tSwitch ;
        
        return cell;
    }
    
    else if ([[[listData objectAtIndex:row] objectForKey:@"Type"] isEqualToString:@"CheckBox"]) {
        
        if ([self.selectedValues containsObject:indexPath])
        {
            cell.textLabel.text = [NSString stringWithFormat:@"\u2611 %@",[[listData objectAtIndex:row] objectForKey:@"Name"]];
        }
        
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"\u2B1C %@",[[listData objectAtIndex:row] objectForKey:@"Name"]];
            
        }
        cell.accessoryView=nil;
        return cell;
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //check box to be added.
    
	NSArray *listData =[self.tableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]];
    NSLog(@"listData: %@",listData);
	NSUInteger row = [indexPath row];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if ([[[listData objectAtIndex:row] objectForKey:@"Type"] isEqualToString:@"CheckBox"])
    {
        
        NSLog(@"abc: %@", cell.textLabel.text);
        NSLog(@"data to compare: %@",[[listData objectAtIndex:row] objectForKey:@"Name"]);
        if ([cell.textLabel.text  isEqualToString:[NSString stringWithFormat:@"\u2B1C %@",[[listData objectAtIndex:row] objectForKey:@"Name"] ]])
        {
            
            for (int i=0; i<[listData count]; i++)
            {
                UITableViewCell *cell1=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                cell1.textLabel.text = [NSString stringWithFormat:@"\u2B1C %@",[[listData objectAtIndex:i] objectForKey:@"Name"]];
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"\u2611 %@",[[listData objectAtIndex:row] objectForKey:@"Name"]];
            
            [self.selectedValues removeAllObjects];
            
            if (![self.selectedValues containsObject:indexPath])
                [self.selectedValues addObject:indexPath];
            
        }
        
        else if ([cell.textLabel.text  isEqualToString:[NSString stringWithFormat:@"\u2611 %@",[[listData objectAtIndex:row] objectForKey:@"Name"] ]])
        {
            cell.textLabel.text = [NSString stringWithFormat:@"\u2B1C %@",[[listData objectAtIndex:row] objectForKey:@"Name"]];
            
            if ([self.selectedValues containsObject:indexPath])
                [self.selectedValues removeObject:indexPath];
        }
    }
    
    
}

@end
