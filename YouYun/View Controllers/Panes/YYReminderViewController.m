//
//  YYReminderViewController.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/21/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYReminderViewController.h"

static NSString * const REMINDER_TABLE_VIEW_CELL_ID = @"REMINDER_TABLE_VIEW_CELL_ID";

@interface YYReminderViewController ()

@end

@implementation YYReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialize];
    
    [self fetchReminders];
}

- (void)initialize
{
    FAKIonIcons *newReminderIcon = [FAKIonIcons ios7PlusIconWithSize:28];
    [newReminderIcon addAttribute:NSForegroundColorAttributeName value:UI_COLOR];
    
    UIButton *newReminderButton = [UIButton new];
    newReminderButton.frame = CGRectMake(276, 0, 44, 44);
    [newReminderButton setBackgroundImage:[newReminderIcon imageWithSize:CGSizeMake(44, 44)] forState:UIControlStateNormal];
    [newReminderButton setShowsTouchWhenHighlighted:YES];
    [newReminderButton addTarget:self action:@selector(newReminderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -16;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:newReminderButton];
    self.navigationItem.rightBarButtonItems = @[spacer, barItem];
//    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Reminder
- (void)fetchReminders
{
    NSDictionary *parameter = @{@"signature" : @"tempkey"};
    [[YYHTTPManager I] GET:GET_REMINDERS_API parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        OLog(responseObject);
        _reminders = responseObject[@"result"];
        [_table reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        OLog(@"failure");
        OLog(error);
    }];
}

#pragma mark - UIBarButtonItem
- (void)newReminderButtonClicked:(id)sender
{
    YYNewReminderView *view = [YYNewReminderView new];
   [self presentSemiView:view];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYReminderTableViewCell *cell = [_table dequeueReusableCellWithIdentifier:REMINDER_TABLE_VIEW_CELL_ID];
    NSDictionary *info = _reminders[indexPath.row];
    cell.title.text = info[@"message"];
    return cell;
}

@end
