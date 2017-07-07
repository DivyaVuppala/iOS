//
//  SalesProcessViewController.m
//  iPitch V2
//
//  Created by Vineet on 26/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "SalesProcessViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/CALayer.h>
#import "iPitchConstants.h"
#import "Utils.h"
#import "iPitchAnalytics.h"
#import "iPitchConstants.h"

@interface SalesProcessViewController (){
    UINavigationController *SalesNavigaitonController;
}

@end

@implementation SalesProcessViewController
@synthesize  toolBarView,ProgressImage, ProceedButton,stagesBreadCrumbView,stagesDictionary,stagesArray, NotificationIcon, UserIcon, Searchbtn;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"search_icon.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification_icon.png"]];
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_search_icon_1.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_notification_icon.png"]];
        
    }

   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Dashboard_bg.png"]];
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:BFS_DOMAIN]) {
         reviewView = [[ReviewClientViewController alloc] initWithNibName:@"ReviewClientViewController" bundle:nil];
        SalesNavigaitonController=[[UINavigationController alloc]initWithRootViewController:reviewView];

    }
    
    else
    {
        insuranceFirst = [[InsuranceFirstViewController alloc] initWithNibName:@"InsuranceFirstViewController" bundle:nil];
        insuranceFirst.plistName=@"Insurance_First.plist";
        SalesNavigaitonController=[[UINavigationController alloc]initWithRootViewController:insuranceFirst];

    }
    // [cispView.view setFrame:CGRectMake(20, 150, 975, 590)];
    SalesNavigaitonController.navigationBarHidden=YES;
    [SalesNavigaitonController.view setFrame:CGRectMake(35, 142, 975, 540)];
    [self.view addSubview:SalesNavigaitonController.view];
      ProceedButton.titleLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
     [ProceedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [reviewView.view.layer setCornerRadius:6];
    
    self.stagesArray = [[NSMutableArray alloc]init];
    self.stagesDictionary=[[NSMutableDictionary alloc]init];
    stageIndicators= [[NSMutableArray alloc]init];
    
    if([Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN])
    {
        NSString *plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN_PLIST_FILE]];
        
        NSLog(@"[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN_PLIST_FILE]: %@",[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN_PLIST_FILE]);
        NSLog(@"plist path: %@",plistPath);
        self.stagesDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    }
    NSLog(@"stagesDictionary: %@", self.stagesDictionary);

    [self.stagesArray  addObjectsFromArray:[[self.stagesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] ];

    NSLog(@"no:%@", self.stagesArray);

    number_of_stages=[self.stagesArray count];
    
    current_stage=0;
    
    NSLog(@"no:%d", number_of_stages);

    [self loadDomainSpecificStages];
   // [self.toolBarView addGestureRecognizer:revealController.panGestureRecognizer];

    // Do any additional setup after loading the view from its nib.
    
}


-(void) viewWillAppear:(BOOL)animated{
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:BFS_DOMAIN]) {
        
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"BFS Screen" withAction:@"Review Client Process" withLabel:nil withValue:nil];

    }
    
    else
    {
        
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Insurance Screen" withAction:@"Profiling Process" withLabel:nil withValue:nil];
    }
        [super viewWillAppear:animated];
}

-(void)loadDomainSpecificStages
{
    int offset=35;
    
    for (int i=0; i<[self.stagesArray count]; i++)
    {
        UIButton *stageButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        
        if (i==current_stage)
            [stageButton setBackgroundImage:[UIImage imageNamed:@"inprogress_state.png"] forState:UIControlStateNormal];
        else
            [stageButton setBackgroundImage:[UIImage imageNamed:@"circle_plain.png"] forState:UIControlStateNormal];
        

        [stageButton setFrame:CGRectMake(offset, 5, 30, 30)];
        [self.stagesBreadCrumbView addSubview:stageButton];
        [stageIndicators addObject:stageButton];
        
        
        UILabel *stageName=[[UILabel alloc]init];
        stageName.frame = CGRectMake(offset, 40, 100, 40);
        
        if (i==[self.stagesArray count]-1)
        stageName.frame = CGRectMake(offset-40, 40, 100, 40);

        stageName.numberOfLines=2;
        stageName.text = [[self.stagesArray objectAtIndex:i] substringFromIndex:3];
        [stageName setFont:[UIFont fontWithName:FONT_BOLD size:16]];
        [stageName setTextAlignment:UITextAlignmentLeft];
        [stageName setBackgroundColor:[UIColor clearColor]];
        stageName.textColor = [UIColor whiteColor];
        [self.stagesBreadCrumbView addSubview:stageName];
        
        offset= ((950/(number_of_stages -1)) * (i+1)) + 20;
    }
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)ProceedButtonClicked:(id)sender
{
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:BFS_DOMAIN])
    {
        
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"BFS Screen" withAction:@"CISP Process" withLabel:nil withValue:nil];
 
        //This is not the right way to do , please change ASAP - satheesh.
    
    UIButton *stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
    [stageIndicator setBackgroundImage:[UIImage imageNamed:@"selected_state.png"] forState:UIControlStateNormal];
    
    current_stage=current_stage+1;
    
    stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
    [stageIndicator setBackgroundImage:[UIImage imageNamed:@"inprogress_state.png"] forState:UIControlStateNormal];

    cispView = [[cispViewController alloc] initWithNibName:@"cispViewController" bundle:nil];
    cispView.plistName=@"FirstPage.plist";

    [SalesNavigaitonController pushViewController:cispView animated:YES];
    SalesNavigaitonController.navigationBarHidden=YES;
    [cispView.view.layer setCornerRadius:6];
    [SalesNavigaitonController.view setFrame:CGRectMake(35, 142, 975, 540)];
    
    ProgressImage.image=[UIImage imageNamed:@"sutablitiy_analysis.png"];
    [ProceedButton removeFromSuperview];
    proceedBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(902, 698, 105, 29)];
    [self.view addSubview:proceedBtn2];
    [proceedBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [proceedBtn2 setBackgroundImage:[UIImage imageNamed:@"btn_bg_Proceed.png"] forState:UIControlStateNormal];
    [proceedBtn2 setTitle:@"Proceed" forState:UIControlStateNormal];
    proceedBtn2.titleLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
    [proceedBtn2 addTarget:self action:@selector(ProceedBtn2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:INSURANCE_DOMAIN])
    {
       
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Insurance Screen" withAction:@"Product Selector Process" withLabel:nil withValue:nil];
        UIButton *stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"selected_state.png"] forState:UIControlStateNormal];
        
        current_stage=current_stage+1;
        
        stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"inprogress_state.png"] forState:UIControlStateNormal];
        
        insuranceSecond = [[InsuranceSecondViewController alloc] initWithNibName:@"InsuranceSecondViewController" bundle:nil];
        [SalesNavigaitonController pushViewController:insuranceSecond animated:YES];
        SalesNavigaitonController.navigationBarHidden=YES;
        [insuranceSecond.view.layer setCornerRadius:6];
        [SalesNavigaitonController.view setFrame:CGRectMake(35, 142, 975, 540)];
        
        ProgressImage.image=[UIImage imageNamed:@"sutablitiy_analysis.png"];
        [ProceedButton removeFromSuperview];
        proceedBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(902, 698, 105, 29)];
        [self.view addSubview:proceedBtn2];
        [proceedBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [proceedBtn2 setBackgroundImage:[UIImage imageNamed:@"btn_bg_Proceed.png"] forState:UIControlStateNormal];
        [proceedBtn2 setTitle:@"Proceed" forState:UIControlStateNormal];
        proceedBtn2.titleLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
        [proceedBtn2 addTarget:self action:@selector(ProceedBtn2Clicked:) forControlEvents:UIControlEventTouchUpInside];

    }

}

- (IBAction)ProceedBtn2Clicked:(id)sender{
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:BFS_DOMAIN])
    {
        
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"BFS Screen" withAction:@"Suitability Analysis Process" withLabel:nil withValue:nil];
    UIButton *stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
    [stageIndicator setBackgroundImage:[UIImage imageNamed:@"selected_state.png"] forState:UIControlStateNormal];
    
    current_stage=current_stage+1;
    
    stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
    [stageIndicator setBackgroundImage:[UIImage imageNamed:@"inprogress_state.png"] forState:UIControlStateNormal];
    
    suitableAnalysisView = [[SuitabilityAnalysisViewController alloc] initWithNibName:@"SuitabilityAnalysisViewController" bundle:nil];
    [suitableAnalysisView.view.layer setCornerRadius:6];

    [SalesNavigaitonController pushViewController:suitableAnalysisView animated:YES];

    ProgressImage.image=[UIImage imageNamed:@"investment_recomm.png"];
    [proceedBtn2 removeFromSuperview];
    proceedBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(902, 698, 105, 29)];
    [self.view addSubview:proceedBtn3];
    [proceedBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [proceedBtn3 setBackgroundImage:[UIImage imageNamed:@"btn_bg_Proceed.png"] forState:UIControlStateNormal];
    [proceedBtn3 setTitle:@"Proceed" forState:UIControlStateNormal];
      proceedBtn3.titleLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
    [proceedBtn3 addTarget:self action:@selector(ProceedBtn3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:INSURANCE_DOMAIN])
    {
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

          [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Insurance Screen" withAction:@"Product Worksheet Process" withLabel:nil withValue:nil];
        UIButton *stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"selected_state.png"] forState:UIControlStateNormal];
        
        current_stage=current_stage+1;
        
        stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"inprogress_state.png"] forState:UIControlStateNormal];
        
        insuranceThird = [[InsuranceThirdViewController alloc] initWithNibName:@"InsuranceThirdViewController" bundle:nil];
        insuranceThird.plistName=@"Insurance_thirdZ.plist";
        [insuranceThird.view.layer setCornerRadius:6];
        
        [SalesNavigaitonController pushViewController:insuranceThird animated:YES];
        ProgressImage.image=[UIImage imageNamed:@"investment_recomm.png"];
        [proceedBtn2 removeFromSuperview];
        proceedBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(902, 698, 105, 29)];
        [self.view addSubview:proceedBtn3];
        [proceedBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [proceedBtn3 setBackgroundImage:[UIImage imageNamed:@"btn_bg_Proceed.png"] forState:UIControlStateNormal];
        [proceedBtn3 setTitle:@"Proceed" forState:UIControlStateNormal];
        proceedBtn3.titleLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
        [proceedBtn3 addTarget:self action:@selector(ProceedBtn3Clicked:) forControlEvents:UIControlEventTouchUpInside];

    }
}

- (IBAction)ProceedBtn3Clicked:(id)sender{
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:BFS_DOMAIN])
    {
        
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"BFS Screen" withAction:@"Investment Reccomondation Process" withLabel:nil withValue:nil];
        UIButton *stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"selected_state.png"] forState:UIControlStateNormal];
        
        current_stage=current_stage+1;
        
        stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"inprogress_state.png"] forState:UIControlStateNormal];
        
        investmentView = [[InvestmentViewController alloc] initWithNibName:@"InvestmentViewController" bundle:nil];
        [investmentView.view.layer setCornerRadius:6];
        
        [SalesNavigaitonController pushViewController:investmentView animated:YES];
        ProgressImage.image=[UIImage imageNamed:@"Kyc.png"];
        [proceedBtn3 removeFromSuperview];
        proceedBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(902, 698, 105, 29)];
        [self.view addSubview:proceedBtn4];
        [proceedBtn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [proceedBtn4 setBackgroundImage:[UIImage imageNamed:@"btn_bg_Proceed.png"] forState:UIControlStateNormal];
        [proceedBtn4 setTitle:@"Proceed" forState:UIControlStateNormal];
        proceedBtn4.titleLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
        [proceedBtn4 addTarget:self action:@selector(ProceedBtn4Clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:INSURANCE_DOMAIN])
    {
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Insurance Screen" withAction:@"Illustration Process" withLabel:nil withValue:nil];
        
        UIButton *stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"selected_state.png"] forState:UIControlStateNormal];
        
        current_stage=current_stage+1;
        
        stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"inprogress_state.png"] forState:UIControlStateNormal];
        
        insuranceFourth = [[InsuranceFourthViewController alloc] initWithNibName:@"InsuranceFourthViewController" bundle:nil];
        [insuranceFourth.view.layer setCornerRadius:6];
        
        [SalesNavigaitonController pushViewController:insuranceFourth animated:YES];
        ProgressImage.image=[UIImage imageNamed:@"Kyc.png"];
        [proceedBtn3 removeFromSuperview];
        proceedBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(902, 698, 105, 29)];
        [self.view addSubview:proceedBtn4];
        [proceedBtn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [proceedBtn4 setBackgroundImage:[UIImage imageNamed:@"btn_bg_Proceed.png"] forState:UIControlStateNormal];
        [proceedBtn4 setTitle:@"Proceed" forState:UIControlStateNormal];
        proceedBtn4.titleLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
        [proceedBtn4 addTarget:self action:@selector(ProceedBtn4Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (IBAction)ProceedBtn4Clicked:(id)sender{
 
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:BFS_DOMAIN])
    {
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"BFS Screen" withAction:@"KYC Review Process" withLabel:nil withValue:nil];
        
        UIButton *stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"selected_state.png"] forState:UIControlStateNormal];
        
        current_stage=current_stage+1;
        
        stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"inprogress_state.png"] forState:UIControlStateNormal];
        
        
        KYCView = [[kYCController alloc] initWithNibName:@"kYCController" bundle:nil];
        [KYCView.view.layer setCornerRadius:6];
        
        [SalesNavigaitonController pushViewController:KYCView animated:YES];
        
        [proceedBtn4 removeFromSuperview];
        proceedBtn5 = [[UIButton alloc] initWithFrame:CGRectMake(902, 698, 105, 29)];
        [self.view addSubview:proceedBtn5];
        [proceedBtn5 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [proceedBtn5 setBackgroundImage:[UIImage imageNamed:@"btn_bg_Proceed.png"] forState:UIControlStateNormal];
        [proceedBtn5 setTitle:@"Proceed" forState:UIControlStateNormal];
        proceedBtn5.titleLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
        
        [proceedBtn5 addTarget:self action:@selector(ProceedBtn5Clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:INSURANCE_DOMAIN])
    {
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Insurance Screen" withAction:@"E-enrollment Process" withLabel:nil withValue:nil];
        
        UIButton *stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"selected_state.png"] forState:UIControlStateNormal];
        
        current_stage=current_stage+1;
        
        stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
        [stageIndicator setBackgroundImage:[UIImage imageNamed:@"blue_circle.png"] forState:UIControlStateNormal];
        
        insuranceFifth = [[InsuranceFifthViewController alloc] initWithNibName:@"InsuranceFifthViewController" bundle:nil];
        insuranceFifth.plistName=@"Insurance_Fifth.plist";
        [insuranceFifth.view.layer setCornerRadius:6];
        
        [SalesNavigaitonController pushViewController:insuranceFifth animated:YES];
        ProgressImage.image=[UIImage imageNamed:@"Kyc.png"];
        [proceedBtn3 removeFromSuperview];
        proceedBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(902, 698, 105, 29)];
        [self.view addSubview:proceedBtn4];
        [proceedBtn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [proceedBtn4 setBackgroundImage:[UIImage imageNamed:@"btn_bg_Proceed.png"] forState:UIControlStateNormal];
        [proceedBtn4 setTitle:@"Proceed" forState:UIControlStateNormal];
        proceedBtn4.titleLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
        [proceedBtn4 addTarget:self action:@selector(ProceedBtn5Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }

}

- (IBAction)ProceedBtn5Clicked:(id)sender{
    
    UIButton *stageIndicator=(UIButton *)[stageIndicators objectAtIndex:current_stage];
    [stageIndicator setBackgroundImage:[UIImage imageNamed:@"selected_state.png"] forState:UIControlStateNormal];
        
    [proceedBtn4 removeFromSuperview];
    proceedBtn5 = [[UIButton alloc] initWithFrame:CGRectMake(902, 698, 105, 29)];
    [self.view addSubview:proceedBtn5];
    [proceedBtn5 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [proceedBtn5 setBackgroundImage:[UIImage imageNamed:@"btn_bg_Proceed.png"] forState:UIControlStateNormal];
    [proceedBtn5 setTitle:@"Finish" forState:UIControlStateNormal];
    proceedBtn5.titleLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
    
    [proceedBtn5 addTarget:self action:@selector(ProceedBtn6Clicked:) forControlEvents:UIControlEventTouchUpInside];

}

- (IBAction)ProceedBtn6Clicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setStagesBreadCrumbView:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
