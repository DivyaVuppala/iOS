//
//  GalleryView.m
//  Treatment Plan
//
//  Created by Divya Vuppala on 19/05/15.
//
//

#import "GalleryView.h"

@implementation GalleryView
{
    BOOL markerClicked;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)init
{
    self = [super init];

   
    
    UIView*mainView = [[[NSBundle mainBundle] loadNibNamed:@"GalleryView" owner:self options:nil] objectAtIndex:0];
    
   [self addSubview:mainView];
    
    //self.backgroundColor=[UIColor blackColor];
    UIView *holderView=[[UIView alloc]initWithFrame:CGRectMake(680, 280, 50, 110)];
    holderView.backgroundColor=[UIColor whiteColor];
    //undo image
    UIImageView *undoImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"undoBackground.png"]] autorelease];
    [undoImage setFrame:CGRectMake(700, 120, undoImage.image.size.width, undoImage.image.size.height)];
    [holderView addSubview:undoImage];
    
    //undo image
    UIImageView *redoImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"undoBackground.png"]] autorelease];
    [redoImage setFrame:CGRectMake(700, 190, redoImage.image.size.width, redoImage.image.size.height)];
    [holderView addSubview:redoImage];
    
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [undoButton setImage:[UIImage imageNamed:@"undo-button.png"] forState:UIControlStateNormal];
    [undoButton setFrame:CGRectMake(710, 130, 47, 48)];
    [undoButton addTarget:self action:@selector(undoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [holderView addSubview:undoButton];
    
    UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redoButton setImage:[UIImage imageNamed:@"redo-button.png"] forState:UIControlStateNormal];
    [redoButton setFrame:CGRectMake(710, 199, 47, 48)];
    [redoButton addTarget:self action:@selector(redoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [holderView addSubview:redoButton];
    [self addSubview:holderView];

    
    UIButton *markerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [markerButton setImage:[UIImage imageNamed:@"anatomyBtn-normal"] forState:UIControlStateNormal];
    [markerButton setFrame:CGRectMake(710, 150, 56,130)];
    [markerButton addTarget:self action:@selector(markerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:markerButton];
   
    
    markerClicked=NO;
   
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClicked:)];
    [optionalImageViewOne addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClicked:)];
    [optionalImageViewTwo addGestureRecognizer:tapGesture2];
    
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClicked:)];
    [optionalImageViewThree addGestureRecognizer:tapGesture3];
    [self imageClicked:tapGesture3];
    return self;
    
    
}




//-(void)markerButtonPressed:(id)sender
//{
//    markerClicked=YES;
//    UIAlertView *view=[[UIAlertView alloc]initWithTitle:@"kusbdfdsf" message:@"SDFSDF" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [view show];
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (markerClicked) {
        //draw the views
        UITouch *touch = [touches anyObject];
        
        // Get the specific point that was touched
        CGPoint point = [touch locationInView:touch.view];
        //NSLog(@"X location: %f", point.x);
       // NSLog(@"Y Location: %f",point.y);
    
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(touch.view.frame.origin.x, point.y, touch.view.frame.size.width, 1)];
        UIImageView *crossMarkImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"App Icon.png"]];
        crossMarkImageView.frame=CGRectMake(point.x, point.y, 40, 40);
        [self addSubview:lineView];
        [lineView addSubview:crossMarkImageView];
    }
}


-(void)imageClicked:(UITapGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.view==optionalImageViewOne)
    {
        mainImageView.image=optionalImageViewOne.image;
    }
    else if(gestureRecognizer.view==optionalImageViewTwo)
    {
        mainImageView.image=optionalImageViewTwo.image;
    }
    else
    {
        mainImageView.image=optionalImageViewThree.image;
    }
    
}
//- (void)dealloc {
//    [galleryView release];
//    [mainImageView release];
//    [optionalImageViewOne release];
//    [optionalImageViewTwo release];
//    [optionalImageViewThree release];
//    [super dealloc];
//}
- (void)dealloc {
    [super dealloc];
}
@end
