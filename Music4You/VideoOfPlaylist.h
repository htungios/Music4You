//
//  VideoOfPlaylist.h
//  Music4You
//
//  Created by BMXStudio03 on 2/19/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playlist.h"
#import "CellCustomVideoOfPL.h"
#import "DataVideo.h"
#import "PlayerView.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>


@interface VideoOfPlaylist : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableViewVideoOfPL;
@property (strong, nonatomic) NSString *strIndexVideo;

@end
