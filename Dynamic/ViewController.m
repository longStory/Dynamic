//
//  ViewController.m
//  Dynamic
//
//  Created by zengqi on 15/7/15.
//  Copyright (c) 2015年 zengqi. All rights reserved.
//

#import "ViewController.h"
#import <POP.h>
#import "JPEngine.h"

#define LightBlue [UIColor colorWithRed:28.0/255.0 green:190.0/255.0 blue:154.0/255.0 alpha:1]
NSString * const ItsNike = @"ItsNike";
NSString * const NikeTwo = @"NikeTwo";
NSString * const Hide = @"Hide";
NSString * const Scale = @"Scale";
NSString * const ChangeLocation = @"ChangeLocation";
NSString * const ButtonFrame = @"buttonFrame";
NSString * const EaseInOut = @"EaseInOut";
NSString * const POPB = @"POPB";
NSString * const Smooth = @"Smooth";

@interface ViewController (){
    CAShapeLayer *nikeLayer;
    CALayer *roundLayer;
    CAGradientLayer *_grad;
    UIView *conView;
    UIDynamicAnimator *_animator;
    UIAttachmentBehavior *_attach;
}
@property (nonatomic, strong) IBOutlet UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    NSString *sourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0]stringByAppendingPathComponent:@"patch.js"];

    [JPEngine startEngine];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    if (script) {
        [JPEngine evaluateScript:script];
    }
    [super viewDidLoad];
    _button.layer.backgroundColor = LightBlue.CGColor;
    _button.layer.cornerRadius = 3;
    [_button.layer masksToBounds];
    
    conView = [[UIView alloc]initWithFrame:CGRectMake(40, 40, 30, 30)];
    [self.view addSubview:conView];
    
    conView.layer.cornerRadius = 15;
    [conView.layer masksToBounds];
    conView.layer.backgroundColor = LightBlue.CGColor;

    roundLayer = [CALayer layer];
    roundLayer.cornerRadius = 15;
    roundLayer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    roundLayer.borderWidth = 1;
    roundLayer.position = CGPointMake(conView.layer.bounds.size.width/2, conView.layer.bounds.size.height/2) ;
    roundLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [conView.layer addSublayer:roundLayer];
    
    nikeLayer = [CAShapeLayer layer];
    nikeLayer.lineWidth = 3.0f;
    nikeLayer.lineJoin  = kCALineJoinMiter;
    nikeLayer.lineCap   = kCALineCapButt;
    nikeLayer.fillColor = nil;
    nikeLayer.strokeColor = nil;
    
    //贝塞尔曲线的初始化
    UIBezierPath *nikePath  = [[UIBezierPath alloc]init];
    
    CGPoint firstPoint  = CGPointMake(6, 13);
    CGPoint secondPoint = CGPointMake(14.5, 21);
    CGPoint thirdPoint  = CGPointMake(23.5, 7);
    
    //draw lines
    [nikePath moveToPoint:firstPoint];
    [nikePath addLineToPoint:secondPoint];
    [nikePath addLineToPoint:thirdPoint];
    
    nikeLayer.path = nikePath.CGPath;
    [conView.layer addSublayer:nikeLayer];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)tryAnimation:(id)sender{
    //change location
    POPBasicAnimation *basicOne = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    basicOne.duration = 0.4f;
    basicOne.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [basicOne setCompletionBlock:^(POPAnimation *animation ,BOOL isFinish){
        [self transFormer];
    }];
    //放大后spring效果
    POPSpringAnimation *scale = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scale.springSpeed = 10.0f;
    scale.springBounciness = 25.0f;
    scale.toValue = [NSValue valueWithCGPoint:CGPointMake(4, 4)];
    
    [conView pop_addAnimation:basicOne forKey:ChangeLocation];
    
    [conView pop_addAnimation:scale forKey:Scale];
    
    
    POPBasicAnimation *basicButtton = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    basicButtton.toValue = [NSValue valueWithCGPoint:CGPointMake(_button.frame.size.width*0.3, _button.frame.size.height)];
    basicButtton.duration = 0.5f;
    basicButtton.autoreverses = YES;
    [basicButtton setCompletionBlock:^(POPAnimation *animation, BOOL isFinish){
        if (isFinish) {
            [_button setTitle:@"You never finished me!" forState:UIControlStateNormal];
            [_button removeTarget:(id)self action:@selector(tryAnimation:) forControlEvents:UIControlEventTouchUpInside];
            [_button addTarget:(id)self action:@selector(stepTwo:) forControlEvents:UIControlEventTouchUpInside];
        }
    }];
    
    [_button pop_addAnimation:basicButtton forKey:ButtonFrame];
}
-(void)transFormer{
    nikeLayer.strokeColor = [UIColor whiteColor].CGColor;

    POPBasicAnimation *drawNike = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    drawNike.fromValue = @0;
    drawNike.toValue = @1;
    
    [nikeLayer pop_addAnimation:drawNike forKey:ItsNike];
}
-(void)stepTwo :(UIButton*)button{

    //reverse animate from 1 to 0;
    POPBasicAnimation *nextNike = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    nextNike.fromValue = @1;
    nextNike.toValue = @0;
    
    [nextNike setCompletionBlock:^(POPAnimation *animation ,BOOL isFinish){
        if (isFinish) {
            [nikeLayer removeFromSuperlayer];
            POPBasicAnimation *hide = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
            hide.toValue = [NSValue valueWithCGPoint:CGPointMake(conView.layer.bounds.size.width, conView.layer.bounds.size.height)];
            hide.duration = 0.4f;
            
            [roundLayer pop_addAnimation:hide forKey:Hide];
        }
    }];
    [nikeLayer pop_addAnimation:nextNike forKey:NikeTwo];
    
    POPBasicAnimation *popB = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    
    popB.toValue =  [NSValue valueWithCGPoint:CGPointMake(_button.frame.size.width*0.4, _button.frame.size.height)];
    popB.duration = 0.5f;
    popB.autoreverses = YES;
    [_button pop_addAnimation:popB forKey:POPB];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self buttonHide];
    });
    [_button removeTarget:(id)self action:@selector(stepTwo:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonHide{
    
    POPBasicAnimation *move = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    move.toValue = [NSValue valueWithCGPoint:CGPointMake(_button.center.x+100, _button.center.y)];
    [move setCompletionBlock:^(POPAnimation *animation, BOOL isFinish){
        POPBasicAnimation * disappear = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        disappear.toValue =[NSValue valueWithCGPoint:CGPointMake(_button.center.x, _button.center.x-[UIScreen mainScreen].bounds.size.height)];
    
        [disappear setCompletionBlock:^(POPAnimation *animation, BOOL isFinish){
            [self finalAnimation];
            
        }];
        disappear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        disappear.duration = 1;
        
        [_button pop_addAnimation:disappear forKey:@"disappear"];
    }];
    [_button pop_addAnimation:move forKey:@"move"];
    
    
    POPBasicAnimation *hide = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    hide.toValue = @(M_PI/2);
    [_button.layer pop_addAnimation:hide forKey:@"nokey"];
    
}
-(void)showAlert{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Crush it" message:@"empty Array array[10]" delegate:(id)self cancelButtonTitle:@"need patch" otherButtonTitles:@"任性闪退", nil];
    
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex ==1){
        NSArray *array = [NSArray array];
        [array objectAtIndex:10];
    }
    
}
#pragma Dynamic
-(void)finalAnimation{
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    UIGravityBehavior *g = [[UIGravityBehavior alloc]initWithItems:@[_button]];
    
    [animator addBehavior:g];
    
    UICollisionBehavior *coll = [[UICollisionBehavior alloc]initWithItems:@[_button]];
    coll.translatesReferenceBoundsIntoBoundary = YES;
    [coll setTranslatesReferenceBoundsIntoBoundaryWithInsets : UIEdgeInsetsMake([UIScreen mainScreen].bounds.size.height-1, 0, 0, 0)];

    coll.collisionDelegate = (id)self;
    [animator addBehavior:coll];

    _animator = animator;
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier
{
//    //rainbow shows
//    _grad = [CAGradientLayer layer];
//    _grad.startPoint = CGPointMake(0,0.5);
//    _grad.endPoint = CGPointMake(1,0.5);
//    _grad.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 5);
//    NSMutableArray *colors = [NSMutableArray array];
//    for (NSInteger hue = 0; hue <= 360; hue += 5) {
//        
//        UIColor *color;
//        color = [UIColor colorWithHue:1.0 * hue / 360.0
//                           saturation:1.0
//                           brightness:1.0
//                                alpha:1.0];
//        [colors addObject:(id)[color CGColor]];
//    }
//    [_grad setColors:[NSArray arrayWithArray:colors]];
//    [self.view.layer addSublayer:_grad];

    [self showAlert];
    [_animator removeAllBehaviors];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
