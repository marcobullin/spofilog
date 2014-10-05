//
//  SBAppDelegate.m
//  sportblog
//
//  Created by Marco Bullin on 07/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBAppDelegate.h"
#import "FLEXManager.h"
#import "SBFinishedExercisesViewController.h"
#import "SBWorkoutsViewController.h"
#import "UIColor+SBColor.h"
#import "SBWorkoutsInteractor.h"

@implementation SBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RLMMigrationBlock migrationBlock = ^NSUInteger(RLMMigration *migration,
                                                   NSUInteger oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 7) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
        // Return the latest version number (always set manually)
        // Must be a higher than the previous version or an RLMException is thrown
        return 7;
    };
    
    // Apply the migration block above to the default Realm
    [RLMRealm migrateDefaultRealmWithBlock:migrationBlock];
    
    //[[FLEXManager sharedManager] showExplorer];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    
    
    
    SBWorkoutsInteractor *workoutsInteractor = [SBWorkoutsInteractor new];
    
    SBWorkoutsViewController *workoutsViewController = [[SBWorkoutsViewController alloc] initWithNibName:@"SBWorkoutsViewController" bundle:nil];
    
    workoutsViewController.indicator = workoutsInteractor;

    self.workoutNavigationController = [[UINavigationController alloc] initWithRootViewController:workoutsViewController];
    self.workoutNavigationController.navigationBar.shadowImage = [UIImage new];
    self.workoutNavigationController.navigationBar.barTintColor = [UIColor navigationBarColor];
    self.workoutNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.workoutNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    SBFinishedExercisesViewController *finishedExercises = [[SBFinishedExercisesViewController alloc] initWithNibName:@"SBFinishedExercisesViewController" bundle:nil];
    self.statisticNavigationController = [[UINavigationController alloc] initWithRootViewController:finishedExercises];
    self.statisticNavigationController.navigationBar.shadowImage = [UIImage new];
    self.statisticNavigationController.navigationBar.barTintColor = [UIColor navigationBarColor];
    self.statisticNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.statisticNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[self.workoutNavigationController, self.statisticNavigationController];
    self.tabBarController.tabBar.barTintColor = [UIColor navigationBarColor];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    self.tabBarController.delegate = self;
    
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == self.statisticNavigationController) {
        [self.statisticNavigationController popToRootViewControllerAnimated:YES];
        return;
    }
}

@end
