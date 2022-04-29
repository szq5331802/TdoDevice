//
//
#import "DeviceInfo.h"
#import "UserDevice.h"

@protocol TdoDeviceDelegate <NSObject>
@optional

/**
 * 获取用户设备列表，用户绑定解绑设备时回调
 * @param deviceList 设备列表
 */
- (void)onUpdateBind:(NSArray<UserDevice*>*_Nonnull)deviceList;

@end

@interface TdoDeviceApi : NSObject

+ (TdoDeviceApi*_Nonnull)getInstance;

/**
 * 初始化sdk，调用所有接口之前调
 * @param appKey appKey
 * @param appSecret appSecret
 * @param debug 设置开发环境，默认 false，发布前须关闭
 * @param delegate delegate
 */
- (void)initWithAppKey:(NSString*_Nonnull)appKey appSecret:(NSString*_Nonnull)appSecret debug:(BOOL)debug delegate:(nullable id<TdoDeviceDelegate>)delegate;

/**
 * 获取设备列表
 */
- (NSArray<DeviceInfo*>*_Nonnull)getDeviceList;

/**
 * 获取用户已绑定设备列表
 * @param userId 用户唯一标识,长度不超过64
 */
- (void)getUserDeviceList:(NSString*_Nonnull)userId;

/**
 * 打开绑定设备界面
 * @param device getDeviceList 获取
 */
- (void)bind:(UINavigationController*_Nonnull)na device:(DeviceInfo*_Nonnull)device;

/**
 * 打开设备界面
 * @param device onUpdateBind: 回调获取
 */
- (void)connect:(UINavigationController*_Nonnull)na device:(UserDevice*_Nonnull)device;

/**
 * 设置设备别名
 * @param devType devType
 * @param devId devId
 * @param devBT devBT
 * @param alias 设备别名，长度不超过100
 */
- (BOOL)setUserDeviceAlias:(int)devType devId:(int)devId devBT:(NSString*_Nonnull)devBT alias:(NSString*_Nonnull)alias;

@end

