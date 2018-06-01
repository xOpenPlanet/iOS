//
//  RecenFilesCell.h
//  ESPChatComps
//
//  Created by 吴鹏 on 17/7/3.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecenFilesCell : UITableViewCell
///设置显示文件信息
- (void)setFileInfo:(NSDictionary *)dataDic;
///被点击
- (void)cellDidSelected;
@end
