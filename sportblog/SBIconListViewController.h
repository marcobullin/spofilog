//
//  SBIconListViewController.h
//  sportblog
//
//  Created by Marco Bullin on 01/11/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBExercise.h"
#import "SBAbstractViewController.h"

@interface SBIconListViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SBExercise *exercise;
@property (nonatomic) BOOL isFrontBody;

@end
