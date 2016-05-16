//
//  VideoOfPlaylist.m
//  Music4You
//
//  Created by BMXStudio03 on 2/19/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import "VideoOfPlaylist.h"

@interface VideoOfPlaylist ()
{
    NSUserDefaults *defaults;
    NSMutableArray *arrPL, *arrVideoOfPL;
    PlayerView *playerView;
    AppDelegate *appDelegate;
}

@end

@implementation VideoOfPlaylist

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:139.0/255.0 green:13.0/255.0 blue:9.0/255.0 alpha:1.0];
    arrPL = [NSMutableArray arrayWithArray:[defaults objectForKey:@"playList"]];
    NSInteger indexVideo = [_strIndexVideo integerValue];
    arrVideoOfPL = [self loadCustomObjectWithKey:arrPL[indexVideo]];
    [_tableViewVideoOfPL reloadData];
    NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    NSNumber *num1 = [_dataArchive objectAtIndex:0];
    BOOL isPurchase = [num1 boolValue];
    if (isPurchase==NO)
    {
        [self addsReceive];
    }
    self.title = arrPL[indexVideo];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:139.0/255.0 green:13.0/255.0 blue:9.0/255.0 alpha:1.0];
    [self restrictRotation:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableViewVideoOfPL registerNib:[UINib nibWithNibName:@"CellCustomVideoOfPL" bundle:nil] forCellReuseIdentifier:@"Cell"];
    defaults = [NSUserDefaults standardUserDefaults];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    arrPL = [[NSMutableArray alloc] init];
    arrVideoOfPL = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAds) name:@"Purchased" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void) restrictRotation:(BOOL) restriction
{
    appDelegate.restrictRotation = restriction;
}

-(void)addsReceive{
    if (appDelegate.banner) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        {
            [appDelegate.banner setFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 90, [[UIScreen mainScreen]bounds].size.width, 90)];
            [_tableViewVideoOfPL setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90)];
            [self.view addSubview:appDelegate.banner];
        }
        else
        {
            [_tableViewVideoOfPL setFrame:CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height - 50)];
            [appDelegate.banner setFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 50, [[UIScreen mainScreen]bounds].size.width, 50)];
            [self.view addSubview:appDelegate.banner];
        }
    }
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
    [_tableViewVideoOfPL setFrame:CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height)];
    [self.tableViewVideoOfPL reloadData];
}

- (void)saveCustomObject:(NSMutableArray *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaultsVideoPL = [NSUserDefaults standardUserDefaults];
    [defaultsVideoPL setObject:encodedObject forKey:key];
    [defaultsVideoPL synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaultsVideoPL = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaultsVideoPL objectForKey:key];
    NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrVideoOfPL.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellCustomVideoOfPL *cell = (CellCustomVideoOfPL*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self customCell:cell :indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == [PlayerView shareInstance].indexVideoChoose) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_tableViewVideoOfPL deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    return cell;
}

-(void)customCell : (CellCustomVideoOfPL *)cellCT :(NSInteger)indexpath {
    DataVideo *item = [[DataVideo alloc] init];
    item = arrVideoOfPL[indexpath];
    [cellCT.imageThumbnail setImageWithURL:[NSURL URLWithString:item.thumbnailVideo] placeholderImage:[UIImage imageNamed:@"image_load.png"]];
    cellCT.lblNameVideo.text = item.titleVideo;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexVideo = [_strIndexVideo integerValue];
    [PlayerView shareInstance].titleVideoPlaylist = arrPL[indexVideo];
    [PlayerView shareInstance].indexVideoChoose = indexPath.row;
    appDelegate.checkExistVideo = NO;
    [self saveCustomObject:arrVideoOfPL key:@"arrVideo"];
    [self presentViewController:[PlayerView shareInstance] animated:YES completion:nil];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [arrVideoOfPL removeObjectAtIndex:indexPath.row];
    [self saveCustomObject:arrVideoOfPL key:@"arrVideo"];
    NSInteger indexVideo = [_strIndexVideo integerValue];
    [self saveCustomObject:arrVideoOfPL key:arrPL[indexVideo]];
    [_tableViewVideoOfPL deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_tableViewVideoOfPL reloadData];
    
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
