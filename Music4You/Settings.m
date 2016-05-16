//
//  Settings.m
//  Music4You
//
//  Created by BMXStudio03 on 2/17/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import "Settings.h"

@interface Settings ()
{
    NSMutableArray *arrName;
    UIView *viewGhost;
    AppDelegate *appDelegate;
    MainView *mainView;
    Playlist *playList;
    BOOL tapMenu;
}

@end

@implementation Settings
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *arrArchive = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSNumber *number = [arrArchive objectAtIndex:0];
    BOOL isPurchase = [number boolValue];
    if (isPurchase == NO) {
        [self addsReceive];
        appDelegate.checkSetting +=1;
        if (appDelegate.checkSetting == 5) {
            [appDelegate showAds:self];
            appDelegate.checkSetting = -1;
        }
    }
    tapMenu = true;
    [self restrictRotation:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:139.0/255.0 green:13.0/255.0 blue:9.0/255.0 alpha:1.0];
    self.title = @"Setting";
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    playList = [[Playlist alloc] init];
    mainView = [[MainView alloc] init];
    arrName = [[NSMutableArray alloc]init];
    [arrName addObject:[NSString stringWithFormat:NSLocalizedString(@"Write Review", nil)]];
    [arrName addObject:[NSString stringWithFormat:NSLocalizedString(@"Feedback", nil)]];
    [arrName addObject:[NSString stringWithFormat:NSLocalizedString(@"Buy Pro Version", nil)]];
    [arrName addObject:[NSString stringWithFormat:NSLocalizedString(@"Restore Purchase", nil)]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(tapMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Playing"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(tapToPlaying)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0];
    [[IAPHelper sharedHelper] requestProducts];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAds) name:@"Purchased" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoadedNewDevice:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAds) name:@"Purchased" object:nil];
}

-(void) restrictRotation:(BOOL) restriction
{
    appDelegate.restrictRotation = restriction;
}

-(void)productsLoadedNewDevice:(NSNotification *)notification
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *arrArchive = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSNumber *number = [arrArchive objectAtIndex:0];
    BOOL isPurchase = [number boolValue];
    
    if ([IAPHelper sharedHelper].products.count > 0)
    {
        if(([IAPHelper sharedHelper].products.count > 0) && ([IAPHelper sharedHelper].purchasedProducts.count == 0) && (!isPurchase))
        {} else{
            [arrName removeObject:@"Buy Pro Version"];
            [arrName removeObject:@"Restore Purchase"];
        }
        [self.tableViewSetting reloadData];
    }
}
-(void)removeAds
{
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
    [_tableViewSetting setFrame:CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height)];
    [arrName removeObject:@"Buy Pro Version"];
    [arrName removeObject:@"Restore Purchase"];

    [self.tableViewSetting reloadData];
}

-(void)addsReceive{
    if (appDelegate.banner) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        {
            [appDelegate.banner setFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 90, [[UIScreen mainScreen]bounds].size.width, 90)];
            [_tableViewSetting setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90)];
            [self.view addSubview:appDelegate.banner];
        }
        else
        {
            [_tableViewSetting setFrame:CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height - 50)];
            [appDelegate.banner setFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 50, [[UIScreen mainScreen]bounds].size.width, 50)];
            [self.view addSubview:appDelegate.banner];
        }
    }
}
- (void)tapToPlaying {
    appDelegate.checkExistVideo = true;
    [self presentViewController:[PlayerView shareInstance] animated:YES completion:nil];
}
- (void)tapMenu {
    if (tapMenu == true) {
        _iconTopTrending.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_trending.png"]];
        _iconPlaylist.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"playlist.png"]];
        _iconSettings.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"setting.png"]];
        _lblTopTrending.text = @"Top Trending";
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
                             _viewMenu.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 132);
                         }];
        
    } else {
        [UIView animateWithDuration:0.5
                         animations:^{
                             _viewMenu.frame = CGRectMake(0, -68, [UIScreen mainScreen].bounds.size.width, 132);
                         }];
        tapMenu = true;
        viewGhost.hidden = true;
    }
}



- (void)tapHiddenMenu {
    [UIView animateWithDuration:0.5
                     animations:^{
                         _viewMenu.frame = CGRectMake(0, -68, [UIScreen mainScreen].bounds.size.width, 132);
                     }];
    tapMenu = true;
    viewGhost.hidden = true;
}


- (void)tapView1 {

    [self.navigationController pushViewController:mainView animated:YES];
}

- (void)tapView2 {
    [self.navigationController pushViewController:playList animated:YES];
}

- (void)tapView3 {
    if ([self isMemberOfClass:[Settings class]]) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             _viewMenu.frame = CGRectMake(0, -68, [UIScreen mainScreen].bounds.size.width, 132);
                         }];
        tapMenu = true;
        viewGhost.hidden = true;
    }
}

#pragma mark - MailDelegate

- (BOOL)setMFMailFieldAsFirstResponder:(UIView*)view mfMailField:(NSString*)field{
    for (UIView *subview in view.subviews) {
        NSString *className = [NSString stringWithFormat:@"%@", [subview class]];
        if ([className isEqualToString:field])
        {
            //Found the sub view we need to set as first responder
            [subview becomeFirstResponder];
            return YES;
        }
        if ([subview.subviews count] > 0)
        {
            if ([self setMFMailFieldAsFirstResponder:subview mfMailField:field]){
                //Field was found and made first responder in a subview
                return YES;
            }
        }
    }
    //field not found in this view.
    return NO;
}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    //Add an alert in case of failure
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)appNameAndVersionNumberDisplayString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = @"Top Video";
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@, Version %@ (%@)",
            appDisplayName, majorVersion, minorVersion];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrName.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [arrName objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        [iRate sharedInstance].ratedThisVersion = YES;
        [[iRate sharedInstance] openRatingsPageInAppStore];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (indexPath.row==1)
    {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
            [composeViewController setMailComposeDelegate:self];
            [composeViewController setToRecipients:@[EMAIL_SUPPORT]];
            [composeViewController setSubject:EMAIL_SUPPORT_SUBJECT];
            [composeViewController setMessageBody:[[@"\n\n\n\n " stringByAppendingString:[NSString stringWithFormat:@"\n%@",[self appNameAndVersionNumberDisplayString]]] stringByAppendingString:[NSString stringWithFormat:@"\nModel:%@ (%f)",[[UIDevice currentDevice] model],[[UIDevice currentDevice].systemVersion floatValue]]] isHTML:NO];
            [[[composeViewController navigationItem] leftBarButtonItem]setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]} forState:UIControlStateNormal];
            [[[composeViewController navigationItem] leftBarButtonItem]setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]} forState:UIControlStateHighlighted];
            [[[composeViewController navigationItem] rightBarButtonItem]setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]} forState:UIControlStateNormal];
            [[[composeViewController navigationItem] rightBarButtonItem]setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]} forState:UIControlStateHighlighted];
            
            [self setMFMailFieldAsFirstResponder:composeViewController.view mfMailField:@"_MFComposeSubjectView"];
            [self.view.window.rootViewController presentViewController:composeViewController animated:YES completion:nil];
            
        }
        else {
            [[[UIAlertView alloc]initWithTitle:@"Email" message:@"You need config your mail on Devices" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.row==2) {
        if ([IAPHelper sharedHelper].products.count > 0)
        {
            if(([IAPHelper sharedHelper].products.count > 0) && ([IAPHelper sharedHelper].purchasedProducts.count == 0))
            {
                [[IAPHelper sharedHelper] buyProductIdentifier:[[IAPHelper sharedHelper].products firstObject]];
            }
        }
    }
    if (indexPath.row == 3) {
        [[IAPHelper sharedHelper] restoreCompletedTransaction];
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
