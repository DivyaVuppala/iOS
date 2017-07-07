//
//  SalesProcessViewController.h
//  iPitch V2
//
//  Created by Vineet on 26/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvestmentViewController.h"
#import "SuitabilityAnalysisViewController.h"
#import "cispViewController.h"
#import "ReviewClientViewController.h"
#import "KYCController.h"
#import "InsuranceFirstViewController.h"
#import "InsuranceSecondViewController.h"
#import "InsuranceThirdViewController.h"
#import "InsuranceFifthViewController.h"
#import "InsuranceFourthViewController.h"

@interface SalesProcessViewController : UIViewController{
    InvestmentViewController *investmentView;
    SuitabilityAnalysisViewController *suitableAnalysisView;
    cispViewController * cispView;
    ReviewClientViewController * reviewView;
    InsuranceFirstViewController *insuranceFirst;
    InsuranceSecondViewController *insuranceSecond;
    InsuranceThirdViewController *insuranceThird;
    InsuranceFifthViewController *insuranceFifth;
    InsuranceFourthViewController *insuranceFourth;
    kYCController *KYCView;
    UIButton *proceedBtn2;
    UIButton *proceedBtn3;
    UIButton *proceedBtn4;
    UIButton *proceedBtn5;
    
    int number_of_stages;
    int current_stage;
    
    NSMutableArray *stageIndicators;
    
}
@property (weak, nonatomic) IBOutlet UIView *stagesBreadCrumbView;

@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property (weak, nonatomic) IBOutlet UIButton *ProceedButton;
@property (weak, nonatomic) IBOutlet UIImageView *ProgressImage;
@property (strong, nonatomic) NSMutableDictionary *stagesDictionary;
@property (strong, nonatomic) NSMutableArray *stagesArray;
@property(nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property(nonatomic, retain) IBOutlet UIButton *UserIcon;
@property(nonatomic, retain) IBOutlet UIButton *Searchbtn;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonClicked:(id)sender;

- (IBAction)ProceedButtonClicked:(id)sender;


@end
