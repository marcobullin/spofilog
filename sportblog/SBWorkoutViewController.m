//
//  SBExercisesViewController.m
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBWorkoutViewController.h"
#import "SBBigTopBottomCell.h"
#import "SBAddEntryTableViewCell.h"
#import "SBExerciseTableViewCell.h"
#import "SBEditWorkoutTableViewCell.h"
#import "SBExercisesViewController.h"
#import "SBSetsViewController.h"
#import "SBExerciseSet.h"
#import "UIViewController+Tutorial.h"
#import "SBSmallTopBottomCell.h"
#import "SBExerciseSetViewModel.h"
#import "SBAddEntryViewModel.h"

@interface SBWorkoutViewController ()

@end

@implementation SBWorkoutViewController
UIDatePicker *picker;
UIView *changeView;
UIView *overlayView;
UITextField *textfield;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Workout", nil);
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(onWorkoutCompleted:)];

        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                    target:self
                                                                                    action:@selector(onCancelWorkout:)];
        
        self.navigationItem.rightBarButtonItem = doneButton;
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Edit Workout Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interactor = [SBWorkoutsInteractor new];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    
    self.navigationItem.hidesBackButton = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // standard -2 because of (workout and add exercise cell)
        int index = (int)indexPath.row - 2;
        
        [self.interactor removeExerciseAtRow:index fromWorkout:self.workout];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        if ([self.workout.exercises count] == 0) {
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = (int)[self.workout.exercises count] + 2;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"exerciseCell";
    
    if (indexPath.row == 0) {
        cellIdentifier = @"workoutCell";
        SBBigTopBottomCell *workoutCell = (SBBigTopBottomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (workoutCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBBigTopBottomCell" owner:self options:nil];
            workoutCell = [nib objectAtIndex:0];
        }
        
        SBWorkoutViewModel *workoutViewModel = [[SBWorkoutViewModel alloc] initWithWorkout:self.workout];
        [workoutCell render:workoutViewModel];
        
        return workoutCell;
    }

    if (indexPath.row == 1) {
        cellIdentifier = @"addExerciseCell";
        
        SBAddEntryTableViewCell *addExerciseCell = (SBAddEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (addExerciseCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBAddEntryTableViewCell" owner:self options:nil];
            addExerciseCell = [nib objectAtIndex:0];
        }
        
        SBAddEntryViewModel *addEntryViewModel = [[SBAddEntryViewModel alloc] initWithExercises:self.workout.exercises];
        
        [addExerciseCell render:addEntryViewModel];
        
        return addExerciseCell;
    }
    
    SBSmallTopBottomCell *exerciseCell = (SBSmallTopBottomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBSmallTopBottomCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    
    // standard -2 because of (workout and add exercise cell)
    int index = (int)indexPath.row - 2;
    
    SBExerciseSet *exercise = [self.workout.exercises objectAtIndex:index];
    
    SBExerciseSetViewModel *exerciseSetViewModel = [[SBExerciseSetViewModel alloc] initWithExercise:exercise];
    
    [exerciseCell renderWithExerciseSetVM:exerciseSetViewModel];
    
    return exerciseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // user touched on workout to edit name or date
    if (indexPath.row == 0) {
        [self displayEditWorkoutView];
        return;
    }
    
    // user touched on add new exercise
    if (indexPath.row == 1) {
        SBExercisesViewController *exercisesViewController = [[SBExercisesViewController alloc] initWithNibName:@"SBExercisesViewController" bundle:nil];
        
        exercisesViewController.delegate = self;
        [self.navigationController pushViewController:exercisesViewController animated:YES];
        
        return;
    }
    
    // user touched on an exercise
    SBSetsViewController *setViewController = [[SBSetsViewController alloc] initWithNibName:@"SBSetsViewController" bundle:nil];
    
    // standard -2 because of (workout and add exercise cell)
    int index = (int)indexPath.row - 2;
    
    SBExerciseSet *exercise = [self.workout.exercises objectAtIndex:index];
    setViewController.exercise = exercise;
    
    [self.navigationController pushViewController:setViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell.frame.size.height;
}

- (IBAction)onWorkoutCompleted:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCancelWorkout:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addExercisesViewController:(SBExercisesViewController *)controller didSelectExercise:(SBExercise *) exercise {
    
    [self startTapTutorialWithInfo:NSLocalizedString(@"Touch to add or edit sets", nil)
                           atPoint:CGPointMake(160, self.view.frame.size.height / 2 + 50)
              withFingerprintPoint:CGPointMake(50, 205)
              shouldHideBackground:NO];
    
    SBExerciseSet *exerciseSet =  [[SBExerciseSet alloc] init];
    exerciseSet.name = exercise.name;
    exerciseSet.date = self.workout.date;
    exerciseSet.created = [[NSDate date] timeIntervalSince1970];
    
    [self.workout.realm beginWriteTransaction];
    [self.workout.exercises addObject:exerciseSet];
    [self.workout.realm commitWriteTransaction];
    
    [self.navigationController popViewControllerAnimated:YES];
        
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self.workout.exercises count]+1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    if ([self.workout.exercises count] == 1) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)displayEditWorkoutView {
    changeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 340)];
    changeView.backgroundColor = [UIColor whiteColor];
    
    if (overlayView == nil) {
        overlayView = [UIView new];
        overlayView.frame = self.tableView.frame;
        overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    
    [self.view addSubview:overlayView];
    [self.view addSubview:changeView];
    
    UIView *v = [UIView new];
    v.frame = CGRectMake(0, 44, self.view.frame.size.width, 64);
    v.backgroundColor = [UIColor actionCellColor];
    
    textfield = [UITextField new];
    textfield.frame = CGRectMake(8, 17, self.view.frame.size.width - 16, 30);
    textfield.text = self.workout.name;
    textfield.placeholder = NSLocalizedString(@"Workout", nil);
    textfield.textColor = [UIColor textColor];
    textfield.tintColor = [UIColor textColor];
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.delegate = (id)self;
    

    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textfield.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    
    [v addSubview:textfield];
    
    
    picker = [[UIDatePicker alloc] init];
    picker.frame = CGRectMake(0, 108, self.view.frame.size.width, 162);
    picker.date = self.workout.date;
    picker.datePickerMode = UIDatePickerModeDate;
    
    [changeView addSubview:[self createToolbar:NSLocalizedString(@"Workout", nil)]];
    [changeView addSubview:v];
    [changeView addSubview:picker];
    
    [UIView animateWithDuration:0.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height - changeView.frame.size.height,self.tableView.frame.size.width, 340);
    }];
}

- (UIView *)createToolbar:(NSString *)titleString {
    UIToolbar *inputAccessoryView = [[UIToolbar alloc] init];
    inputAccessoryView.translucent = NO;
    inputAccessoryView.barTintColor = [UIColor importantCellColor];
    inputAccessoryView.tintColor = [UIColor whiteColor];
    inputAccessoryView.barStyle = UIBarStyleDefault;
    inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [inputAccessoryView sizeToFit];
    
    CGRect frame = inputAccessoryView.frame;
    frame.size.height = 44.0f;
    inputAccessoryView.frame = frame;
    
    UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 11.0f, 100, 21.0f)];
    [titleLabel setText:titleString];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:cancelBtn,flexibleSpaceLeft,title,flexibleSpaceLeft, doneBtn, nil];
    [inputAccessoryView setItems:array];
    
    return inputAccessoryView;
}

- (void)cancel:(id)sender {
    [UIView animateWithDuration:.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 340);
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        [changeView removeFromSuperview];
    }];
}

- (void)done:(id)sender {
    NSDate *date = picker.date;
    NSString *workoutName = textfield.text;

    if ([workoutName isEqualToString:@""]) {
        workoutName = NSLocalizedString(@"Workout", nil);
    }
    
    [self.interactor updateWorkout:self.workout withName:workoutName andDate:date];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SBBigTopBottomCell *workoutCell = (SBBigTopBottomCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    SBWorkoutViewModel *workoutViewModel = [[SBWorkoutViewModel alloc] initWithWorkout:self.workout];
    [workoutCell render:workoutViewModel];
    
    [UIView animateWithDuration:.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 340);
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        [changeView removeFromSuperview];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardDidShow: (NSNotification *) notif{
    CGRect keyboardRect = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    changeView.frame = CGRectMake(changeView.frame.origin.x, keyboardRect.origin.y - 44 - 64, changeView.frame.size.width, changeView.frame.size.height);
}

- (void)keyboardDidHide: (NSNotification *) notif{
    changeView.frame = CGRectMake(changeView.frame.origin.x, self.tableView.frame.size.height - 340, changeView.frame.size.width, changeView.frame.size.height);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

@end
