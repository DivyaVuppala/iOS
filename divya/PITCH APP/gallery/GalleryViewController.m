//
//  GalleryViewController.m
//  Treatment Plan
//
//  Created by Divya Vuppala on 20/05/15.
//
//
#import "GalleryView.h"
#import "GalleryViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.view = [[GalleryView alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    // Do any additional setup after loading the view.
////    GalleryView *gv=[[GalleryView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
////    [self.view addSubview:gv];
//    
//    GalleryView *gv=[[GalleryView alloc]initWithFrame:CGRectMake(0, 0, 568, 984)];
//    self.view = gv;
//    self.view = gv;
    //self.view.backgroundColor=[UIColor blackColor];

    self.view.backgroundColor = [UIColor grayColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
