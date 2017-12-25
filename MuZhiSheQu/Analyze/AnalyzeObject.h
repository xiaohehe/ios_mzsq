//
//  AnalyzeObject.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyzeObject : NSObject
//举报
-(void)noticeReport :(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
//我的帖子
-(void)getMyNoticeList:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
//我的回复
-(void)getMyReplyList:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
//邻里圈
-(void)getNoticeWall:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;
//社区公告
-(void)getCommunityNoticeList:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;

//获取登陆验证码
-(void)getyanzhengma:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;

//首页轮播图片
-(void)mu_zhi_adwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *首页精选分类
 */
-(void)shouYeFenLei:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

//首页零售商家分类精选列表接口

-(void)getRetailShopList:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;

#pragma mark -- 社区标语
- (void)communitySlogan:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;


//上门服务

-(void)getServShopListwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;


-(void)leibiaol:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

//微商精选

-(void)getWeiShopListwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;


-(void)shangjial:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

//商家列表查询接口

-(void)queryShopByKeyAndProwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;

//零售类商家商品分类接口

-(void)getRetailShopClasswithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;

//零售类商家商品列表接口

-(void)getProdListByClasswithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;

//零售类商家商品详情接口

-(void)getprodDetailwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;

//商家详情接口

-(void)queryShopDetailwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;


//商家评价

-(void)commentListwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;

#pragma mark -- 商家信息
-(void)ShopshopInfoWithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;



/**
 *我的公告接口
 */

-(void)getNoticeListwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;

#pragma mark - 用户登录接口
/**
 *用户登录接口
 */
-(void)userLoginWithTel:(NSString *)mobile Block:(void(^)(id models, NSString *code ,NSString * msg))block;
-(void)userLoginWithTelAndCode:(NSString *)mobile andCode:(NSString*) code Block:(void(^)(id models, NSString *code ,NSString * msg))block;
-(void)userLogin:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *添加商品到购物车接口
 */

-(void)addProdWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *请求购物车接口
 */
-(void)showCartWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *微商页中商铺分类列表接口
 */

-(void)getShopClassListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *商家列表查询接口（根据查询条件进行查询商家）点击“微商”按钮调用的接口
 */
-(void)queryShopByKeyWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *清空购物车
 */
-(void)clearCartWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *提交订单
 */

-(void)OrdersubmitWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *删除购物车中得一个商品
 */

-(void)delProdInCartWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *服务类商家订单提交接口
 */

-(void)serveShopSubmitWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *我的地址列表接口
 */

-(void)getAddressListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *新增地址接口
 */
-(void)addAddressWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *设置默认地址接口
 */
-(void)setDefaultAddressWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *我的收藏
 */
-(void)getCollectListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *我的公告
 */
-(void)getNoticeListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

//我的订单列表
-(void)myOrderListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

//服务类订单
-(void)myServeOrderListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

//删除订单
-(void)delAddressWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *公告墙列表
 */
-(void)getNoticeListwallWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *公告墙详情
 */
-(void)noticeDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *公告墙评论接口
 */
-(void)NoticeWallcommentWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *公告墙点赞
 */

-(void)NoticeWallAgreeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *发布公告
 */

-(void)addNoticeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


-(void)delNoticeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *修改头像
 */
-(void)modifyLogoWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *修改昵称
 */

-(void)modifyNicknameWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *修改性别
 */

-(void)modifySexWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *修改生日
 */

-(void)modifyBirthdayWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *修改密码
 */

-(void)modifyPayPassWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *个人中心
 */

-(void)myCentreWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *创建家庭
 */

-(void)createFamilyWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 * 获取我的家庭信息
 */

-(void)getMyFamilyWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 * 获取我的家庭成员
 */

-(void)getFamilyMemberWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 * 签约/邀请
 */

-(void)addFamilyWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 * 获取家庭模块商品内容
 */

-(void)getFamilyProductWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 * 积分兑换
 */

-(void)familyOrderWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 * 历史记录
 */
-(void)getFamilyExchangeLogWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 * 去积分兑换
 */
-(void)familyExchangeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *发表评价
 */

+(void)addCommentWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *获取省列表
 */

-(void)getProvinceListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *获取市列表
 */
-(void)getCityListWithDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *获取区列表
 */
-(void)getDistrictListDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *获取社区列表
 */

-(void)getCommunityListWithDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *设置社区地址
 */

-(void)modifyCommunityAddressDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *帮助信息
 */

-(void)helpInfoWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *收藏接口
 */
//
-(void)addCollectWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *订单详情   
 */

-(void)myOrderDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *取消订单
 */
-(void)cancelOrderWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *删除订单
 */
-(void)delOrderWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *完成订单接口
 */

-(void)finishOrderWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *服务类订单详情
 */
-(void)myServeOrderDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *取消收藏接口
 */
-(void)delCollectWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *常用电话接口
 */
-(void)showCommonTelWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *获取聊天人得信息
 */
-(void)GetNickAndAvatarWithUser_ID:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *意见反馈按钮   User.getPushDetail
 */
-(void)feedbackWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *web
 */
-(void)getPushDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *编辑公告接口
 */
-(void)editNoticeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *轮播详情接口
 */
-(void)sliderDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *检测是否收藏
 */
-(void)isCollectWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *检测是否在营业中
 */
-(void)isInServeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *大管家id
 */
-(void)getGJidWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *购物车数量和价格
 */
-(void)getShopingCartDataWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


-(void)zhuandhizi:(NSString *)lat lon:(NSString *)lon Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *大管家轮播信息
 */
-(void)getgjInfo:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *电话统计
 */
-(void)telTongJi:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *广告
 */
-(void)ADD:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *广告记录
 */
-(void)ADDJLu:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *公告数量
 */
-(void)GongGaoNum:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *首页搜索列表
 */
-(void)shouYeSouList:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *首页商品列表
 */
-(void)shouYeGoodsF:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *生活服务类列表
 */
-(void)shenghuoList:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *检测商品库存
 */
-(void)kucun:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *物业中心
 */
- (void)wuyYeZhongxin:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *推送商家详情
 */
-(void)getRetailShopClassPushwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;


/**
 *推送商品信息
 */
-(void)getprodDetailPushwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *推送生活服务商家
 */
-(void)shangjialPush:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *附近的社区接口
 */
-(void)getNearbyCommunity:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *重新提交订单（下单后未支付的情况）
 */
-(void)resubmitOrder:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *获取该店铺营业情况
 */
-(void)getShopOnlineTime:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *获取该店铺信息
 */
-(void)getCommunityShop:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *逛街
 */
-(void)windowShopping:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *热词
 */
-(void)getHotSearchKey:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *登录用户获取购物车
 */
-(void)checkCart:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
@end
