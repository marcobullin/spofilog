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
@property (nonatomic, strong) NSMutableArray *sets;
@end

@implementation SBSetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.exercise.name;
    self.navigationItem.hidesBackButton = YES;
    
    self.tableView.dataSource = self;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneSets:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelSets:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.sets = [[NSMutableArray alloc] init];
    for (SBSet *set in self.exercise.sets) {
        [self.sets addObject:set];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [self.sets count] + 1;
    
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
    
    SBSet *set = [self.sets objectAtIndex:index];
    
    setCell.leftLabel.text = [NSString stringWithFormat:@"Set - %d", set.number];
    setCell.rightLabel.text = [NSString stringWithFormat:@"%.01fkg | %dreps", set.weight, set.repetitions];

    return setCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SBSetViewController *setViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBSetViewController"];
    
    SBSet *set;
    // user touched on a set to edit it
    if (indexPath.row > 0) {
        set = [self.sets objectAtIndex:(indexPath.row-1)];
    }

    // new
    if (indexPath.row == 0) {
        SBSet *previousSet = [self.sets lastObject];
        setViewController.previousSet = previousSet;
    }
    
    setViewController.currentSet = set;
    setViewController.delegate = self;
    
    [self.navigationController pushViewController:setViewController animated:YES];
}

- (void)addSetViewController:(SBSetViewController *)controller didCreatedNewSet:(SBSet *)set {
    [self.sets addObject:set];
}

- (void)onCancelSets:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onDoneSets:(id)sender {
    [self.exercise.realm beginWriteTransaction];
    [self.exercise.sets removeAllObjects];
    [self.exercise.sets addObjectsFromArray:self.sets];
    [self.exercise.realm commitWriteTransaction];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
