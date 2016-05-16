//
//  Playlist.h
//  Music4You
//
//  Created by BMXStudio03 on 2/17/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataVideo.h"
#import "VideoOfPlaylist.h"
#import "MainView.h"
#import "Settings.h"
#import "PlayerView.h"
#import "AppDelegate.h"
#import "CellCustomPlaylist.h"
#import "CellAddNewPlaylist.h"
#import <UIImageView+AFNetworking.h>
@interface Playlist : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableViewPlaylist;
@property (strong, nonatomic) IBOutlet UIView *viewMenu;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *iconTopTrending;
@property (strong, nonatomic) IBOutlet UILabel *lblTopTrending;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *iconPlaylist;
@property (strong, nonatomic) IBOutlet UILabel *lblPlaylist;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *iconSettings;
@property (strong, nonatomic) IBOutlet UILabel *lblSettings;
@property (strong, nonatomic) DataVideo *videoChoose;

@end
