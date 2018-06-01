//
//  MessageDataManager.m
//  TalkChain
//
//  Created by Javor Feng on 2018/3/13.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "MessageDataManager.h"
#import "JFMessageManager.h"
#import "MessageDbManager.h"
#import "EnvironmentVariable.h"
#import "Constant.h"
#import "PersonModel.h"
#import "ChatDownlaodManager.h"
#import "TokenRequestManager.h"

@implementation MessageDataManager {
    BOOL                        isAddressSuccess;
    BOOL                        isPublicSuccess;
    BOOL                        isGroupSuccess;
    BOOL                        isAnimationDownloadSuccess;
}

#pragma mark -Lazy
-(EFChatHttpManager *)httpManager {
    if (!_httpManager) {
        _httpManager = [[EFChatHttpManager alloc]init];
    }
    return _httpManager;
}

- (void)isFirstLoading {
    MessageDbManager * manager = [[MessageDbManager alloc] init];
    [manager createDataBase];
    // 默认铃声、震动设置
    // 免打扰
    NSString *bother = [EnvironmentVariable getPropertyForKey:EF_DISTURB WithDefaultValue:@""];
    // 播放声音
    NSString *playsound = [EnvironmentVariable getPropertyForKey:EF_PLAYSOUND WithDefaultValue:@""];
    // 播放震动
    NSString *playVibrate = [EnvironmentVariable getPropertyForKey:EF_PLAYVIBRATE WithDefaultValue:@""];
    if ([bother isEqualToString:@""] && [playsound isEqualToString:@""] && [playVibrate isEqualToString:@""]) {
        [EnvironmentVariable setProperty:@"YES" forKey:EF_PLAYVIBRATE];
        [EnvironmentVariable setProperty:@"YES" forKey:EF_PLAYSOUND];
        [EnvironmentVariable setProperty:@"NO" forKey:EF_DISTURB];
    }
    NSString *userId = [EnvironmentVariable getIMUserID];
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    NSString *update = [userDefs objectForKey:@"updateHint"];
    if (update == nil || ![userId isEqualToString:update]) {
        //下载animation所有文件
        [ChatDownlaodManager totalAnimationDownloadUnzipsuccess:^(id response) {
            NSLog(@"animation所有文件下载完成");
            [self performLoadRootVC:@"animation"];
        } fail:^(id response) {
            NSLog(@"animation所有文件下载失败");
        }];
        //加载通讯录数据
        [self requesetChatAddressBookData];
        //加载群组数据
        [self requestGroupListData];
        //加载公众号信息
        [self requestPublicData];
        //加载群成员数据
        //    [self getGroupPeron];
        //加载个人信息
//        [self requestSelfInfoData];
        
    }else{
        if(_delegate && [_delegate respondsToSelector:@selector(onMessageComplete:)]) {
            [_delegate onMessageComplete:self];
        }
    }
}

- (void)performLoading {
    //    [EnvironmentVariable setPassWord:self.loginView.textPwd.text];
    //    [EnvironmentVariable setUser:self.loginView.textName.text];
    //    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    [delegate login];
    //    //    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //    //    [ud setObject:_loginView.textName.text forKey:@"username"];
    //    //    [ud setObject:_loginView.textPwd.text forKey:@"password"];
    //    [self hiddenHudView];
    
}

- (void)performLoadRootVC:(NSString *)type {
    if ([type isEqualToString:@"address"]) {
        isAddressSuccess = YES;
    }else if ([type isEqualToString:@"public"]){
        isPublicSuccess = YES;
    }else if ([type isEqualToString:@"group"]){
        isGroupSuccess = YES;
    }else if([type isEqualToString:@"animation"]){
        isAnimationDownloadSuccess = YES;
    }
    if (isAddressSuccess && isPublicSuccess && isGroupSuccess && isAnimationDownloadSuccess) {
        NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
        NSString *userId = [EnvironmentVariable getIMUserID];
        [userDefs setObject:userId forKey:@"updateHint"];
        [self performLoading];
        if(_delegate && [_delegate respondsToSelector:@selector(onMessageComplete:)]) {
            [_delegate onMessageComplete:self];
        }
    }
}

-(void)requesetChatAddressBookDataSuccess:(successBlock)success fail:(failBlock)fail {
    MessageDbManager *messageDBManager = [[MessageDbManager alloc] init];
    NSString *token = [TokenRequestManager access_token];
    [self.httpManager HttpRequestForAddresslistWithToken:token success:^(id responseObject) {
        [TokenRequestManager isTokenExpiredWithResponse:responseObject complete:^(BOOL isTokenExpired) {
            if (isTokenExpired) {
                [self requesetChatAddressBookDataSuccess:success fail:fail];
            }else{
                NSMutableArray *array = [NSMutableArray array];
                array = responseObject[@"addressList"];
                for (NSDictionary *addressDic in array) {
                    PersonModel *model = [[PersonModel alloc] init];
                    [model setValuesForKeysWithDictionary:addressDic];
                    model.userName = addressDic[@"userId"];
                    model.userId = [addressDic[@"imUserId"] intValue];
                    model.mobilePhone = addressDic[@"mobilePhone"];
                    model.remarkName = addressDic[@"note"];
                    model.userType = 0;
                    if (addressDic[@"nickName"]) {
                        model.nickName = addressDic[@"nickName"];
                    } else {
                        model.nickName = addressDic[@"userName"];
                    }
                }
                BOOL isOK = [messageDBManager insertIntoUserAndFriends:array loginUserId:[[EnvironmentVariable getIMUserID] integerValue]];
                NSLog(@"isOK %d",isOK);
                success(@"{\"result\":\"ok\"}");
            }
        }];
    } failure:^(NSString *error) {
        fail(error);
    }];
    
    
//    NSString *userid = [EnvironmentVariable getIMUserID];
//    NSString *password = [EnvironmentVariable getIMPassword];
//    [self.httpManager HttpRequestForGettingAddressListUserId:userid userPassword:password success:^(id responseObject) {
//        NSLog(@"请求通讯录数据成功");
//        NSMutableArray *array = [NSMutableArray array];
//        array = responseObject[@"addressList"];
//        for (NSDictionary *addressDic in array) {
//            PersonModel *model = [[PersonModel alloc] init];
//            [model setValuesForKeysWithDictionary:addressDic];
//            model.userName = addressDic[@"userName"];
//            model.userId = [addressDic[@"userId"] intValue];
//            model.mobilePhone = addressDic[@"mobilePhone"];
//            model.remarkName = addressDic[@"note"];
//            model.userType = 0;
//            if (addressDic[@"nickName"]) {
//                model.nickName = addressDic[@"nickName"];
//            } else {
//                model.nickName = addressDic[@"userName"];
//            }
//        }
//        BOOL isOK = [messageDBManager insertIntoUserAndFriends:array loginUserId:[userid integerValue]];
//        success(@"{\"result\":\"ok\"}");
//    } failure:^(NSString *error) {
//        fail(error);
//    }];
}

-(void)requestPublicDataSuccess:(successBlock)success fail:(failBlock)fail {
    MessageDbManager *messageDBManager = [[MessageDbManager alloc] init];
    NSString *userid = [EnvironmentVariable getIMUserID];
    NSString *password = [EnvironmentVariable getIMPassword];
    //加载公众号
    NSString *token = [TokenRequestManager access_token];
    [self.httpManager opHttpRequestForPublicListWithToken:token success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        array = responseObject[@"publics"];
//        for (NSDictionary *infoDic in array) {
//            PersonModel *model = [[PersonModel alloc] init];
//            [model setValuesForKeysWithDictionary:infoDic];
//            model.userName = infoDic[@"userName"];
//            model.userId = [infoDic[@"userId"] intValue];
//            model.userType = [infoDic [@"userType"] intValue];
//            model.avatar = infoDic[@"avatar"];
//            if (infoDic[@"nickName"]) {
//                model.nickName = infoDic[@"nickName"];
//            } else {
//                model.nickName = infoDic[@"userName"];
//            }
//        }
        [messageDBManager insertIntoUserAndFriends:array loginUserId:[userid integerValue]];
        success(@"{\"result\":\"ok\"}");
    } failure:^(NSString *error) {
        fail(error);
    }];
    
    
//    [self.httpManager HttpRequestForGettingPublicListUserId:userid userPassword:password success:^(id responseObject) {
//        NSMutableArray *array = [NSMutableArray array];
//        array = responseObject[@"publics"];
//        for (NSDictionary *infoDic in array) {
//            PersonModel *model = [[PersonModel alloc] init];
//            [model setValuesForKeysWithDictionary:infoDic];
//            model.userName = infoDic[@"userName"];
//            model.userId = [infoDic[@"userId"] intValue];
//            model.userType = [infoDic [@"userType"] intValue];
//            model.avatar = infoDic[@"avatar"];
//            if (infoDic[@"nickName"]) {
//                model.nickName = infoDic[@"nickName"];
//            } else {
//                model.nickName = infoDic[@"userName"];
//            }
//        }
//        [messageDBManager insertIntoUserAndFriends:array loginUserId:[userid integerValue]];
//        success(@"{\"result\":\"ok\"}");
//    } failure:^(NSString *error) {
//         fail(error);
//    }];
}

-(void)requestGroupListDataSuccess:(successBlock)success fail:(failBlock)fail {
    NSString *userid = [EnvironmentVariable getIMUserID];
    NSString *password = [EnvironmentVariable getIMPassword];
    [self.httpManager HttpRequestForGettingGroupListWithUserId:userid userPassword:password success:^(id responseObject) {
        NSLog(@"请求群组数据成功");
        NSMutableArray *chatGroupListArray = [NSMutableArray arrayWithCapacity:1];
        if (responseObject[@"groups"] == nil) {
             success(@"{\"result\":\"ok\"}");
            return ;
        }
        chatGroupListArray = responseObject[@"groups"];
        if (chatGroupListArray.count < 1) {
             success(@"{\"result\":\"ok\"}");
            return ;
        }
        MessageDbManager *messageDBManager = [[MessageDbManager alloc] init];
        for (NSInteger i = 0; i < chatGroupListArray.count; i++) {
            NSMutableDictionary *groupDictionary = [NSMutableDictionary dictionaryWithDictionary:chatGroupListArray[i]];
            //            NSArray *array = [[NSArray alloc] init];
            //            [groupDictionary setObject:array forKey:@"addUserIdArray"];
            [groupDictionary setObject:userid forKey:@"loginUserId"];
            [messageDBManager addChatGroup:groupDictionary];
        }
         success(@"{\"result\":\"ok\"}");
    } failure:^(NSString *error) {
        fail(error);
    }];
}

#pragma mark - 请求通讯录列表信息
- (void)requesetChatAddressBookData {
   
}

#pragma mark - 请求公众号信息
- (void)requestPublicData {
   
}

#pragma mark - 请求群聊列表信息
- (void)requestGroupListData {
    
}

#pragma mark - 请求个人信息
- (void)requestSelfInfoData {
    [self.httpManager HttpRequestForGettingOtherUserInfoWithFriendId:[EnvironmentVariable getIMUserID] success:^(id responseObject) {
        NSDictionary *useDic = responseObject;
        NSDictionary *info = useDic[@"user"];
        NSString *avatar = info[@"avatar"];
        if (avatar != nil) {
            [EnvironmentVariable setProperty:avatar forKey:@"avatar"];
        }else{
            [EnvironmentVariable setProperty:@"" forKey:@"avatar"];
        }
        NSString *sign = info[@"sign"];
        if (sign != nil) {
            [EnvironmentVariable setProperty:sign forKey:@"sign"];
        }else{
            [EnvironmentVariable setProperty:@"" forKey:@"sign"];
        }
        NSString *sex = info[@"sex"];
        if (sex != nil && ![sex isEqualToString:@""] ) {
            [EnvironmentVariable setProperty:sex forKey:@"sex"];
        }else{
            [EnvironmentVariable setProperty:@"M" forKey:@"sex"];//公众号可能为nil暂设M
        }
        NSString *nickName = info[@"nickName"];
        if (nickName != nil) {
            [EnvironmentVariable setProperty:nickName forKey:@"nickName"];
        }else{
            [EnvironmentVariable setProperty:info[@"userName"] forKey:@"nickName"];
            
        }
        [EnvironmentVariable setProperty:info[@"userName"] forKey:@"userName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:updateLeftUserInfo object:self userInfo:info];
        MessageDbManager *messageDBManager = [[MessageDbManager alloc] init];
        [messageDBManager updateUserInfoWithUserInfoDic:info];
        [self performLoadRootVC:@"user"];
        NSLog(@"请求个人信息成功");
    } failure:^(NSString *error) {
        //        [self getDataFailure:@"请求用户数据失败，请重新登录"];
        NSLog(@"请求个人信息失败，%@", error);
    }];
}

@end
