//
//  SBExercisesViewController.m
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBExercisesViewController.h"
#import "SBExercise.h"
#import "SBExerciseTableViewCell.h"
#import "SBCreateExerciseTableViewCell.h"
#import "UIColor+SBColor.h"

@interface SBExercisesViewController ()
@property (nonatomic, strong) RLMArray *exercises;
@end

@implementation SBExercisesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Exercises", nil);
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Exercises Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *key = @"exercisesAlreadyImported";
    
    if([preferences objectForKey:key] == nil) {
        SBExercise *exercise = [[SBExercise alloc] init];
        exercise.name = NSLocalizedString(@"bench press", nil);
        
        SBExercise *exercise2 = [[SBExercise alloc] init];
        exercise2.name = NSLocalizedString(@"deadlift", nil);
        
        SBExercise *exercise3 = [[SBExercise alloc] init];
        exercise3.name = NSLocalizedString(@"biceps curls", nil);
        
        SBExercise *exercise4 = [[SBExercise alloc] init];
        exercise4.name = NSLocalizedString(@"shoulder press", nil);
        
        SBExercise *exercise5 = [[SBExercise alloc] init];
        exercise5.name = NSLocalizedString(@"hammer curl", nil);
        
        SBExercise *exercise6 = [[SBExercise alloc] init];
        exercise6.name = NSLocalizedString(@"tricep press", nil);
        
        SBExercise *exercise7 = [[SBExercise alloc] init];
        exercise7.name = NSLocalizedString(@"barbell shrug", nil);
        
        SBExercise *exercise8 = [[SBExercise alloc] init];
        exercise8.name = NSLocalizedString(@"full squat", nil);
        
        SBExercise *exercise9 = [[SBExercise alloc] init];
        exercise9.name = NSLocalizedString(@"bench pull", nil);
        
        SBExercise *exercise10 = [[SBExercise alloc] init];
        exercise10.name = NSLocalizedString(@"butterfly", nil);
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addObject:exercise];
        [realm addObject:exercise2];
        [realm addObject:exercise3];
        [realm addObject:exercise4];
        [realm addObject:exercise5];
        [realm addObject:exercise6];
        [realm addObject:exercise7];
        [realm addObject:exercise8];
        [realm addObject:exercise9];
        [realm addObject:exercise10];
        [realm commitWriteTransaction];
        
        [preferences setInteger:1 forKey:key];
    }
    
    self.exercises = [[SBExercise allObjects] arraySortedByProperty:@"name" ascending:YES];
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int index = (int)indexPath.row - 1;
        
        SBExercise *exercise = [self.exercises objectAtIndex:index];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        [realm deleteObject:exercise];
        [realm commitWriteTransaction];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exercises count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier;
    
    if (indexPath.row == 0) {
        cellIdentifier = @"createExerciseCell";
        
        SBCreateExerciseTableViewCell *createExerciseCell = (SBCreateExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (createExerciseCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBCreateExerciseTableViewCell" owner:self options:nil];
            createExerciseCell = [nib objectAtIndex:0];
        }

        createExerciseCell.exerciseField.placeholder = NSLocalizedString(@"New exercise", nil);
        createExerciseCell.exerciseField.delegate = self;
        createExerciseCell.exerciseField.returnKeyType = UIReturnKeyDone;
        createExerciseCell.exerciseField.textColor = [UIColor textColor];
        createExerciseCell.exerciseField.tintColor = [UIColor textColor];
        createExerciseCell.exerciseField.backgroundColor = [UIColor whiteColor];
        createExerciseCell.backgroundColor = [UIColor actionCellColor];
        createExerciseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [createExerciseCell.addButton addTarget:self
                                         action:@selector(textFieldShouldReturn:)
                               forControlEvents:UIControlEventTouchUpInside];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, createExerciseCell.exerciseField.frame.size.height)];
        leftView.backgroundColor = [UIColor clearColor];
        createExerciseCell.exerciseField.leftView = leftView;
        createExerciseCell.exerciseField.leftViewMode = UITextFieldViewModeAlways;
        
        return createExerciseCell;
    }
    
    cellIdentifier = @"exerciseCell";
    
    SBExerciseTableViewCell *exerciseCell = (SBExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBExerciseTableViewCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    
    SBExercise *exercise = [self.exercises objectAtIndex:indexPath.row-1];
    exerciseCell.exerciseLabel.text = exercise.name;
    exerciseCell.exerciseLabel.textColor = [UIColor textColor];
    //exerciseCell.layoutMargins = UIEdgeInsetsZero;
    exerciseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    exerciseCell.backgroundColor = [UIColor clearColor];
    
    return exerciseCell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SBCreateExerciseTableViewCell *cell = (SBCreateExerciseTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *exerciseName = [cell.exerciseField.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
    
    if ([exerciseName isEqualToString:@""]) {
        [cell.exerciseField resignFirstResponder];
        return YES;
    }
    
    SBExercise *exercise = [[SBExercise alloc] init];
    exercise.name = exerciseName;
    
    [RLMRealm.defaultRealm beginWriteTransaction];
    [RLMRealm.defaultRealm addObject:exercise];
    [RLMRealm.defaultRealm commitWriteTransaction];
    
    self.exercises = [[SBExercise allObjects] arraySortedByProperty:@"name" ascending:YES];
    [self.tableView reloadData];
    
    [cell.exerciseField resignFirstResponder];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    
    SBExercise *exercise = [self.exercises objectAtIndex:indexPath.row - 1];
    
    [self.delegate addExercisesViewController:self didSelectExercise:exercise];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
