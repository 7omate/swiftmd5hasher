//
//  main.swift
//  md5hasher
//  Licence: WTFPL
//  Created by thomas saliou on 13/04/16.
//  Copyright © 2016 Abstrium pydio.com . All rights reserved.
//

import Foundation

/**
 Calculates the MD5 of a file
 - Parameters:
    - path to file
 
 Warning: For some reason I can't get it to work with a buffer smaller than the file size... HELP WANTED
*/
func md5file(filepath: String) -> String {
    // figure out a buffsize
    var buffsize = 0
    do {
        let fileAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(filepath)
        buffsize = fileAttributes[NSFileSize] as! Int + 1
    } catch let err as NSError {
        NSLog(String(format: "Failed to get file size of %s", filepath))
        NSLog(err.localizedDescription)
        return ""
    }
    // Instantiate a stream reader without autorelease
    let readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, NSURL(fileURLWithPath: filepath))
    CFReadStreamOpen(readStream)
    let context = UnsafeMutablePointer<CC_MD5_CTX>.alloc(1)
    var digest = Array<UInt8>(count:Int(CC_MD5_DIGEST_LENGTH), repeatedValue:0)
    CC_MD5_Init(context)
    
    var hasMoreData = true
    while (hasMoreData) {
        let buffer = [uint8](count: buffsize, repeatedValue: 0)
        let readBytesCount = CFReadStreamRead(readStream, UnsafeMutablePointer(buffer), buffer.count)
        //print(String(readBytesCount) + " " + String(buffer.count))
        if readBytesCount == -1 {
            break
        }
        if readBytesCount != buffer.count {
            CC_MD5_Update(context, buffer, CC_LONG(buffer.count-1))
            break
        }
        if readBytesCount == 0 {
            hasMoreData = false
            break
        }
        CC_MD5_Update(context, buffer, CC_LONG(buffer.count))
    }
    CFReadStreamClose(readStream)
    CC_MD5_Final(&digest, context)
    context.dealloc(1)
    var hexString = ""
    for byte in digest {
        hexString += String(format:"%02x", byte)
    }
    return hexString
}

func main(){
    let path = "/Users/thomas/Pydio/tests/" + "lefile100"
    print(path)
    var starttime = NSDate()
    starttime = NSDate()
    print(md5file(path))
    print("CFRead CC_MD5 " + String(NSDate().timeIntervalSinceDate(starttime)))
}

main()

/*
func md5OfFile(path String){
    let s = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
    var context = UnsafeMutablePointer<CC_MD5_CTX>.alloc(1)
    var digest = Array<UInt8>(count:Int(CC_MD5_DIGEST_LENGTH), repeatedValue:0)
    CC_MD5_Init(context)
    CC_MD5_Update(context, s, CC_LONG(s.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
    CC_MD5_Final(&digest, context)
    context.dealloc(1)
    var hexString = ""
    for byte in digest {
        hexString += String(format:"%02x", byte)
    }
    return hexString
}
*/

/*
func md5OfString(s String){
    let digestLength = Int(CC_MD5_DIGEST_LENGTH)
    let md5Buffer = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLength)
    CC_MD5(s, CC_LONG(s.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)), md5Buffer)
    var output = NSMutableString(capacity: Int(CC_MD5_DIGEST_LENGTH * 2))
    for i in 0..<digestLength {
        output.appendFormat("%02x", md5Buffer[i])
    }
    let finishedin = NSDate().timeIntervalSinceDate(starttime)
    print(finishedin)
    print(output)
}
*/

