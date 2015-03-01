//
//  MovieStore.h
//  iTMDB
//
//  Created by Nazariy Vlizlo on 01.03.15.
//  Copyright (c) 2015 Nazariy Vlizlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoviesViewController.h"



@interface MovieStore : NSObject

- (NSInteger)moviesCount;
- (void)requestForTypeOfMovies:(NSString *)type viewController:(id)controller;
+ (instancetype)sharedStore;

@end
