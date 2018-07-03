//
//  Movie.m
//  flixster
//
//  Created by Bevin Benson on 7/2/18.
//  Copyright © 2018 Bevin Benson. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.overview = dictionary[@"overview"];
    self.id = dictionary[@"id"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = dictionary[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    self.posterUrl = [NSURL URLWithString:fullPosterURLString];
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    self.backdropUrl = [NSURL URLWithString:fullBackdropURLString];
    
    
    
    
    return self;
}

+ (NSArray *)moviesWithDictionary:(NSArray *)dictionaries {
    
    NSMutableArray *movies = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        
        [movies addObject:movie];
        
    }
    
    return movies;
}

@end
