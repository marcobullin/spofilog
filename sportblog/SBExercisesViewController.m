#import "SBExercisesViewController.h"
#import "SBExercise.h"
#import "SBExerciseTableViewCell.h"
#import "SBCreateExerciseTableViewCell.h"
#import "UIColor+SBColor.h"
#import "SBIconListViewController.h"

@interface SBExercisesViewController ()
@property (nonatomic, strong) RLMArray *exercises;
@end

@implementation SBExercisesViewController
int currentSelectedExercises = -1;
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
    currentSelectedExercises = -1;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
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
        exercise.frontImages = @"front_shoulder,front_breast";
        exercise.backImages = @"back_triceps";
        
        SBExercise *exercise2 = [[SBExercise alloc] init];
        exercise2.name = NSLocalizedString(@"deadlift", nil);
        exercise2.frontImages = @"front_neck,front_sides,front_sixpack,front_legs";
        exercise2.backImages = @"back_neck,back_back,back_ass,back_legs";
        
        SBExercise *exercise3 = [[SBExercise alloc] init];
        exercise3.name = NSLocalizedString(@"biceps curls", nil);
        exercise3.frontImages = @"front_biceps";
        exercise3.backImages = @"back";
        
        SBExercise *exercise4 = [[SBExercise alloc] init];
        exercise4.name = NSLocalizedString(@"shoulder press", nil);
        exercise4.frontImages = @"front_neck,front_shoulder";
        exercise4.backImages = @"back_neck,back_shoulder";
        
        SBExercise *exercise5 = [[SBExercise alloc] init];
        exercise5.name = NSLocalizedString(@"hammer curl", nil);
        exercise5.frontImages = @"front_biceps,front_underarm";
        exercise5.backImages = @"back_underarm";
        
        SBExercise *exercise6 = [[SBExercise alloc] init];
        exercise6.name = NSLocalizedString(@"tricep press", nil);
        exercise6.frontImages = @"front";
        exercise6.backImages = @"back_triceps";
        
        SBExercise *exercise7 = [[SBExercise alloc] init];
        exercise7.name = NSLocalizedString(@"barbell shrug", nil);
        exercise7.frontImages = @"front_neck,front_underarm";
        exercise7.backImages = @"back_neck,back_underarm";
        
        SBExercise *exercise8 = [[SBExercise alloc] init];
        exercise8.name = NSLocalizedString(@"full squat", nil);
        exercise8.frontImages = @"front_legs";
        exercise8.backImages = @"back_ass,back_legs";
        
        SBExercise *exercise9 = [[SBExercise alloc] init];
        exercise9.name = NSLocalizedString(@"bench pull", nil);
        exercise9.frontImages = @"front";
        exercise9.backImages = @"back_triceps,back_shoulder,back_back";
        
        SBExercise *exercise10 = [[SBExercise alloc] init];
        exercise10.name = NSLocalizedString(@"butterfly", nil);
        exercise10.frontImages = @"front_shoulder,front_breast";
        exercise10.backImages = @"back";
        
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
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
        
        if (index == currentSelectedExercises) {
            currentSelectedExercises = -1;
        } else if (index < currentSelectedExercises) {
            currentSelectedExercises -= 1;
        }
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
    exerciseCell.exerciseLabel.textColor = [UIColor headlineColor];
    //exerciseCell.layoutMargins = UIEdgeInsetsZero;
    //exerciseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    exerciseCell.backgroundColor = [UIColor clearColor];
    exerciseCell.leftButton.tag = indexPath.row-1;
    [exerciseCell.leftButton addTarget:self action:@selector(onChangeLeftIcon:) forControlEvents:UIControlEventTouchUpInside];
    exerciseCell.rightButton.tag = indexPath.row-1;
    [exerciseCell.rightButton addTarget:self action:@selector(onChangeRightIcon:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *frontImageNames;
    NSArray *backImageNames;
    if (exercise.frontImages != nil && ![exercise.frontImages isEqualToString:@""]) {
        frontImageNames = [exercise.frontImages componentsSeparatedByString: @","];
    }
    
    if (exercise.backImages != nil && ![exercise.backImages isEqualToString:@""]) {
        backImageNames = [exercise.backImages componentsSeparatedByString: @","];
    }

    if ([backImageNames count] > 0) {
        for (NSString *imageName in backImageNames) {
            UIImage *image = [UIImage imageNamed:imageName];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            [imageView setImage:image];
            
            [exerciseCell.rightButton addSubview:imageView];
        }
    } else {
        UIImage *image = [UIImage imageNamed:@"back"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [imageView setImage:image];
        
        [exerciseCell.rightButton addSubview:imageView];
    }
    
    if ([frontImageNames count] > 0) {
        for (NSString *imageName in frontImageNames) {
            UIImage *image = [UIImage imageNamed:imageName];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            [imageView setImage:image];
            
            [exerciseCell.leftButton addSubview:imageView];
        }
    } else {
        UIImage *image = [UIImage imageNamed:@"front"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [imageView setImage:image];
        
        [exerciseCell.leftButton addSubview:imageView];
        
    }
    
    if (currentSelectedExercises == (indexPath.row-1)) {
        exerciseCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        exerciseCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return exerciseCell;
}

- (void)onChangeLeftIcon:(id)sender {
    UIButton *button = (UIButton *)sender;
    SBExercise *exercise = [self.exercises objectAtIndex:button.tag];
    
    SBIconListViewController *controller = [[SBIconListViewController alloc] initWithNibName:@"SBIconListViewController" bundle:nil];
    controller.exercise = exercise;
    controller.isFrontBody = YES;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.navigationBar.shadowImage = [UIImage new];
    navController.navigationBar.barTintColor = [UIColor navigationBarColor];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    [self presentViewController:navController animated:YES completion:nil];
}

- (void)onChangeRightIcon:(id)sender {
    UIButton *button = (UIButton *)sender;
    SBExercise *exercise = [self.exercises objectAtIndex:button.tag];
    
    SBIconListViewController *controller = [[SBIconListViewController alloc] initWithNibName:@"SBIconListViewController" bundle:nil];
    controller.exercise = exercise;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.navigationBar.shadowImage = [UIImage new];
    navController.navigationBar.barTintColor = [UIColor navigationBarColor];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self presentViewController:navController animated:YES completion:nil];
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
    exercise.frontImages = @"front";
    exercise.backImages = @"back";
    
    [RLMRealm.defaultRealm beginWriteTransaction];
    [RLMRealm.defaultRealm addObject:exercise];
    [RLMRealm.defaultRealm commitWriteTransaction];
    
    self.exercises = [[SBExercise allObjects] arraySortedByProperty:@"name" ascending:YES];
    [self.tableView reloadData];
    
    [cell.exerciseField resignFirstResponder];
    
    int position = 0;
    for (SBExercise *e in self.exercises) {
        if ([e.name isEqualToString:exerciseName]) {
            break;
        }
        position += 1;
    }
    
    NSIndexPath *iP = [NSIndexPath indexPathForRow:position inSection:0];
    [self.tableView scrollToRowAtIndexPath:iP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    
    currentSelectedExercises = indexPath.row-1;
    [self.tableView reloadData];
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

- (void)onDone {
    if (currentSelectedExercises != -1) {
        SBExercise *exercise = [self.exercises objectAtIndex:currentSelectedExercises];
    
        [self.delegate addExercisesViewController:self didSelectExercise:exercise];
    }

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
