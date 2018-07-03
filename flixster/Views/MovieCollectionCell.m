//
//  MovieCollectionCell.m
//  flixster
//
//  Created by Bevin Benson on 6/28/18.
//  Copyright © 2018 Bevin Benson. All rights reserved.
//

#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCollectionCell

- (void)setMovie:(Movie *)movie {
    
    _movie = movie;
    
    self.posterView.image = nil;
    if (self.movie.posterUrl != nil) {
        [self.posterView setImageWithURL:self.movie.posterUrl];
    }
}

@end
