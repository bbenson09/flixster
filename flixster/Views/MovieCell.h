//
//  MovieCell.h
//  flixster
//
//  Created by Bevin Benson on 6/27/18.
//  Copyright © 2018 Bevin Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (nonatomic, strong) Movie *movie;

@end
