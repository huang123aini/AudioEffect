#import <UIKit/UIKit.h>

//title显示在滑块的上方或下方
typedef enum : NSUInteger{
    TopTitleStyle,
    BottomTitleStyle
}TitleStyle;

@interface BAUISlider : UISlider

//是否显示百分比
@property (nonatomic,assign) BOOL isShowTitle;
@property (nonatomic,assign) TitleStyle titleStyle;

@end
