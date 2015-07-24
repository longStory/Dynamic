//
//  DYButton.m
//  Dynamic
//
//  Created by zengqi on 15/7/17.
//  Copyright (c) 2015年 zengqi. All rights reserved.
//

#import "DYButton.h"
@implementation DYButton
//only to know wether finger is left
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //ok,I know
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //remove g
    [[NSNotificationCenter defaultCenter]postNotificationName:FINGERLEFT object:nil];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //remove g
    [[NSNotificationCenter defaultCenter]postNotificationName:FINGERLEFT object:nil];
}

@end
