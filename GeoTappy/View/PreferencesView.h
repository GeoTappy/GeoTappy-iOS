//
//  PreferencesView.h
//  GeoTappy
//
//  Created by Dylan Marriott on 06/11/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PreferencesViewDelegate <NSObject>

- (void)openMail;

@end

@interface PreferencesView : UIView

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (id)initWithCoder:(NSCoder *)aDecoder UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<PreferencesViewDelegate>)delegate;

@end
