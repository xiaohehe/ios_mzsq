#import <UIKit/UIKit.h>
#import "IntroView.h"

@protocol introlDelegate <NSObject>

-(void)tabaryes;

@end


@interface IntroControll : UIView<UIScrollViewDelegate> {
    UIImageView *backgroundImage1;
    UIImageView *backgroundImage2;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSArray *pages;
    
    NSTimer *timer;
    
    int currentPhotoNum;
}

- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pages;

- (void)index:(NSInteger )index;

@property(nonatomic,assign)id<introlDelegate>delegate;
@end
