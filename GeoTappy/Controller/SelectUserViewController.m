//
//  SelectUserViewController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 12/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "SelectUserViewController.h"
#import "User.h"
#import "UserDefaults.h"

@implementation SelectUserViewController {
    User* _user;
    __weak id<SelectUserDelegate> _delegate;
}

- (instancetype)initWithDelegate:(id<SelectUserDelegate>)delegate {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _delegate = delegate;
        _user = [UserDefaults instance].currentUser;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _user.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    User* friend = [_user.friends objectAtIndex:indexPath.row];
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = friend.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User* u = [_user.friends objectAtIndex:indexPath.row];
    [_delegate selectedUser:u];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
