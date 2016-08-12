//
//  DebugCell.m
//  AtourLife
//
//  Created by vvusu on 3/4/16.
//  Copyright © 2016 Anasue. All rights reserved.
//

#import "DebugCell.h"
#import "DebugUtils.h"

@implementation DebugCell
- (void)awakeFromNib {
    // Initialization code
    self.handSwitch.on = NO;
    [self.handSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)switchAction:(UISwitch *)sender {
    switch (self.debugType) {
        case DebugTypeDebug: {
            [DebugUtils switchDebug];
        }
            break;
        case DebugTypeAPI: {
            [DebugUtils switchTestAPI];
        }
            break;
        case DebugTypeWebAPI: {
            [DebugUtils switchWebTestAPI];
        }
            break;
        case DebugTypeNightMode:
            [DebugUtils switchNightMode];
        default:
            break;
    }
}

- (void)createItem:(NSString *)title With:(NSIndexPath *)index {
    self.title.text = title;
    switch (index.row) {
        case 0: {
            self.debugType = DebugTypeDebug;
            [self changeSwitchType:[DebugUtils isDebug]];
        }
            break;
        case 1: {
            self.debugType = DebugTypeAPI;
            [self changeSwitchType:[DebugUtils isTestAPI]];
        }
            break;
        case 2: {
            self.debugType = DebugTypeWebAPI;
            [self changeSwitchType:[DebugUtils isWebTestAPI]];
        }
            break;
        case 3: {
            self.debugType = DebugTypeNightMode;
            [self changeSwitchType:[DebugUtils isNightMode]];
        }
        default:
            break;
    }
}

- (void)changeSwitchType:(BOOL)type {
    if (type) {
        self.handSwitch.on = YES;
    } else {
        self.handSwitch.on = NO;
    }
}

@end
