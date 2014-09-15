//
//  SBSetsViewController.h
//  sportblog
//
//  Created by Bullin, Marco on 12.09.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBExerciseSet.h"
#import "SBSetViewController.h"

@interface SBSetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SBSetViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SBExerciseSet *exercise;

@end
