//
//  SearchResultCell.h
//  StoreSearch
//
//  Created by Jack Lee on 13-9-29.
//  Copyright (c) 2013年 ljq007@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;

@end
