//
//  SBViewController.h
//  sportblog
//
//  Created by Marco Bullin on 07/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RKTabView.h>
#import "SBWorkoutViewController.h"

@interface SBWorkoutsViewController : UIViewController <RKTabViewDelegate, UITableViewDataSource, UITableViewDelegate, SBWorkoutViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
