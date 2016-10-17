//
//  SearchCell.h
//  LNMarket
//
//  Created by vvusu on 8/10/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SearchCellBlock)();

@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (copy, nonatomic) SearchCellBlock cellBlock;

- (void)searchListItem:(NSString *)title code:(NSString *)code;
@end
