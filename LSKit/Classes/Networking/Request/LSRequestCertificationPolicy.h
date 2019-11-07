//
//  LSRequestCertificationPolicy.h
//  LSKit
//
//  Created by Lyson on 2019/9/15.
//

#import <Foundation/Foundation.h>


/**
 SSL校验模式

 - LSSSLPinningMode_None: 不校验
 - LSSSLPinningMode_PublicKey: 校验公钥
 - LSSSLPinningMode_Certificate: 校验权证书
 */
typedef NS_ENUM(NSInteger,LSSSLPinningMode) {
    
    LSSSLPinningMode_None,
    LSSSLPinningMode_PublicKey,
    LSSSLPinningMode_Certificate,
};

@interface LSRequestCertificationPolicy : NSObject

@property (readonly, nonatomic, assign) LSSSLPinningMode SSLPinningMode;

@property (nonatomic, strong, nullable) NSSet <NSData *> *pinnedCertificates;

@property (nonatomic, assign) BOOL allowInvalidCertificates;

@property (nonatomic, assign) BOOL validatesDomainName;

@end
