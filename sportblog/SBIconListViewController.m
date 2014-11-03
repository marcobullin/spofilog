//
//  SBIconListViewController.m
//  sportblog
//
//  Created by Marco Bullin on 01/11/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBIconListViewController.h"
#import "SBIconCell.h"

static NSString * const IconCellIdentifier = @"IconCell";

@interface SBIconListViewController ()

@end

@implementation SBIconListViewController

NSArray *allImageNames;
NSArray *currentSelectedImages;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Select Muscle Groups", nil);
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    if (self.isFrontBody) {
        allImageNames = @[
                    @"front",
                    @"front_neck",
                    @"front_breast",
                    @"front_shoulder",
                    @"front_biceps",
                    @"front_underarm",
                    @"front_lat",
                    @"front_sides",
                    @"front_sixpack",
                    @"front_legs",
                    @"front_shin"
                    ];
    } else {
        allImageNames = @[
                  @"back",
                  @"back_neck",
                  @"back_shoulder",
                  @"back_triceps",
                  @"back_underarm",
                  @"back_back",
                  @"back_ass",
                  @"back_legs",
                  @"back_calf"
                  ];
    }

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allImageNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBIconCell *cell = (SBIconCell *)[tableView dequeueReusableCellWithIdentifier:IconCellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBIconCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.iconView setImage:[UIImage imageNamed:allImageNames[indexPath.row]]];
    cell.imageName.text = NSLocalizedString(allImageNames[indexPath.row], nil);
    
    if (self.isFrontBody) {
        currentSelectedImages = [self.exercise.frontImages componentsSeparatedByString:@","];
    } else {
        currentSelectedImages = [self.exercise.backImages componentsSeparatedByString:@","];
    }
    
    if ([currentSelectedImages containsObject:allImageNames[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *names = [NSMutableArray new];
    if (self.isFrontBody) {
        if ([self.exercise.frontImages isEqual:@""]) {
            names = [NSMutableArray new];
        } else {
            names = [[NSMutableArray alloc] initWithArray:[self.exercise.frontImages componentsSeparatedByString:@","]];
        }
    } else {
        if ([self.exercise.backImages isEqual:@""]) {
            names = [NSMutableArray new];
        } else {
            names = [[NSMutableArray alloc] initWithArray:[self.exercise.backImages componentsSeparatedByString:@","]];
        }
    }
    
    if ([names containsObject:allImageNames[indexPath.row]]) {
        // delete
        [names removeObject:allImageNames[indexPath.row]];
    } else {
        NSString *name = allImageNames[indexPath.row];
        //add
        [names addObject:name];
    }
    
    [RLMRealm.defaultRealm beginWriteTransaction];
    if (self.isFrontBody) {
        self.exercise.frontImages = [names componentsJoinedByString:@","];
    } else {
        self.exercise.backImages = [names componentsJoinedByString:@","];
    }
    [RLMRealm.defaultRealm commitWriteTransaction];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)onDone {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

@end
