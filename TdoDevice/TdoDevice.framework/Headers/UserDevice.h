//
//
#import "DeviceInfo.h"


@interface UserDevice : NSObject

@property (nonatomic, assign) int devType;          //设备类型
@property (nonatomic, assign) int devId;            //设备编号
@property (nonatomic, assign) int power;            //电量
@property (nonatomic, assign) int resVersion;       //表盘版本
@property (nonatomic, assign) int resId;            //表盘id
@property (nonatomic, copy) NSString* devName;      //设备名称
@property (nonatomic, copy) NSString* devNo;        //设备固件号
@property (nonatomic, copy) NSString* devBT;        //设备蓝牙地址
@property (nonatomic, copy) NSString* mfName;       //厂家信息
@property (nonatomic, copy) NSString* swRev;        //软件版本
@property (nonatomic, copy) NSString* swId;         //软件ID
@property (nonatomic, copy) NSString* moduleNum;    //设备型号
@property (nonatomic, copy) NSString* sn;           //流水号
@property (nonatomic, copy) NSString* alias;           //设备别名
@property (nonatomic, retain) DeviceInfo* deviceInfo;

@end

