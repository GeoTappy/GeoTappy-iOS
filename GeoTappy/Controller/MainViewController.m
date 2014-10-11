//
//  MainViewController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "MainViewController.h"
#import "User.h"
#import "UserDefaults.h"
#import <CoreLocation/CoreLocation.h>
#import "Group.h"
#import "GroupEditViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@end

@implementation MainViewController {
    CLLocationManager* _locationManager;
    User* _user;
    UITableView* _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _user = [UserDefaults instance].currentUser;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImage* coverImage = _user.coverImage;
    UIImageView* coverImageView = [[UIImageView alloc] initWithImage:coverImage];
    coverImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:coverImageView];
    
    UIImageView* superbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"superbg"]];
    superbg.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
    superbg.alpha = 0.5;
    [self.view addSubview:superbg];
    
    UIImage* profileImage = _user.profileImage;
    UIImageView* profileImageView = [[UIImageView alloc] initWithImage:profileImage];
    profileImageView.frame = CGRectMake(self.view.frame.size.width / 2 - 35, 34, 70, 70);
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.cornerRadius = 35;
    profileImageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    profileImageView.layer.borderWidth = 4;
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:profileImageView];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, profileImageView.frame.origin.y + profileImageView.frame.size.height + 12, self.view.frame.size.width, 20)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    nameLabel.layer.shadowRadius = 1;
    nameLabel.layer.shadowOffset = CGSizeMake(0, 0);
    nameLabel.layer.shadowOpacity = 0.5;
    nameLabel.layer.masksToBounds = NO;
    nameLabel.clipsToBounds = NO;
    nameLabel.text = _user.name;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:nameLabel];
    
    
    
    UIButton* editButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 35, 35)];
    [editButton setImage:[[UIImage imageNamed:@"edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    editButton.tintColor = [UIColor whiteColor];
    editButton.layer.shadowColor = [UIColor blackColor].CGColor;
    editButton.layer.shadowRadius = 1;
    editButton.layer.shadowOffset = CGSizeMake(0, 0);
    editButton.layer.shadowOpacity = 0.5;
    editButton.layer.masksToBounds = NO;
    [editButton addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    
    UIButton* addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 25 - 10, 115, 25, 25)];
    [addButton setImage:[[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    addButton.tintColor = [UIColor whiteColor];
    addButton.layer.shadowColor = [UIColor blackColor].CGColor;
    addButton.layer.shadowRadius = 1;
    addButton.layer.shadowOffset = CGSizeMake(0, 0);
    addButton.layer.shadowOpacity = 0.5;
    addButton.layer.masksToBounds = NO;
    [addButton addTarget:self action:@selector(actionAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height - 150) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    // this is just to get the permission here in the app
    // has to be an instance var, otherwise it will get released, an the alert view disappears
    // a reason to <3 apple
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)actionEdit:(id)sender {
    [_tableView setEditing:!_tableView.editing animated:YES];
}

- (void)actionAdd:(id)sender {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"New Group" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].placeholder = @"Enter a group name";
    [av show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    return [alertView textFieldAtIndex:0].text.length > 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        Group* group = [[Group alloc] init];
        group.name = [alertView textFieldAtIndex:0].text;
        [_user.unselectedFavourites addObject:group];
        [_user save];
        [_tableView reloadData];
        GroupEditViewController* vc = [[GroupEditViewController alloc] initWithGroup:group user:_user];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Favourites";
    } else if (section == 1) {
        return @"Other";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _user.selectedFavourites.count;
    } else if (section == 1) {
        return _user.unselectedFavourites.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    id<Favourite> fav;
    if (indexPath.section == 0) {
        fav = [_user.selectedFavourites objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        fav = [_user.unselectedFavourites objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [fav displayName];
    if ([fav isKindOfClass:[Group class]]) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    } else {
        if (_user.selectedFavourites.count < 5) {
            return UITableViewCellEditingStyleInsert;
        } else {
            return UITableViewCellEditingStyleNone;
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        id obj = [_user.selectedFavourites objectAtIndex:indexPath.row];
        [_user.selectedFavourites removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_user.unselectedFavourites addObject:obj];
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:_user.unselectedFavourites.count - 1 inSection:1];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (indexPath.section == 1 && editingStyle == UITableViewCellEditingStyleInsert) {
        id obj = [_user.unselectedFavourites objectAtIndex:indexPath.row];
        [_user.unselectedFavourites removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_user.selectedFavourites addObject:obj];
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:_user.selectedFavourites.count - 1 inSection:0];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [_user save];
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id obj = [_user.selectedFavourites objectAtIndex:sourceIndexPath.row];
    [_user.selectedFavourites removeObjectAtIndex:sourceIndexPath.row];
    [_user.selectedFavourites insertObject:obj atIndex:destinationIndexPath.row];
    [_user save];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.section != sourceIndexPath.section) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<Favourite> fav;
    if (indexPath.section == 0) {
        fav = [_user.selectedFavourites objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        fav = [_user.unselectedFavourites objectAtIndex:indexPath.row];
    }
    if ([fav isKindOfClass:[Group class]]) {
        GroupEditViewController* vc = [[GroupEditViewController alloc] initWithGroup:(Group *)fav user:_user];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
