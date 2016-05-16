//
//  PlayerView.m
//  Music4You
//
//  Created by BMXStudio03 on 2/18/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import "PlayerView.h"
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerView ()

{
    NSTimer *timer;
    float duration;
    BOOL check, unloop, randomVideo, showPlaylist, checkOrientation, checkInternet;
    AppDelegate *appDelegate;
    Playlist *playList;
    DataVideo *item;
    NSMutableArray *arrPLVideo, *arrID;
    MPVolumeView *volume;
    NSDictionary *playerVars;
    NSNumber *numberLoopVideo, *numberRandomVideo;
    float time;
    UIInterfaceOrientation orientation;
    CGRect rect;
    Reachability *reachabilityInfo;
}

@end

@implementation PlayerView


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    playerVars = @{
                   @"playsinline" : @1,
                   @"controls" : @1,
                   @"origin" : @"https://www.youtube.com",
                   @"showinfo" : @0,
                   @"autohide" :@1,
                   @"fs" : @0,
                   @"rel" :@0,
                   };
    _titleVideoPL.text = _titleVideoPlaylist;
    arrPLVideo = [[NSMutableArray alloc] init];
    arrID = [[NSMutableArray alloc] init];
    item = [[DataVideo alloc] init];
    
    arrPLVideo = [self loadCustomObjectWithKey:@"arrVideo"];
    for (DataVideo *itemVideo in arrPLVideo) {
        [arrID addObject:itemVideo.idVideo];
    }
    if (appDelegate.checkExistVideo == false) {
        [self loadVideo:_indexVideoChoose];
    } else {
        appDelegate.checkExistVideo = false;
    }
    
    if (showPlaylist == NO) {
        [UIView transitionFromView:_tableViewPlaylist
                            toView:_viewYTPlayer
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:nil];
        showPlaylist = YES;
        [_tableViewPlaylist removeFromSuperview];
        showPlaylist = YES;
    }
    
    
    [_tableViewPlaylist reloadData];
    
    NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    NSNumber *num1 = [_dataArchive objectAtIndex:0];
    BOOL isPurchase = [num1 boolValue];
    if (isPurchase==NO)
    {
        [self addsReceive];
        
    }
    [ self restrictRotation:NO];
    
}


- (void)viewWillLayoutSubviews {
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            _customNavi.hidden = true;
            _viewCustomControl.hidden = true;
            _viewPlayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height);
            _viewYTPlayer.center = _viewPlayer.center;
            checkOrientation = YES;
        }  else {
            _customNavi.hidden = false;
            _viewCustomControl.hidden = false;
            _viewPlayer.frame = CGRectMake(0, 110, rect.size.width, rect.size.height);
            _viewYTPlayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            _tableViewPlaylist.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            checkOrientation = NO;
        }
    } else {
        orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            _customNavi.hidden = true;
            _viewCustomControl.hidden = true;
            _viewPlayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height);
            checkOrientation = YES;
        }  else {
            _customNavi.hidden = false;
            _viewCustomControl.hidden = false;
            _viewPlayer.frame = CGRectMake(0, 66, rect.size.width, rect.size.height);
            _viewYTPlayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            _tableViewPlaylist.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            checkOrientation = NO;
        }
    }
}

-(void) restrictRotation:(BOOL) restriction
{
    appDelegate.restrictRotation = restriction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_indexVideoChoose) {
        _btnAddPL.enabled = NO;
        _btnBackVideo.enabled = NO;
        _btnNextVideo.enabled = NO;
        _btnShareVideo.enabled = NO;
        _btnPlayPause.enabled = NO;
    }
    self.view.backgroundColor = [UIColor blackColor];
    _viewPlayer.backgroundColor = [UIColor blackColor];
    _customNavi.backgroundColor = [UIColor colorWithRed:139.0/255.0 green:13.0/255.0 blue:9.0/255.0 alpha:1.0];
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width * 0.62);
        volume = [[MPVolumeView alloc] initWithFrame:CGRectMake(75, 25, [UIScreen mainScreen].bounds.size.width - 200, 30)];
        _lblTimeEnd.font = [UIFont fontWithName:@"System" size:18];
        _lblTimeStart.font = [UIFont fontWithName:@"System" size:18];
        _lblTitleVideo.font = [UIFont fontWithName:@"System" size:20];
    } else {
        rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width * 0.82);
        volume = [[MPVolumeView alloc] initWithFrame:CGRectMake(50, _viewCT4.bounds.size.height/3, [UIScreen mainScreen].bounds.size.width - 100, 30)];
    }
    appDelegate = [[AppDelegate alloc] init];
    playList = [[Playlist alloc] init];
    arrPLVideo = [[NSMutableArray alloc] init];
    arrID = [[NSMutableArray alloc] init];
    arrPLVideo = [self loadCustomObjectWithKey:@"arrVideo"];
    check = YES;
    checkOrientation = NO;
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:_customNavi];
    _viewYTPlayer.backgroundColor = [UIColor blackColor];
    [_sliderTimeVideo setThumbImage:[UIImage imageNamed:@"circle_red.png"] forState:UIControlStateNormal];
    [_sliderTimeVideo setTintColor:[UIColor redColor]];
    [_btnPlayPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [_btnNextVideo setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [_btnBackVideo setImage:[UIImage imageNamed:@"preview.png"] forState:UIControlStateNormal];
    
    [_viewCT4 addSubview:volume];
    [_btnLoop setImage:[UIImage imageNamed:@"repeat_anpha.png"] forState:UIControlStateNormal];
    [_btnRandom setImage:[UIImage imageNamed:@"random_anpha.png"] forState:UIControlStateNormal];
    [_btnAddPL setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [_btnShareVideo setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    numberLoopVideo = @0;
    numberRandomVideo = @0;
    [volume setVolumeThumbImage:[UIImage imageNamed:@"circle_white.png"] forState:UIControlStateNormal];
    [_tableViewPlaylist registerNib:[UINib nibWithNibName:@"CellCustomVideoOfPL" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAds) name:@"Purchased" object:nil];
    
    _btnAddPL.showsTouchWhenHighlighted = YES;
    _btnBack.showsTouchWhenHighlighted = YES;
    _btnBackVideo.showsTouchWhenHighlighted = YES;
    _btnLoop.showsTouchWhenHighlighted = YES;
    _btnNextVideo.showsTouchWhenHighlighted = YES;
    _btnPlayPause.showsTouchWhenHighlighted = YES;
    _btnRandom.showsTouchWhenHighlighted = YES;
    _btnShareVideo.showsTouchWhenHighlighted = YES;
    _btnShowPlaylist.showsTouchWhenHighlighted = YES;
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer = nil;
}

+ (instancetype)shareInstance{
    static PlayerView *sharedManager = nil;
    if (sharedManager == nil)
    {
        sharedManager = [[self alloc]init];
    }
    return sharedManager;
}

-(void)removeAds{
    NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    if (_dataArchive.count>0)
    {
        BOOL Purchase = YES;
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:Purchase], nil];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:arr]
                                                  forKey:@"Purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [appDelegate.banner removeFromSuperview];
    
}

-(void)addsReceive{
    if (appDelegate.banner) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        {
            [appDelegate.banner setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 90, [[UIScreen mainScreen]bounds].size.width, 90)];
            [self.view addSubview:appDelegate.banner];
        }
        else
        {
            [appDelegate.banner setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [[UIScreen mainScreen]bounds].size.width, 50)];
            [self.view addSubview:appDelegate.banner];
        }
    }
}


- (void)backView {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaultsVideoPL = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaultsVideoPL objectForKey:key];
    NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
    
    _btnAddPL.enabled = YES;
    _btnBackVideo.enabled = YES;
    _btnNextVideo.enabled = YES;
    _btnShareVideo.enabled = YES;
    _btnPlayPause.enabled = YES;
    
    
    _sliderTimeVideo.maximumValue = [_viewYTPlayer duration] - 2.0;
    _sliderTimeVideo.minimumValue = 0.0;
    _customNavi.hidden = false;
    _viewCustomControl.hidden = false;
    _viewPlayer.frame = CGRectMake(0, 64, rect.size.width, rect.size.height);
    [_viewYTPlayer setPlaybackQuality:kYTPlaybackQualitySmall];
    [_viewYTPlayer playVideo];
    [_viewYTPlayer loadPlaylistByVideos:arrID index:(int)_indexVideoChoose startSeconds:0.0f suggestedQuality:kYTPlaybackQualitySmall];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        _customNavi.hidden = true;
        _viewCustomControl.hidden = true;
        _viewPlayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height);
    }
    check = YES;
    [_tableViewPlaylist reloadData];
}

- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality {
    [_viewYTPlayer setPlaybackQuality:kYTPlaybackQualitySmall];
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
    if (state == kYTPlayerStateBuffering) {
        duration = [_viewYTPlayer duration];
        _lblTimeStart.text = @"00:00";
        NSInteger timeEND = duration;
        if (timeEND >= 3600) {
            _lblTimeEnd.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", timeEND / 3600, (timeEND / 60) % 60, timeEND % 60] ;
        } else {
            _lblTimeEnd.text = [NSString stringWithFormat:@"%02ld:%02ld", timeEND/ 60, timeEND % 60];
        }
    }
    if (state == kYTPlayerStatePaused) {
        _btnAddPL.enabled = YES;
        _btnBackVideo.enabled = YES;
        _btnNextVideo.enabled = YES;
        _btnShareVideo.enabled = YES;
        _btnPlayPause.enabled = YES;
        check = NO;
        [_btnPlayPause setImage:[UIImage imageNamed:@"continue.png"] forState:UIControlStateNormal];
    }
    if (state == kYTPlayerStatePlaying) {
        _sliderTimeVideo.maximumValue = [_viewYTPlayer duration] - 2.0;
        time = _viewYTPlayer.currentTime + 2.0;
        _checkPlay = YES;
        _btnAddPL.enabled = YES;
        _btnBackVideo.enabled = YES;
        _btnNextVideo.enabled = YES;
        _btnShareVideo.enabled = YES;
        _btnPlayPause.enabled = YES;
        [_btnPlayPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        if (!timer) {
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(valueChangedSlider) userInfo:nil repeats:YES];
        }
        check = YES;
        appDelegate.checkPlay = YES;
    }
    if (checkOrientation == NO) {
        if ((state == kYTPlayerStatePaused && _checkPlay == YES) || (state == kYTPlayerStateBuffering && _checkPlay == YES)) {
            [self continuePlay];
            appDelegate.checkPlay = YES;
        }
    }
    [_tableViewPlaylist reloadData];
}

-(void) loadVideo :(NSInteger) index {
    [_viewYTPlayer setPlaybackQuality:kYTPlaybackQualitySmall];
    _viewYTPlayer.delegate = self;
    item = arrPLVideo[index];
    [_viewYTPlayer loadWithVideoId:item.idVideo playerVars:playerVars];
    _lblTitleVideo.text = item.titleVideo;
    if (check == YES) {
        [_btnPlayPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    } else {
        [_btnPlayPause setImage:[UIImage imageNamed:@"continue.png"] forState:UIControlStateNormal];
    }
}

- (void) valueChangedSlider {
    NSInteger timeST = _viewYTPlayer.currentTime;
    NSInteger timeEND = duration;
    if (timeST >= 3600 || (timeEND - timeST) >=3600) {
        _lblTimeStart.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",timeST / 3600, (timeST / 60) % 60, timeST % 60];
        _lblTimeEnd.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (timeEND - timeST)/3600, ((timeEND - timeST)/60)%60, (timeEND - timeST) % 60] ;
    } else {
        _lblTimeStart.text = [NSString stringWithFormat:@"%02ld:%02ld", timeST / 60, timeST % 60];
        _lblTimeEnd.text = [NSString stringWithFormat:@"%02ld:%02ld", (timeEND - timeST) / 60, (timeEND - timeST) % 60];
    }
    _sliderTimeVideo.value = timeST;
    if (_viewYTPlayer.currentTime > 0) {
        if (unloop == YES) {
            [_viewYTPlayer stopVideo];
            [_btnPlayPause setImage:[UIImage imageNamed:@"continue.png"] forState:UIControlStateNormal];
            check = NO;
            unloop = NO;
        }
    }
    int i = [numberLoopVideo intValue];
    if (time != 0) {
        time = _viewYTPlayer.currentTime + 2.0;
    } else {
        time = 0;
    }
    
    if (time > duration && duration > 0)   {
        
        if (i == 0) {
            if ([numberRandomVideo isEqualToNumber:@0]) {
                if (_indexVideoChoose == arrID.count - 1) {
                    [_viewYTPlayer stopVideo];
                    [_btnPlayPause setImage:[UIImage imageNamed:@"continue.png"] forState:UIControlStateNormal];
                    unloop = YES;
                    _indexVideoChoose = 0;
                    //                    [self loadVideo:_indexVideoChoose];
                    [_viewYTPlayer playVideoAt:(int)_indexVideoChoose];
                    item = arrPLVideo[_indexVideoChoose];
                    _lblTitleVideo.text = item.titleVideo;
                } else {
                    _indexVideoChoose = _indexVideoChoose + 1;
                    //                    [self loadVideo:_indexVideoChoose];
                    [_viewYTPlayer playVideoAt:(int)_indexVideoChoose];
                    item = arrPLVideo[_indexVideoChoose];
                    _lblTitleVideo.text = item.titleVideo;
                }
            } else {
                _indexVideoChoose = arc4random() % arrID.count;
                //                [self loadVideo:_indexVideoChoose];
                [_viewYTPlayer playVideoAt:(int)_indexVideoChoose];
                item = arrPLVideo[_indexVideoChoose];
                _lblTitleVideo.text = item.titleVideo;
            }
        } else if (i == 1) {
            [_viewYTPlayer seekToSeconds:0.0 allowSeekAhead:YES];
        } else {
            if ([numberRandomVideo isEqualToNumber:@0]) {
                if (_indexVideoChoose == arrID.count - 1) {
                    _indexVideoChoose = 0;
                    //                    [self loadVideo:_indexVideoChoose];
                    [_viewYTPlayer playVideoAt:(int)_indexVideoChoose];
                    item = arrPLVideo[_indexVideoChoose];
                    _lblTitleVideo.text = item.titleVideo;
                } else {
                    _indexVideoChoose = _indexVideoChoose + 1;
                    //                    [self loadVideo:_indexVideoChoose];
                    [_viewYTPlayer playVideoAt:(int)_indexVideoChoose];
                    item = arrPLVideo[_indexVideoChoose];
                    _lblTitleVideo.text = item.titleVideo;
                }
            } else {
                _indexVideoChoose = arc4random() % arrID.count;
                //                [self loadVideo:_indexVideoChoose];
                [_viewYTPlayer playVideoAt:(int)_indexVideoChoose];
                item = arrPLVideo[_indexVideoChoose];
                _lblTitleVideo.text = item.titleVideo;
            }
        }
        time = 0;
    }
}

- (IBAction)actionValueChangedSlider:(UISlider *)sender {
    [_sliderTimeVideo addTarget:self action:@selector(sliderStart) forControlEvents:UIControlEventTouchDown];
    [_sliderTimeVideo addTarget:self action:@selector(moveSlider) forControlEvents:UIControlEventTouchDragInside];
    [_sliderTimeVideo addTarget:self action:@selector(sliderEnd) forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchCancel | UIControlEventTouchUpInside];
}

- (void)continuePlay{
    [_viewYTPlayer playVideo];
    _checkPlay = YES;
}

- (void) sliderStart {
    [_viewYTPlayer pauseVideo];
    [timer invalidate];
    timer = nil;
    _checkPlay = NO;
}

- (void) moveSlider {
    [_viewYTPlayer seekToSeconds:_sliderTimeVideo.value allowSeekAhead:YES];
    NSInteger timeST = _sliderTimeVideo.value;
    NSInteger timeEND = _sliderTimeVideo.maximumValue;
    //    NSInteger timeEND = _viewYTPlayer.duration;
    if (timeST >= 3600 || (timeEND - timeST) >=3600) {
        _lblTimeStart.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",timeST / 3600, (timeST / 60) % 60, timeST % 60];
        _lblTimeEnd.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (timeEND - timeST)/3600, ((timeEND - timeST)/60)%60, (timeEND - timeST) % 60] ;
    } else {
        _lblTimeStart.text = [NSString stringWithFormat:@"%02ld:%02ld", timeST / 60, timeST % 60];
        _lblTimeEnd.text = [NSString stringWithFormat:@"%02ld:%02ld", (timeEND - timeST) / 60, (timeEND - timeST) % 60];
    }
}

- (void) sliderEnd {
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(valueChangedSlider) userInfo:nil repeats:YES];
    }
    
    [_viewYTPlayer playVideo];
    _checkPlay = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkPlayPauseVideo:(id)sender {
    if (check == NO) {
        check = YES;
        [_viewYTPlayer playVideo];
        appDelegate.checkPlay = YES;
        _checkPlay = YES;
        [_btnPlayPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
    } else {
        [self pauseVideoPlaying];
        _checkPlay = NO;
        appDelegate.checkPlay = NO;
    }
}

- (void) pauseVideoPlaying {
    check = NO;
    
    [_viewYTPlayer pauseVideo];
    [_btnPlayPause setImage:[UIImage imageNamed:@"continue.png"] forState:UIControlStateNormal];
}

- (IBAction)nextVideo:(id)sender {
    [self nextVideoRemote];
}


- (void)nextVideoRemote{
    if ([numberRandomVideo isEqualToNumber:@0]) {
        if (_indexVideoChoose == arrID.count - 1) {
            _indexVideoChoose = 0;
            [_viewYTPlayer playVideoAt:(int)_indexVideoChoose];
        } else {
            _indexVideoChoose +=1;
            [_viewYTPlayer nextVideo];
        }
    } else {
        _indexVideoChoose = arc4random() % arrID.count;
        [_viewYTPlayer playVideoAt:(int)_indexVideoChoose];
    }
    item = arrPLVideo[_indexVideoChoose];
    _lblTitleVideo.text = item.titleVideo;
    if (check == YES) {
        [_btnPlayPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    } else {
        [_btnPlayPause setImage:[UIImage imageNamed:@"continue.png"] forState:UIControlStateNormal];
    }
}

- (void)backVideoRemote{
    if ([numberRandomVideo isEqualToNumber:@0]) {
        if (_indexVideoChoose == 0) {
            [_viewYTPlayer seekToSeconds:0.0 allowSeekAhead:YES];
        }else{
            _indexVideoChoose -=1;
            [_viewYTPlayer previousVideo];
        }
    } else {
        _indexVideoChoose = arc4random() % arrID.count;
        [_viewYTPlayer playVideoAt:(int)_indexVideoChoose];
    }
    
    item = arrPLVideo[_indexVideoChoose];
    _lblTitleVideo.text = item.titleVideo;
    
    if (check == YES) {
        [_btnPlayPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    } else {
        [_btnPlayPause setImage:[UIImage imageNamed:@"continue.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)backvideo:(id)sender {
    [self backVideoRemote];
    
}

- (IBAction)loopVideo:(id)sender {
    if ([numberLoopVideo isEqualToNumber: @0]) {
        numberLoopVideo = @1;
        [_btnLoop setImage:[UIImage imageNamed:@"repeat_1.png"] forState:UIControlStateNormal];
        _checkPlay = YES;
    } else if ([numberLoopVideo isEqualToNumber: @1]) {
        numberLoopVideo = @2;
        _checkPlay = YES;
        [_btnLoop setImage:[UIImage imageNamed:@"repeat.png"] forState:UIControlStateNormal];
    } else {
        numberLoopVideo = @0;
        _checkPlay = YES;
        [_btnLoop setImage:[UIImage imageNamed:@"repeat_anpha.png"] forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)randomVideo:(id)sender {
    if ([numberRandomVideo isEqualToNumber:@0]) {
        numberRandomVideo = @1;
        [_btnRandom setImage:[UIImage imageNamed:@"random.png"] forState:UIControlStateNormal];
    } else {
        numberRandomVideo = @0;
        [_btnRandom setImage:[UIImage imageNamed:@"random_anpha.png"] forState:UIControlStateNormal] ;
    }
}

- (IBAction)addToPlaylist:(id)sender {
    playList.videoChoose = arrPLVideo[_indexVideoChoose];
    appDelegate.tapAddPlaylist = true;
    [timer invalidate];
    timer = nil;
    UINavigationController *naviPL = [[UINavigationController alloc] initWithRootViewController:playList];
    [self presentViewController:naviPL animated:YES completion:nil];
}

- (IBAction)shareVideo:(id)sender {
    NSString *stringURL = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",item.idVideo];
    NSURL *url = [NSURL URLWithString:stringURL];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    controller.excludedActivityTypes = @[UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypeAirDrop];
    [self presentViewController:controller animated:YES completion:nil
     ];
}

- (IBAction)backToMainView:(id)sender {
    if (appDelegate.checkPlay == YES) {
        _checkPlay = YES;
    } else {
        _checkPlay = NO;
    }
    appDelegate.checkPlaying +=1;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
}

- (IBAction)showPlaylist:(id)sender {
    appDelegate.checkExistVideo = true;
    [self showList];
    
    
}
- (void)showList {
    if (showPlaylist == YES) {
        [UIView transitionFromView:_viewYTPlayer
                            toView:_tableViewPlaylist
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:nil];
        [_viewPlayer addSubview:_tableViewPlaylist];
        showPlaylist = NO;
        //        [self continuePlay];
    } else {
        [UIView transitionFromView:_tableViewPlaylist
                            toView:_viewYTPlayer
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:nil];
        showPlaylist = YES;
        [_tableViewPlaylist removeFromSuperview];
    }
}



#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _indexVideoChoose = indexPath.row;
    [self loadVideo:indexPath.row];
    [UIView transitionFromView:_tableViewPlaylist
                        toView:_viewYTPlayer
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:nil];
    showPlaylist = YES;
    [_tableViewPlaylist removeFromSuperview];
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrPLVideo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellCustomVideoOfPL *cell = (CellCustomVideoOfPL *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self customCell:cell :indexPath.row];
    if (indexPath.row == _indexVideoChoose) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    return cell;
}
-(void)customCell : (CellCustomVideoOfPL *)cellCT :(NSInteger)indexpath {
    DataVideo *temp = [[DataVideo alloc] init];
    temp = arrPLVideo[indexpath];
    [cellCT.imageThumbnail setImageWithURL:[NSURL URLWithString:temp.thumbnailVideo] placeholderImage:[UIImage imageNamed:@"search.png"]];
    cellCT.lblNameVideo.text = temp.titleVideo;
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
