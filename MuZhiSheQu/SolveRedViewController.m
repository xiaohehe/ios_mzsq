//
//  SolveRedViewController.m
//  MuZhiSheQu
//
//  Created by apple on 16/2/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SolveRedViewController.h"
#import "IntroControll.h"
#import "IntroModel.h"
#import "UmengCollection.h"
@interface SolveRedViewController ()<introlDelegate>
@property(nonatomic,strong)IntroControll *IntroV;
@end

@implementation SolveRedViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

    
    
    
    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <_data.count; i ++) {
        
        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",_data[i]]];
        [pagesArr addObject:model1];
    }
    
    _IntroV = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
    _IntroV.delegate=self;
    [_IntroV index:_index-1];
    [self.view addSubview:_IntroV];
}

-(void)tabaryes{

    [self dismissViewControllerAnimated:NO completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
