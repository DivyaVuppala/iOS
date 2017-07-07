//
//  InsuranceFourthViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 3/13/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "InsuranceFourthViewController.h"

@interface InsuranceFourthViewController ()

@end

@implementation InsuranceFourthViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"for_insurance.png"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
