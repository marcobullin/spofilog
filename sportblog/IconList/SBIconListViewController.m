#import "SBIconListViewController.h"
#import "SBIconCell.h"
#import "SBExerciseSet.h"

static NSString * const IconCellIdentifier = @"IconCell";

@interface SBIconListViewController ()

@end

@implementation SBIconListViewController

NSArray *allImageNames;
NSArray *currentSelectedImages;

#pragma mark - lifecycle methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Icon List Screen";
}

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
    
    self.frontImages = self.exercise[@"frontImages"];
    self.backImages = self.exercise[@"backImages"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

#pragma mark - Actions
- (void)updatedIcons:(NSDictionary *)icons atIndexPath:(NSIndexPath *)indexPath {
    if (icons[@"frontImages"]) {
        self.frontImages = icons[@"frontImages"];
    } else {
        self.backImages = icons[@"backImages"];
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
        currentSelectedImages = self.frontImages;
    } else {
        currentSelectedImages = self.backImages;
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
        if ([self.frontImages count] > 0) {
            names = [[NSMutableArray alloc] initWithArray:self.frontImages];
        }
    } else {
        if ([self.backImages count] > 0) {
            names = [[NSMutableArray alloc] initWithArray:self.backImages];
        }
    }
    
    NSString *currentName = allImageNames[indexPath.row];
    
    if ([names containsObject:currentName]) {
        // delete
        [names removeObject:currentName];
    } else {
        //add
        [names addObject:currentName];
    }
        
    if (self.isFrontBody) {
        [self.presenter updateExercise:self.exercise withFrontImages:names atIndexPath:indexPath];
    } else {
        [self.presenter updateExercise:self.exercise withBackImages:names atIndexPath:indexPath];
    }
}

- (void)onDone {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

@end
