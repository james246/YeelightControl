//
//  AppDelegate.swift
//  YeelightControl
//
//  Created by james246 on 18/11/2017.
//  Copyright © 2017 james246. All rights reserved.
//

import Cocoa
import CocoaAsyncSocket

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, GCDAsyncUdpSocketDelegate {
    let broadcastHost = "239.255.255.250"
    let broadcastPort = UInt16.init(53401)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSLog("Hello %@!", "world")
        listen()
        discoverDevice()
    }
    
    func discoverDevice() {
        let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        do {
            try socket.bind(toPort: broadcastPort)
            try socket.joinMulticastGroup(broadcastHost)
            try socket.beginReceiving()
        } catch let msg {
            NSLog("Error setting up socket: \(msg)")
        }
        
        socket.send(
            discoveryMessage().data(using: String.Encoding.utf8)!,
            toHost: broadcastHost,
            port: broadcastPort,
            withTimeout: 2,
            tag: 0
        )
    }
    
    func listen() {
        //
    }
    
//    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: Data!, fromAddress address: Data!, withFilterContext filterContext: Any!) {
//        guard let stringData = String(data: data as Data, encoding: String.Encoding.utf8) else {
//            NSLog(">>> Data received, but cannot be converted to String")
//            return
//        }
//        NSLog("Data received: \(stringData)")
//    }
    
    func discoveryMessage() -> String {
        return "M-SEARCH * HTTP/1.1\r\nHOST: \(broadcastHost):\(broadcastPort)\r\nMAN: \"ssdp:discover\"\r\nST: wifi_bulb"
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

