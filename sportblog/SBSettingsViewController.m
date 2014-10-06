//
//  SBSettingsViewController.m
//  sportblog
//
//  Created by Bullin, Marco on 06.10.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBSettingsViewController.h"

@interface SBSettingsViewController ()

@end

@implementation SBSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Settings", nil);
        self.tabBarItem.title = NSLocalizedString(@"Settings", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"settings"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
