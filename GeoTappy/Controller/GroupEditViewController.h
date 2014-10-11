//
//  GroupEditViewController.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Group;
@class User;

@interface GroupEditViewController : UITableViewController

- (id)initWithGroup:(Group *)group user:(User *)user;

@end
