//
//  SBSetViewController.m
//  sportblog
//
//  Created by Marco Bullin on 13/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBSetViewController.h"
#import "SBLeftRightTableViewCell.h"
#import "SBPickerTableViewCell.h"

@interface SBSetViewController ()

@property (nonatomic) bool isEditSet;
@property (nonatomic) bool isEditWeight;
@property (nonatomic) bool isEditRepetitions;

@end

@implementation SBSetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 3;
    
    if (self.isEditSet) {
        count++;
    }
    
    if (self.isEditWeight) {
        count++;
    }
    
    if (self.isEditRepetitions) {
        count++;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier;
    
    // set cell
    if (indexPath.row == 0) {
        cellIdentifier = @"setCell";
        SBLeftRightTableViewCell *setCell = (SBLeftRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (setCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBLeftRightTableViewCell" owner:self options:nil];
            setCell = [nib objectAtIndex:0];
        }
        
        setCell.leftLabel.text = NSLocalizedString(@"Satz", nil);
        setCell.rightLabel.text = [NSString stringWithFormat:@"%d", self.currentSet.number];
        
        return setCell;
    }
    
    // edit set cell
    if (indexPath.row == 1 && self.isEditSet) {
        cellIdentifier = @"editSetCell";
        SBPickerTableViewCell *editSetCell = (SBPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (editSetCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBPickerTableViewCell" owner:self options:nil];
            editSetCell = [nib objectAtIndex:0];
        }
        
        return editSetCell;
    }
    
    // weight cell
    if ((indexPath.row == 1 && !self.isEditSet) || (indexPath.row == 2 && self.isEditSet)) {
        cellIdentifier = @"weightCell";
        SBLeftRightTableViewCell *weightCell = (SBLeftRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (weightCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBLeftRightTableViewCell" owner:self options:nil];
            weightCell = [nib objectAtIndex:0];
        }
        
        weightCell.leftLabel.text = NSLocalizedString(@"Gewicht", nil);
        weightCell.rightLabel.text = [NSString stringWithFormat:@"%fkg", self.currentSet.weight];
        
        return weightCell;
    }
    
    // edit weight cell
    if ((indexPath.row == 2 && !self.isEditSet && self.isEditWeight) || (indexPath.row == 3 && self.isEditSet && self.isEditWeight)) {
        cellIdentifier = @"editWeightCell";
        SBPickerTableViewCell *editWeightCell = (SBPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (editWeightCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBPickerTableViewCell" owner:self options:nil];
            editWeightCell = [nib objectAtIndex:0];
        }
        
        return editWeightCell;
    }
    
    // repetitions cell
    if ((indexPath.row == 2 && !self.isEditSet && !self.isEditWeight) || (indexPath.row == 3 && self.isEditSet && !self.isEditWeight) || (indexPath.row == 3 && !self.isEditSet && self.isEditWeight) || (indexPath.row == 4 && self.isEditSet && self.isEditWeight)) {

        cellIdentifier = @"repetitionCell";
        SBLeftRightTableViewCell *repetitionCell = (SBLeftRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (repetitionCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBLeftRightTableViewCell" owner:self options:nil];
            repetitionCell = [nib objectAtIndex:0];
        }
        
        repetitionCell.leftLabel.text = NSLocalizedString(@"Wiederholungen", nil);
        repetitionCell.rightLabel.text = [NSString stringWithFormat:@"%d", self.currentSet.repetitions];
        
        return repetitionCell;
    }
    
    cellIdentifier = @"editRepetitionsCell";
    SBPickerTableViewCell *editRepetitionsCell = (SBPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (editRepetitionsCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBPickerTableViewCell" owner:self options:nil];
        editRepetitionsCell = [nib objectAtIndex:0];
    }
    
    return editRepetitionsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = [indexPath section];
    
    // toggle set
    if (indexPath.row == 0) {
        self.isEditSet = !self.isEditSet;
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:section];
        NSArray *indexPaths = [NSArray arrayWithObject:newIndexPath];
        
        if (self.isEditSet) {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        } else {
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        }
        
        return;
    }
    
    // toggle weight
    if ((indexPath.row == 1 && !self.isEditSet) || (indexPath.row == 2 && self.isEditSet)) {
        self.isEditWeight = !self.isEditWeight;
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:section];
        NSArray *indexPaths = [NSArray arrayWithObject:newIndexPath];
        
        if (self.isEditWeight) {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        } else {
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        }
    }
    
    // toggle repetitions
    if ((indexPath.row == 2 && !self.isEditSet && !self.isEditWeight) || (indexPath.row == 3 && self.isEditSet && !self.isEditWeight) || (indexPath.row == 3 && !self.isEditSet && self.isEditWeight) || (indexPath.row == 4 && self.isEditSet && self.isEditWeight)) {
        self.isEditRepetitions = !self.isEditRepetitions;
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:section];
        NSArray *indexPaths = [NSArray arrayWithObject:newIndexPath];
        
        if (self.isEditRepetitions) {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        } else {
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || (indexPath.row == 1 && !self.isEditSet) || (indexPath.row == 2 && self.isEditSet) || (indexPath.row == 2 && !self.isEditSet && !self.isEditWeight) || (indexPath.row == 3 && self.isEditSet && !self.isEditWeight) || (indexPath.row == 3 && !self.isEditSet && self.isEditWeight) || (indexPath.row == 4 && self.isEditSet && self.isEditWeight)) {
        
        return 44.0;
    }
    
    UITableViewCell *editCell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    return editCell.frame.size.height;
}

- (void)onDone:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
