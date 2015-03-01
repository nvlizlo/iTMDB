//
//  DetailViewController.h
//  iTMDB
//
//  Created by Nazariy Vlizlo on 23.02.15.
//  Copyright (c) 2015 Nazariy Vlizlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic) NSInteger movieId;
@property (weak, nonatomic) IBOutlet UIImageView *moviePicture;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *genreAndDate;
@property (weak, nonatomic) IBOutlet UILabel *popularityAndBudget;
@property (weak, nonatomic) IBOutlet UITextView *movieDescription;

@end
