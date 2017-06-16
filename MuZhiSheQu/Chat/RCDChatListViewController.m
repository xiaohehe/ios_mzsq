//
//  FirstViewController.m
//  RongCloud
//
//  Created by Liv on 14/10/31.
//  Copyright (c) 2014年 胡利武. All rights reserved.
//

#import "RCDChatListViewController.h"
#import "DefaultPageSource.h"
#import <RongIMKit/RongIMKit.h>
//#import "KxMenu.h"
//#import "RCDAddressBookViewController.h"
//#import "RCDSearchFriendViewController.h"
//#import "RCDSelectPersonViewController.h"
//#import "RCDRCIMDataSource.h"
#import "RCDLocationViewController.h"
#import "RCDChatViewController.h"
///#import "UIColor+RCColor.h"
#import "RCDChatListCell.h"
//#import "RCDAddFriendTableViewController.h"
//#import "RCDHttpTool.h"
//#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDUserInfo.h"
#import "AnalyzeObject.h"
@interface RCDChatListViewController ()<RCIMGroupInfoDataSource,RCIMReceiveMessageDelegate>

//@property (nonatomic,strong) NSMutableArray *myDataSource;
@property (nonatomic,strong) RCConversationModel *tempModel;

//- (void) updateBadgeValueForTabBarItem;

@end

@implementation RCDChatListViewController

/**
 *  此处使用storyboard初始化，代码初始化当前类时*****必须要设置会话类型和聚合类型*****
 *
 *  @param aDecoder aDecoder description
 *
 *  @return return value description
 */
-(id)init
{
    self =[super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
      // [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
  
        
        
        
    }
    return self;
}

- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left{

//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);


}
- (void)viewDidLoad {
    self.navigationController.navigationBarHidden=NO;
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];//[UIColor colorWithRed:0/255.0 green:134/255.0 blue:237/255.0 alpha:1];
//    UIView *statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
//    statusBarView.backgroundColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
//    [self.navigationController.navigationBar addSubview:statusBarView];

    [super viewDidLoad];
//    [RCIM sharedRCIM].userInfoDataSource=self;
    [RCIM sharedRCIM].groupInfoDataSource=self;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置tableView样式
    //self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
    self.conversationListTableView.tableFooterView = [UIView new];
  //  self.conversationListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 12)];
    [self newNav];
}
-(void)newNav{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 15);
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}
- (void)leftBarButtonItemPressed:(id)sender {
    if (_isPush) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    //需要调用super的实现
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)GetData:(NSArray *)Arr{

}
//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion{
//    
//    NSString *str = [userId substringToIndex:1];
//    
//    if ([str isEqualToString:@"m"]) {
//        NSString *commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
//        AnalyzeObject *nale = [AnalyzeObject new];
//        [nale getGJidWithDic:@{@"community_id":commid} Block:^(id models, NSString *code, NSString *msg) {
//            if ([models isKindOfClass:[NSDictionary class]]) {
//                RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@",models[@"id"]] name:[NSString stringWithFormat:@"%@",models[@"user_name"]] portrait:[NSString stringWithFormat:@"%@",models[@"logo"]]];
//                completion(info);
//                
//            }
//            
//        }];
//        
//    }
//    
//    
//  AnalyzeObject *analy=[[AnalyzeObject alloc]init];
//    [analy GetNickAndAvatarWithUser_ID:@{@"user_id":userId} Block:^(id models, NSString *code, NSString *msg) {
//        NSArray *Arr=models;
//        if (Arr && Arr.firstObject && [code isEqualToString:@"0"]) {
//            NSDictionary *dic = Arr.firstObject;
//            RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@",dic[@"id"]] name:[NSString stringWithFormat:@"%@",dic[@"nick_name"]] portrait:[NSString stringWithFormat:@"%@",dic[@"avatar"]]];
//            completion(info);
//        }
//    }];
//
//}
-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
  //  self.navigationController.navigationBarHidden=YES;
    [super viewWillAppear:animated];
    self.title=@"会话";
//    [RCIM sharedRCIM].receiveMessageDelegate=self;

    [RCIM sharedRCIM].disableMessageAlertSound=NO;
}


/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed=YES;
    
//    NSString *commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
//    
//    AnalyzeObject *nale = [AnalyzeObject new];
//    [nale getGJidWithDic:@{@"community_id":commid} Block:^(id models, NSString *code, NSString *msg) {
//        if ([models isKindOfClass:[NSDictionary class]]) {
////            self.userName = models[@"user_name"];
////            self.targetId = models[@"id"];
////            self.conversationType = ConversationType_PRIVATE;
//            
//            
//            NSString *mystring = @"Letter1234";
//            NSString *regex = @"[a-z][A-Z][0-9]";
//            
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//            
//            if ([predicate evaluateWithObject:mystring] == YES) {
//                
//            }
    
    
    NSString *str = [model.targetId substringToIndex:1];
    
    
    if ([str isEqualToString:@"m"]) {
        self.hidesBottomBarWhenPushed=YES;
        CenterViewController *center = [CenterViewController new];
        center.isPush=YES;
        center.conversationType = model.conversationType;
        center.targetId = model.targetId;
        center.title = model.conversationTitle;
        [self.navigationController pushViewController:center animated:YES];
        return;
    }

  
            
            if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
                RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
                _conversationVC.conversationType = model.conversationType;
                _conversationVC.targetId = model.targetId;
              //  _conversationVC.userName = model.conversationTitle;
                _conversationVC.title = model.conversationTitle;
                _conversationVC.conversation = model;
                [self.navigationController pushViewController:_conversationVC animated:YES];
            }
            //聚合会话类型，此处自定设置。
            if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
                
                RCDChatListViewController *temp = [[RCDChatListViewController alloc] init];
                NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
                [temp setDisplayConversationTypes:array];
                [temp setCollectionConversationType:nil];
                temp.isEnteredToCollectionViewController = YES;
                [self.navigationController pushViewController:temp animated:YES];
            }
            

        

    
    
    
    
    
    
     //自定义会话类型
   /* if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
        RCDUserInfo *userinfo = [RCDUserInfo new];
        
        NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]objectForKey:_contactNotificationMsg.sourceUserId];
        if (_cache_userinfo) {
            userinfo.userName       = _cache_userinfo[@"username"];
            userinfo.portraitUri    = _cache_userinfo[@"portraitUri"];
            userinfo.userId         = _contactNotificationMsg.sourceUserId;
        }
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RCDAddFriendTableViewController *temp = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDAddFriendTableViewController"];
        temp.userInfo = userinfo;//model.extend;
        [self.navigationController pushViewController:temp animated:YES];
    }*/

}

/**
 *  弹出层
 *
 *  @param sender sender description
 */
- (IBAction)showMenu:(UIButton *)sender {
  /*  NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"发起聊天"
                     image:[UIImage imageNamed:@"chat_icon"]
                    target:self
                    action:@selector(pushChat:)],
      
      [KxMenuItem menuItem:@"添加好友"
                     image:[UIImage imageNamed:@"addfriend_icon"]
                    target:self
                    action:@selector(pushAddFriend:)],
      
      [KxMenuItem menuItem:@"通讯录"
                     image:[UIImage imageNamed:@"contact_icon"]
                    target:self
                    action:@selector(pushAddressBook:)],
      
      [KxMenuItem menuItem:@"公众账号"
                     image:[UIImage imageNamed:@"public_account"]
                    target:self
                    action:@selector(pushPublicService:)],
      
      [KxMenuItem menuItem:@"添加公众号"
                     image:[UIImage imageNamed:@"add_public_account"]
                    target:self
                    action:@selector(pushAddPublicService:)],
      ];
    
    CGRect targetFrame = self.tabBarController.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y + 15;
    [KxMenu showMenuInView:self.tabBarController.navigationController.navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];*/
}


/**
 *  发起聊天
 *
 *  @param sender sender description
 */
- (void) pushChat:(id)sender
{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    RCDSelectPersonViewController *selectPersonVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDSelectPersonViewController"];
    
    //设置点击确定之后回传被选择联系人操作
//    __weak typeof(&*self)  weakSelf = self;
//    selectPersonVC.clickDoneCompletion = ^(RCDSelectPersonViewController *selectPersonViewController,NSArray *selectedUsers){
//        if(selectedUsers.count == 1)
//        {
//            RCUserInfo *user = selectedUsers[0];
//            RCDChatViewController *chat =[[RCDChatViewController alloc]init];
//            chat.targetId                      = user.userId;
//            chat.userName                    = user.name;
//            chat.conversationType              = ConversationType_PRIVATE;
//            chat.title                         = user.name;
//            
//            //跳转到会话页面
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
//                [weakSelf.navigationController popToViewController:tabbarVC animated:YES];
//                [tabbarVC.navigationController  pushViewController:chat animated:YES];
//            });
//
//        }
//        //选择多人则创建讨论组
//        else if(selectedUsers.count > 1)
//        {
//            
//            NSMutableString *discussionTitle = [NSMutableString string];
//            NSMutableArray *userIdList = [NSMutableArray new];
//            for (RCUserInfo *user in selectedUsers) {
//                [discussionTitle appendString:[NSString stringWithFormat:@"%@%@", user.name,@","]];
//                [userIdList addObject:user.userId];
//            }
//            [discussionTitle deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];
//
//            [[RCIMClient sharedRCIMClient] createDiscussion:discussionTitle userIdList:userIdList success:^(RCDiscussion *discussion) {
//                NSLog(@"create discussion ssucceed!");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RCDChatViewController *chat =[[RCDChatViewController alloc]init];
//                    chat.targetId                      = discussion.discussionId;
//                    chat.userName                    = discussion.discussionName;
//                    chat.conversationType              = ConversationType_DISCUSSION;
//                    chat.title                         = @"讨论组";
//                    
//                    
//                    UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
//                    [weakSelf.navigationController popToViewController:tabbarVC animated:YES];
//                    [tabbarVC.navigationController  pushViewController:chat animated:YES];
//                });
//            } error:^(RCErrorCode status) {
//                NSLog(@"create discussion Failed > %ld!", (long)status);
//            }];
//            return;
//        }
//    };
//
//    [self.navigationController showViewController:selectPersonVC sender:self.navigationController];
}

/**
 *  公众号会话
 *
 *  @param sender sender description
 */
- (void) pushPublicService:(id) sender
{
        RCPublicServiceListViewController *publicServiceVC = [[RCPublicServiceListViewController alloc] init];
        [self.navigationController pushViewController:publicServiceVC  animated:YES];
    
}


/**
 *  添加好友
 *
 *  @param sender sender description
 */
- (void) pushAddFriend:(id) sender
{
//    RCDSearchFriendViewController *searchFirendVC = [RCDSearchFriendViewController searchFriendViewController];
//    [self.navigationController pushViewController:searchFirendVC  animated:YES];
    
}

/**
 *  通讯录
 *
 *  @param sender sender description
 */
-(void) pushAddressBook:(id) sender
{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    RCDAddressBookViewController *addressBookVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDAddressBookViewController"];
//    [self.navigationController pushViewController:addressBookVC animated:YES];

}

/**
 *  添加公众号
 *
 *  @param sender sender description
 */
- (void) pushAddPublicService:(id) sender
{
    RCPublicServiceSearchViewController *searchFirendVC = [[RCPublicServiceSearchViewController alloc] init];
    [self.navigationController pushViewController:searchFirendVC  animated:YES];
    
}


//*********************插入自定义Cell*********************//

//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{

//    for (int i=0; i<_myDataSource.count; i++) {
//        RCConversationModel *customModel =[_myDataSource objectAtIndex:i];
//        [dataSource insertObject:customModel atIndex:0];
//    }

    return dataSource;
}
//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0f;
}

////自定义cell
-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    __block NSString *userName    = nil;
    __block NSString *portraitUri = nil;
    
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
        NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]objectForKey:_contactNotificationMsg.sourceUserId];
        if (_cache_userinfo) {
            userName = _cache_userinfo[@"username"];
            portraitUri = _cache_userinfo[@"portraitUri"];
        }
        
    }else{
       RCDUserInfo *user = (RCDUserInfo *)model.extend;
        userName    = user.userName;
        portraitUri = user.portraitUri;
    }
    
    RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.lblDetail.text =[NSString stringWithFormat:@"来自%@的好友请求",userName];
    [cell.ivAva setImageWithURL :[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
    return cell;
}

//*********************插入自定义Cell*********************//

/*
#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification
{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
        
        //该接口需要替换为从消息体获取好友请求的用户信息
//        [RCDHTTPTOOL getUserInfoByUserID:_contactNotificationMsg.sourceUserId
//                              completion:^(RCUserInfo *user) {
//                                  RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
//                                  rcduserinfo_.userName = user.name;
//                                  rcduserinfo_.userId = user.userId;
//                                  rcduserinfo_.portraitUri = user.portraitUri;
//                                  
//            RCConversationModel *customModel = [RCConversationModel new];
//            customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
//            customModel.extend = rcduserinfo_;
//            customModel.senderUserId = message.senderUserId;
//            customModel.lastestMessage = _contactNotificationMsg;
            //[_myDataSource insertObject:customModel atIndex:0];
                                  
                                  //local cache for userInfo
                                  NSDictionary *userinfoDic = @{@"username": rcduserinfo_.userName,
                                                                @"portraitUri":rcduserinfo_.portraitUri
                                                                };
                                  [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                  
          dispatch_async(dispatch_get_main_queue(), ^{
              //调用父类刷新未读消息数
              [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
              //[super didReceiveMessageNotification:notification];
              [blockSelf_ resetConversationListBackgroundViewIfNeeded];
              [blockSelf_ updateBadgeValueForTabBarItem];
          });
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [blockSelf_ updateBadgeValueForTabBarItem];
        });
    }
}
*/
@end
