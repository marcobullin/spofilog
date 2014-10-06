//
//  SBAppDelegate.h
//  sportblog
//
//  Created by Marco Bullin on 07/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *workoutNavigationController;
@property (strong, nonatomic) UINavigationController *statisticNavigationController;
@property (strong, nonatomic) UINavigationController *settingsNavigationController;

@end
