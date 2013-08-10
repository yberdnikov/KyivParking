//
//  DAXMLParserOperation.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/18/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAXMLParserOperation.h"


static NSString * const kDAParkingElementName = @"parking";


@implementation DAXMLParserOperation {
	BOOL _finished;
	BOOL _executing;

	NSXMLParser *_parser;
	NSMutableDictionary *_element;
	NSString *_elementName;

	void (^_elementHandler)(NSDictionary *);
}

- (id)initWithFileURL:(NSURL *)url elementHandler:(void (^)(NSDictionary *element))elementHandler
{
	self = [self init];

	if (nil != self) {
		_parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		_elementHandler = elementHandler;

		if (nil == _parser) {
			self = nil;
		}
		else {
			_parser.delegate = self;
		}
	}

	return self;
}

- (BOOL)isConcurrent
{
    return YES;
}
 
- (BOOL)isExecuting
{
    return _executing;
}
 
- (BOOL)isFinished
{
    return _finished;
}

- (void)start
{
   if ([self isCancelled]) {
      [self willChangeValueForKey:@"isFinished"];
      _finished = YES;
      [self didChangeValueForKey:@"isFinished"];

      return;
   }
 
   [self willChangeValueForKey:@"isExecuting"];
   [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
   _executing = YES;
   [self didChangeValueForKey:@"isExecuting"];
}

- (void)main
{
	[_parser parse];

	[self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    _finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
	namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:kDAParkingElementName]) {
		_element = [NSMutableDictionary new];
	}
	else {
		_elementName = elementName;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
	namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:kDAParkingElementName]) {
		if (NULL != _elementHandler) {
			_elementHandler(_element);
		}

		_element = nil;
	}

	_elementName = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (nil != _elementName) {
		_element[_elementName] = string;
	}
}

@end
