//
//  SBSetsViewController.m
//  sportblog
//
//  Created by Bullin, Marco on 12.09.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBSetsViewController.h"
#import "SBSetViewController.h"
#import "SBAddEntryTableViewCell.h"
#import "SBSet.h"
#import "SBLeftRightTableViewCell.h"

@interface SBSetsViewController ()

@end

@implementation SBSetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.exercise.name;
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [self.exercise.sets count] + 1;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"setCell";
    
    if (indexPath.row == 0) {
        cellIdentifier = @"addSetCell";
        
        SBAddEntryTableViewCell *addSetCell = (SBAddEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (addSetCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBAddEntryTableViewCell" owner:self options:nil];
            addSetCell = [nib objectAtIndex:0];
        }
        
        addSetCell.addEntryLabel.text = @"Add new set";
        
        return addSetCell;
    }
    
    SBLeftRightTableViewCell *setCell = (SBLeftRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (setCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBLeftRightTableViewCell" owner:self options:nil];
        setCell = [nib objectAtIndex:0];
    }
    
    // standard -1 because of the add set cell
    int index = indexPath.row - 1;
    
    SBSet *set = [self.exercise.sets objectAtIndex:index];
    
    setCell.leftLabel.text = [NSString stringWithFormat:@"Set - %d", set.number];
    setCell.rightLabel.text = [NSString stringWithFormat:@"%.01fkg | %dreps", set.weight, set.repetitions];

    return setCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SBSetViewController *setViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBSetViewController"];
    
    SBSet *set;
    // user touched on workout to edit name or date
    if (indexPath.row > 0) {
        set = [self.exercise.sets objectAtIndex:(indexPath.row-1)];
    } else {
        set = [[SBSet alloc] init];
        set.number = 1;
        set.weight = 0.0;
        set.repetitions = 0;
        
        [self.exercise.realm beginWriteTransaction];
        [self.exercise.sets addObject:set];
        [self.exercise.realm commitWriteTransaction];
    }

    setViewController.currentSet = set;
    
    [self.navigationController pushViewController:setViewController animated:YES];
}

@end
