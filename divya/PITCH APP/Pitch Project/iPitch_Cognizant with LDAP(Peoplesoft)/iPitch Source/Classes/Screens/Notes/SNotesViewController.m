//
//  SNotesViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 2/13/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "SNotesViewController.h"
#import "iPitchConstants.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Notes.h"
#import <QuartzCore/QuartzCore.h>
#import "ThemeHelper.h"


@interface SNotesViewController ()
{
    Notes *currentNote;
    NSIndexPath *indexPathOfRowSwiped;
}
@end

@implementation SNotesViewController

@synthesize noteSaveButton=_noteSaveButton;
@synthesize noteCancelButton=_noteCancelButton;
@synthesize managedObjectContext;

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

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
    self.navigationController.navigationBarHidden=YES;
    self.managedObjectContext=SAppDelegateObject.managedObjectContext;
    self.view.layer.cornerRadius=6;
   // self.noteView.text=[Utils userDefaultsGetObjectForKey:@"iPitchNotes"];
   // [self.noteView becomeFirstResponder];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden=YES;
    [ThemeHelper applyCurrentThemeToView];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNoteSaveButton:nil];
    [self setNoteCancelButton:nil];
    [self setNotesEmailButton:nil];
    [self setPreviousNotesTableView:nil];
    [self setAddNewNoteButton:nil];
    [self setEmptyNotesLabel:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
- (IBAction)noteCancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)noteSaveButtonCancelled:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
   // [Utils userDefaultsSetObject:self.noteView.text forKey:@"iPitchNotes"];
}

- (IBAction)notesEmailButtonClicked:(id)sender
{

    //[self dismissModalViewControllerAnimated:YES];
    
   // [Utils userDefaultsSetObject:self.noteView.text forKey:@"iPitchNotes"];

    //[SAppDelegateObject sendMailToRecipients:nil withSubject:@"Mailing Notes" andMessage:self.noteView.text];
}


#pragma mark TableView Datasource


-(CGFloat)getLabelHeightForIndex:(NSIndexPath *)index
{
    CGSize maximumSize = CGSizeMake(900, 200);
    CGSize labelHeighSize = [((Notes *) [SAppDelegateObject.notesArray objectAtIndex:index.row]).noteContent  sizeWithFont: [UIFont fontWithName:FONT_REGULAR size:16.0f] constrainedToSize:maximumSize];
    // NSLog(@"label size in fn:%f",labelHeighSize.height);
    return labelHeighSize.height;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tempHeight = [self getLabelHeightForIndex:indexPath];
    
    if (tempHeight<=19) {
        return 100;
    }
    
    else{
        return 150;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([SAppDelegateObject.notesArray count] == 0 ) {
        self.emptyNotesLabel.hidden=NO;
    }
    
    else
    {
        self.emptyNotesLabel.hidden=YES;
    }
    
    
    return [SAppDelegateObject.notesArray count];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if(cell == nil)
    {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    else
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    
    [cell setDelegate:self];
    
    [cell setFirstStateIconName:@"check.png"
                     firstColor:[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
            secondStateIconName:@"cross.png"
                    secondColor:[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]
                  thirdIconName:nil
                     thirdColor:nil
                 fourthIconName:nil
                    fourthColor:nil];
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];    
   
    [cell setMode:MCSwipeTableViewCellModeExit];

    cell.selectionStyle=UITableViewCellSelectionStyleGray;
  
    cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:18];
    cell.textLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];

    cell.detailTextLabel.numberOfLines=0;
    cell.detailTextLabel.font=[UIFont fontWithName:FONT_REGULAR size:16];
    cell.detailTextLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];

    cell.textLabel.text= ((Notes *) [SAppDelegateObject.notesArray objectAtIndex:indexPath.row]).noteTitle;
    cell.detailTextLabel.text= ((Notes *) [SAppDelegateObject.notesArray objectAtIndex:indexPath.row]).noteContent;
    
    return cell;
}


#pragma mark TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoteDetailViewController *noteDetail=[[NoteDetailViewController alloc]initWithNibName:@"NoteDetailViewController" bundle:nil];
    noteDetail.delegate=self;
    noteDetail.noteTitle=((Notes *) [SAppDelegateObject.notesArray objectAtIndex:indexPath.row]).noteTitle;
    noteDetail.noteContent=((Notes *) [SAppDelegateObject.notesArray objectAtIndex:indexPath.row]).noteContent;
    noteDetail.existingNote=NO;
    [self.navigationController pushViewController:noteDetail animated:YES];
}

#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode
{
    if (mode == MCSwipeTableViewCellModeExit) {
                
        UIAlertView *rowSwipeAlert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"CONFIRM", @"Confirm") message:NSLocalizedString(@"DELETE_NOTE_MESSAGE", @"Are you sure, you want to delete this note?")  delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"No")  otherButtonTitles:NSLocalizedString(@"YES", @"Yes") , nil];
        
        [rowSwipeAlert show];
        
        indexPathOfRowSwiped=[self.previousNotesTableView indexPathForCell:cell];

    }
}

- (IBAction)addNewNoteButtonClicked:(id)sender
{
    NoteDetailViewController *noteDetail=[[NoteDetailViewController alloc]initWithNibName:@"NoteDetailViewController" bundle:nil];
    noteDetail.delegate=self;
    noteDetail.existingNote=NO;
    [self.navigationController pushViewController:noteDetail animated:YES];
}

#pragma mark AlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        //do nothing.
        [self.previousNotesTableView reloadData];
    }
    
    else if(buttonIndex==1)
    {
        Notes *note=[SAppDelegateObject.notesArray objectAtIndex:indexPathOfRowSwiped.row];
        
        [SAppDelegateObject.notesArray removeObject:note];
        
        [self.previousNotesTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathOfRowSwiped] withRowAnimation:UITableViewRowAnimationFade];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTES_DELETED_NOTIFICATION object:note.noteID];

    }
}

#pragma mark NoteDetailDelegate

-(void)noteSaveClicked:(BOOL)noteStatus
{
    if(noteStatus)
    [self dismissModalViewControllerAnimated:YES];
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.previousNotesTableView reloadData];
        
    }
}
@end
