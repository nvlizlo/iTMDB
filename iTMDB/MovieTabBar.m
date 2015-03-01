//
//  MovieTabBar.m
//  iTMDB
//
//  Created by Nazariy Vlizlo on 01.03.15.
//  Copyright (c) 2015 Nazariy Vlizlo. All rights reserved.
//

#import "MovieTabBar.h"

@implementation MovieTabBar

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *titles = @[@"Top", @"Popular", @"Upcoming"];
    NSArray *icons = @[[UIImage imageNamed:@"top"], [UIImage imageNamed:@"popular"], [UIImage imageNamed:@"upcoming"]];
    for (int i = 0; i < titles.count; i++) {
        [self.items[i] setTitle:titles[i]];
        [self.items[i] setImage:icons[i]];
    }
}

@end
