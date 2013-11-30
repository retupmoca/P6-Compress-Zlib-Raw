use v6;
module Compress::Zlib::Raw;

use NativeCall;

# structs
class z_stream is repr('CStruct') is export {
    has CArray[int8] $.next-in;
    has int32 $.avail-in;
    has int $.total-in;

    has CArray[int8] $.next-out;
    has int32 $.avail-out;
    has int $.total-out;

    has Str $.msg;
    has OpaquePointer $.state;

    has OpaquePointer $.zalloc;
    has OpaquePointer $.zfree;
    has OpaquePointer $.opaque;

    has int32 $.data-type;
    has int $.adler;
    has int $.reserved;
};

class gz_header is repr('CStruct') is export {
    has int32 $.text;
    has int $.time;
    has int32 $.xflags;
    has int32 $.os;
    has OpaquePointer $.extra;
    has int32 $.extra_len;
    has int32 $.extra_max;
    has Str $.name;
    has int32 $.name_max;
    has Str $.comment;
    has int32 $.comm_max;
    has int32 $.hcrc;
    has int32 $.done;
}

# constants

constant ZLIB_VERSION = "1.2.8";
constant ZLIB_VERNUM = 0x1280;

constant Z_NULL = 0;

# allowed flush values
constant Z_NO_FLUSH = 0;
constant Z_PARTIAL_FLUSH = 1;
constant Z_SYNC_FLUSH = 2;
constant Z_FULL_FLUSH = 3;
constant Z_FINISH = 4;
constant Z_BLOCK = 5;
constant Z_TREES = 6;

# return codes
constant Z_OK = 0;
constant Z_STREAM_END = 1;
constant Z_NEED_DICT = 2;
constant Z_ERRNO = -1;
constant Z_STREAM_ERROR = -2;
constant Z_DATA_ERROR = -3;
constant Z_MEM_ERROR = -4;
constant Z_BUF_ERROR = -5;
constant Z_VERSION_ERROR = -6;

# compression levels
constant Z_NO_COMPRESSION = 0;
constant Z_BEST_SPEED = 1;
constant Z_BEST_COMPRESSION = 9;
constant Z_DEFAULT_COMPRESSION = -1;

# compression strategy
constant Z_FILTERED = 1;
constant Z_HUFFMAN_ONLY = 2;
constant Z_RLE = 3;
constant Z_FIXED = 4;
constant Z_DEFAULT_STRATEGY = 0;

# data_type values
constant Z_BINARY = 0;
constant Z_TEXT = 1;
constant Z_ASCII = Z_TEXT;
constant Z_UNKNOWN = 2;

# deflate compression method
constant Z_DEFLATED = 8;

# functions
sub zlibVersion() returns Str is encoded('ascii') is native('libz.so.1') is export { * }

sub deflateInit_(z_stream, int32, Str is encoded('ascii'), int32) returns int32 is native('libz.so.1') { * }
sub deflateInit(z_stream $stream, int32 $level) is export {
    return deflateInit_($stream, $level, ZLIB_VERSION, 112); # 112 == sizeof z_stream (64 bit linux)
}
sub deflate(z_stream, int32) returns int32 is native('libz.so.1') is export { * }
sub deflateEnd(z_stream) returns int32 is native('libz.so.1') is export { * }

sub inflateInit_(z_stream, Str is encoded('ascii'), int32) returns int32 is native('libz.so.1') { * }
sub inflateInit(z_stream $stream) is export {
    return inflateInit_($stream, ZLIB_VERSION, 112);
}
sub inflate(z_stream, int32) returns int32 is native('libz.so.1') is export { * }
sub inflateEnd(z_stream) returns int32 is native('libz.so.1') is export { * }


