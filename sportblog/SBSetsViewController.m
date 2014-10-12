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
#import "SBSmallTopBottomCell.h"
#import "UIColor+SBColor.h"
#import "SBHelperView.h"

@interface SBSetsViewController ()
@property (nonatomic, strong) RLMArray *sets;
@end

@implementation SBSetsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Sets Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.exercise.name;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.sets = self.exercise.sets;
    
    [self.view addSubview:self.tableView];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = (int)[self.sets count] + 1;
    
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
        
        addSetCell.backgroundColor = [UIColor actionCellColor];
        
        if ([self.sets count] > 0) {
            addSetCell.addEntryLabel.text = NSLocalizedString(@"Add another set", nil);
        } else {
            addSetCell.addEntryLabel.text = NSLocalizedString(@"Add new set", nil);
        }
        addSetCell.addEntryLabel.textColor = [UIColor whiteColor];
        //addSetCell.layoutMargins = UIEdgeInsetsZero;
        addSetCell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, addSetCell.bounds.size.width);
        addSetCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return addSetCell;
    }
    
    SBSmallTopBottomCell *setCell = (SBSmallTopBottomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (setCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBSmallTopBottomCell" owner:self options:nil];
        setCell = [nib objectAtIndex:0];
    }
    
    // standard -1 because of the add set cell
    int index = (int)indexPath.row - 1;
    
    SBSet *set = [self.sets objectAtIndex:index];
    
    setCell.backgroundColor = [UIColor clearColor];
    setCell.topLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Set - %d", nil), set.number];
    setCell.bottomLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%.01fkg | %dreps", nil), set.weight, set.repetitions];
    setCell.topLabel.textColor = [UIColor importantCellColor];
    setCell.bottomLabel.textColor = [UIColor textColor];
    //setCell.layoutMargins = UIEdgeInsetsZero;
    setCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return setCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // add new set
    if (indexPath.row == 0) {
        SBHelperView *helperView = [[SBHelperView alloc] initWithMessage:NSLocalizedString(@"Touch to change values", nil)
                                                                 onPoint:CGPointMake(20, 170)
                                                          andHintOnPoint:CGPointMake(20, 110)
                                                         andRenderOnView:self.parentViewController.view];
        
        helperView.frame = self.view.frame;
        
        SBSet *set = [SBSet new];
        if ([self.sets count] > 0) {
            SBSet *previousSet = [self.sets lastObject];
            set.number = previousSet.number + 1;
            set.weight = previousSet.weight;
            set.repetitions = previousSet.repetitions;
        } else {
            set.number = 1;
            set.weight = 10.0;
            set.repetitions = 10;
        }
        
        [self.exercise.realm beginWriteTransaction];
        [self.exercise.sets addObject:set];
        [self.exercise.realm commitWriteTransaction];

        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self.sets count] inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        if ([self.sets count] == 1) {
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        return;
    }
    
    SBSetViewController *setViewController = [[SBSetViewController alloc] initWithNibName:@"SBSetViewController" bundle:nil];
    
    SBSet *set = [self.sets objectAtIndex:(indexPath.row-1)];
    setViewController.currentSet = set;
    setViewController.delegate = self;
    
    [self.navigationController pushViewController:setViewController animated:YES];
}

- (void)addSetViewController:(SBSetViewController *)controller didCreatedNewSet:(SBSet *)set {
    [self.exercise.realm beginWriteTransaction];
    [self.exercise.sets addObject:set];
    [self.exercise.realm commitWriteTransaction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int index = (int)indexPath.row - 1;
        
        [self.exercise.realm beginWriteTransaction];
        [self.exercise.sets removeObjectAtIndex:index];
        [self.exercise.realm commitWriteTransaction];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        if ([self.sets count] == 0) {
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

@end
