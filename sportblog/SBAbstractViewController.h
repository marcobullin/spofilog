//
//  SBAbstractViewController.h
//  sportblog
//
//  Created by Bullin, Marco on 03.11.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface SBAbstractViewController : GAITrackedViewController

@property (nonatomic, strong) UITableView *tableView;

@end
