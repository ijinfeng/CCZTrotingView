//
//  CCZTrotingAttribute.h
//  CCZTrotView
//
//  Created by 金峰 on 16/9/25.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCZTrotingAttribute : NSObject
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) NSAttributedString *attribute;
@property (nonatomic, copy) NSString *identifier; //／ 这个属性可以用作特殊用途
@end
