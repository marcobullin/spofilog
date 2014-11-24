#import "SBWorkoutViewController.h"
#import "SBBigTopBottomCell.h"
#import "SBAddEntryTableViewCell.h"
#import "SBExerciseTableViewCell.h"
#import "SBEditWorkoutTableViewCell.h"
#import "SBExercisesViewController.h"
#import "SBSetsViewController.h"
#import "SBExerciseSet.h"
#import "SBExerciseDetailCell.h"
#import "SBExerciseSetViewModel.h"
#import "SBAddEntryViewModel.h"
#import "SBHelperView.h"
#import "SBExercisesInteractor.h"

@interface SBWorkoutViewController ()
@end

@implementation SBWorkoutViewController
UIDatePicker *picker;
UIView *changeView;
UIView *overlayView;
UITextField *textfield;

#pragma mark - lifecycle methods

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Workout", nil);
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Edit Workout Screen";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.workoutPresenter findExercisesFromWorkout:self.workout];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

#pragma mark - actions

- (void)displayExercises:(NSArray *)exercises {
    self.exercises = [NSMutableArray arrayWithArray:exercises];
}

- (void)displayAddedExercise:(NSDictionary *)exercise {
    [self.exercises addObject:exercise];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self.exercises count]+1 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    if ([self.exercises count] == 1) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)deletedExerciseAtIndex:(int)index {
    [self.exercises removeObjectAtIndex:index];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index+2 inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    if ([self.exercises count] == 0) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)displayWorkoutWithName:(NSString *)name andDate:(NSDate *)date {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SBBigTopBottomCell *workoutCell = (SBBigTopBottomCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    self.workout[@"name"] = name;
    self.workout[@"date"] = date;
    
    SBWorkoutViewModel *workoutViewModel = [[SBWorkoutViewModel alloc] initWithWorkout:self.workout];
    [workoutCell render:workoutViewModel];
    
    [UIView animateWithDuration:.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 340);
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        [changeView removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource

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
        
        NSDictionary *exercise = [self.exercises objectAtIndex:index];
        [self.workoutPresenter removeExercise:exercise fromWorkout:self.workout atIndex:index];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = (int)[self.exercises count] + 2;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier;
    
    // Workout row with name and date
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

    // Add a new exercise row
    if (indexPath.row == 1) {
        cellIdentifier = @"addExerciseCell";
        
        SBAddEntryTableViewCell *addExerciseCell = (SBAddEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (addExerciseCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBAddEntryTableViewCell" owner:self options:nil];
            addExerciseCell = [nib objectAtIndex:0];
        }
        
        SBAddEntryViewModel *addEntryViewModel = [[SBAddEntryViewModel alloc] initWithExercises:self.exercises];
        
        [addExerciseCell render:addEntryViewModel];
        
        return addExerciseCell;
    }
    
    // exercise row
    cellIdentifier = @"exerciseCell";
    
    SBExerciseDetailCell *exerciseCell = (SBExerciseDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBExerciseDetailCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    
    // standard -2 because of (workout and add exercise cell)
    int index = (int)indexPath.row - 2;
    
    SBExerciseSetViewModel *exerciseSetViewModel = [[SBExerciseSetViewModel alloc] initWithExercise:[self.exercises objectAtIndex:index]];
    
    [exerciseCell renderWithExerciseSetVM:exerciseSetViewModel];
    
    return exerciseCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // user touched on workout to edit name or date
    if (indexPath.row == 0) {
        [self displayEditWorkoutView];
        return;
    }
    
    // user touched on add new exercise
    if (indexPath.row == 1) {
        SBExercisesViewController *exercisesViewController = [[SBExercisesViewController alloc] initWithNibName:@"SBExercisesViewController" bundle:nil];
        
        
        SBExercisesPresenter *exercisesPresenter = [SBExercisesPresenter new];
        SBExercisesInteractor *exercisesInteractor = [SBExercisesInteractor new];
        
        exercisesViewController.presenter = exercisesPresenter;
        exercisesPresenter.view = exercisesViewController;
        exercisesPresenter.interactor = exercisesInteractor;
        exercisesInteractor.output = exercisesPresenter;

        exercisesViewController.delegate = self;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:exercisesViewController];
        navController.navigationBar.shadowImage = [UIImage new];
        navController.navigationBar.barTintColor = [UIColor navigationBarColor];
        navController.navigationBar.tintColor = [UIColor whiteColor];
        [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        [self presentViewController:navController animated:YES completion:nil];
        
        return;
    }
    
    // user touched on an exercise
    SBSetsViewController *setViewController = [[SBSetsViewController alloc] initWithNibName:@"SBSetsViewController" bundle:nil];
    
    // standard -2 because of (workout and add exercise cell)
    int index = (int)indexPath.row - 2;
    
    SBExerciseSet *exercise = [self.exercises objectAtIndex:index];
    setViewController.exercise = exercise;
    
    [self.navigationController pushViewController:setViewController animated:YES];
}

#pragma mark - SBExerciseViewControllerDelegate

- (void)addExercisesViewController:(SBExercisesViewController *)controller didSelectExercise:(NSDictionary *) exercise {
    
    SBHelperView *helperView = [[SBHelperView alloc] initWithMessage:NSLocalizedString(@"Touch to add or edit sets", nil)
                                                             onPoint:CGPointMake(20, 240)
                                                      andHintOnPoint:CGRectMake(0, 178, self.view.frame.size.width, 77)
                                                     andRenderOnView:self.parentViewController.view];
    
    helperView.frame = self.view.frame;
    
    [self.workoutPresenter addExercise:exercise toWorkout:self.workout];
}

#pragma mark - actions

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
    textfield.text = [self.workout[@"name"] isEqualToString:@"Workout"] ? @"" : self.workout[@"name"];
    textfield.placeholder = NSLocalizedString(@"New Workout Name", nil);
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
    picker.date = self.workout[@"date"];
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
    
    UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateWorkoutNameAndDate:)];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeOverlay:)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 11.0f, 100, 21.0f)];
    [titleLabel setText:titleString];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:cancelBtn,flexibleSpaceLeft,title,flexibleSpaceLeft, doneBtn, nil];
    [inputAccessoryView setItems:array];
    
    return inputAccessoryView;
}

- (void)closeOverlay:(id)sender {
    [UIView animateWithDuration:.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 340);
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        [changeView removeFromSuperview];
    }];
}

- (void)updateWorkoutNameAndDate:(id)sender {
    [self.workoutPresenter updateWorkout:self.workout withName:textfield.text andDate:picker.date];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
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

@end
