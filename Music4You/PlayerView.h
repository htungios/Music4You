//
//  PlayerView.h
//  Music4You
//
//  Created by BMXStudio03 on 2/18/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "DataVideo.h"
#import "AppDelegate.h"
#import "Playlist.h"
#import "CellCustomVideoOfPL.h"



@interface PlayerView : UIViewController <YTPlayerViewDelegate>
@property (strong, nonatomic) IBOutlet YTPlayerView *viewYTPlayer;
@property (strong, nonatomic) IBOutlet UIView *viewCustomControl;
@property (strong, nonatomic) IBOutlet UIView *viewCT1;
@property (strong, nonatomic) IBOutlet UIView *viewCT2;
@property (strong, nonatomic) IBOutlet UIView *viewCT3;
@property (strong, nonatomic) IBOutlet UIView *viewCT4;
@property (strong, nonatomic) IBOutlet UIView *viewCT5;
@property (strong, nonatomic) IBOutlet UIView *viewPlayer;
@property (strong, nonatomic) IBOutlet UIView *viewPlaylist;
@property ( nonatomic) NSInteger indexVideoChoose;
@property (strong, nonatomic) IBOutlet UISlider *sliderTimeVideo;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleVideo;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeStart;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeEnd;
@property (strong, nonatomic) IBOutlet UIButton *btnBackVideo;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayPause;
@property (strong, nonatomic) IBOutlet UIButton *btnNextVideo;
@property (strong, nonatomic) IBOutlet UIButton *btnLoop;
@property (strong, nonatomic) IBOutlet UIButton *btnShareVideo;
@property (strong, nonatomic) IBOutlet UIButton *btnAddPL;
@property (strong, nonatomic) IBOutlet UIButton *btnRandom;
@property (strong, nonatomic) IBOutlet UIView *customNavi;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnShowPlaylist;
@property (strong, nonatomic) IBOutlet UITableView *tableViewPlaylist;
@property (strong, nonatomic) IBOutlet UIImageView *imgMute;
@property (strong, nonatomic) IBOutlet UIImageView *imgVolume;
@property (strong, nonatomic) IBOutlet UILabel *titleVideoPL;
@property (strong, nonatomic) NSString *titleVideoPlaylist;
@property (nonatomic) BOOL checkPlay;

+ (instancetype)shareInstance;
- (void)continuePlay;
- (void)pauseVideoPlaying;
- (void)nextVideoRemote;
- (void)backVideoRemote;
@end
