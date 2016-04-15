# swiftmd5hasher
MD5 digest a file FAST.

# How to
Copy paste the function and make sure Xcode is aware of your bridging header.

# Drawback
I couldn't figure out how to use a small buffer... The md5 is wrong when I use a buffer smaller than the file size.
