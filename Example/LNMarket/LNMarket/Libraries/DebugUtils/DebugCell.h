//
//  DebugCell.h
//  AtourLife
//
//  Created by vvusu on 3/4/16.
//  Copyright © 2016 Anasue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , DebugType) {
    DebugTypeDebug = 0,
    DebugTypeAPI,
    DebugTypeWebAPI,
    DebugTypeNightMode,
    DebugTypeGreenUp
};

@interface DebugCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UISwitch *handSwitch;
@property (assign, nonatomic) DebugType debugType;

- (void)createItem:(NSString *)title With:(NSIndexPath *)index;
@end
