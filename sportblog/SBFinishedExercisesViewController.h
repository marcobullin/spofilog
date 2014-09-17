//
//  SBFinishedExercisesViewController.h
//  sportblog
//
//  Created by Marco Bullin on 17/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RKTabView.h>

@interface SBFinishedExercisesViewController : UIViewController <RKTabViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
