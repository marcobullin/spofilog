//
//  SBSetViewController.h
//  sportblog
//
//  Created by Marco Bullin on 13/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBSet.h"

@class SBSetViewController;

@protocol SBSetViewControllerDelegate <NSObject>
- (void)addSetViewController:(SBSetViewController *)controller didCreatedNewSet:(SBSet *)set;
@end

@interface SBSetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) int number;
@property (nonatomic) float weight;
@property (nonatomic) int repetitions;
@property (strong, nonatomic) SBSet *currentSet;
@property (strong, nonatomic) SBSet *previousSet;
@property (nonatomic, weak) id <SBSetViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
