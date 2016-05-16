//
//  MainView.h
//  Music4You
//
//  Created by BMXStudio03 on 2/16/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataVideo.h"
#import "CellCustomMainView.h"
#import "Playlist.h"
#import "Settings.h"
#import "PlayerView.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>

@interface MainView : UIViewController <UISearchBarDelegate, UISearchResultsUpdating, UIActionSheetDelegate, UISearchDisplayDelegate, UISearchControllerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewVideo;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarr;
//@property (strong, nonatomic) UISearchBar *searchBarr;
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
+ (instancetype)shareInstance;
@end
