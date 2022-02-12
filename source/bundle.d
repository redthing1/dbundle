module bundle;

/* Simple compression interface.
 * Copyright (c) 2013, 2014, 2015, 2016, 2017 r-lyeh.
 * ZLIB/libPNG licensed.

 * - rlyeh ~~ listening to Boris / Missing Pieces
 */

extern (C):

enum BUNDLE_VERSION = "2.2.0"; /* (2022/02/12) redthing1 hacking
#define BUNDLE_VERSION "2.1.0" // (2017/06/10) C API and DLL bindings; Pump up libcsc; Rename .bnd to .bun
#define BUNDLE_VERSION "2.0.5" // (2016/02/06) Bring back BZIP2 support
#define BUNDLE_VERSION "2.0.4" // (2015/12/04) Add padding support; Fix reentrant CRUSH; Optimizations & fixes
#define BUNDLE_VERSION "2.0.3" // (2015/12/02) Add LZJB and CRUSH; Add BUNDLE_NO_CDDL directive
#define BUNDLE_VERSION "2.0.2" // (2015/11/07) Fix ZMolly segmentation fault (OSX)
#define BUNDLE_VERSION "2.0.1" // (2015/11/04) Fix clang warnings and compilation errors
#define BUNDLE_VERSION "2.0.0" // (2015/11/03) Add BCM,ZLING,MCM,Tangelo,ZMolly,ZSTDf support; Change archive format /!\
#define BUNDLE_VERSION "1.0.2" // (2015/10/29) Skip extra copy during archive decompression; add extra archive meta-info
#define BUNDLE_VERSION "1.0.1" // (2015/10/10) Shrink to fit during measures() function
#define BUNDLE_VERSION "1.0.0" // (2015/10/09) Change benchmark API to sort multiples values as well /!\
#define BUNDLE_VERSION "0.9.8" // (2015/10/07) Remove confusing bundle::string variant class from API
#define BUNDLE_VERSION "0.9.7" // (2015/10/07) Add license configuration directives { BUNDLE_NO_BSD2, BUNDLE_NO_BSD3, ... }
#define BUNDLE_VERSION "0.9.6" // (2015/10/03) Add library configuration directives { BUNDLE_NO_ZSTD, BUNDLE_NO_CSC, ... }
#define BUNDLE_VERSION "0.9.5" // (2015/09/28) Add missing prototypes; bugfix helper function
#define BUNDLE_VERSION "0.9.4" // (2015/09/26) Add CSC20 + Shrinker support; rename enums LZ4->LZ4F/LZ4HC->LZ4
#define BUNDLE_VERSION "0.9.3" // (2015/09/25) Add a few missing API calls
#define BUNDLE_VERSION "0.9.2" // (2015/09/22) Pump up Brotli; split BROTLI enum into BROTLI9/11 pair
#define BUNDLE_VERSION "0.9.1" // (2015/05/10) Switch to ZLIB/LibPNG license
#define BUNDLE_VERSION "0.9.0" // (2015/04/08) BSC support
#define BUNDLE_VERSION "0.8.1" // (2015/04/07) Pump up Brotli+ZSTD, LZMA20/25 dict, unify FOURCCs
#define BUNDLE_VERSION "0.8.0" // (2015/01/27) ZSTD support, reorder enums, simplify API
#define BUNDLE_VERSION "0.7.1" // (2015/01/26) Fix LZMA, verify DEFLATEs, new AUTO enum
#define BUNDLE_VERSION "0.7.0" // (2014/10/22) Brotli support, pump up LZ4
#define BUNDLE_VERSION "0.6.3" // (2014/09/27) Switch to BOOST license
#define BUNDLE_VERSION "0.6.2" // (2014/09/02) Fix 0-byte streams, deflate alignment
#define BUNDLE_VERSION "0.6.1" // (2014/06/30) Safer lz4 decompression, pump up lz4+zpaq
#define BUNDLE_VERSION "0.6.0" // (2014/06/26) LZ4HC support, optimize in-place decompression
#define BUNDLE_VERSION "0.5.0" // (2014/06/09) ZPAQ support, UBER encoding, fixes
#define BUNDLE_VERSION "0.4.1" // (2014/06/05) Switch to lzmasdk
#define BUNDLE_VERSION "0.4.0" // (2014/05/30) Maximize compression (lzma)
#define BUNDLE_VERSION "0.3.0" // (2014/05/28) Fix alignment (deflate), change stream header
#define BUNDLE_VERSION "0.2.1" // (2014/05/23) Fix overflow bug
#define BUNDLE_VERSION "0.2.0" // (2014/05/14) Add VLE header, fix vs201x compilation errors
#define BUNDLE_VERSION "0.1.0" // (2014/05/13) Add high-level API, iOS support
#define BUNDLE_VERSION "0.0.0" // (2014/05/09) Initial commit */

// C Api {

// size_t
// bool

enum BUNDLE_API = BUNDLE_API_EXPORT;

// libraries and/or encoders 
enum
{
    BUNDLE_RAW = 0,
    BUNDLE_SHOCO = 1,
    BUNDLE_LZ4F = 2,
    BUNDLE_MINIZ = 3,
    BUNDLE_LZIP = 4,
    BUNDLE_LZMA20 = 5,
    BUNDLE_ZPAQ = 6,
    BUNDLE_LZ4 = 7, //  0..7
    BUNDLE_BROTLI9 = 8,
    BUNDLE_ZSTD = 9,
    BUNDLE_LZMA25 = 10,
    BUNDLE_BSC = 11,
    BUNDLE_BROTLI11 = 12,
    BUNDLE_SHRINKER = 13,
    BUNDLE_CSC20 = 14, //  7..14
    BUNDLE_ZSTDF = 15,
    BUNDLE_BCM = 16,
    BUNDLE_ZLING = 17,
    BUNDLE_MCM = 18,
    BUNDLE_TANGELO = 19,
    BUNDLE_ZMOLLY = 20,
    BUNDLE_CRUSH = 21,
    BUNDLE_LZJB = 22, // 15..22
    BUNDLE_BZIP2 = 23 // 23..
}

// constant: 32 = [0..10] padding + [1] 0x70 + [1] q + [1..10] vle(in) + [1..10] vle(out)
enum
{
    BUNDLE_MAX_HEADER_SIZE = 32
}

// algorithm properties
const char* bundle_name_of (uint q);
const char* bundle_version_of (uint q);
const char* bundle_ext_of (uint q);
size_t bundle_unc_payload (uint q);
size_t bundle_bound (uint q, size_t len);

// low level API (raw pointers)
bool bundle_is_packed (const(void)* mem, size_t size);
bool bundle_is_unpacked (const(void)* mem, size_t size);
uint bundle_type_of (const(void)* mem, size_t size);
uint bundle_guess_type_of (const(void)* mem, size_t size);
size_t bundle_len (const(void)* mem, size_t size);
size_t bundle_zlen (const(void)* mem, size_t size);
size_t bundle_padding (const(void)* mem, size_t size);
const(void)* bundle_zptr (const(void)* mem, size_t size);
bool bundle_pack (uint q, const(void)* in_, size_t len, void* out_, size_t* zlen);
bool bundle_unpack (uint q, const(void)* in_, size_t len, void* out_, size_t* zlen);

// variable-length encoder
size_t bundle_enc_vlebit (char* buf, size_t val); // return number of bytes written
size_t bundle_dec_vlebit (const(char)* i, size_t* val); // return number of bytes read

// } C API

// C++ API

// libraries and/or encoders 
//  0..7
//  7..14
// 15..22
// 23..

// algorithm properties

// low level API (raw pointers)

// medium level API, templates (in-place)

// sanity checks

// decapsulate, skip header (initial byte), and grab Q (compression algorithm)

// retrieve uncompressed and compressed size

// decompress

// note: output must be resized properly before calling this function!! (see bound() function)

// sanity checks

/* is_unpacked( input ) */
// resize to worst case

// compress

// resize properly (new zlen)

// encapsulate

// high level API, templates (copy)

// helpers

// for archival purposes

// measures for all given encodings

//std::cout << name_of(encoding) << std::endl;

// @todo: clean up, if !best ratio && !fastest dec && !best mem

// sort_* functions return sorted slot indices (as seen order in measures vector)

// skip compression results if compression ratio is below % (like <5%). default: 0 (do not skip)
// also, sort in reverse order

// find_* functions return sorted encoding enums (as slot indices are traversed from measures vector)

// inspection (json doc)

// .bun binary serialization

// .zip binary serialization

/* level [0(store)..100(max)] */

// generic serialization

// inspection (json doc)

// __cplusplus
// BUNDLE_HPP

// tiny unittest suite { // usage: int main() { /* orphan test */ test(1<2); suite("grouped tests") { test(1<2); test(1<2); } }

// } rlyeh, public domain.

// 23 mb dataset

// pack, unpack & verify all encoders

//std::cout << "zipping files..." << std::endl;

// save .zip archive to memory string (then optionally to disk)
// compression level = 60 (of 100)

//std::cout << "saving test:\n" << pak.toc() << std::endl;

//std::cout << "unzipping files..." << std::endl;

//std::cout << "loading test:\n" << pak.toc() << std::endl;

//std::cout << "packing files..." << std::endl;

// save .bun archive to memory string (then optionally to disk)

//std::cout << "saving test:\n" << pak.toc() << std::endl;

//std::cout << "unpacking files..." << std::endl;

//std::cout << "loading test:\n" << pak.toc() << std::endl;

//std::cout << pak[0]["data"] << std::endl;

//std::cout << pak.toc() << std::endl;

// BUNDLE_BUILD_TESTS
