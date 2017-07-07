//
//  ProductDetailViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/3/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import "DocumentTileView.h"
#import "BoxObject.h"
#import "AsyncImageView.h"
#import "BoxFile.h"
#import "BoxNetworkOperationManager.h"
#import "BoxDownloadOperation.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface ProductDetailViewController ()
{
    MBProgressHUD *hud;
}
@end

@implementation ProductDetailViewController
@synthesize productObject,productNameLabel,productOwnerLabel,prodcutReleaseDateLabel,prodcutDescriptionLabel,productWebsiteButton,productCollaterals,productContactPersonButton;

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
    
    self.productNameLabel.text=self.productObject.PRODUCT_NAME;
    self.prodcutDescriptionLabel.text=self.productObject.PRODUCT_DESCRIPTION;
    self.productOwnerLabel.text=self.productObject.PRODUCT_OWNER;
    [self.productContactPersonButton setTitle:self.productObject.PRODUCT_CONTACT_EMAIL forState:UIControlStateNormal];
    self.prodcutReleaseDateLabel.text=self.productObject.PRODUCT_RELEASE_DATE;
    [self.productWebsiteButton setTitle:self.productObject.PRODUCT_WEBSITE forState:UIControlStateNormal];
    self.productCategoryLabel.text=self.productObject.PRODUCT_CATEGORY;

    
    self.productDescriptionTitle.textColor=[Utils colorFromHexString:ORANGE_COLOR_CODE];
    self.productCollateralsTitle.textColor=[Utils colorFromHexString:ORANGE_COLOR_CODE];
    self.productOwnerTitle.textColor=[Utils colorFromHexString:ORANGE_COLOR_CODE];
    self.productWebsiteTitle.textColor=[Utils colorFromHexString:ORANGE_COLOR_CODE];
    self.productReleaseDateTitle.textColor=[Utils colorFromHexString:GRAY1_COLOR_CODE];
    self.productContactPersonTitle.textColor=[Utils colorFromHexString:ORANGE_COLOR_CODE];
    self.productNameLabel.textColor=[Utils colorFromHexString:DARK_BLUE_COLOR_CODE];

    self.productIconImageView.image=self.productObject.productIcon;
    [self.productIconImageView.layer setMasksToBounds:YES];
    [self.productIconImageView.layer setCornerRadius:6];
    
    [self.collateralsButton setTitleColor:[Utils colorFromHexString:ORANGE_COLOR_CODE] forState:UIControlStateNormal];
    [self.technicalDocsButton setTitleColor:[Utils colorFromHexString:GRAY1_COLOR_CODE] forState:UIControlStateNormal];

    
    self.productCollateralsScrollView.layer.borderColor=[[Utils colorFromHexString:GRAY1_COLOR_CODE] CGColor];
    self.productCollateralsScrollView.layer.borderWidth=2.0f;
    
    NSLog(@"self. %@",self.productObject.productCollaterals);

   [self loadProductCollateralsScrollViewForBox];
    
    
    UIBarButtonItem *shareButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Share_icon.png"] landscapeImagePhone:[UIImage imageNamed:@"Share_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonPressed)];

    self.navigationItem.rightBarButtonItem=shareButton;

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProductNameLabel:nil];
    [self setProductDescriptionTitle:nil];
    [self setProdcutDescriptionLabel:nil];
    [self setProductCollateralsTitle:nil];
    [self setProductReleaseDateTitle:nil];
    [self setProductOwnerTitle:nil];
    [self setProductWebsiteTitle:nil];
    [self setProductContactPersonTitle:nil];
    [self setProdcutReleaseDateLabel:nil];
    [self setProductOwnerLabel:nil];
    [self setProductWebsiteButton:nil];
    [self setProductCollateralsScrollView:nil];
    [self setProductIconImageView:nil];
    [self setTechnicalDocsButton:nil];
    [self setCollateralsButton:nil];
    [self setProductCategoryLabel:nil];
    [super viewDidUnload];
}

- (void)shareButtonPressed
{
    [SAppDelegateObject sendMailToRecipients:[NSArray arrayWithObject:self.productObject.PRODUCT_CONTACT_EMAIL] withSubject:[NSString stringWithFormat:@"Regarding %@",self.productObject.PRODUCT_NAME] andMessage:@"Hi I am interested in your product, let us set up a discussion when you are free"];
}

- (IBAction)productWebsiteButtonClicked:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.productObject.PRODUCT_WEBSITE]];
    
}

- (IBAction)productContactPersonClicked:(id)sender {
    
    [SAppDelegateObject sendMailToRecipients:[NSArray arrayWithObject:self.productObject.PRODUCT_CONTACT_EMAIL] withSubject:[NSString stringWithFormat:@"Regarding %@",self.productObject.PRODUCT_NAME] andMessage:@"Hi I am interested in your product, let us set up a discussion when you are free"];
}

- (IBAction)technicalDocumenteButtonClicked:(id)sender {
    [self.technicalDocsButton setTitleColor:[Utils colorFromHexString:ORANGE_COLOR_CODE] forState:UIControlStateNormal];
    [self.collateralsButton setTitleColor:[Utils colorFromHexString:GRAY1_COLOR_CODE] forState:UIControlStateNormal];

}

- (IBAction)collateralsButtonClicked:(id)sender {
    [self.collateralsButton setTitleColor:[Utils colorFromHexString:ORANGE_COLOR_CODE] forState:UIControlStateNormal];
    [self.technicalDocsButton setTitleColor:[Utils colorFromHexString:GRAY1_COLOR_CODE] forState:UIControlStateNormal];


}


- (void)loadProductCollateralsScrollViewForBox
{
    CGFloat contentSize=200;
    
    for(UIView *tView in self.productCollateralsScrollView.subviews)
    {
        if (![tView isKindOfClass:[UIImageView class]]) {
            [tView removeFromSuperview];
        }
    }
    
    
    self.productCollateralsScrollView.showsHorizontalScrollIndicator=YES;
    
    
    for(int i = 0; i < [self.productObject.productCollaterals  count]; ++i)
    {
        DocumentTileView *innerView = [[DocumentTileView alloc]initWithFrame:CGRectMake(i*150+30, 25, 100, 120)];
        innerView.backgroundColor=[UIColor clearColor];
        
        UIButton *dummyBtn = [[UIButton alloc]init];
        dummyBtn.frame = CGRectMake(0,0, 100, 120);
        dummyBtn.tag = i;
        
        BoxObject *boxObject=[self.productObject.productCollaterals objectAtIndex:i];
        innerView.docNameLabel.text= boxObject.objectName;
        innerView.docNameLabel.font=[UIFont fontWithName:FONT_BOLD size:14];
        
        BoxFile *file=[self.productObject.productCollaterals  objectAtIndex:i];
        [innerView.docIcon setImageURL:[NSURL URLWithString:file.previewThumbnailURL]];
        innerView.docModifiedDateLabel.text=[NSString stringWithFormat:@"%@", boxObject.objectUpdatedTime];
        
        [dummyBtn setBackgroundColor:[UIColor clearColor]];
        [dummyBtn addTarget:self action:@selector(collateralClicked:)forControlEvents:UIControlEventTouchUpInside];
                
        [innerView addSubview:dummyBtn];
        
        contentSize=contentSize+200;
        [self.productCollateralsScrollView setContentSize:CGSizeMake(contentSize,0)];
        
        [self.productCollateralsScrollView addSubview:innerView];
        
    }
    

}


- (void)collateralClicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    BoxObject *boxObject=[self.productObject.productCollaterals objectAtIndex:btn.tag];
    
      hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode =MBProgressHUDModeAnnularDeterminate;
        hud.labelText=@"Downloading File From Server...";
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        BoxDownloadOperation *op = [BoxDownloadOperation operationForFileID:boxObject.objectId toPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory,boxObject.objectName]];
        [op setProgressHandler:^(BoxOperation *op, NSNumber *completionRatio) {
            NSLog(@"got completion ratio %@ for op %@", completionRatio, op);
            hud.progress=[completionRatio floatValue];
        }];
        [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:op onCompletetion:^(BoxOperation *op, BoxOperationResponse response) {
            NSLog(@"download completed with response %d", response);
            [hud hide:YES];
            
            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud hide:YES afterDelay:HUD_ALERT_TIMING];
            hud.mode =MBProgressHUDModeText;
            hud.labelText= @"File Downloaded Successfully!!";
            
            NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
            
            File *fileObject=[NSEntityDescription
                              insertNewObjectForEntityForName:@"File"
                              inManagedObjectContext:context];
            
            fileObject.fileName=boxObject.objectName;
            fileObject.filePath=[NSString stringWithFormat:@"%@/%@",documentsDirectory,boxObject.objectName];
            
            NSError *error=nil;
            
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save Folders %@", [error localizedDescription]);
            }
            
        }];
            
    
}

@end
