//
//  YYMenuViewController.m
//  YouYun
//
//  Created by Ranchao Zhang on 2/28/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYMenuViewController.h"

static NSString * const LAST_VISITED_PAGE_KEY = @"LAST_VISITED_PAGE_KEY";
static NSString * const MENU_TABLE_VIEW_CELL_ID = @"MENU_TABLE_VIEW_CELL_ID";

@interface YYMenuViewController ()

@end

@implementation YYMenuViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialize
{
    [self reload];
}

- (void)reload {
    @try {
        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"settings" withExtension:@"plist"]];
        _menuItems = settings[@"menu items"][[[YYUser I] typeKey]];
        
        // Validate entries
        NSAssert(_menuItems && _menuItems.count, @"Settings file should have menu items.");
        for (NSDictionary *item in _menuItems) {
            NSAssert(item[@"module"] && item[@"title"], @"Menu item should have a module and a title.");
        }
        
        _moduleIdentifiers = settings[@"module identifiers"];
        for (NSString *key in [_moduleIdentifiers allKeys]) {
            NSAssert(key && _moduleIdentifiers[key], @"Module should have a key and an identifier.");
        }
    }
    @catch (NSException *exception) {
        // TODO
    }
    @finally {
    }
}

- (void)loadInitialMenuItem
{
    // Retrieve last visited page
    NSDictionary *lastVisited = [[NSUserDefaults standardUserDefaults] dictionaryForKey:LAST_VISITED_PAGE_KEY];
    NSDictionary *info = lastVisited ? lastVisited : _menuItems[0];
    [self transitionToViewController:info];
}

- (void)loadMenuItemAtIndex:(NSInteger) index
{
    if (index >= 0 && index < _menuItems.count) {
        [self transitionToViewController:_menuItems[index]];
    }
}

- (void)transitionToViewController:(NSDictionary *) info
{
    if (info == _selectedMenuItem) return;
    
    @try {
        _selectedMenuItem = info;
        [[NSUserDefaults standardUserDefaults] setObject:info forKey:LAST_VISITED_PAGE_KEY];
        
        BOOL animateTransition = _drawer.paneViewController != nil;
        UIViewController *viewController = [_drawer.storyboard instantiateViewControllerWithIdentifier:_moduleIdentifiers[info[@"module"]]];
        viewController.navigationItem.title = info[@"title"];
        [self setMenuIconForViewController:viewController];
        
        YYNavigationController *navi = [[YYNavigationController alloc] initWithRootViewController:viewController];
        
        [_drawer setPaneViewController:navi animated:animateTransition completion:nil];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)setMenuIconForViewController:(UIViewController *) viewCtrl
{
    FAKIonIcons *menuIcon = [FAKIonIcons naviconRoundIconWithSize:28];
    [menuIcon addAttribute:NSForegroundColorAttributeName value:UI_COLOR];
    
    UIButton *menuButton = [UIButton new];
    menuButton.frame = CGRectMake(276, 0, 44, 44);
    [menuButton setBackgroundImage:[menuIcon imageWithSize:CGSizeMake(44, 44)] forState:UIControlStateNormal];
    [menuButton setShowsTouchWhenHighlighted:YES];
    [menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -16;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    viewCtrl.navigationItem.leftBarButtonItems = @[spacer, barItem];
}

- (void)menuButtonClicked:(id)sender
{
    OLog(@"menuButtonClicked");
    BOOL drawerIsOpen = _drawer.paneState == MSDynamicsDrawerPaneStateOpen;
    if (drawerIsOpen) {
        [_drawer setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:^{
        }];
    } else {
        [_drawer setPaneState:MSDynamicsDrawerPaneStateOpen animated:YES allowUserInterruption:YES completion:^{
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:MENU_TABLE_VIEW_CELL_ID];
    NSDictionary *info = _menuItems[indexPath.row];
    cell.textLabel.text = info[@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = _menuItems[indexPath.row];
    [self transitionToViewController:info];
}

@end
