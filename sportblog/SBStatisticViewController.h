//
//  SBStatisticViewController.h
//  sportblog
//
//  Created by Marco Bullin on 16/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCLineChartView.h"
#import "GAITrackedViewController.h"

@interface SBStatisticViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *exerciseName;
@property (nonatomic, strong) PCLineChartView *lineChartView;
@property (nonatomic, strong) UITableView *tableView;
@end
