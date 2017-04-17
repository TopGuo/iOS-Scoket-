//
//  ViewController.m
//  Socket入门
//
//  Created by Shaoting Zhou on 2017/4/17.
//  Copyright © 2017年 Shaoting Zhou. All rights reserved.
//   nc -lk 12345  监听12345端口

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self socketDemo];
}


//MARK : Socket演练
- (void)socketDemo {
    //1.创建Socket
    /**
     参数
     
     domain:    协议域，AF_INET --> IPV4
     type:      Socket 类型，SOCK_STREAM(TCP)/SOCK_DGRAM(UDP)
     protocol: IPPROTO_TCP, 如果传入0,会自动更具第二个参数,选择合适的协议
     
     返回值
     socket
     */
    int  clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    //2.连接到服务器
    /**
     参数
     1> 客户端socket
     2> 指向数据结构体sockaddr的指针，其中包括目的端口和IP地址
     3> 结构体数据长度
     返回值
     0 成功/其他 错误代号
     */
    //结构体  sockaddr
    struct sockaddr_in serverAddr;
    //协议域
    serverAddr.sin_family = AF_INET;
    //端口号
    serverAddr.sin_port = htons(12345);     //定义一个端口号演示
    //IP地址
    serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    
    
    int connResult =  connect(clientSocket, (const struct sockaddr *)&serverAddr , sizeof(serverAddr));
    //3.发送数据给服务器
    /**  C语言里面  Void *  代表指向任意类型
     参数
     1> 客户端socket
     2> 发送内容地址(指针)
     3> 发送内容长度
     4> 发送方式标志，一般为0
     返回值
     如果成功，则返回发送的字节数，失败则返回SOCKET_ERROR
     */
    NSString * sendMsg = @"shaoting";   //随意定义一个字符串演示
    
    ssize_t sendLen =  send(clientSocket, sendMsg.UTF8String, strlen(sendMsg.UTF8String), 0);
    NSLog(@"发送了 %ld 个字节",sendLen);
    
    //4.从服务器接收数据
    /**
     参数
     1> 客户端socket
     2> 接收内容缓冲区地址(指针)
     3> 接收内容缓存区长度
     4> 接收方式，0表示阻塞，必须等待服务器返回数据
     返回值
     如果成功，则返回读入的字节数，失败则返回SOCKET_ERROR
     */
    uint8_t buffer[1024];//空间准备出来
    
    ssize_t recvLen =   recv(clientSocket, buffer, sizeof(buffer), 0);
    NSLog(@"接收到了 %ld 个字节",recvLen);
    
    //获取服务器返回的数据,从缓冲区读取recvLen个字节!!!
    NSData * data = [NSData dataWithBytes:buffer length:recvLen];
    //二进制转字符串
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    
    
    
    //5.关闭
    close(clientSocket);
    
    
    
}


@end
