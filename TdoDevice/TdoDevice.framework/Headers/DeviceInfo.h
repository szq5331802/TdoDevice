//
//



@interface DeviceInfo : NSObject

@property (nonatomic, assign) int id;                       //设备id
@property (nonatomic, assign) int typeId;                   //类型
@property (nonatomic, copy) NSString* name;                 //设备名称
@property (nonatomic, copy) NSString* desc;                 //设备描述
@property (nonatomic, copy) NSString* imgUrl;               //设备列表背景图片
@property (nonatomic, copy) NSString* iconUrl;              //设备icon
@property (nonatomic, copy) NSString* sportSettingBgUrl;    //设备运动设置背景图片

@end

