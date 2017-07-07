//
//  ProductCategoryViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/28/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "ProductCategoryViewController.h"
#import "ThemeHelper.h"
#import "BoxFolder.h"
#import "BoxFile.h"
#import "BoxNetworkOperationManager.h"
#import "BoxUser.h"
#import "BoxDownloadOperation.h"
#import "XMLParser.h"
#import "BoxLoginViewController.h"
#import "BoxCommonUISetup.h"
#import "iPitchConstants.h"
#import "Utils.h"
#import "ProductCategory.h"
#import "DocumentTileView.h"
#import "ProductDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CategoryTileView :UIView
@property (retain, nonatomic)  UIImageView *categoryIcon;
@property (retain, nonatomic)  UILabel *categoryNameLabel;
@property (assign, nonatomic)  BOOL selectedState;
@property (retain, nonatomic) UIView *selectedView;
@property (retain, nonatomic) UIImage *selectedImage;
@property (retain, nonatomic) UIImage *unselectedImage;

-(void)toggleSelection;

@end

@implementation CategoryTileView

#define DIVIDER_WIDTH 2
#define CATEGORY_ICON_WIDTH 48
#define CATEGORY_ICON_HEIGHT 49

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *divider=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, DIVIDER_WIDTH, self.frame.size.height)];
        divider.image=[UIImage imageNamed:@"divider.png"];
        [self addSubview:divider];
        
        _categoryIcon=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width -CATEGORY_ICON_WIDTH)/2, (self.frame.size.height -CATEGORY_ICON_HEIGHT)/2, CATEGORY_ICON_WIDTH, CATEGORY_ICON_HEIGHT)];
        [self addSubview:_categoryIcon];
        
        _categoryNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-21, self.frame.size.width, 20)];
        _categoryNameLabel.textAlignment=NSTextAlignmentCenter;
        _categoryNameLabel.font=[UIFont fontWithName:FONT_REGULAR size:12];
        _categoryNameLabel.textColor=[Utils colorFromHexString:GRAY1_COLOR_CODE];
        _categoryNameLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:_categoryNameLabel];

        
        _selectedView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-(DIVIDER_WIDTH*2), self.frame.size.width, DIVIDER_WIDTH*2)];
        [_selectedView setBackgroundColor:[Utils colorFromHexString:GRAY1_COLOR_CODE]];
        //[self addSubview:_selectedView];


        
    }
    return self;
}

-(void)toggleSelection
{
    if(self.selectedState)
    {
        //[self.selectedView setBackgroundColor:[Utils colorFromHexString:DARK_BLUE_COLOR_CODE]];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"product_selection_bluebg.png"]]];
        [self.categoryIcon setImage:self.unselectedImage];
        [self.categoryNameLabel setTextColor:[UIColor whiteColor]];
    }
    
    else
    {
        [self setBackgroundColor:[UIColor clearColor]];

       // [self.selectedView setBackgroundColor:[Utils colorFromHexString:GRAY1_COLOR_CODE]];
        [self.categoryIcon setImage:self.unselectedImage];
        [self.categoryNameLabel setTextColor:[Utils colorFromHexString:GRAY1_COLOR_CODE]];

    }
}


@end



@interface ProductCategoryViewController ()<BoxLoginViewControllerDelegate>
{
    NSMutableArray *boxProductCategoriesList;
    NSMutableArray *boxProductsListArray;
    BoxLoginViewController * vc;
    BoxFolder *currentDomainBoxFolder;
    BoxFolder *currentCategoryBoxFolder;
    NSMutableArray *currentProductCollaterals;
    BOOL firstTime;
}

@property (weak, nonatomic) IBOutlet UIScrollView *categoriesScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *productsScrollView;
@property (retain, nonatomic) NSString *folderID;
@end

@implementation ProductCategoryViewController

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
    
    currentProductCollaterals=[NSMutableArray array];
    boxProductCategoriesList=[NSMutableArray array];
    boxProductsListArray=[NSMutableArray array];

    CAGradientLayer  *gradient2 = [CAGradientLayer layer];
    gradient2.frame = self.categoriesScrollView.bounds;
    gradient2.colors = [NSArray arrayWithObjects: (id)[[Utils colorFromHexString:WHITE_COLOR_CODE] CGColor],(id)[[Utils colorFromHexString:@"d6d6d6"]  CGColor], nil];
    [self.categoriesScrollView.layer insertSublayer:gradient2 atIndex:0];
    
    //self.categoriesScrollView.layer.borderColor=[[Utils colorFromHexString:GRAY2_COLOR_CODE] CGColor];
    //self.categoriesScrollView.layer.borderWidth=1.5f;
    self.categoriesScrollView.pagingEnabled=YES;
    
    
    [Utils showLoading:self.view];
    firstTime=YES;
    [self getBoxFolderForCurrentDomain];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [ThemeHelper applyCurrentThemeToView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCategoriesScrollView:nil];
    [self setProductsScrollView:nil];
    [super viewDidUnload];
}

#pragma mark Box CMS methods

- (void)getBoxFolderForCurrentDomain
{
    
    BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
        
        if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
            
            
            //taking out current domain folder
            for (BoxObject *object in folder.objectsInFolder) {
                
                if([object.objectName isEqualToString:[Utils userDefaultsGetObjectForKey: IPITCH_CURRENT_DOMAIN]] && [object isKindOfClass:[BoxFolder class]])
                {
                    currentDomainBoxFolder=(BoxFolder *)object;
                    break;
                }
            }
            
            [self getCategoriesForCurrentDomain];

            
        }
        
        else if(response==boxFolderDownloadResponseTypeFolderNotLoggedIn
                ) {
            [self presenBoxLoginForm];
        }
        
        else {
            
            [Utils removeLoading:self.view];

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            [alert show];
        }
    };
        
    
    [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:@"0"onCompletion:block];
}

- (void)getCategoriesForCurrentDomain
{
   if(currentDomainBoxFolder != nil)
   {
       BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
           
           if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
               
               currentDomainBoxFolder=folder;
               BoxObject *categoryListXMLFile;

               //taking out CategoryList.xml from current domain folder.
               
               for (BoxObject *object in folder.objectsInFolder) {
                   
                   if([object.objectName isEqualToString:@"CategoryList.xml"])
                   {
                       categoryListXMLFile=object;
                   }
                   
                   else
                   {
                       [NSThread detachNewThreadSelector:@selector(downloadCategoryIconsFromFolder:) toTarget:self withObject:object];
                   }
               }
               
               
               if(categoryListXMLFile)
               {
                   BoxDownloadOperation *op = [BoxDownloadOperation operationForFileID:categoryListXMLFile.objectId toPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",categoryListXMLFile.objectName]]];
                   
                   [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:op onCompletetion:^(BoxOperation *op, BoxOperationResponse response) {
                       NSLog(@"download completed with response %d", response);
                       if(response==BoxOperationResponseSuccessful)
                       {
                           NSLog(@"CategoryList.xml Downloaded!!");
                           
                           NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",categoryListXMLFile.objectName]]]];
                           
                           //Initialize the delegate.
                           XMLParser *parser = [[XMLParser alloc] initXMLParser];
                           parser.parsingType=Categories;
                           
                           //Set delegate
                           [xmlParser setDelegate:parser];
                           
                           //Start parsing the XML file.
                           BOOL success = [xmlParser parse];
                           
                           if(success)
                           {
                               NSLog(@"No Errors");
                               
                               boxProductCategoriesList=[[NSMutableArray alloc]initWithArray:parser.resultsArray];
                           }
                           else
                               NSLog(@"Error Error Error!!!");
                           
                           if(firstTime)
                           {
                               //[self performSelectorInBackground:@selector(getProductsFromBoxForCategory:) withObject:[boxProductCategoriesList objectAtIndex:0]];
                               
                               
                               [NSThread detachNewThreadSelector:@selector(getProductsFromBoxForCategory:) toTarget:self withObject:[boxProductCategoriesList objectAtIndex:0]];
                           }
                           
                           
                           [self performSelectorOnMainThread:@selector(loadCategories) withObject:nil waitUntilDone:YES];
                           
                       }
                   }];

               }
           }
           
           else if(response==boxFolderDownloadResponseTypeFolderNotLoggedIn
                   ) {
               [self presenBoxLoginForm];
           }
           
           else {
               
               [Utils removeLoading:self.view];

               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
               [alert show];
           }
       };
 
       NSLog(@"folder id: %@",currentDomainBoxFolder.objectId);
       
       [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:currentDomainBoxFolder.objectId onCompletion:block];
   }
}

- (void)getProductsFromBoxForCategory:(ProductCategory *)category
{    
    BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
        
        if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
            
            BoxObject *productListXMLFile;
            
            currentCategoryBoxFolder=folder;
            
            //taking out CategoryList.xml from current domain folder.
            
            for (BoxObject *object in folder.objectsInFolder) {
                
                if([object.objectName isEqualToString:@"ProductList.xml"])
                {
                    productListXMLFile=object;
                    break;
                }
            }
            
            
            if(productListXMLFile)
            {
                BoxDownloadOperation *op = [BoxDownloadOperation operationForFileID:productListXMLFile.objectId toPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",productListXMLFile.objectName]]];
                
                [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:op onCompletetion:^(BoxOperation *op, BoxOperationResponse response) {
                    NSLog(@"download completed with response %d", response);
                    if(response==BoxOperationResponseSuccessful)
                    {
                        NSLog(@"ProductList.xml Downloaded!!");
                        
                        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",productListXMLFile.objectName]]]];
                        
                        //Initialize the delegate.
                        XMLParser *parser = [[XMLParser alloc] initXMLParser];
                        parser.parsingType=Products;
                        
                        //Set delegate
                        [xmlParser setDelegate:parser];
                        
                        //Start parsing the XML file.
                        BOOL success = [xmlParser parse];
                        
                        if(success)
                        {
                            NSLog(@"No Errors");
                            
                            boxProductsListArray=[[NSMutableArray alloc]initWithArray:parser.resultsArray];
                        }
                        else
                            NSLog(@"Error Error Error!!!");
                        
                        [self performSelectorOnMainThread:@selector(loadProducts) withObject:nil waitUntilDone:YES];
                        
                    }
                }];
                
            }
        }
        
        else if(response==boxFolderDownloadResponseTypeFolderNotLoggedIn
                ) {
            [self presenBoxLoginForm];
        }
        
        else {
            
            [Utils removeLoading:self.view];

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            [alert show];
        }
    };

    
    NSString *categoryFolderID;
    
    for(BoxObject *object in currentDomainBoxFolder.objectsInFolder)
    {
        
        if ([object.objectName isEqualToString:category.CATEGORY_FOLDER_NAME] && [object isKindOfClass:[BoxFolder class]]) {
            categoryFolderID=object.objectId;
        }
    }
    
    if(categoryFolderID)
    [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:categoryFolderID onCompletion:block];
}

- (void)getCollateralsForProduct:(Product *)product
{
    BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
        
        if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
            
            
            //taking out CategoryList.xml from current domain folder.
            
            for (BoxObject *object in folder.objectsInFolder)
            {
                [currentProductCollaterals addObject:object];
            }
            

        }
        
        else if(response==boxFolderDownloadResponseTypeFolderNotLoggedIn
                ) {
            [self presenBoxLoginForm];
        }
        
   
        else {
            
            [Utils removeLoading:self.view];

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            [alert show];
        }
    };

    
    NSString *categoryFolderID;
    for(BoxObject *object in currentDomainBoxFolder.objectsInFolder)
    {
        
        if ([object.objectName isEqualToString:product.PRODUCT_NAME]) {
            categoryFolderID=object.objectId;
        }
    }
    
    [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:categoryFolderID onCompletion:block];

}


- (void)downloadCategoryIconsFromFolder:(BoxObject *)object
{
    BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
        
        if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
            
            BoxObject *categoryIcon;
                        
            //taking out CategoryIcon.png from current domain folder.
            
            for (BoxObject *object in folder.objectsInFolder) {
                
                if([object.objectName isEqualToString:@"CategoryIcon.png"])
                {
                    categoryIcon=object;
                    break;
                }
            }
            
            
            if(categoryIcon)
            {
                BoxDownloadOperation *op = [BoxDownloadOperation operationForFileID:categoryIcon.objectId toPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"CAT_%@.png",object.objectName]]];
                
                [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:op onCompletetion:^(BoxOperation *op, BoxOperationResponse response) {
                    
                    if(response==BoxOperationResponseSuccessful)
                    {
                        NSLog(@"CateforyIcon for %@ Downloaded!!",object.objectName);
                        [self performSelectorOnMainThread:@selector(loadCategories) withObject:nil waitUntilDone:YES];
                    }
                }];
                
            }
        }
        
        else if(response==boxFolderDownloadResponseTypeFolderNotLoggedIn
                ) {
            [self presenBoxLoginForm];
        }
        
        else {
            
            [Utils removeLoading:self.view];

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            [alert show];
        }
    };
    
    
    NSFileManager *fileMGR=[NSFileManager defaultManager];
    if(! [fileMGR fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"CAT_%@.png",object.objectName]]])
        [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:object.objectId onCompletion:block];
}


- (void)presenBoxLoginForm
{
    vc = [BoxLoginViewController loginViewControllerWithNavBar:YES];
    vc.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:vc.navigationController andNavItem:vc.navigationItem]; //Adds the box styling to the navigation item of the view. This is optional.
    vc.boxLoginDelegate = self;
    
    [self presentModalViewController:vc animated:YES];
}

- (void)boxLoginViewController:(BoxLoginViewController *)boxLoginViewController didFinishWithResult:(LoginResult)result {
    
    
    if(result==LoginSuccess)
    {
        //        BoxDownloadActionViewController * inputController = [[BoxDownloadActionViewController alloc] initWithFolderID:@"0"];
        //
        //        [viewTail buildBoxFolderListAfterLogin:inputController];
        
        firstTime=YES;
        [self getBoxFolderForCurrentDomain];
        
        [vc dismissModalViewControllerAnimated:YES];
        
        
    }
    
    
    if (result==LoginCancelled)
    {
        [vc dismissModalViewControllerAnimated:YES];
        [Utils removeLoading:self.view];

    }
    
    
    //  [self.navigationController popViewControllerAnimated:YES]; //Only one of these lines should actually be used depending on how you choose to present it.
}

#pragma mark scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView==self.categoriesScrollView)
    {
        CAGradientLayer  *gradient2 = [CAGradientLayer layer];
        gradient2.frame = self.categoriesScrollView.bounds;
        gradient2.colors = [NSArray arrayWithObjects: (id)[[Utils colorFromHexString:WHITE_COLOR_CODE] CGColor],(id)[[Utils colorFromHexString:@"d6d6d6"]  CGColor], nil];
        [self.categoriesScrollView.layer insertSublayer:gradient2 atIndex:0];

    }
}

#pragma mark Custom UI Methods

- (void)loadCategories
{
    CGFloat contentSize=200;
    
    for(UIView *tView in self.categoriesScrollView.subviews)
    {
        //if (![tView isKindOfClass:[UIImageView class]]) {
            [tView removeFromSuperview];
        //}
    }
    
    
    self.categoriesScrollView.showsHorizontalScrollIndicator=YES;
    
    for(int i = 0; i < [boxProductCategoriesList count]; ++i)
    {
        ProductCategory *catObject = [boxProductCategoriesList objectAtIndex:i];
        NSString *imageName=[NSString stringWithFormat:@"%@_unselected.png",catObject.CATEGORY_ICON];

        CategoryTileView *tileView=[[CategoryTileView alloc]initWithFrame:CGRectMake(i*177, 0, 177, 96)];
        tileView.tag=i;
        tileView.categoryNameLabel.text=catObject.CATEGORY_NAME;
        tileView.unselectedImage=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/CAT_%@.png",NSTemporaryDirectory(),catObject.CATEGORY_FOLDER_NAME]];
        imageName=[NSString stringWithFormat:@"%@_selected.png",catObject.CATEGORY_ICON];
        tileView.selectedImage=[UIImage imageNamed:imageName];
        if(i== 0)
        [tileView setSelectedState:YES];
        else
        [tileView setSelectedState:NO];

        [tileView toggleSelection];

        UITapGestureRecognizer *categoryTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(categoryTapped:)];
        [tileView addGestureRecognizer:categoryTapGesture];
        
        [self.categoriesScrollView addSubview:tileView];
        
        [self.categoriesScrollView setContentSize:CGSizeMake(contentSize,0)];
        
        contentSize+=contentSize;

    }
    
    if (!firstTime)
    {
        [Utils removeLoading:self.view];
    }
    else
    {
        firstTime=NO;
    }
}

- (void)categoryTapped:(id)sender
{
    for (CategoryTileView *kView in [self.categoriesScrollView subviews]) {
        kView.selectedState=NO;
        [kView toggleSelection];
    }
    
    CategoryTileView *senderView=(CategoryTileView *) ((UITapGestureRecognizer *)sender).view;
    if(senderView.selectedState)
    senderView.selectedState =NO;
    else
        senderView.selectedState=YES;
    
    [senderView toggleSelection];
    
    [Utils showLoading:self.view];
    [self performSelectorInBackground:@selector(getProductsFromBoxForCategory:) withObject:[boxProductCategoriesList objectAtIndex:senderView.tag]];
    
}
- (void)loadProducts
{
    CGFloat contentSize=200;
    
    for(UIView *tView in self.productsScrollView.subviews)
    {
        //if (![tView isKindOfClass:[UIImageView class]]) {
        [tView removeFromSuperview];
        //}
    }
    
    int row = 0;
    int column = 0;
   
    
    for(int i = 0; i < [boxProductsListArray count]; ++i)
    {
        Product *catObject = [boxProductsListArray objectAtIndex:i];
        
        UIView *tileView=[[UIView alloc]initWithFrame:CGRectMake(column*220+50, row*110+20, 200, 150)];
        tileView.backgroundColor=[UIColor clearColor];
        
        tileView.tag=i;
        
        
        UIImageView *productIcon=[[UIImageView alloc]initWithFrame:CGRectMake(10,10,180,100)];
        
        UIImage *productImage=[UIImage imageWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_icon.png",catObject.PRODUCT_NAME]]];
        if (productImage) {
            catObject.productIcon=productImage;
            [productIcon setImage:productImage];
        }
        else
        {
            [productIcon setImage:[UIImage imageNamed:@"Product_default_image.png"]];
            [self loadProductIconinImageView:productIcon ForProduct:catObject];
        }
        [tileView addSubview:productIcon];
        
        UILabel *productNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, tileView.frame.size.height-20, tileView.frame.size.width, 20)];
        productNameLabel.text=catObject.PRODUCT_NAME;
        productNameLabel.textAlignment=NSTextAlignmentCenter;
        productNameLabel.font=[UIFont fontWithName:FONT_REGULAR size:13];
        productNameLabel.textColor=[Utils colorFromHexString:GRAY1_COLOR_CODE];
        productNameLabel.backgroundColor=[UIColor clearColor];
        [tileView addSubview:productNameLabel];
        
        
        [self loadProductIconinImageView:productIcon ForProduct:catObject];
        
        UITapGestureRecognizer *productTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productTapped:)];
        [tileView addGestureRecognizer:productTapGesture];
        
        [self.productsScrollView addSubview:tileView];
                
        if (column == 3)
        {
            column = 0;
            row++;
            contentSize=contentSize+150;
            [self.productsScrollView setContentSize:CGSizeMake(0, contentSize)];
            
        } else {
            column++;
        }
        
    }
    [Utils removeLoading:self.view];

}

- (void)productTapped:(id)sender
{
    
    [Utils showLoading:self.view];
    
    CategoryTileView *senderView=(CategoryTileView *) ((UITapGestureRecognizer *)sender).view;

    Product *productObject = [boxProductsListArray objectAtIndex:senderView.tag];
    productObject.PRODUCT_CATEGORY=currentCategoryBoxFolder.objectName;
    
    productObject.productCollaterals=[NSMutableArray array];
    
    BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
        
        if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
            
            [Utils removeLoading:self.view];
            for(BoxObject *boxObject in folder.objectsInFolder)
            {
                if(![boxObject.objectName isEqualToString:@"ProductIcon.png"])
                {
                    [productObject.productCollaterals addObject:boxObject];
                }
            
            }
        
        ProductDetailViewController *productDetail=[[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
            productDetail.productObject=productObject;
            [self.navigationController pushViewController:productDetail animated:YES];
        }
        
        else if(response==boxFolderDownloadResponseTypeFolderNotLoggedIn
                ) {
            [self presenBoxLoginForm];
        }
        
        else {
            
            [Utils removeLoading:self.view];

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            [alert show];
        }
    };
    
    NSString *productFolderID;
    
    for (BoxObject *object in currentCategoryBoxFolder.objectsInFolder) {
        if([object.objectName isEqualToString:productObject.PRODUCT_NAME])
        {
            productFolderID=object.objectId;
            break;
        }
    }
    
    if (productFolderID)
    [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:productFolderID onCompletion:block];

    else
        [Utils removeLoading:self.view];

}

- (void)loadProductIconinImageView:(UIImageView *)imgView ForProduct:(Product *)productObject
{
    BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
        
        if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
            
            NSString *productIconId=@"";
            for(BoxObject *boxObject in folder.objectsInFolder)
            {
                if(![boxObject.objectName isEqualToString:@"ProductIcon.png"])
                {
                    //[productObject.productCollaterals addObject:boxObject];
                }
                
                else
                {
                    productIconId=boxObject.objectId;
                }
                
            }
                        
            BoxDownloadOperation *op = [BoxDownloadOperation operationForFileID:productIconId toPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_icon.png",folder.objectName]]];
            
            [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:op onCompletetion:^(BoxOperation *op, BoxOperationResponse response) {
                NSLog(@"download completed with response %d", response);
                
                if(response == BoxOperationResponseSuccessful
                   ) {
                    productObject.productIcon=[UIImage imageWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_icon.png",folder.objectName]]];
                    [imgView setImage:[UIImage imageWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_icon.png",folder.objectName]]]];
                    
                }
                
            }];
            
        }
        
        else if(response==boxFolderDownloadResponseTypeFolderNotLoggedIn
                ) {
            [self presenBoxLoginForm];
        }
        
        else {
            
            [Utils removeLoading:self.view];

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            [alert show];
        }
    };
    if (self.folderID == nil) {
        //NSLog(@"Error: FolderID must be set in BoxBrowserGridViewController");
    }
    
    
    NSString *productFolderID;
    
    for (BoxObject *object in currentCategoryBoxFolder.objectsInFolder) {
        if([object.objectName isEqualToString:productObject.PRODUCT_NAME])
        {
            productFolderID=object.objectId;
            break;
        }
    }
    
    if (productFolderID)
        [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:productFolderID onCompletion:block];
}
@end
