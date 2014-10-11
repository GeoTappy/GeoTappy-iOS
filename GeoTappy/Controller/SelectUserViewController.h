//
//  SelectUserViewController.h
//  GeoTappy
//
//  Created by Dylan Marriott on 12/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@protocol SelectUserDelegate <NSObject>

- (void)selectedUser:(User *)user;

@end

@interface SelectUserViewController : UITableViewController

- (instancetype)initWithDelegate:(id<SelectUserDelegate>)delegate;

@end
