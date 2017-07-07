
#import "kYCController.h"
#import "Utils.h"
#import "iPitchConstants.h"

@implementation kYCController
@synthesize tableContents;
@synthesize sortedKeys;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


//@"\u2611", @"\u2B1C", @"\u2705", @"\u26AB", @"\u26AA", @"\u2714", @"\U0001F44D", @"\U0001F44E"


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	//NSDictionary *temp =[[NSDictionary alloc]initWithObjectsAndKeys:@"A",@"A",@"A",@"B",@"A",@"c",nil];
    
    NSString *plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"BFS_Questions.plist"];
    
    self.tableContents=[NSDictionary dictionaryWithContentsOfFile:plistPath];
    
	NSLog(@"table %@",self.tableContents);
	NSLog(@"table with Keys %@",[self.tableContents allKeys]);
    
    self.sortedKeys =  [[self.tableContents allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];

	//self.sortedKeys =[[self.tableContents allKeys] sortedArrayUsingSelector:@selector(compare:)];
	NSLog(@"sorted %@",self.sortedKeys);
    [super viewDidLoad];
}



// Override to allow orientations other than the default portrait orientation.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table Methods

-(CGFloat)getLabelHeightForIndex:(NSIndexPath *)index
{
    NSArray *listData =[self.tableContents objectForKey:[self.sortedKeys objectAtIndex:[index section]]];
    CGSize maximumSize = CGSizeMake(900, 200);
    CGSize labelHeighSize = [[listData objectAtIndex:index.row] sizeWithFont: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0f] constrainedToSize:maximumSize];
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
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44.0)];
        //headerView.contentMode = UIViewContentModeScaleToFill;
        
        // Add the label
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, -5.0, 300.0, 44)];
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
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setBackgroundView:nil];

	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	NSArray *listData =[self.tableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]];
	
	UITableViewCell * cell = [tableView 
							  dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	if(cell == nil) {
		
		 cell = [[UITableViewCell alloc] 
		 initWithStyle:UITableViewCellStyleDefault 
		 reuseIdentifier:SimpleTableIdentifier];
		 
		
		/*cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:SimpleTableIdentifier] autorelease];
		*/
	}
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
	NSUInteger row = [indexPath row];
	cell.textLabel.numberOfLines=0;
    cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14];
    cell.textLabel.textColor=[Utils colorFromHexString:@"868686"];

    if (indexPath.row==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"\u2611 %@",[listData objectAtIndex:row]];

    }
    
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"\u2B1C %@",[listData objectAtIndex:row]];

    }
    //\u2B1C
	return cell;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSArray *listData =[self.tableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]];
	NSUInteger row = [indexPath row];
       
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:[NSString stringWithFormat:@"\u2B1C %@",[listData objectAtIndex:row]]]) {
        cell.textLabel.text = [NSString stringWithFormat:@"\u2611 %@",[listData objectAtIndex:row]];
    }
    
    else  if ([cell.textLabel.text isEqualToString:[NSString stringWithFormat:@"\u2611 %@",[listData objectAtIndex:row]]]) {
        cell.textLabel.text = [NSString stringWithFormat:@"\u2B1C %@",[listData objectAtIndex:row]];
    }
}

@end
