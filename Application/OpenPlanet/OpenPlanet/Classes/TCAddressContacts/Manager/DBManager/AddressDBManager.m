//
//  AddressDBManager.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/20.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "AddressDBManager.h"
#import "CategoryHeader.h"

@implementation AddressDBManager

//+ (AddressDBManager *)shareManager{
//    static AddressDBManager *manager = nil;
//    if (manager == nil) {
//        manager = [[AddressDBManager alloc] init];
//    }
//    return manager;
//}
//
//
////  定义一个静态区指针 连接数据库 让数据库再程序结束后自动释放
//static sqlite3 *db = nil;
//
//- (sqlite3 *)openDB{
//    //  说明已经打开数据库
//    if (db != nil) {
//        return db;
//    }
//
//    //  创建数据库
//    //  先搞路径
//    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"contacts.sqlite"];
//
//    NSLog(@"%@",dbPath);
//
//    //  如果没有Student.sqlite文件 会创建一个
//    int result = sqlite3_open(dbPath.UTF8String, &db);
//
//    if (result == SQLITE_OK) {
//        NSLog(@"打开数据库成功");
//    } else {
//        NSLog(@"打开数据库失败");
//    }
//
//    return db;
//}
//
//
//- (void)closeDB{
//    int result = sqlite3_close(db);
//    if (result == SQLITE_OK) {
//        //  把指针 重置为空 方便下次打开
//        db = nil;
//        NSLog(@"关闭数据库成功");
//    } else {
//        NSLog(@"关闭数据库失败");
//    }
//}
//
////  创建表
//- (void)createTable{
//    // 1.打开数据库
//    db = [self openDB];
//
//    //  2.写sql语句 根据model 创建表
//    //  create table Student (Student 是表名)
//    //  number integer primary key not NULL 主键值 如果不操作 自增
//    NSString *sql = @"create table if not exists contacts(contactId integer primary key not NULL,name text,phones text)";
//
//    //  3.执行sql语句 创建表
//
//    /**
//     *  第1个参数不再说了，是前面open函数得到的指针。说了是关键数据结构。
//     第2个参数constchar*sql是一条sql 语句，以\0结尾。
//     第3个参数sqlite3_callback 是回调，当这条语句执行之后，sqlite3会去调用你提供的这个函数。
//     第4个参数void*是你所提供的指针，你可以传递任何一个指针参数到这里，这个参数最终会传到回调函数里面，如果不需要传递指针给回调函数，可以填NULL。等下我们再看回调函数的写
//     法，以及这个参数的使用。
//     第5个参数char** errmsg 是错误信息。
//     *
//     */
//    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
//
//    if (result == SQLITE_OK) {
//        NSLog(@"创建表成功");
//    } else {
//        NSLog(@"创建表失败");
//    }
//
//    //  4.关闭数据库
//    [self closeDB];
//
//
//}
//
////  插入数据
//- (void)insertWithContact:(Contact *)contact{
//    //  1.打开数据库
//    db = [self openDB];
//    NSMutableArray *phones = [NSMutableArray array];
//    for (ContactPhone *phone in contact.phones) {
//        NSDictionary *dict = @{@"phoneTitle":phone.phoneTitle,@"phoneNum":phone.phoneNumber};
//        [phones addObject:dict];
//    }
//    NSString *phoneString = [NSString jsonInfoToJsonString:phones];
//
//    //  2.写sql语句
//    NSString *sql = [NSString stringWithFormat:@"insert into contacts(contactId,name,phones) values('%ld','%@','%@','%@')",contact.contactId,contact.name,phoneString];
//    //  3.执行语句
//    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
//    if (result == SQLITE_OK) {
//        NSLog(@"插入成功");
//    } else {
//        NSLog(@"插入失败");
//    }
//    //  4.关闭数据库
//    [self closeDB];
//}
//
//
//
//- (void)deleteWithContactId:(NSInteger)contactId{
//    //  1.打开数据库
//    db = [self openDB];
//    //  2.写sql语句
//    NSString *sql = [NSString stringWithFormat:@"delete from contacts where contactId == '%ld'",contactId];
//    //  3.执行语句
//    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
//    if (result == SQLITE_OK) {
//        NSLog(@"删除成功");
//    } else {
//        NSLog(@"删除失败");
//    }
//
//    //  4.关闭数据库
//    [self closeDB];
//
//}
//
//
//- (void)updateContact:(Contact *)contact{
//    //  1.打开数据库
//    db = [self openDB];
//
//    NSMutableArray *phones = [NSMutableArray array];
//    for (ContactPhone *phone in contact.phones) {
//        NSDictionary *dict = @{@"phoneTitle":phone.phoneTitle,@"phoneNum":phone.phoneNumber};
//        [phones addObject:dict];
//    }
//    NSString *phoneString = [NSString jsonInfoToJsonString:phones];
//
//
//    //  2.写sql语句  where 后面是根据什么
//    NSString *sql = [NSString stringWithFormat:@"update contacts set phones = '%@' where contactId = '%ld'",phoneString,contact.contactId];
//    //  3.执行语句
//    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
//
//    if (result == SQLITE_OK) {
//        NSLog(@"更改成功");
//    } else {
//        NSLog(@"更改失败");
//    }
//
//    //  4.关闭数据库
//    [self closeDB];
//
//}
//
//
//- (Contact *)queryContactWithContactId:(NSInteger)contactId{
//
//    //  1.打开数据库
//    db = [self openDB];
//
//    //  2.写sql语句  *表示 查询所有字段
//    NSString *sql = [NSString stringWithFormat:@"select * from contacts where contactId = '%ld'",contactId];
//
//    //  3.创建跟随指针 保存sql语句
//    sqlite3_stmt *stmt = nil;
//
//    //  4.执行语句
//    //  -1 指sql语句长度 可以无限长
//    //  &stmt 跟随指针 地址
//    //  第四个参数 截取sql语句未使用部分
//
//
//    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
//
//    //  5.判断语句是否正确
//    if (result == SQLITE_OK) {
//        NSLog(@"查询语句正确");
//
////        //  6.进行查询值的绑定 也就是问号? 的绑定
////        //  第二个参数 指第几个问号 从1开始
////        sqlite3_bind_text(stmt, 1, name.UTF8String, -1, NULL);
////        sqlite3_bind_int(stmt, 2, (int)age); //  注意转换类型
////
////        //  7.进行查询
////        //  如果 查询结果 返回 SQLITE_ROW 那么查询正确 执行循环
////        while (sqlite3_step(stmt) == SQLITE_ROW) {
////            //  8.满足条件 读取数据
////            //  第二个参数 指的是 表中的列数 从0开始
////            charchar *name = (charchar *)sqlite3_column_text(stmt, 1);
////            charchar *gender = (charchar *)sqlite3_column_text(stmt, 2);
////            int age = sqlite3_column_int(stmt, 3);
////            int number = sqlite3_column_int(stmt, 0);
////
////            //  9.赋值学生对象 字符串需要转换格式
////            LanOuStudent *student = [[LanOuStudent alloc] init];
////            student.name = [NSString stringWithUTF8String:name];
////            student.gender = [NSString stringWithUTF8String:gender];
////            student.age = age;
////            student.number = number;
////
////            //  10.释放跟随指针
////            sqlite3_finalize(stmt);
////
////            return student;
////
////        }
////
//
//
//    } else {
//        NSLog(@"查询语句错误");
//    }
//
//    //  查询语句错误 也要释放跟随指针
//    sqlite3_finalize(stmt);
//
//    //  11.关闭数据库
//    [self closeDB];
//
//    return nil;
//}
//
//
//- (NSArray *)queryAllContacts{
//    //  1.打开数据库
//    db = [self openDB];
//    //  2.写sql语句
//    NSString *sql = @"select * from contacts";
//    //  3.创建跟随指针
//    sqlite3_stmt *stmt = nil;
//    //  4.执行语句
//    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
//    //  5.判断语句是否正确
////    if (result == SQLITE_OK) {
////        NSLog(@"查询语句正确");
////        //  6.创建数组
////        NSMutableArray *array = [NSMutableArray array];
////        //  7.执行查询
////        while (sqlite3_step(stmt) == SQLITE_ROW) {
////
////            //  8.满足条件 读取数据
////            charchar *name = (charchar *)sqlite3_column_text(stmt, 1);
////            charchar *gender = (charchar *)sqlite3_column_text(stmt, 2);
////            int age = sqlite3_column_int(stmt, 3);
////            int number = sqlite3_column_int(stmt, 0);
////
////            //  9.赋值学生对象 字符串需要转换格式
////            LanOuStudent *student = [[LanOuStudent alloc] init];
////            student.name = [NSString stringWithUTF8String:name];
////            student.gender = [NSString stringWithUTF8String:gender];
////            student.age = age;
////            student.number = number;
////
////            //  10.装进数组
////            [array addObject:student];
////
////            //  11.释放学生对象
////            [student release];
////        }
////
////        //  12.释放跟随指针
////        sqlite3_finalize(stmt);
////
////        return array;
//
//
////    } else {
////        NSLog(@"查询语句错误");
////    }
////
////    //  查询语句错误 也要释放跟随指针
////    sqlite3_finalize(stmt);
////
////    //  11.关闭数据库
////    [self closeDB];
////
//    return nil;
//}

@end
