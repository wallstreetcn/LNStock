//
//  SearchCell.m
//  LNMarket
//
//  Created by vvusu on 8/10/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.addBtn addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)addButtonAction {
    if (self.cellBlock) {
        self.cellBlock();
    }
}

- (void)searchListItem:(NSString *)title code:(NSString *)code {
    self.nameLabel.text = title;
    self.codeLabel.text = code;
}

@end
