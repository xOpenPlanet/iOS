//
//  Macrol.h
//  FaceKeyboard
//
//  Created by ruofei on 16/3/31.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#ifndef ChatKeyBoardMacroDefine_h
#define ChatKeyBoardMacroDefine_h

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define KEYBOARD_INTERVAL 8

/**  从bundle包中获取图片 */
#define LoadImage(string) [UIImage imageNamed:string]
#define kChatToolBar(string) [NSString stringWithFormat:@"ChatImgBundle.bundle/image_ChatKeyBoard/icon_dialog/%@", string]
#define kMoreItem(string) [NSString stringWithFormat:@"ChatImgBundle.bundle/image_chatToolBar/%@", string]
#define kKeyBoardFace(string) [NSString stringWithFormat:@"ChatImgBundle.bundle/image_keyBoardFace/%@",string]
#define kImage(string)              [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:string]]
#define kChatVoiceImage(string) [NSString stringWithFormat:@"ChatImgBundle.bundle/image_chatVoice/chatVoice/%@",string]


/**  判断文字中是否包含表情 */
#define IsTextContainFace(text) [text containsString:@"["] &&  [text containsString:@"]"] && [[text substringFromIndex:text.length - 1] isEqualToString:@"]"]

/** 判断emoji下标 */
#define emojiText(text)  (text.length >= 2) ? [text substringFromIndex:text.length - 2] : [text substringFromIndex:0]

//ChatKeyBoard背景颜色
#define kChatKeyBoardColor              [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0f]

//键盘上面的工具条
#define kChatToolBarHeight              49 * 2

//表情模块高度
#define kFacePanelHeight                216
#define kFacePanelBottomToolBarHeight   40
#define kUIPageControllerHeight         25

//拍照、发视频等更多功能模块的面板的高度
#define kMorePanelHeight                216
#define kMoreItemH                      80
#define kMoreItemIconSize               60

#define kBarItemContentPanelHeight      216
//整个聊天工具的高度
#define kChatKeyBoardHeight     kChatToolBarHeight + kBarItemContentPanelHeight

#define isIPhone4_5                (kScreenWidth == 320)
#define isIPhone6_6s               (kScreenWidth == 375)
#define isIPhone6p_6sp             (kScreenWidth == 414)

#endif /* ChatKeyBoardMacroDefine_h */
