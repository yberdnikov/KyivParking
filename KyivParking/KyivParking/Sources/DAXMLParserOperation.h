//
//  DAXMLParserOperation.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/18/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//


@interface DAXMLParserOperation : NSOperation <NSXMLParserDelegate>

- (id)initWithFileURL:(NSURL *)url elementHandler:(void (^)(NSDictionary *element))elementHandler;

@end
