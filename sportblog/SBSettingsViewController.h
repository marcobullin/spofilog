//
//  SBSettingsViewController.h
//  sportblog
//
//  Created by Bullin, Marco on 06.10.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GAITrackedViewController.h"

@interface SBSettingsViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
