//
//  AFSecuteCertificate.m
//  ISSP
//
//  Created by bjike on 16/12/16.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "AFSecuteCertificate.h"

@implementation AFSecuteCertificate

+(AFSecurityPolicy *)customSecurityPolicy:(NSString *)name{
    //导入证书，证书路径
    NSString * cerPath = [[NSBundle mainBundle]pathForResource:name ofType:@"cer"];
    
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    //证书验证模式
    AFSecurityPolicy * policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //是否允许无效证书
    policy.allowInvalidCertificates = YES;
    //是否需要验证域名
    policy.validatesDomainName = NO;
    
    NSSet * set = [[NSSet alloc]initWithObjects:cerData, nil];
    
    policy.pinnedCertificates = set;
    
    return policy;
    
}
@end
