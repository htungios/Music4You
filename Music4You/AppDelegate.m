//
//  AppDelegate.m
//  Music4You
//
//  Created by BMXStudio03 on 2/16/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import "AppDelegate.h"
#import "MainView.h"
#import "Playlist.h"
#import "iRate.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

// #import "Music4You-Prefix.pch"
@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productRestore:) name:kProductRestoredNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productLoadFailed:) name:kProductsLoadedFailNotification object: nil];
    
    [PlayerView shareInstance];
    [self loadAds];
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    
    NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    if (_dataArchive.count>0)
    {
    }
    else
    {
        _isPurchase = NO;
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:_isPurchase], nil];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:arr]
                                                  forKey:@"Purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _searchVideo = true;
    [iRate sharedInstance].applicationBundleID = [[NSBundle mainBundle] bundleIdentifier];
    [iRate sharedInstance].appStoreID = App_Id;
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].previewMode = NO;
    
    // NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    NSNumber *num = [_dataArchive objectAtIndex:0];
    BOOL isPurchase = [num boolValue];
    if (isPurchase==NO)
    {
        self.banner = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50))];
    }
    MainView *mainView = [[MainView alloc] init];
    Playlist *playList = [[Playlist alloc] init];
    
    UINavigationController *nvMainView = [[UINavigationController alloc] initWithRootViewController:mainView];
    UINavigationController *nvPlaylist = [[UINavigationController alloc] initWithRootViewController:playList];
    
    [[MPRemoteCommandCenter sharedCommandCenter].playCommand addTarget:self action:@selector(remoteNextPrevTrackCommandReceived:)];
    [[MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand addTarget:self action:@selector(remoteNextPrevTrackCommandReceived:)];
    [[MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand addTarget:self action:@selector(remoteNextPrevTrackCommandReceived:)];
    
    NSUserDefaults *numberOpenApp = [NSUserDefaults standardUserDefaults];
    NSNumber *number = @1;
    number = [numberOpenApp objectForKey:@"numberOpenApp"];
    if ([number  isEqual: @2]) {
        [[iRate sharedInstance]promptForRating];
        number = @1;
        [numberOpenApp setObject:number forKey:@"numberOpenApp"];
    } else {
        int i = [number intValue];
        i +=1;
        number = [NSNumber numberWithInt:i];
        [numberOpenApp setObject:number forKey:@"numberOpenApp"];
    }
    
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:208.0/255.0 green:194.0/255.0 blue:174.0/255.0 alpha:1.0]];
    
    [self.window addSubview:nvPlaylist.view];
    [self.window setRootViewController:nvMainView];
    [self.window makeKeyAndVisible];


    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// ----------------- Purchase -------------------

-(void)productsLoaded:(NSNotification *)notification
{
    
}

-(void)productPurchased:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSString *productIdentifier = (NSString*) notification.object;
    if([productIdentifier isEqualToString:@"YoutubeSingleViewNoAds"])
    {
        BOOL isPurchase = YES;
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:isPurchase], nil];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:arr]
                                                  forKey:@"Purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Purchased" object:nil];
    }
}

-(void)productRestore:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSString *productIdentifier = (NSString*) notification.object;
    if([productIdentifier isEqualToString:@"YoutubeSingleViewNoAds"])
    {
        BOOL isPurchase = YES;
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:isPurchase], nil];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:arr]
                                                  forKey:@"Purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Purchased" object:nil];
    }
    
}

-(void)productPurchaseFailed:(NSNotification *)notification
{
    SKPaymentTransaction *transaction = (SKPaymentTransaction*) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase failed" message:transaction.error.localizedDescription
                                                       delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)productLoadFailed:(NSNotification *)notification
{
    NSError*err=(NSError*)notification.object;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:err.localizedDescription delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (_checkPlay == NO) {
        [PlayerView shareInstance].checkPlay = NO;
    }else {
        [[PlayerView shareInstance]continuePlay];
        [PlayerView shareInstance].checkPlay = YES;
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (_checkPlay == NO) {
        [PlayerView shareInstance].checkPlay = NO;
    }else {
        [[PlayerView shareInstance]continuePlay];
        [PlayerView shareInstance].checkPlay = YES;
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
   
    if(self.restrictRotation) {
        return UIInterfaceOrientationMaskPortrait;
    }
    else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}


-(void) remoteNextPrevTrackCommandReceived:(id)event
{
    
}

-(void)loadAds
{
    NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    NSNumber *num = [_dataArchive objectAtIndex:0];
    BOOL isPurchase = [num boolValue];
    if (isPurchase==NO)
    {
        self.interstital = [[GADInterstitial alloc] initWithAdUnitID:ADMODINTER];
        self.interstital.delegate = self;
        GADRequest *request = [GADRequest request];
        [self.interstital loadRequest:request];
    }
}

-(void)showAds:(UIViewController*)controller
{
    NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    NSNumber *num = [_dataArchive objectAtIndex:0];
    BOOL isPurchase = [num boolValue];
    if (isPurchase==NO)
    {
        
        if ([self.interstital isReady]) {
            [PlayerView shareInstance].checkPlay = NO;
            [[PlayerView shareInstance] pauseVideoPlaying];
            
            [self.interstital presentFromRootViewController:controller];
        }
    }
}

-(void)loadBanner
{
    NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Purchase"];
    NSMutableArray *_dataArchive = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    NSNumber *num = [_dataArchive objectAtIndex:0];
    BOOL isPurchase = [num boolValue];
    if (isPurchase==NO)
    {
        self.banner.rootViewController = self.window.rootViewController;
        self.banner.delegate = self;
        self.banner.adUnitID = ADMODID;
        [self.banner loadRequest:[GADRequest request]];
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    
    if (_checkPlay == NO) {
        [[PlayerView shareInstance] pauseVideoPlaying];
    } else {
        
        [[PlayerView shareInstance] continuePlay];
    }
    
    [self loadAds];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}


-(void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
    case UIEventSubtypeRemoteControlPlay:
        NSLog(@"AppDelegate PLAY remoteControlReceivedWithEvent");
        break;
    case UIEventSubtypeRemoteControlPause:
        NSLog(@"AppDelegate PAUSE UIEventSubtypeRemoteControlPause");
        [PlayerView shareInstance].checkPlay = NO;
        break;
    case UIEventSubtypeRemoteControlNextTrack:
        NSLog(@"AppDelegate NEXT UIEventSubtypeRemoteControlNextTrack");
        [[PlayerView shareInstance] nextVideoRemote];
        break;
    case UIEventSubtypeRemoteControlPreviousTrack:
        NSLog(@"AppDelegate PREV UIEventSubtypeRemoteControlPreviousTrack");
        [[PlayerView shareInstance] backVideoRemote];
        break;
    default:
        break;
} }


@end
