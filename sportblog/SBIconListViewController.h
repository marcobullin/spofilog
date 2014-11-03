//
//  SBIconListViewController.h
//  sportblog
//
//  Created by Marco Bullin on 01/11/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBExercise.h"

@interface SBIconListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) SBExercise *exercise;
@property (nonatomic) BOOL isFrontBody;

@end
