//
//  Settings.h
//  Music4You
//
//  Created by BMXStudio03 on 2/17/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "Playlist.h"
#import "AppDelegate.h"
#import "iRate.h"
#import "IAPHelper.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h> 
#define EMAIL_SUPPORT @"help.bmx2015@gmail.com"
#define EMAIL_SUPPORT_SUBJECT @"Top Music - Support"

@interface Settings : UIViewController <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewSetting;
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

@end
