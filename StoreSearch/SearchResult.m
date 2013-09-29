//
//  SearchResult.m
//  StoreSearch
//
//  Created by Jack Lee on 13-9-28.
//  Copyright (c) 2013年 ljq007@gmail.com. All rights reserved.
//

#import "SearchResult.h"

@implementation SearchResult

@synthesize name = _name;
@synthesize artistName = _artistName;

@synthesize artworkURL60 = _artworkURL60;
@synthesize artworkURL100 = _artworkURL100;
@synthesize storeURL = _storeURL;
@synthesize kind = _kind;
@synthesize currency = _currency;
@synthesize price = _price;
@synthesize genre = _genre;

- (NSComparisonResult)compareName:(SearchResult *)other
{
    return [self.name localizedStandardCompare:other.name];
}

@end
