//
//  SongTableViewCell.h
//  new
//
//  Created by Евгений on 15.09.15.
//  Copyright (c) 2015 Eugene Kirtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@end
