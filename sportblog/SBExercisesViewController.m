#import "SBExercisesViewController.h"
#import "SBExercise.h"
#import "SBExerciseTableViewCell.h"
#import "SBCreateExerciseTableViewCell.h"
#import "UIColor+SBColor.h"
#import "SBIconListViewController.h"

@interface SBExercisesViewController ()
@end

@implementation SBExercisesViewController

int currentSelectedExercises = -1;
int position = -1;

#pragma mark - lifecycle methods

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Exercises", nil);
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone)];
        self.navigationItem.rightBarButtonItem = doneButton;
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Exercises Screen";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentSelectedExercises = -1;
    position = -1;

    [self createOrIgnoreDefaultExercises];
    [self.presenter findExercises];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.backgroundColor = [UIColor lightBackgroundColor];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

#pragma mark - Actions

- (void)displayExercises:(NSArray *)exercises {
    self.exercises = [NSMutableArray arrayWithArray:exercises];
}

- (void)deletedExerciseAtIndex:(int)index {
    [self.exercises removeObjectAtIndex:index];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)createdExercise:(NSDictionary *)exercise {
    [self.presenter findExercises];
    
    currentSelectedExercises = -1;
    
    [self.tableView reloadData];
    
    [self scrollToExerciseWithName:exercise[@"name"]];
}

- (void)scrollToExerciseWithName:(NSString *)name {
    position = 0;
    for (NSDictionary *e in self.exercises) {
        if ([e[@"name"] isEqualToString:name]) {
            break;
        }
        position += 1;
    }
    
    NSIndexPath *iP = [NSIndexPath indexPathForRow:position inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:iP atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int index = (int)indexPath.row - 1;

        if (index == currentSelectedExercises) {
            currentSelectedExercises = -1;
        } else if (index < currentSelectedExercises) {
            currentSelectedExercises -= 1;
        }

        [self.presenter deletedExerciseAtIndex:index];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exercises count] + 1;
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
    
    NSDictionary *exercise = [self.exercises objectAtIndex:indexPath.row-1];
    exerciseCell.exerciseLabel.text = exercise[@"name"];
    exerciseCell.exerciseLabel.textColor = [UIColor headlineColor];
    exerciseCell.backgroundColor = [UIColor clearColor];
    exerciseCell.leftButton.tag = indexPath.row-1;
    [exerciseCell.leftButton addTarget:self action:@selector(onChangeLeftIcon:) forControlEvents:UIControlEventTouchUpInside];
    exerciseCell.rightButton.tag = indexPath.row-1;
    [exerciseCell.rightButton addTarget:self action:@selector(onChangeRightIcon:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([exercise[@"backImages"] count] > 0) {
        for (NSString *imageName in exercise[@"backImages"]) {
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
    
    if ([exercise[@"frontImages"] count] > 0) {
        for (NSString *imageName in exercise[@"frontImages"]) {
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
    
    if (position != -1 && indexPath.row == (position+1)) {
        exerciseCell.backgroundColor = [UIColor actionCellColor];
        [UIView animateWithDuration:1.0 animations:^{
            exerciseCell.backgroundColor = [UIColor clearColor];
            position = -1;
        }];
    }
    
    return exerciseCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    
    currentSelectedExercises = (int)indexPath.row-1;
    [self.tableView reloadData];
}


#pragma mark - actions

- (void)onChangeLeftIcon:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSDictionary *exercise = [self.exercises objectAtIndex:button.tag];
    
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
    NSDictionary *exercise = [self.exercises objectAtIndex:button.tag];
    
    SBIconListViewController *controller = [[SBIconListViewController alloc] initWithNibName:@"SBIconListViewController" bundle:nil];
    controller.exercise = exercise;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.navigationBar.shadowImage = [UIImage new];
    navController.navigationBar.barTintColor = [UIColor navigationBarColor];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SBCreateExerciseTableViewCell *cell = (SBCreateExerciseTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *exerciseName = [cell.exerciseField.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];

    [cell.exerciseField resignFirstResponder];
    
    if (!exerciseName || [exerciseName isEqualToString:@""]) {
        return YES;
    }
    
    [self.presenter createExerciseWithName:exerciseName];
    
    return YES;
}

- (void)onDone {
    if (currentSelectedExercises != -1) {
        NSDictionary *exercise = [self.exercises objectAtIndex:currentSelectedExercises];
        [self.delegate addExercisesViewController:self didSelectExercise:exercise];
    }

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)createOrIgnoreDefaultExercises {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *key = @"exercisesAlreadyImported";
    
    if ([preferences objectForKey:key] == nil) {
        [self.presenter createBulkOfExercises];
        [preferences setInteger:1 forKey:key];
    }
}

@end
