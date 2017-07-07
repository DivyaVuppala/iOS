//
//  PlayListContentsViewController.m
//  iPitch V2
//
//  Created by Sandhya Sandala on 15/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "PlayListContentsViewController.h"
#import "File.h"
#import "Folder.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import "ThemeHelper.h"

@interface PlayListContentsViewController ()

@end

@implementation PlayListContentsViewController
@synthesize playlist=_playlist;
@synthesize delegate;
@synthesize playListEmptyMessageLabel;

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
    
    
    self.playListEmptyMessageLabel.text=NSLocalizedString(@"NO_DOCS_IN_PLAYLIST", @"No items in playlist add them by long pressing documents you like.");
    [self.titleItem setTitle:NSLocalizedString(@"PLAYLIST_DOCUMENTS", @"Playlist Documents")];
    
    [self.doneButton setTitle:NSLocalizedString(@"DONE", @"Done")];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ThemeHelper applyCurrentThemeToView];
}
- (void)viewDidUnload
{
    [self setPlayListEmptyMessageLabel:nil];
    [self setDoneButton:nil];
    [self setTitleItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    self.playListEmptyMessageLabel.hidden=YES;

    if ([self.playlist.playListDocuments count]==0)
    {
        self.playListEmptyMessageLabel.hidden=NO;
    }
    
    return [self.playlist.playListDocuments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell * cell = [tableView 
                              dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:SimpleTableIdentifier];
        
    }
    
    else
        
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    
    File *aFile = [[self.playlist.playListDocuments allObjects] objectAtIndex:indexPath.row];
    
    cell.textLabel.text= aFile.fileName;
//    cell.imageView.image = [UIImage imageNamed:@"pdf.png"];
    
    NSString *pathString=[NSString stringWithFormat:@"%@",aFile .filePath];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        
        UIImage *pdfThumbNailImage=[Utils generateThumbNailIconForFile:pathString WithSize:CGSizeMake(60, 60)];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            cell.imageView.image = pdfThumbNailImage;
        });
    });
    return cell;

}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [self.delegate playlistFileSelected:[[self.playlist.playListDocuments allObjects] objectAtIndex:indexPath.row]];
    
}

-(IBAction)dismissModalVC
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
