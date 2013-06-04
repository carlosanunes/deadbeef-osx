/*
 Core Audio Decoder plugin
 Copyright (C) 2012 Carlos Nunes <carloslnunes@gmail.com>
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#include <stdlib.h>
#include <string.h>
#include "../../deadbeef.h"

#if !defined(__COREAUDIO_USE_FLAT_INCLUDES__)
#include <AudioToolbox/AudioToolbox.h>
#else
#include <AudioToolbox.h>
#endif

#define trace(...) { fprintf(stderr, __VA_ARGS__); }

#define READ_BUFFER_SIZE 0x2800 // 10k should be enough for a single frame

// define Leopard specific symbols for backward compatibility if applicable
#if COREAUDIOTYPES_VERSION < 1050
typedef Float32 AudioSampleType;
enum { kAudioFormatFlagsCanonical = kAudioFormatFlagIsFloat | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked };
#endif
#if COREAUDIOTYPES_VERSION < 1051
typedef Float32 AudioUnitSampleType;
enum {
    kLinearPCMFormatFlagsSampleFractionShift    = 7,
    kLinearPCMFormatFlagsSampleFractionMask     = (0x3F << kLinearPCMFormatFlagsSampleFractionShift),
};
#endif

//  define the IsMixable format flag for all versions of the system
#if (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3)
enum { kIsNonMixableFlag = kAudioFormatFlagIsNonMixable };
#else
enum { kIsNonMixableFlag = (1L << 6) };
#endif

static DB_decoder_t plugin;
static DB_functions_t *deadbeef;

// taken from Core Audio Developer Documentation (supported formats since OS X v10.4)
static const char * exts[] = { "aac", "mp3", "alac", "mp4", "aif", "aiff", "aifc", "caf", "m4a", "snd", "au", "sd2", "wav", "adts", NULL }; 

typedef struct {
    DB_fileinfo_t info;
	AudioStreamBasicDescription streamdescription;
	AudioFileStreamID stream;
    UInt64 datapacket_count;
	DB_FILE * file;
    int startsample;
    int endsample;
    int currentsample;
    char buffer[READ_BUFFER_SIZE];
    int junk_size;
	int error; 
	int decode; // decoding flag 0/1
} audiofile_info_t;

static inline bool IsASBDescriptionEmpty (const AudioStreamBasicDescription f) {
	return	(f.mSampleRate == 0) &&
            (f.mFormatID == 0) &&
            (f.mFormatFlags == 0) &&
            (f.mFramesPerPacket == 0) &&
            (f.mBytesPerFrame == 0) &&
            (f.mChannelsPerFrame == 0) &&
            (f.mBitsPerChannel == 0) &&
            (f.mReserved == 0);
}

static void coreaudio_property_callback (void *inClientData, AudioFileStreamID inAudioFileStream, AudioFileStreamPropertyID inPropertyID, UInt32 *ioFlags) {
	
    audiofile_info_t *info = (audiofile_info_t *)inClientData;

	// debug
	trace("found property '%c%c%c%c'\n", (inPropertyID>>24)&255, (inPropertyID>>16)&255, (inPropertyID>>8)&255, inPropertyID&255);
	
	switch (inPropertyID) {
		case kAudioFileStreamProperty_ReadyToProducePackets :
		{
			// the file stream parser is now ready to produce audio packets.
			// get the stream format.
			UInt32 asbdSize = sizeof(info->streamdescription);
			OSStatus err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_DataFormat, &asbdSize, &info->streamdescription);
			if (err) {
				trace("coredecoder: get kAudioFileStreamProperty_DataFormat failed"); info->error = 1; break;
			}
			break;
        }
        case kAudioFileStreamProperty_AudioDataPacketCount :
        {
            UInt32 propertySize = sizeof(info->datapacket_count);
            OSStatus err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_AudioDataPacketCount, &propertySize, &info->datapacket_count);
            if (err) {
                trace("coredecoder: failed found property '%c%c%c%c'\n", (err>>24)&255, (err>>16)&255, (err>>8)&255, err&255);
                info-> error = 1; break;
            }

			break; 
		}
    }
	
}

static void coreaudio_packets_callback (void *inClientData, UInt32 inNumberBytes, UInt32 inNumberPackets, const void *inInputData, AudioStreamPacketDescription *inPacketDescriptions) {

	audiofile_info_t *info = (audiofile_info_t *)inClientData;
	
	if (info->decode) {
	
		// insert decode code here
	}
		
	
}

// allocate codec control structure
static DB_fileinfo_t *
coredecoder_open (uint32_t hints) {
    DB_fileinfo_t *_info = malloc (sizeof (audiofile_info_t));
    audiofile_info_t *info = (audiofile_info_t *)_info;
    memset (info, 0, sizeof (audiofile_info_t));
    return _info;
}

// prepare to decode the track, fill in mandatory plugin fields
// return -1 on failure
static int
coredecoder_init (DB_fileinfo_t *_info, DB_playItem_t *it) {

    trace ("coreaudio_init %s\n", deadbeef->pl_find_meta (it, ":URI"));

    audiofile_info_t *info = (audiofile_info_t *)_info;
    info->decode = 1;
    info->error = 0;
    ssize_t bytes_read = 0;

    deadbeef->pl_lock ();
	info->file = deadbeef->fopen(deadbeef->pl_find_meta (it, ":URI"));
    deadbeef->pl_unlock (); 
    
    if (!info->file)
        return -1;

	OSStatus err = AudioFileStreamOpen(info, coreaudio_property_callback, coreaudio_packets_callback, 0, &info->stream);
	if (err) { trace ("coredecoder: AudioFileStreamOpen() failed"); return -1; }

	while(1) {
        bytes_read = deadbeef->fread(info->buffer, 1, READ_BUFFER_SIZE, info->file);
        err = AudioFileStreamParseBytes(info->stream, bytes_read, info->buffer, 0);
        if (err) { trace ("coredecoder: AudioFileStreamParseBytes() failed"); return -1; }
    } 
																		
    // set audio file info
    _info->fmt.bps = 16;
    _info->fmt.channels = 2;
    _info->fmt.samplerate  = 44100;
    for (int i = 0; i < _info->fmt.channels; i++) {
        _info->fmt.channelmask |= 1 << i;
    }
    _info->readpos = 0;
    _info->plugin = &plugin;

    if (it->endsample > 0) {
        info->startsample = it->startsample;
        info->endsample = it->endsample;
        plugin.seek_sample (_info, 0);
    }
    else {
        info->startsample = 0;
        int TOTALSAMPLES = 1000; // calculate from file
        info->endsample = TOTALSAMPLES-1;
    }
    return 0;
}

// free everything allocated in _init
static void
coredecoder_free (DB_fileinfo_t *_info) {
    audiofile_info_t *info = (audiofile_info_t *)_info;
    if (info) {
        free (info);
    }
}


// try decode `size' bytes
// return number of decoded bytes
// or 0 on EOF/error
static int
coredecoder_read (DB_fileinfo_t *_info, char *bytes, int size) {
    audiofile_info_t *info = (audiofile_info_t *)_info;
    info->currentsample += size / (_info->fmt.channels * _info->fmt.bps/8);
    return size;
}

// seek to specified sample (frame)
// return 0 on success
// return -1 on failure
static int
coredecoder_seek_sample (DB_fileinfo_t *_info, int sample) {
    audiofile_info_t *info = (audiofile_info_t *)_info;
    
    info->currentsample = sample + info->startsample;
    _info->readpos = (float)sample / _info->fmt.samplerate;
    return 0;
}

// seek to specified time in seconds
// return 0 on success
// return -1 on failure
static int
coredecoder_seek (DB_fileinfo_t *_info, float time) {
    return coredecoder_seek_sample (_info, time * _info->fmt.samplerate);
}

// read information from the track
// load/process cuesheet if exists
// insert track into playlist
// return track pointer on success
// return NULL on failure

static DB_playItem_t *
coredecoder_insert (ddb_playlist_t *plt, DB_playItem_t *after, const char *fname) {
    
    // open file
    DB_FILE *fp = deadbeef->fopen (fname);
    int64_t fsize = -1;
    if (!fp) {
        trace ("example: failed to fopen %s\n", fname);
        return NULL;
    }

    if (fp->vfs->is_streaming ()) {
        DB_playItem_t *it = deadbeef->pl_item_alloc_init (fname, plugin.plugin.id);
        deadbeef->fclose (fp);
        deadbeef->pl_add_meta (it, "title", NULL);
        deadbeef->plt_set_item_duration (plt, it, -1);
        after = deadbeef->plt_insert_item (plt, after, it);
        deadbeef->pl_item_unref (it);
        return after;
    }

    // looking for file info

    audiofile_info_t info = {0};
    info.file = fp;
    info.error = 0;
    info.decode = 0; // no decode necessary, just getting audio file info
    info.junk_size = deadbeef->junk_get_leading_size (fp);
        if (info.junk_size >= 0) {
			trace ("junk: %d\n", info.junk_size);
		deadbeef->fseek (fp, info.junk_size, SEEK_SET);
    }
    else {
        info.junk_size = 0;
    }
	
    DB_playItem_t *it = deadbeef->pl_item_alloc_init (fname, plugin.plugin.id);
	const char * filetype = "unknown";

    int apeerr = deadbeef->junk_apev2_read (it, fp);
    int v2err = deadbeef->junk_id3v2_read (it, fp);
    int v1err = deadbeef->junk_id3v1_read (it, fp);

    OSStatus err = AudioFileStreamOpen(&info, coreaudio_property_callback, coreaudio_packets_callback, 0, &info.stream);
	deadbeef->fseek (fp, info.junk_size, SEEK_SET);

    if (err) { 
		trace ("coredecoder: AudioFileStreamOpen() failed");
		deadbeef->fclose (fp);
		return NULL; 
	}
	
	size_t bytesread = 0;
	unsigned char buf[READ_BUFFER_SIZE];
    char str[100];
	
    while (1) {
			
		bytesread = deadbeef->fread(buf, 1, READ_BUFFER_SIZE, info.file);
		err = AudioFileStreamParseBytes(info.stream, bytesread, buf, 0);
		if (err) { trace("coredecoder: AudioFileStreamParseBytes() failed"); return NULL; }
		
        if(!IsASBDescriptionEmpty(info.streamdescription)) {
            // TODO: Handle VBR data
            // deadbeef->plt_set_item_duration (plt, it, (float) info.datapacket_count * info.streamdescription.mFramesPerPacket / info.streamdescription.mSampleRate );
			
            switch(info.streamdescription.mFormatID) {
                case kAudioFormatLinearPCM : {
                    filetype = "PCM";
                    break;
                }
                case kAudioFormatAppleIMA4 : {
                    filetype = "ADPCM";
                    break;
                }
                case kAudioFormatMPEG4AAC : {
                    filetype = "AAC";
                    break;
                }   
                case kAudioFormatMPEG4CELP : {
                    filetype = "CELP";
                    break;
                }   
                case kAudioFormatMPEG4HVXC : {
                    filetype = "HVXC";
                    break;
                }             
                case kAudioFormatMPEG4TwinVQ : {
                    filetype = "TwinVQ";
                    break;
                }
                case kAudioFormatMACE3 : {
                    filetype = "MACE 3:1";
                    break;
                }            
                case kAudioFormatMACE6 : {
                    filetype = "MACE 6:1";
                    break;
                }
                case kAudioFormatULaw : {
                    filetype = "uLaw";
                    break;
                }
                case kAudioFormatALaw : {
                    filetype = "aLaw";
                    break;
                }  
                case kAudioFormatQDesign : {
                    filetype = "QDesign";
                    break;
                }
                case kAudioFormatQDesign2 : {
                    filetype = "QDesign2";
                    break;
                }
                case kAudioFormatQUALCOMM : {
                    filetype = "QUALCOMM PureVoice";
                    break;
                }
                case kAudioFormatMPEGLayer1 : {
                    filetype = "MP1";
                    break;                    
                }
                case kAudioFormatMPEGLayer2 : {
                    filetype = "MP2";
                    break;
                }
                case kAudioFormatMPEGLayer3 : {
                    filetype = "MP3";
                    break;
                }
                case kAudioFormatMIDIStream : {
                    filetype = "MIDI";
                    break;
                }
                case kAudioFormatAppleLossless : {
                    filetype = "ALAC";
                    break;
                }
                case kAudioFormatMPEG4AAC_HE : {
                    filetype = "AAC-HE";
                    break;
                }
                case kAudioFormatMPEG4AAC_LD : {
                    filetype = "AAC-LD";
                    break;
                }       
                case kAudioFormatMPEG4AAC_HE_V2 : {
                    filetype = "AAC-HE V2";
                    break;
                }         
                case kAudioFormatMPEG4AAC_Spatial : {
                    filetype = "AAC Spatial";
                    break;
                }        
                case kAudioFormatAMR : {
                    filetype = "AMR";
                    break;
                }
                case kAudioFormatAudible : {
                    filetype = "Audible Book Codec";
                    break;
                }
                case kAudioFormatiLBC : {
                    filetype = "iLBC";
                    break;
                }                
                case kAudioFormatDVIIntelIMA : {
                    filetype = "IMA ADPCM";
                    break;
                }            
                case kAudioFormatMicrosoftGSM : {
                    filetype = "Microsoft GSM";
                    break;
                } 
                case kAudioFormatAES3 : {
                    filetype = "AES3-2003";
                    break;  
                }
            }
            deadbeef->pl_add_meta (it, ":FILETYPE", filetype);	
		}

		if (bytesread == 0) // end of file
			break;
	}

    snprintf (str, sizeof (str), "%f", info.streamdescription.mSampleRate);
	deadbeef->pl_add_meta (it, ":SAMPLERATE", str);
    snprintf (str, sizeof (str), "%d", info.streamdescription.mChannelsPerFrame);
    deadbeef->pl_add_meta (it, ":CHANNELS", str);
    snprintf (str, sizeof (str), "%lld", deadbeef->fgetlength (fp) );
    deadbeef->pl_add_meta (it, ":FILE_SIZE", str);
/*
    snprintf (s, sizeof (s), "%d", WavpackGetBytesPerSample (ctx) * 8);
    deadbeef->pl_add_meta (it, ":BPS", s);
    snprintf (s, sizeof (s), "%d", (int)(WavpackGetAverageBitrate (ctx, 1) / 1000));
    deadbeef->pl_add_meta (it, ":BITRATE", s);
*/
    AudioFileStreamClose(info.stream);
    deadbeef->fclose(info.file);

    after = deadbeef->plt_insert_item (plt, after, it);
    deadbeef->pl_item_unref (it);
    return after;
}

static int
coredecoder_start (void) {
    // do one-time plugin initialization here
    // e.g. starting threads for background processing, subscribing to events, etc
    // return 0 on success
    // return -1 on failure
    return 0;
}

static int
coredecoder_stop (void) {
    // undo everything done in _start here
    // return 0 on success
    // return -1 on failure
    return 0;
}


static DB_decoder_t plugin = {
    DB_PLUGIN_SET_API_VERSION
    .plugin.version_major = 0,
    .plugin.version_minor = 1,
    .plugin.type = DB_PLUGIN_DECODER,
    .plugin.name = "CoreAudio Decoder",
    .plugin.id = "coredecoder",
    .plugin.descr = "Decoder plugin that relies on the Core Audio framework",
    .plugin.copyright = "CoreAudio Decoder Plugin\n" 
						"Copyright (c) 2012-2013 Carlos Nunes <carloslnunes@gmail.com>\n"
						"\n"
						"CoreAudio Output Deadbeef Plugin is licensed under a Creative \n"
						"Commons Attribution-NoDerivs 3.0 Unported License.\n",
    .plugin.start = coredecoder_start,
    .plugin.stop = coredecoder_stop,
    .init = coredecoder_init,
    .free = coredecoder_free,
    .read = coredecoder_read,
    .seek = coredecoder_seek,
    .seek_sample = coredecoder_seek_sample,
    .insert = coredecoder_insert,
    .exts = exts,
};


DB_plugin_t *
coredecoder_load (DB_functions_t *api) {
    deadbeef = api;
    return DB_PLUGIN (&plugin);
}
