//
//  SBViewController.h
//  sportblog
//
//  Created by Marco Bullin on 07/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBWorkoutsInteractor.h"
#import "GAITrackedViewController.h"

@interface SBWorkoutsViewController : GAITrackedViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SBWorkoutsInteractor *indicator;

@end
