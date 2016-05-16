//
//  MainView.m
//  Music4You
//
//  Created by BMXStudio03 on 2/16/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import "MainView.h"



@interface MainView ()
{
    NSString *nextPageToken, *textSearch;
    NSMutableArray *arrVideo, *arrPassing;
    BOOL search, tapMenu, searchIos7, checkInternet, continuesSearch;
    NSInteger index, tagButton;
    UIView *viewGhost;
    DataVideo *dataVideo;
    Playlist * playList;
    Settings *settings;
    PlayerView *playView;
    AppDelegate *appDelegate;
    UIDeviceOrientation previousOrientation;
    Reachability *reachabilityInfo;
    UIRefreshControl *refreshControl;
    UIAlertView *alter ;
    
}

@end

@implementation MainView

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self tapHiddenMenu];
    appDelegate.tapAddPlaylist = false;
    
    
    [self restrictRotation:YES];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *arrArchive = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSNumber *number = [arrArchive objectAtIndex:0];
    BOOL isPurchase = [number boolValue];
    if (!isPurchase) {
        [self addsReceive];
        appDelegate.checkMainView +=1;
        if (appDelegate.checkMainView == 3) {
            [appDelegate showAds:self];
            appDelegate.checkMainView = 0;
        }
        
        if (appDelegate.checkPlaying == 2) {
            [appDelegate showAds:self];
            appDelegate.checkPlaying = 0;
        }
        
        
    }
    
    
    //    [_tableViewVideo reloadData];
}



- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    UIDevice* device = [UIDevice currentDevice];
    if (previousOrientation != device.orientation) {
        NSNumber *value = [NSNumber numberWithInt:previousOrientation];
        [device setValue:value forKey:@"orientation"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status != NotReachable)
    {
        checkInternet = YES;
    }
    [_tableViewVideo registerNib:[UINib nibWithNibName:@"CellCustomMainView" bundle:nil] forCellReuseIdentifier:@"Cell"];
    _tableViewVideo.tag = 0;
    self.title = @"Trending Music";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:139.0/255.0 green:13.0/255.0 blue:9.0/255.0 alpha:1.0];
    arrVideo = [[NSMutableArray alloc] init];
    arrPassing = [[NSMutableArray alloc] init];
    playList = [[Playlist alloc] init];
    settings = [[Settings alloc] init];
    playView = [PlayerView shareInstance];
    alter = [[UIAlertView alloc] init];
    [self.view addSubview:_searchBarr];
    //    if ([UISearchController class]) {
    //        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //        self.searchController.searchResultsUpdater = self;
    //        self.searchController.dimsBackgroundDuringPresentation = NO;
    //        self.searchController.searchBar.delegate = self;
    //        self.searchController.searchBar.text = textSearch;
    //        self.tableViewVideo.tableHeaderView = self.searchController.searchBar;
    //        [self.searchController.searchBar sizeToFit];
    //        self.definesPresentationContext = YES;
    //
    //    } else {
    //        _searchBarr = [[UISearchBar alloc] init];
    //        _searchBarr.delegate = self;
    //        _searchBarr.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 38);
    //        _tableViewVideo.tableHeaderView = _searchBarr;
    //        [_tableViewVideo addSubview:_searchBarr];
    
    //    }
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    tapMenu = true;
    search = false;
    if (appDelegate.searchVideo == true) {
        if (appDelegate.tapAddPlaylist == false) {
            [self getDataVideoInPlaylist];
            appDelegate.searchVideo = false;
        } else {
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"search"];
            [self getIDVideoYT:str];
        }
    } else{
        arrVideo = [self loadCustomObjectWithKey:@"arrVideoMain"];
        nextPageToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"nextPageToken"];
    }
    
    
    
    reachabilityInfo = [Reachability reachabilityWithHostName:@"google.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myReachabilityDidChangedMethod)
                                                 name:kReachabilityChangedNotification
                                               object:reachabilityInfo];
    
    
    
    [reachabilityInfo startNotifier ];
    
    refreshControl = [UIRefreshControl new];
    refreshControl.tintColor = [UIColor colorWithRed:1 green:0.047 blue:0.6313 alpha:1];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tableViewVideo addSubview:refreshControl];
    [_tableViewVideo sendSubviewToBack:refreshControl];
    
    if([IAPHelper sharedHelper].products.count == 0)
    {
        [[IAPHelper sharedHelper] requestProducts];
    }
    
    NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    NSNumber *num1 = [_dataArchive objectAtIndex:0];
    BOOL isPurchase = [num1 boolValue];
    if (isPurchase==NO)
    {
        [appDelegate loadBanner];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAds) name:@"Purchased" object:nil];
    
    
    
    
}


-(void) restrictRotation:(BOOL) restriction
{
    appDelegate.restrictRotation = restriction;
}

-(void)removeAds{
    /// set frame
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
    [_tableViewVideo setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
}


- (void)myReachabilityDidChangedMethod {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alter = [alter initWithTitle:@"Warning"
                             message:@"No internet access ! Please check to network setting!"
                            delegate:nil
                   cancelButtonTitle:@"OK"
                   otherButtonTitles: nil];
        [alter show];
        alter = nil;
        
    }
    else if (status != NotReachable && checkInternet == NO) {
        alter = [[UIAlertView alloc]  initWithTitle:@"Warning"
                                            message:@"Drag view to refresh data !"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alter show];
        checkInternet = YES;
        
        
        NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
        NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
        NSNumber *num1 = [_dataArchive objectAtIndex:0];
        BOOL isPurchase = [num1 boolValue];
        if (isPurchase==NO)
        {
            [appDelegate loadBanner];
            [appDelegate loadAds];
        }
        
    } else if (status != NotReachable) {
        alter = [[UIAlertView alloc] init];
    }
}


-(void)refreshView:(UIRefreshControl*)refresh{
    nextPageToken = nil;
    [arrVideo removeAllObjects];
    [arrPassing removeAllObjects];
    
    if (appDelegate.tapAddPlaylist == false) {
        [self getDataVideoInPlaylist];
    } else {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"search"];
        [self getIDVideoYT:str];
    }
    [_tableViewVideo reloadData];
    [refresh endRefreshing];
}


- (void)viewWillLayoutSubviews {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"top_trending.png"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(tapMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Playing"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(tapToPlaying)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0];
    
    
    
}


-(void)addsReceive{
    if (appDelegate.banner) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        {
            [appDelegate.banner setFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 90-64, [[UIScreen mainScreen]bounds].size.width, 90)];
            [_tableViewVideo setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 90-44)];
            [self.view addSubview:appDelegate.banner];
        }
        else
        {
            
            [_tableViewVideo setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 50-44)];
            [appDelegate.banner setFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 50-64, [[UIScreen mainScreen]bounds].size.width, 50)];
            [self.view addSubview:appDelegate.banner];
        }
    }
    
}
+ (instancetype)shareInstance{
    static MainView *sharedManager = nil;
    if (sharedManager == nil)
    {
        sharedManager = [[self alloc]init];
    }
    return sharedManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UISearchController

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    if (searchString.length > 0) {
        search = true;
        [self getDataSearchYT:searchString];
        textSearch = searchController.searchBar.text;
        [self.tableViewVideo reloadData];
    } else {
        search = false;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBarr resignFirstResponder];
    search = false;
    [arrPassing removeAllObjects];
    [arrVideo removeAllObjects];
    nextPageToken = nil;
    _searchBarr.showsCancelButton = NO;
    continuesSearch = false;
    appDelegate.searchVideo = false;
    _searchBarr.text = nil;
    //    [self getDataVideoInPlaylist];
    arrVideo = [self loadCustomObjectWithKey:@"arrVideoMain"];
    nextPageToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"nextPageToken"];
    [_tableViewVideo reloadData];
}


#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _searchBarr.showsCancelButton = YES;
    _searchBarr.text = @"";
    search = true;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length > 0) {
        search = true;
        [arrPassing removeAllObjects];
        [self getDataSearchYT:searchText];
        [self.tableViewVideo reloadData];
    }
    
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.searchBarr.text.length == 0) {
        search = false;
        self.searchBarr.showsCancelButton = NO;
    }
    [self.searchBarr resignFirstResponder];
    
}


- (void)ontap {
    [_searchDisplayController setActive:NO animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    search = false;
    nextPageToken = nil;
    //    _searchController.active = false;
    [arrVideo removeAllObjects];
    [arrPassing removeAllObjects];
    //    if ([UISearchController class]) {
    //        self.searchController.searchBar.text = textSearch;
    //        [self getIDVideoYT:textSearch];
    //    } else {
    [self getIDVideoYT:searchBar.text];
    textSearch = searchBar.text;
    //    }
    [_searchBarr resignFirstResponder];
    _searchBarr.showsCancelButton = NO;
    [self.tableViewVideo reloadData];
    continuesSearch = YES;
    appDelegate.searchVideo = YES;
}


- (void)tapMenu {
    if (tapMenu == true) {
        _iconTopTrending.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_trending.png"]];
        _iconPlaylist.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"playlist.png"]];
        _iconSettings.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"setting.png"]];
        _lblTopTrending.text = @"Trending Music";
        _lblPlaylist.text = @"Playlists";
        _lblSettings.text = @"Settings";
        UITapGestureRecognizer *tapView1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView1)];
        [_view1 addGestureRecognizer:tapView1];
        UITapGestureRecognizer *tapView2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView2)];
        [_view2 addGestureRecognizer:tapView2];
        UITapGestureRecognizer *tapView3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView3)];
        [_view3 addGestureRecognizer:tapView3];
        viewGhost = [[UIView alloc] init];
        viewGhost.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHiddenMenu)];
        [viewGhost addGestureRecognizer:tap];
        [viewGhost addSubview:_viewMenu];
        
        [self.view addSubview:viewGhost];
        _viewMenu.hidden = false;
        [_viewMenu layoutSubviews];
        tapMenu = false;
        [UIView animateWithDuration:0.5
                         animations:^{
                             _viewMenu.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 132);
                         }];
        
    } else {
        [UIView animateWithDuration:0.5
                         animations:^{
                             _viewMenu.frame = CGRectMake(0, -132, [UIScreen mainScreen].bounds.size.width, 132);
                         }];
        tapMenu = true;
        viewGhost.hidden = true;
    }
}

- (void)tapToPlaying {
    appDelegate.checkExistVideo = true;
    [self presentViewController:[PlayerView shareInstance] animated:YES completion:nil];
}


- (void)tapHiddenMenu {
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         _viewMenu.frame = CGRectMake(0, -132, [UIScreen mainScreen].bounds.size.width, 132);
                     }];
    tapMenu = true;
    viewGhost.hidden = true;
}
- (void)tapView1 {
    if ([self isMemberOfClass:[MainView class]]) {
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             _viewMenu.frame = CGRectMake(0, -132, [UIScreen mainScreen].bounds.size.width, 132);
                         }];
        tapMenu = true;
        viewGhost.hidden = true;
        arrPassing = [[NSMutableArray alloc] init];
        arrVideo = [[NSMutableArray alloc] init];
        nextPageToken = nil;
        
        ////// prepair
        if (continuesSearch == true) {
            [self getDataVideoInPlaylist];
            _searchBarr.text = nil;
            [_tableViewVideo reloadData];
        }
        
        continuesSearch = false;
        appDelegate.searchVideo = false;
        
        
    }
}

- (void)tapView2 {
    [self.navigationController pushViewController:playList animated:YES];
}

- (void)tapView3 {
    [self.navigationController pushViewController:settings animated:YES];
}


- (void)ShowActionSheet : (UIButton*) sender { // dùng uibutton để có thể lấy chỉ số hiện tại của cell dc click
    if ([UIAlertController class]) {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* addToPlaylist = [UIAlertAction
                                        actionWithTitle:@"Add to playlist"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            //Do some thing here
                                            playList.videoChoose = arrVideo[sender.tag];
                                            appDelegate.tapAddPlaylist = true;
                                            UINavigationController *nvPlaylist = [[UINavigationController alloc] initWithRootViewController:playList];
                                            [self presentViewController:nvPlaylist animated:YES completion:nil];
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                        }];
        UIAlertAction* shareApp = [UIAlertAction
                                   actionWithTitle:@"Share"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       NSString *stringURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/muzi-tube-free-music-video/id1088745426?ls=1&mt=8"];
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
                                       [self presentViewController:controller animated:YES completion:nil];
                                       [view dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [view addAction:addToPlaylist];
        [view addAction:shareApp];
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else {
        tagButton = sender.tag;
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:
                                @"Add to playlist",
                                @"Share",
                                nil];
        [popup showInView:self.view];
        
    }
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
        {
            playList.videoChoose = arrVideo[tagButton];
            appDelegate.tapAddPlaylist = true;
            UINavigationController *nvPlaylist = [[UINavigationController alloc] initWithRootViewController:playList];
            [self presentViewController:nvPlaylist animated:YES completion:nil];
        }
            break;
        case 1:
        {
            NSString *stringURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/muzi-tube-free-music-video/id1088745426?ls=1&mt=8"];
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
            [self presentViewController:controller animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)saveCustomObject:(NSMutableArray *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaultsVideoPL = [NSUserDefaults standardUserDefaults];
    [defaultsVideoPL setObject:encodedObject forKey:key];
    [defaultsVideoPL synchronize];
    
}

- (NSMutableArray *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaultsVideoPL = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaultsVideoPL objectForKey:key];
    NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}


#pragma mark Get data youtube

- (void)getDataSearchYT :(NSString *)stringSearchVideo {
    NSString *stringSearch = [NSString stringWithFormat:@"http://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=%@",stringSearchVideo];
    stringSearch = [stringSearch stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:stringSearch];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //        NSLog(@"%@",responseObject);
        NSMutableArray *recipesData = responseObject;
        NSArray *arr = [recipesData objectAtIndex:1];
        [arrPassing removeAllObjects];
        [arrPassing addObjectsFromArray:arr];
        [_searchController becomeFirstResponder];
        [_tableViewVideo performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error.description);
    }];
}

- (void)getDataVideoInPlaylist {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strURL = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails&playlistId=PLDcnymzs18LVXfO_x0Ei0R24qDbVtyy66&maxResults=20&key=AIzaSyDTpypPNBXpFNj5DVnDR46FEXeVilDdc4M"];
    if (nextPageToken) {
        strURL = [NSString stringWithFormat:@"%@&pageToken=%@",strURL,nextPageToken];
    }
    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:strURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        //        NSLog(@"%@",responseObject);
        nextPageToken = [responseObject objectForKey:@"nextPageToken"];
        NSDictionary *dictChildren = [responseObject objectForKey:@"items"];
        for (id item in dictChildren) {
            [self getDataVideoFromIDVideoYT:[[item objectForKey:@"contentDetails"] objectForKey:@"videoId"]];
        }
        [_tableViewVideo reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error.description);
    }];
    
}

- (void)getIDVideoYT :(NSString *)strSearch {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strURL = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=20&q=%@&type=video&videoEmbeddable=true&key=AIzaSyDTpypPNBXpFNj5DVnDR46FEXeVilDdc4M",strSearch];
    NSLog(@"%@", strSearch);
    if (nextPageToken) {
        strURL = [NSString stringWithFormat:@"%@&pageToken=%@",strURL,nextPageToken];
    }
    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:strURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        nextPageToken = [responseObject objectForKey:@"nextPageToken"];
        NSDictionary *dictChildren = [responseObject objectForKey:@"items"];
        for (id item in dictChildren) {
            [self getDataVideoFromIDVideoYT:[[item objectForKey:@"id"] objectForKey:@"videoId"]];
        }
        [_tableViewVideo reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error.description);
    }];
}

- (void) getDataVideoFromIDVideoYT:(NSString*)videoID {
    NSString *stringURL = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet,contentDetails,statistics,status&id=%@&key=AIzaSyDTpypPNBXpFNj5DVnDR46FEXeVilDdc4M",videoID];
    stringURL = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *dictChildren = [dict objectForKey:@"items"];
        for (id item in dictChildren) {
            dataVideo = [[DataVideo alloc] init];
            dataVideo.idVideo = videoID;
            dataVideo.titleVideo = [[item objectForKey:@"snippet"] objectForKey:@"title"];
            dataVideo.thumbnailVideo = [[[[item objectForKey:@"snippet"] objectForKey:@"thumbnails"] objectForKey:@"default"] objectForKey:@"url"];
            [arrVideo addObject:dataVideo];
        }
    }
    if (arrVideo.count == 20) {
    }
    
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (search == true ) {
        return arrPassing.count;
    } else {
        //        [self saveCustomObject:arrVideo key:@"arrVideo"];
        if (arrVideo.count > 0 && appDelegate.searchVideo == false) {
            [self saveCustomObject:arrVideo key:@"arrVideoMain"];
            [[NSUserDefaults standardUserDefaults] setObject:nextPageToken forKey:@"nextPageToken"];
        }
        
        return arrVideo.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (search == true) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
        }
        [self customCellSearch:cell :indexPath.row];
        return  cell;
    } else {
        CellCustomMainView *cell = (CellCustomMainView *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[CellCustomMainView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        [self customCell:cell :indexPath.row];
        if (continuesSearch == false) {
            if (arrVideo.count - 1 == indexPath.row && nextPageToken != nil) {
                [self getDataVideoInPlaylist];
            }
        } else {
            if (arrVideo.count - 1 == indexPath.row && nextPageToken != nil) {
                [self getIDVideoYT:textSearch];
                NSLog(@"%@",textSearch);
            }
        }
        
        return cell;
    }
    return  nil;
}


- (void)customCellSearch : (UITableViewCell *)cellCT : (NSInteger)indexpath {
//    cellCT.thumbnailVideo.hidden = true;
//    cellCT.btnAdd.hidden = true;
//    cellCT.titleVideo.text = arrPassing[indexpath];
    cellCT.textLabel.text = arrPassing[indexpath];
}

- (void)customCell : (CellCustomMainView *)cellCT :(NSInteger)indexpath {
    DataVideo *item = arrVideo[indexpath];
    cellCT.thumbnailVideo.hidden = false;
    cellCT.btnAdd.hidden = false;
    [cellCT.thumbnailVideo setImageWithURL:[NSURL URLWithString:item.thumbnailVideo] placeholderImage:[UIImage imageNamed:@"search.png"]];
    NSString *str = [NSString stringWithFormat:@"  %@",item.titleVideo];
    cellCT.titleVideo.text = str;
    cellCT.btnAdd.tag = indexpath;
    [cellCT.btnAdd addTarget:self action:@selector(ShowActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        return 64.0f;
    }
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (search == true) {
        nextPageToken = nil;
        [_searchBarr resignFirstResponder];
        _searchBarr.showsCancelButton = NO;
        _searchBarr.text = arrPassing[indexPath.row];
        continuesSearch = YES;
        appDelegate.searchVideo = YES;
        arrVideo = [[NSMutableArray alloc] init];
        [self getIDVideoYT:arrPassing[indexPath.row]];
        NSString *str = arrPassing[indexPath.row];
        NSUserDefaults *item = [NSUserDefaults standardUserDefaults];
        [item setObject:str forKey:@"search"];
        textSearch = str;
        search = false;
        [_tableViewVideo reloadData];
    }
    else {
        
        [PlayerView shareInstance].titleVideoPlaylist = @"Trending Music";
        playView.indexVideoChoose = indexPath.row;
        appDelegate.checkExistVideo = NO;
        [self saveCustomObject:arrVideo key:@"arrVideo"];
        [_tableViewVideo selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        [self presentViewController:[PlayerView shareInstance] animated:YES completion:nil];
        
    }
    
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
