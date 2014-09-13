//
//  SBSetViewController.h
//  sportblog
//
//  Created by Marco Bullin on 13/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBSet.h"

@interface SBSetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SBSet *currentSet;

@end
