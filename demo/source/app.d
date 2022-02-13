import std.stdio;
import std.string;
import std.array;
import std.range;
import std.file;
import std.utf;
import std.conv;

import bundle;

public static char* c_str(string str) {
	return str.toUTFz!(char*)();
}

void main(string[] args) {
	writeln("dbundle demo");

	// 23 mb dataset
	string original = "There's a lady who's sure all that glitters is gold";
	for (int i = 0; i < 18; ++i)
		original ~= original ~ replicate(format("%c", cast(char)(32 + i)), i + 1);

	// writefln("original: %s", original);

	// argument file?
	if (args.length > 1) {
		original = readText(args[1]);
	}

	// // pack, unpack & verify all encoders
	// vector<unsigned> libs { 
	//     RAW, SHOCO, LZ4F, MINIZ, LZIP, LZMA20,
	//     ZPAQ, LZ4, BROTLI9, ZSTD, LZMA25,
	//     BSC, BROTLI11, SHRINKER, CSC20, BCM,
	//     ZLING, MCM, TANGELO, ZMOLLY, CRUSH, LZJB
	// };
	// for( auto &lib : libs ) {
	//     #ifdef _MSC_VER
	//     double t = omp_get_wtime();
	//     #endif
	//     string packed = pack(lib, original);
	//     string unpacked = unpack(packed);
	//     cout << original.size() << " <--> " << packed.size() << " bytes (" << name_of(lib) << ")";
	//     #ifdef _MSC_VER
	//     cout << " " << ((omp_get_wtime() - t)*1000) << "ms.";
	//     #endif
	//     if( original == unpacked ) cout << endl; else cout << " (failed)" << endl;
	// }

	// cout << "All ok." << endl;

	// pack, unpack & verify all encoders
	BUNDLE_LIBS[] libs = [
		BUNDLE_LIBS.BUNDLE_RAW, BUNDLE_LIBS.BUNDLE_SHOCO, BUNDLE_LIBS.BUNDLE_LZ4F,
		BUNDLE_LIBS.BUNDLE_MINIZ, BUNDLE_LIBS.BUNDLE_LZIP,
		BUNDLE_LIBS.BUNDLE_LZMA20, BUNDLE_LIBS.BUNDLE_ZPAQ, BUNDLE_LIBS.BUNDLE_LZ4,
		BUNDLE_LIBS.BUNDLE_BROTLI9, BUNDLE_LIBS.BUNDLE_ZSTD,
		BUNDLE_LIBS.BUNDLE_LZMA25,
		BUNDLE_LIBS.BUNDLE_BSC, BUNDLE_LIBS.BUNDLE_BROTLI11,
		BUNDLE_LIBS.BUNDLE_SHRINKER,
		BUNDLE_LIBS.BUNDLE_CSC20, BUNDLE_LIBS.BUNDLE_BCM,
		BUNDLE_LIBS.BUNDLE_ZLING, BUNDLE_LIBS.BUNDLE_MCM,
		BUNDLE_LIBS.BUNDLE_TANGELO,
		BUNDLE_LIBS.BUNDLE_ZMOLLY, BUNDLE_LIBS.BUNDLE_CRUSH,
		BUNDLE_LIBS.BUNDLE_LZJB
	];

	foreach (lib; libs) {
		writefln("packing using %s", lib);
		auto raw_data = cast(ubyte[])(original.dup);
		auto zlen = bundle_bound(lib, raw_data.length);
		auto output_data = new ubyte[BUNDLE_MAX_HEADER_SIZE + zlen];
		writefln("stream lengths: %d %d", raw_data.length, zlen);
		auto inptr = cast(ubyte*) raw_data;
		auto outptr = cast(ubyte*) &output_data[BUNDLE_MAX_HEADER_SIZE];
		writefln("inptr: %s outptr: %s", inptr, outptr);
		auto result = bundle_pack(lib, inptr, raw_data.length, outptr, &zlen);
		writefln("packing result: %s", result ? "ok" : "failed");
	}
}
