//
//  PageSelectorViewController.m
//  Leaves
//
//  Created by Satheeshwaran on 1/4/13.
//  Copyright (c) 2013 Tom Brow. All rights reserved.
//

#import "PageSelectorViewController.h"
#import "AppDelegate.h"
#import "LandscapeViewController.h"
#import "iPitchConstants.h"
#import "ModelTrackingClass.h"
#import "PDFPreviewViewController.h"

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define PSIsIpad() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

@interface PageSelectorViewController ()
{
    CGSize pageSize;
}

@end

@implementation PageSelectorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.contentSizeForViewInPopover=CGSizeMake(300, 500);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics: UIBarMetricsDefault];
    
    self.navigationController.navigationBarHidden=NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *makePdfBtn=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GENERATE_PDF", @"Generate PDF") style:UIBarButtonItemStylePlain target:self action:@selector(didClickMakePDF)];

    self.navigationItem.rightBarButtonItem=makePdfBtn;
    
    UIBarButtonItem *editTable=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"EDIT_PAGES", @"Edit Pages") style:UIBarButtonItemStylePlain target:self action:@selector(editTable)];
    
    self.navigationItem.rightBarButtonItem=makePdfBtn;
    self.navigationItem.leftBarButtonItem=editTable;
    
    
   // self.tableView.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeLeft];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
}
-(void)editTable
{
    if (self.editing) {
        
        self.navigationItem.leftBarButtonItem.title=NSLocalizedString(@"EDIT_PAGES", @"Edit Pages");
        self.navigationItem.leftBarButtonItem.style=UIBarButtonItemStylePlain;
        [self setEditing:NO animated:YES];

    }
    else
    {
        self.navigationItem.leftBarButtonItem.title=NSLocalizedString(@"DONE", @"Done");
        self.navigationItem.leftBarButtonItem.style=UIBarButtonItemStyleBordered;
        [self setEditing:YES animated:YES];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    
    PDFFile *sFile=(PDFFile*)[SAppDelegateObject.selectedPages objectAtIndex:indexPath.row];
    
    cell.imageView.image= [self imageScaledToSize:CGSizeMake(50, 50) ForImage:[UIImage imageWithContentsOfFile:sFile.filePath]];
    cell.textLabel.text=sFile.fileName;
    
    // cell.textLabel.text=[NSString stringWithFormat:@"Page-%d",indexPath.row+1];
    // Configure the cell...
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [SAppDelegateObject.selectedPages count];
}



#pragma mark Row Deleting

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
	
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        NSArray *array=[[NSArray alloc]initWithObjects:indexPath, nil];
        [SAppDelegateObject.selectedPages removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationMiddle];
        
        //[self.tableView reloadData];
        
    }
}

#pragma mark Row reordering

// Update the data model according to edit actions delete or insert.

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSString *item = [SAppDelegateObject.selectedPages objectAtIndex:fromIndexPath.row] ;
	[SAppDelegateObject.selectedPages  removeObject:item];
	[SAppDelegateObject.selectedPages  insertObject:item atIndex:toIndexPath.row];
    
    
}

#pragma mark PDF Generation Methods

- (void)didClickMakePDF
{
    
    if ([SAppDelegateObject.selectedPages count]>0) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = NSLocalizedString(@"GENERATING_PDF", @"Generating Pdf...");
        HUD.detailsLabelText=NSLocalizedString(@"PLEASE_WAIT", @"Please Wait");
        
        
        [self performSelectorInBackground:@selector(generatePDF) withObject:nil];
        
    }
    
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"NO_PAGES_SELECTED", @"No Pages Selected") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"Ok") otherButtonTitles:nil, nil] ;
        [alert show];
    }
    
}

-(void)generatePDF
{
    generatedPDFFile=[[PDFFile alloc]init];
    [self setupPDFDocumentNamed:@"generatedPDF" Width:850 Height:900];
    
    
    for (int i=0; i< [SAppDelegateObject.selectedPages count];i++)
    {
        
        [self beginPDFPage];
        
        PDFFile *sFile=(PDFFile*)[SAppDelegateObject.selectedPages objectAtIndex:i];
        
        UIImage* image = Nil;
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr fileExistsAtPath:sFile.filePath isDirectory:FALSE]) {
            NSLog(@"file exist");
            image =  [UIImage imageWithContentsOfFile:sFile.filePath];
            
        }
        else {
            NSLog(@"file not exist");
        }
        
        
        [self addImageToPDF:image];
        
    }
    
    UIGraphicsEndPDFContext();
    
    [self performSelectorOnMainThread:@selector(updateAfterPDFGeneration) withObject:nil waitUntilDone:YES];
    
    
}

-(void)updateAfterPDFGeneration
{
    [HUD removeFromSuperview];
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SUCCESS", @"Success" ) message:NSLocalizedString(@"PDF_GENERATED", @"PDF Generated want to open Now??") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", @"Ok"), nil] ;
    [alert show];
}


- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height {
       
    pageSize = CGSizeMake(width, height);
    
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    
    generatedPDFFile.fileName=name;
    generatedPDFFile.filePath=pdfPath;
    
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}

- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
}

- (void)finishPDF {
    UIGraphicsEndPDFContext();
}

- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
	CGSize stringSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(pageSize.width - 2*20-2*20, pageSize.height - 2*20 - 2*20) lineBreakMode:UILineBreakModeWordWrap];
    
	float textWidth = frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > pageSize.width)
        textWidth = pageSize.width - frame.origin.x;
    
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    [text drawInRect:renderingRect
            withFont:font
       lineBreakMode:UILineBreakModeWordWrap
           alignment:UITextAlignmentLeft];
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    return frame;
}

- (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    
    // this is the thickness of the line
    CGContextSetLineWidth(currentContext, frame.size.height);
    
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return frame;
}

- (CGRect)addImageToPDF:(UIImage*)image {
    
    //Vineet's change.
     CGRect imageFrame = CGRectMake(-90,120,image.size.width,image.size.height+100);
    [image drawInRect:imageFrame];
    
    return imageFrame;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

-(void)dismissModalVC
{
    [generatedPDFController dismissModalViewControllerAnimated:YES];
}

- (UIImage*) imageScaledToSize: (CGSize) newSize ForImage:(UIImage *)image{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

#pragma mark AlertView Delegate Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        
        PDFPreviewViewController *pdfPreview=[[PDFPreviewViewController alloc]initWithNibName:@"PDFPreviewViewController" bundle:nil];
        pdfPreview.pdfFile=generatedPDFFile;
        pdfPreview.modalPresentationStyle=UIModalPresentationFormSheet;
        [self presentModalViewController:pdfPreview animated:YES];
        /*CGRect r = CGRectMake(self.view.bounds.size.width/2 - 325,
                              self.view.bounds.size.height/2 - 300,
                              650, 600);
        r = [self.view convertRect:r toView:pdfPreview.view.superview.superview];
        pdfPreview.view.superview.frame = r;*/
        
        
    }
}


@end
