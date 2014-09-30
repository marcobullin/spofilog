//
//  SBFinishedExercisesViewController.h
//  sportblog
//
//  Created by Marco Bullin on 17/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBFinishedExercisesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
