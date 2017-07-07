//
//  CISPViewController.m
//  iPitch V2
//
//  Created by Vineet on 26/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "InvestmentViewController.h"
#import "AppDelegate.h"
#import "DocumentTileView.h"
#import "iPitchConstants.h"
#import "File.h"
#import "PDFViewController.h"
@interface InvestmentViewController ()

@end

@implementation InvestmentViewController
@synthesize DocumentsScrollView, tableSource, currentFolder, currentFolderpath, DocumentButton, ProductButton;
@synthesize managedObjectContext;
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
  
    [self initialzeWithFolderPath];
    [self loadDocumentsScrollView];
    
    [ProductButton setTitleColor:[ self colorFromHexString:@"868686"] forState:UIControlStateNormal];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"investment_recomm1.png"]];
   
  


    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)initialzeWithFolderPath
{
    
    self.tableSource=[[NSMutableArray alloc]init];
    
    self.managedObjectContext=SAppDelegateObject.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"fileName" ascending:YES];
    fetchRequest.sortDescriptors=[NSArray arrayWithObject:sortDescriptor];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"File"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [self.managedObjectContext
                               executeFetchRequest:fetchRequest error:nil
                               ];
    
    NSLog(@"fetchedObjects: %@",fetchedObjects);
    
    [self.tableSource addObjectsFromArray:fetchedObjects];
    
    NSLog(@"self.tableSource:  %@",self.tableSource);
    
    
    
}



-(void)loadDocumentsScrollView
{
     CGFloat contentSize=155;
    for(UIView *tView in DocumentsScrollView.subviews)
    {
        if (![tView isKindOfClass:[UIImageView class]]) {
            [tView removeFromSuperview];
        }
    }
    
    
    DocumentsScrollView.showsHorizontalScrollIndicator=YES;
    
    
    for(int i = 0; i < [ self.tableSource count]; ++i)
    {
        DocumentTileView * innerView = [[DocumentTileView alloc]initWithFrame:CGRectMake(i*150+10, 5, 130, 130)];
        
        
        innerView.backgroundColor=[UIColor clearColor];
        
        UIButton *  dummyBtn = [[UIButton alloc]init];
        dummyBtn.frame = CGRectMake(0,0, 140, 140);
        dummyBtn.tag = i;
        File *aFile = [self.tableSource objectAtIndex:i];
        innerView.docNameLabel.text= aFile.fileName;
        
        if ([[aFile getFileType] isEqualToString:@"pdf"]) {
            if (i %3 == 0)
                innerView.docIcon.image=[UIImage imageNamed:@"doc_3.png"];
            else if ( i%3 ==1)
                innerView.docIcon.image=[UIImage imageNamed:@"doc_5.png"];
            else
                innerView.docIcon.image=[UIImage imageNamed:@"doc_6.png"];
        }
        [dummyBtn setBackgroundColor:[UIColor clearColor]];
     
        
        //                    [dummyBtn addTarget:self action:@selector(itemMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        //                    [dummyBtn addTarget:self action:@selector(itemMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        //[dummyBtn addTarget:self action:@selector(ShowPdfPreview:)forControlEvents:UIControlEventTouchUpInside];
        
       
        
        [innerView addSubview:dummyBtn];
        
        contentSize=contentSize+155;
        [DocumentsScrollView setContentSize:CGSizeMake(contentSize,0 )];
        
        
        [DocumentsScrollView addSubview:innerView];
        
    }
    
}

-(UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


-(void)ShowPdfPreview:(id)sender
{
    UIButton *temp=(UIButton*)sender;
    NSLog(@"n,cnjl: %d", temp.tag);
    File *selectedFile = [self.tableSource objectAtIndex:temp.tag];
    if ([[selectedFile getFileType] isEqualToString:@"pdf"]) {
        
        PDFViewController *viewController = [[PDFViewController alloc] initWithPDFFile:selectedFile.fileName];
        
        [self.navigationController pushViewController:viewController animated:YES];
        [self.navigationController setNavigationBarHidden:NO];
    }
    
}
- (IBAction)DocumentButtonClicked:(id)sender{
    
    [ProductButton setTitleColor:[ self colorFromHexString:@"868686"] forState:UIControlStateNormal];
    [DocumentButton setTitleColor:[ self colorFromHexString:ORANGE_COLOR_CODE] forState:UIControlStateNormal];
    
    [ProductButton setBackgroundImage:nil forState:UIControlStateNormal];
    [DocumentButton setBackgroundImage: [UIImage imageNamed:@"tab_btn_new.png" ] forState:UIControlStateNormal];
}
- (IBAction)ProductButtonClicked:(id)sender{
    
    [ProductButton setTitleColor:[ self colorFromHexString:ORANGE_COLOR_CODE] forState:UIControlStateNormal];
    [DocumentButton setTitleColor:[ self colorFromHexString:@"868686"] forState:UIControlStateNormal];
    [DocumentButton setBackgroundImage:nil forState:UIControlStateNormal];
    [ProductButton setBackgroundImage: [UIImage imageNamed:@"tab_btn_new.png" ] forState:UIControlStateNormal];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
