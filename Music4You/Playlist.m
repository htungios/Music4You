//
//  Playlist.m
//  Music4You
//
//  Created by BMXStudio03 on 2/17/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import "Playlist.h"


@interface Playlist ()
{
    BOOL tapMenu, checkExistVideo, checkNameVideo;
    NSMutableArray *arrPlaylist, *arrTemp;
    NSMutableArray *arrVideoPlaylistSave;
    NSInteger index;
    NSUserDefaults *defaults;
    UIView *viewGhost;
    MainView *mainView;
    Settings *settings;
    PlayerView *playerView;
    AppDelegate *appDelegate;
    CellCustomPlaylist *cell;
    CellAddNewPlaylist *cell1;
    VideoOfPlaylist *videoOfPlaylist;
    
    
}

@end

@implementation Playlist

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"Playlist";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0]}];
    if (appDelegate.tapAddPlaylist == false) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playlist.png"]
                                                                                 style:UIBarButtonItemStyleDone
                                                                                target:self
                                                                                action:@selector(tapMenu)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Playing"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(tapToPlaying)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(tapDone)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(tapCancel)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0];
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:139.0/255.0 green:13.0/255.0 blue:9.0/255.0 alpha:1.0];
    
    defaults = [NSUserDefaults standardUserDefaults];
    arrPlaylist = [NSMutableArray arrayWithArray:[defaults objectForKey:@"playList"]];
    if (!arrPlaylist) {
        arrPlaylist = [[NSMutableArray alloc] init];
    }
    [_tableViewPlaylist reloadData];
    
    [self restrictRotation:YES];
    
    arrVideoPlaylistSave = [[NSMutableArray alloc] init];
    NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    NSNumber *num1 = [_dataArchive objectAtIndex:0];
    BOOL isPurchase = [num1 boolValue];
    if (isPurchase==NO)
    {
        [self addsReceive];
        appDelegate.checkPlaylist +=1;
        if (appDelegate.checkPlaylist == 4) {
            [appDelegate showAds:self];
            appDelegate.checkPlaylist = -1;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    mainView = [[MainView alloc] init];
    settings = [[Settings alloc] init];
    playerView = [PlayerView shareInstance];
    videoOfPlaylist = [[VideoOfPlaylist  alloc] init];
    arrTemp = [[NSMutableArray alloc] init];
    arrPlaylist = [[NSMutableArray alloc] init];
    [_tableViewPlaylist registerNib:[UINib nibWithNibName:@"CellCustomPlaylist" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableViewPlaylist registerNib:[UINib nibWithNibName:@"CellAddNewPlaylist" bundle:nil] forCellReuseIdentifier:@"cell1"];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    tapMenu = true;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAds) name:@"Purchased" object:nil];
}

-(void) restrictRotation:(BOOL) restriction
{
    appDelegate.restrictRotation = restriction;
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
        [_tableViewPlaylist setFrame:CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height)];
        [self.tableViewPlaylist reloadData];
}

-(void)addsReceive{
    if (appDelegate.banner) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        {
            [appDelegate.banner setFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 90, [[UIScreen mainScreen]bounds].size.width, 90)];
            [_tableViewPlaylist setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90)];
            [self.view addSubview:appDelegate.banner];
        }
        else
        {
            [_tableViewPlaylist setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 )];
            [appDelegate.banner setFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 50, [[UIScreen mainScreen]bounds].size.width, 50)];
            [self.view addSubview:appDelegate.banner];
        }
    }
}

- (void)tapToPlaying {
    appDelegate.checkExistVideo = true;
    [self presentViewController:[PlayerView shareInstance] animated:YES completion:nil];
}

- (void) tapDone {
    appDelegate.checkMainView -=1;
    appDelegate.checkPlaylist -=1;
    if (arrPlaylist.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else{
    
    if (!index) {
        index = 0;
    }
    arrVideoPlaylistSave = [[NSMutableArray alloc] init];
    arrVideoPlaylistSave = [self loadCustomObjectWithKey:arrPlaylist[index]];
    if (!arrVideoPlaylistSave) {
        arrVideoPlaylistSave = [[NSMutableArray alloc] init];
        [arrVideoPlaylistSave addObject:_videoChoose];
    } else{
        for (DataVideo *item in arrVideoPlaylistSave) {
            NSString *str1 = item.titleVideo;
            NSString *str2 = _videoChoose.titleVideo;
            if ([str1 isEqualToString:str2]) {
                checkExistVideo = true;
                break;
            } else {
                checkExistVideo = false;
            }
        }
        if (checkExistVideo == false) {
            [arrVideoPlaylistSave addObject:_videoChoose];
        } else {
            [self showAlertMessenger];
        }
    }
    _videoChoose = nil;
    [self saveCustomObject:arrVideoPlaylistSave key:arrPlaylist[index]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    appDelegate.tapAddPlaylist = false;
    appDelegate.checkExistVideo = true;
}

- (void)showAlertMessenger {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The video already existed in playlist"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void) tapCancel {
    appDelegate.checkMainView -=1;
    appDelegate.checkPlaylist -=1;
    _videoChoose = nil;
    playerView.checkPlay = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    appDelegate.tapAddPlaylist = false;
    appDelegate.checkExistVideo = true;
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
    if ([self isMemberOfClass:[Playlist class]]) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             _viewMenu.frame = CGRectMake(0, -68, [UIScreen mainScreen].bounds.size.width, 132);
                         }];
        tapMenu = true;
        viewGhost.hidden = true;

}
}

- (void)tapView3 {
    [self.navigationController pushViewController:settings animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return arrPlaylist.count;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        cell1 = (CellAddNewPlaylist *)[tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [self customCellAddPlaylist:cell1 :indexPath.row];
        return cell1;
    } else {
        cell = (CellCustomPlaylist *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [self customCellPlaylist:cell :indexPath.row];
        if (arrPlaylist.count > 0) {
            NSMutableArray *arrVideoPlaylistGet = [[NSMutableArray alloc] init];
            arrVideoPlaylistGet = [self loadCustomObjectWithKey:arrPlaylist[indexPath.row]];
            if (!arrVideoPlaylistGet) {
                cell.lblNumberPlaylist.text = @"0 video";
            }
            NSString *str = [NSString stringWithFormat:@"%lu videos",(unsigned long)arrVideoPlaylistGet.count];
            cell.lblNumberPlaylist.text = str;
        }
     return cell;   
    }
    
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [arrPlaylist removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:arrPlaylist forKey:@"playList"];
    [_tableViewPlaylist deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_tableViewPlaylist reloadData];
    
}



- (void)customCellAddPlaylist :(CellAddNewPlaylist *)cellCT : (NSInteger) indexpath {
    cellCT.editing = NO;
    cellCT.lblAddNewPlaylist.text = @"Add New Playlist";
    
}

- (void)customCellPlaylist : (CellCustomPlaylist *)cellCT : (NSInteger) indexpath {
    
    if (appDelegate.tapAddPlaylist == false) {
        cellCT.accessoryType = UITableViewCellAccessoryNone;
    } else {
        if (indexpath == index) {
            cellCT.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cellCT.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cellCT.lblNamePlaylist.text = arrPlaylist[indexpath];
    NSMutableArray *mArrTemp = [[NSMutableArray alloc] init];
    mArrTemp = [self loadCustomObjectWithKey:arrPlaylist[indexpath]];
    if (mArrTemp.count > 0) {
        DataVideo *item = [mArrTemp lastObject];
        [cellCT.imagePlaylist setImageWithURL:[NSURL URLWithString:item.thumbnailVideo] placeholderImage:[UIImage imageNamed:@"image_load.png"]];
    } else {
        cellCT.imagePlaylist.image = [UIImage imageNamed:@"image_load.png"];
    }
}



#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        return 64.0f;
    } else {
        return 50.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([UIAlertController class]) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"New Playlist"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           UITextField *temp = alert.textFields.firstObject;
                                                           NSString *namePlaylist = temp.text;
                                                           
                                                           for (int i=0; i < arrPlaylist.count ; i++) {
                                                               NSString *str = arrPlaylist[i];
                                                               if ([str isEqualToString:namePlaylist] || [namePlaylist isEqualToString:@""]) {
                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                                                                                   message:@"Name error!"
                                                                                                                  delegate:self
                                                                                                         cancelButtonTitle:@"OK"
                                                                                                         otherButtonTitles: nil];
                                                                   [alert show];
                                                                   NSLog(@"Name error!");
                                                                   checkNameVideo = YES;
                                                                   break;
                                                               } else {
                                                                   checkNameVideo = NO;
                                                               }
                                                           }
                                                           if (checkNameVideo == NO) {
                                                               NSLog(@"Done");
                                                               [arrPlaylist addObject:namePlaylist];
                                                               defaults = [NSUserDefaults standardUserDefaults];
                                                               [defaults setObject:arrPlaylist forKey:@"playList"];
                                                               [defaults synchronize];
                                                               [_tableViewPlaylist reloadData];
                                                               NSLog(@"Data saved");
                                                           }
                                                           
                                                       }];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
            [alert addAction:ok];
            [alert addAction:cancel];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Name of playlist";
            }];
            [self presentViewController:alert animated:YES completion:nil];

        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New playlist"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"OK", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
            
        }
    }
    if (indexPath.section == 1) {
        if (appDelegate.tapAddPlaylist == false) {
            videoOfPlaylist.strIndexVideo = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
            [self.navigationController pushViewController:videoOfPlaylist animated:YES];
        } else {
            index = indexPath.row;
            [_tableViewPlaylist reloadData];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
//        UITextField *temp = alertView.textFields.firstObject;
        UITextField *temp = [alertView textFieldAtIndex:0];
        NSString *namePlaylist = temp.text;
        [arrPlaylist addObject:namePlaylist];
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:arrPlaylist forKey:@"playList"];
        [defaults synchronize];
        [_tableViewPlaylist reloadData];
        NSLog(@"Data saved");
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
