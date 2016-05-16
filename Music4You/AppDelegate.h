//
//  AppDelegate.h
//  Music4You
//
//  Created by BMXStudio03 on 2/16/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;
@interface AppDelegate : UIResponder <UIApplicationDelegate,GADBannerViewDelegate,GADInterstitialDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GADBannerView *banner;
@property (strong, nonatomic) GADInterstitial *interstital;
@property (nonatomic) BOOL tapAddPlaylist;
@property (nonatomic) BOOL checkExistVideo;
@property (nonatomic) BOOL isPurchase;
@property (nonatomic) BOOL restrictRotation;
@property (nonatomic) BOOL checkPlay;
@property (nonatomic) BOOL checkPurchased;
@property (nonatomic) BOOL searchVideo;
@property (nonatomic) NSInteger checkMainView;
@property (nonatomic) NSInteger checkPlaylist;
@property (nonatomic) NSInteger checkSetting;
@property (nonatomic) NSInteger checkPlaying;

-(void)showAds:(UIViewController *)view;
-(void)loadAds;
-(void)loadBanner;
@end

