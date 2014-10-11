//
//  GroupEditViewController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "GroupEditViewController.h"
#import "Group.h"
#import "User.h"
#import "SelectUserViewController.h"
#import "UserDefaults.h"

@interface GroupEditViewController () <SelectUserDelegate>

@end

@implementation GroupEditViewController {
    Group* _group;
    User* _user;
}

- (id)initWithGroup:(Group *)group user:(User *)user {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _group = group;
        _user = user;
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = _group.name;
        UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
        self.navigationItem.rightBarButtonItem = addItem;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)add:(id)sender {
    SelectUserViewController* vc = [[SelectUserViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectedUser:(User *)user {
    [_group.users addObject:user];
    [_user save];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _group.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    User* user = [_group.users objectAtIndex:indexPath.row];
    cell.textLabel.text = user.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
