//
//  cispViewController.m
//  iPitch V2
//
//  Created by Krishna Chaitanya on 26/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "cispViewController.h"
#import "iPitchConstants.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>


@interface cispViewController ()
{
    NSMutableArray *currentExpandedSections;
}


@end

@implementation cispViewController
@synthesize plays;

#define DEFAULT_ROW_HEIGHT 88
#define HEADER_HEIGHT 60

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

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
    
    [super viewDidLoad];
    
    NSString *plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:self.plistName];
    
    self.tableContents=[NSDictionary dictionaryWithContentsOfFile:plistPath];
        
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
    
    self.sortedKeys =  [[self.tableContents allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    self.selectedValues=[[NSMutableArray alloc]init];
        
    currentExpandedSections  = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
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
    UIView *headerView=[[[NSBundle mainBundle] loadNibNamed:@"SectionHeaderView" owner:self options:nil] objectAtIndex:0];
    //headerView.contentMode = UIViewContentModeScaleToFill;
    
    CAGradientLayer  *gradient2 = [CAGradientLayer layer];
    CGRect gradientFrame=headerView.frame;
    gradientFrame.size.width=tableView.frame.size.width;
    gradient2.frame = gradientFrame;
    gradient2.colors = [NSArray arrayWithObjects: (id)[[Utils colorFromHexString:WHITE_COLOR_CODE] CGColor],(id)[[Utils colorFromHexString:@"d6d6d6"]  CGColor], nil];
    [headerView.layer insertSublayer:gradient2 atIndex:0];
    
    // Add the label
    UILabel *headerLabel = (UILabel *)[headerView viewWithTag:100];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    
    headerLabel.text = [[self.sortedKeys objectAtIndex:section] substringFromIndex:3];
    
    
    headerLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
    headerLabel.highlightedTextColor = [UIColor blackColor];
    
    //this is what you asked
    headerLabel.font = [UIFont fontWithName:FONT_BOLD size:16];
    
    headerLabel.shadowColor = [UIColor clearColor];
    headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    headerLabel.numberOfLines = 0;
    [headerView addSubview: headerLabel];
    
    UIButton *expandCollapseButton=(UIButton *)[headerView viewWithTag:111];
    [expandCollapseButton addTarget:self action:@selector(sectionExpandClicked:) forControlEvents:UIControlEventTouchUpInside];
    expandCollapseButton.tag=section;

    // Return the headerView
    return headerView;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if([currentExpandedSections containsObject:[NSString stringWithFormat:@"%d",section]])
    {
        
	NSArray *listData =[self.tableContents objectForKey:[self.sortedKeys objectAtIndex:section]];
	return [listData count];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView setBackgroundView:nil];
    
    if([currentExpandedSections
        containsObject:[NSString stringWithFormat:@"%d",indexPath.section]])
    {
        
    
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
        
    }
    
    else     if ([[[listData objectAtIndex:row] objectForKey:@"Type"] isEqualToString:@"Segment"]) {
        UISegmentedControl  *tSegment = [[UISegmentedControl alloc] initWithItems:[[listData objectAtIndex:row] objectForKey:@"Values"]];
        [tSegment setSelectedSegmentIndex:0];
        [tSegment setFrame:CGRectMake(5, 0, 300, 31)];
        cell.accessoryView = tSegment ;
        
    }
    
    else     if ([[[listData objectAtIndex:row] objectForKey:@"Type"] isEqualToString:@"Switch"]) {
        UISwitch  *tSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(5, 0, 280, 31)];
        cell.accessoryView = tSwitch ;
        
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
    }
	return cell;
    }
    
    return nil;
    
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

-(void)sectionExpandClicked:(UIButton *)sender
{
    UIButton *senderButton=(UIButton *)sender;

    NSString *tagStringValue=[NSString stringWithFormat:@"%d",senderButton.tag];
    
    if(![currentExpandedSections containsObject:tagStringValue])
    {
    
        [senderButton setImage:[UIImage imageNamed:@"uparrow.png"] forState:UIControlStateNormal];
        
    if(senderButton.tag < [[self.tableContents allKeys] count])
    {
        [currentExpandedSections addObject:tagStringValue];

        NSArray *listData =[self.tableContents objectForKey:[self.sortedKeys objectAtIndex:senderButton.tag]];
        
        NSMutableArray *rowsToAdd= [[NSMutableArray alloc]init];
        
        for (int i=0;i< [listData count];i++) {
            
            [rowsToAdd addObject:[NSIndexPath indexPathForRow:i inSection:senderButton.tag]];
        }

        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:rowsToAdd withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }

    }
    
    
    else
    {
        
        if([currentExpandedSections containsObject:tagStringValue])
            [currentExpandedSections removeObject:tagStringValue];
                
        [senderButton setImage:[UIImage imageNamed:@"downarrow.png"] forState:UIControlStateNormal];


        if(senderButton.tag < [[self.tableContents allKeys] count])
        {
            NSArray *listData =[self.tableContents objectForKey:[self.sortedKeys objectAtIndex:senderButton.tag]];
            
            NSMutableArray *rowsToDelete= [[NSMutableArray alloc]init];
            
            for (int i=0;i< [listData count];i++) {
                
                [rowsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:senderButton.tag]];
            }
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationTop];
            
            [self.tableView endUpdates];
        }

    }
}

@end
