//
//  MovieCell.m
//  flixster
//
//  Created by Bevin Benson on 6/27/18.
//  Copyright © 2018 Bevin Benson. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovie:(Movie *)movie {
    
    _movie = movie;
    
    self.titleLabel.text = self.movie.title;
    self.synopsis.text = self.movie.overview;
    
    self.posterView.image = nil;
    if (self.movie.posterUrl != nil) {
        [self.posterView setImageWithURL:self.movie.posterUrl];
    }
}

@end
