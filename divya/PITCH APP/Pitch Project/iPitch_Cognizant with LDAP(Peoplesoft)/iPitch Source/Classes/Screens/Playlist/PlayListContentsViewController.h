//
//  PlayListContentsViewController.h
//  iPitch V2
//
//  Created by Sandhya Sandala on 15/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

@class Playlist;

#import <UIKit/UIKit.h>
#import "Playlist.h"
#import "File.h"

@protocol PlaylistFilePreviewDelegate;

@interface PlayListContentsViewController : UIViewController{
}

@property (nonatomic,strong) Playlist *playlist;
@property (nonatomic,weak) id <PlaylistFilePreviewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleItem;
@property (weak, nonatomic) IBOutlet UILabel *playListEmptyMessageLabel;
@end

@protocol PlaylistFilePreviewDelegate 

@optional

- (void)playlistFileSelected:(File *)selectedFile;

@end