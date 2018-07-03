//
//  Movie.h
//  flixster
//
//  Created by Bevin Benson on 7/2/18.
//  Copyright © 2018 Bevin Benson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSURL *posterUrl;
@property (nonatomic, strong) NSURL *backdropUrl;
@property (nonatomic, strong) NSString *id;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)moviesWithDictionary:(NSArray *)dictionaries;

@end
