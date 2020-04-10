//
//  TXTAudioEffectsManager.m
//  Pods-TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/12.
//

#import "TXTAudioEffectsManager.h"
#include <stdio.h>
#import "sonic.h"
#import "reverb.h"
#import "biquad.h"
#import "BerVibrato.h"

typedef struct sonicInstStruct
{
    sonicStream stream;
    short *byteBuf;
    int byteBufSize;
}sonicInstStruct;

@interface TXTAudioEffectsManager()
{
    sonicInstStruct *sonicInst;
    sf_biquad_state_st bq_state;
    sf_reverb_state_st rv_state;
}

@property(nonatomic,assign)float pitch;
@property(nonatomic,assign)BOOL isReverbAdvance;
@property(nonatomic,strong)BerVibrato* berVibrato;
@end

static float clampf(float v, float min, float max)
{
    return v < min ? min : (v > max ? max : v);
}

static void clampfReturn(float min,float max,float value)
{
    if (value < min || value > max)
    {
        printf("param is invalid-clampfReturn");
        return;
    }
}
@implementation TXTAudioEffectsManager

@synthesize pitch =_pitch;
@synthesize effectType = _effectType;

+ (instancetype)sharedInstance
{
    static TXTAudioEffectsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init
{
    if (self = [super init])
    {
        _effectType = AudioEffectType_NONE;
        self.channels = 1; /**ios端音频采集是单声道*/
        self.sampleRate = 44100;/** ios android 麦克风默认采样率是44100*/
        self.isReverbAdvance = NO;
        self.advanceReverbParms = [NSMutableDictionary dictionary];
        self.biquadParams = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setEffectType:(AudioEffectType)effectType
{
    _effectType = effectType;
}
-(AudioEffectType)effectType
{
    return _effectType;
}

#pragma mark ---Pitch---
-(void)initPitch
{
    _effectType = AudioEffectType_PITCH;
     int sampleRate = self.sampleRate;
     int channels = self.channels;
     sonicInst = (sonicInstStruct *)calloc(1, sizeof(struct sonicInstStruct));
     sonicInst->stream = sonicCreateStream(sampleRate, channels);
     if(sonicInst->stream == NULL)
     {
         return ;
     }
     sonicSetPitch(sonicInst->stream, self.pitch);
     sonicSetRate(sonicInst->stream, 1.0f);
     sonicSetSpeed(sonicInst->stream, 1.f);
     sonicSetChordPitch(sonicInst->stream, 0);
     sonicSetQuality(sonicInst->stream, 0);
     sonicInst->byteBufSize = 200;
     sonicInst->byteBuf = (short *)calloc(sonicInst->byteBufSize, sizeof(short));
     if(sonicInst->byteBuf == NULL)
     {
         return ;
     }
}

-(void)setPitch:(float)pitch
{
    if (pitch < 0.5f && pitch > 2.f)
    {
        return;
    }
    _pitch = pitch;
    sonicSetPitch(sonicInst->stream,_pitch);
}

-(void)pushPitchData:(uint8_t*)data length:(int)dataLen finished:(void(^)(uint8_t* outData, int outLen))finished
{
    int samples = dataLen/(sizeof(short)*sonicGetNumChannels(sonicInst->stream));
       int remainingBytes = dataLen - samples * sizeof(short) * sonicGetNumChannels(sonicInst->stream);
       if(remainingBytes != 0)
       {
           printf("something have TODO: Remaining bytes == %d!!!", remainingBytes);
       }
       if(dataLen > sonicInst->byteBufSize*sizeof(short))
       {
           sonicInst->byteBufSize = dataLen*(2/sizeof(short));
           sonicInst->byteBuf = (short *)realloc(sonicInst->byteBuf, sonicInst->byteBufSize*sizeof(short));
           if(sonicInst->byteBuf == NULL)
           {
               return;
           }
       }
       sonicWriteShortToStream(sonicInst->stream, (short *)data, samples);
       int available = sonicSamplesAvailable(sonicInst->stream)*sizeof(short)*sonicGetNumChannels(sonicInst->stream);
       int samplesRead, bytesRead;
       if(dataLen > available)
       {
           dataLen = available;
       }
       if(dataLen > sonicInst->byteBufSize*sizeof(short))
       {
           sonicInst->byteBufSize = dataLen*(2/sizeof(short));
           sonicInst->byteBuf = (short *)realloc(sonicInst->byteBuf, sonicInst->byteBufSize*sizeof(short));
           if(sonicInst->byteBuf == NULL)
           {
               return ;
           }
       }
       samplesRead = sonicReadShortFromStream(sonicInst->stream, sonicInst->byteBuf,
                                              dataLen/(sizeof(short)*sonicGetNumChannels(sonicInst->stream)));
       bytesRead = samplesRead * sizeof(short) * sonicGetNumChannels(sonicInst->stream);
       if (bytesRead > 0)
       {
           finished((uint8_t *)(sonicInst->byteBuf), bytesRead);
       }
}

#pragma mark ---Reverb---
-(NSDictionary*)getAdvanceReverbParms
{
    NSDictionary* defaultDic = @{
        @"oversamplefactor":@(3),
        @"ertolate":@(0.5),
        @"erefwet":@(-20.f),
        @"dry":@(-20),
        @"ereffactor":@(1.f),
        @"erefwidth":@(0.f),
        @"width":@(0.5f),
        @"wet":@(-20.f),
        @"wander":@(0.3f),
        @"bassb":@(0.3f),
        @"spin":@(5.f),
        @"inputlpf":@(10000.f),
        @"basslpf":@(500.f),
        @"damplpf":@(10000.f),
        @"outputlpf":@(10000.f),
        @"rt60":@(10.f),
        @"delay":@(0.f)
    };
    return (NSMutableDictionary*)defaultDic;
}

-(void)initReverb:(ReverbType) reverbType
{
    _effectType = AudioEffectType_REVERB;
    sf_reverb_preset p;
    switch (reverbType)
    {
        case ReverbType_DEFAULT:
        {
            self.isReverbAdvance = NO;
            p =  SF_REVERB_PRESET_DEFAULT;
            break;
        }
        case ReverbType_SMALLHALL1:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_SMALLHALL1;
            break;
        }
        case ReverbType_SMALLHALL2:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_SMALLHALL2;
            break;
        }
        case ReverbType_MEDIUMHALL1:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_MEDIUMHALL1;
            break;
        }
        case ReverbType_MEDIUMHALL2:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_MEDIUMHALL2;
            break;
        }
        case ReverbType_LARGEHALL1:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_LARGEHALL1;
            break;
        }
        case ReverbType_LARGEHALL2:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_LARGEHALL2;
            break;
        }
        case ReverbType_SMALLROOM1:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_SMALLROOM1;
            break;
        }
        case ReverbType_SMALLROOM2:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_SMALLROOM2;
            break;
        }
        case ReverbType_MEDIUMROOM1:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_MEDIUMROOM1;
            break;
        }
        case ReverbType_MEDIUMROOM2:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_MEDIUMROOM2;
            break;
        }
        case ReverbType_LARGEROOM1:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_LARGEROOM1;
            break;
        }
        case ReverbType_LARGEROOM2:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_LARGEROOM2;
            break;
        }
        case ReverbType_MEDIUMER1:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_MEDIUMER1;
            break;
        }
        case ReverbType_MEDIUMER2:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_MEDIUMER2;
            break;
        }
        case ReverbType_PLATEHIGH:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_PLATEHIGH;
            break;
        }
        case ReverbType_PLATELOW:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_PLATELOW;
            break;
        }
        case ReverbType_LONGREVERB1:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_LONGREVERB1;
            break;
        }
        case ReverbType_LONGREVERB2:
        {
            self.isReverbAdvance = NO;
            p = SF_REVERB_PRESET_LONGREVERB2;
            break;
        }
        case ReverbType_ADVANCE:
        {
            self.isReverbAdvance = YES;
            break;
        }
        default:
            break;
      }
    if (!self.isReverbAdvance)
    {
        sf_presetreverb(&rv_state, self.sampleRate, p);
        
    }else
    {
        if (self.advanceReverbParms)
        {
            int oversamplefactor = [[_advanceReverbParms objectForKey:@"oversamplefactor"] intValue];
            if (oversamplefactor < 1 || oversamplefactor > 4)
            {
                return;
            }
            float ertolate = [[_advanceReverbParms objectForKey:@"ertolate"] floatValue];
            float erefwet = [[_advanceReverbParms objectForKey:@"erefwet"] floatValue];
            float dry = [[_advanceReverbParms objectForKey:@"dry"] floatValue];
            float ereffactor = [[_advanceReverbParms objectForKey:@"ereffactor"] floatValue];
            float erefwidth = [[_advanceReverbParms objectForKey:@"erefwidth"] floatValue];
               float width = [[_advanceReverbParms objectForKey:@"width"] floatValue];
             float wet = [[_advanceReverbParms objectForKey:@"wet"] floatValue];
            float wander = [[_advanceReverbParms objectForKey:@"wander"] floatValue];
             float bassb = [[_advanceReverbParms objectForKey:@"bassb"] floatValue];
            float spin = [[_advanceReverbParms objectForKey:@"spin"] floatValue];
            float inputlpf = [[_advanceReverbParms objectForKey:@"inputlpf"] floatValue];
            float basslpf = [[_advanceReverbParms objectForKey:@"basslpf"] floatValue];
            float damplpf = [[_advanceReverbParms objectForKey:@"damplpf"] floatValue];
             float outputlpf = [[_advanceReverbParms objectForKey:@"outputlpf"] floatValue];
            float rt60 = [[_advanceReverbParms objectForKey:@"rt60"] floatValue];
            float delay = [[_advanceReverbParms objectForKey:@"delay"] floatValue];
            clampfReturn(0.f, 1.f, ertolate);
            clampfReturn(-70.f, 10.f, erefwet);
            clampfReturn(-70.f, 10.f, dry);
            clampfReturn(0.5f, 2.5f, ereffactor);
            clampfReturn(-1.f, 1.f, erefwidth);
            clampfReturn(0.f, 1.f, width);
            clampfReturn(-70.f, 10.f, wet);
            clampfReturn(0.1f, 0.6f, wander);
            clampfReturn(0.f, 0.5f, bassb);
            clampfReturn(0.f, 10.f, spin);
            clampfReturn(200.f, 18000.f, inputlpf);
            clampfReturn(50.f, 1050.f, basslpf);
            clampfReturn(200.f, 18000.f, damplpf);
            clampfReturn(200.f, 18000.f, outputlpf);
            clampfReturn(0.1f, 30.f, rt60);
            clampfReturn(-0.5f, 0.5f, delay);
            sf_advancereverb(&rv_state, self.sampleRate, oversamplefactor, ertolate, erefwet, dry, ereffactor, erefwidth, width, wet, wander, bassb, spin, inputlpf, basslpf, damplpf, outputlpf, rt60, delay);
        }
    }
      
}

-(void)pushRevervData:(uint8_t*)data length:(int)dataLen finished:(void(^)(uint8_t* outData, int outLen))finished
{
    int channels = self.channels;
    int sampleRate = self.sampleRate;
    int numChannels = channels;
    int numSamples = dataLen / 2;
    int tail = 0.1;
    sf_snd snd = sf_snd_new(numSamples, sampleRate, false);
    int j = 0;
    int16_t L, R;
    for (int i = 0; i < numSamples; i++,j += 2)
    {
        uint16_t  b1 = data[j];
        uint16_t  b2 = data[j + 1];
        L = (b1) | (b2 << 8);
        if (numChannels == 1)
        {
            R = L; // expand to stereo
            
        }else
        {
            j += 2;
            uint16_t  b1 = data[j];
            uint16_t  b2 = data[j + 1];
            R =  (b1) | (b2 << 8);
        }
        
        if (L < 0)
        {
            snd->samples[i].L = (float)L / 32768.0f;
        }
        else
        {
            snd->samples[i].L = (float)L / 32767.0f;
        }
        
        if (R < 0)
        {
            snd->samples[i].R = (float)R / 32768.0f;
            
        }else
        {
            snd->samples[i].R = (float)R / 32767.0f;
        }
    }
    int tailsmp = tail * snd->rate;
    sf_snd output_snd = sf_snd_new(snd->size + tailsmp, snd->rate, true);
    if (output_snd == NULL)
    {
        sf_snd_free(snd);
        fprintf(stderr, "Error: Failed to apply filter\n");
    }
    sf_reverb_process(&rv_state, snd->size, snd->samples, output_snd->samples);
    if (tailsmp > 0)
    {
        int pos = snd->size;
        sf_sample_st empty[48000];
        memset(empty, 0, sizeof(sf_sample_st) * 48000);
        while (tailsmp > 0)
        {
            if (tailsmp <= 48000)
            {
                sf_reverb_process(&rv_state, tailsmp, empty, &output_snd->samples[pos]);
                break;
            }
            else
            {
                sf_reverb_process(&rv_state, 48000, empty, &output_snd->samples[pos]);
                tailsmp -= 48000;
                pos += 48000;
            }
        }
    }
    uint8_t *outData = malloc(snd->size * 2 * numChannels);
    memset(outData, 0, snd->size * 2 * numChannels);
    for (int i = 0; i < snd->size; i++)
    {
        float L = clampf(output_snd->samples[i].L, -1, 1);
        float R = clampf(output_snd->samples[i].R, -1, 1);
        int16_t Lv, Rv;
        if (L < 0)
        {
            Lv = (int16_t)(L * 32768.0f);
            
        }else
        {
            Lv = (int16_t)(L * 32767.0f);
        }
        
        if (R < 0)
        {
            Rv = (int16_t)(R * 32768.0f);
        }else
        {
            Rv = (int16_t)(R * 32767.0f);
        }
        
        
        outData[i*2*numChannels] = Lv & 0xFF;
        outData[i*2*numChannels + 1] = (Lv >> 8) & 0xFF;
        
        if (numChannels == 2) //双声道数据
        {
            outData[i*2*numChannels + 2] = Rv & 0xFF;
            outData[i*2*numChannels + 3] = (Rv >> 8) & 0xFF;
        }
    }
    sf_snd_free(snd);
    sf_snd_free(output_snd);
    finished((uint8_t *)(outData), dataLen * numChannels);
}
#pragma mark ---Biquad---

-(NSDictionary*)getDefaultBiquadParams
{
    NSDictionary* defaultDic = @{
        @"freq":@(800.f),
        @"Q":@(0.f),
        @"gain":@(0.f)
    };
    return defaultDic;
}
-(void)initBiquad:(BiquadType) biquadType
{
    _effectType = AudioEffectType_BIQUAD;
    int inputSampleRate = self.sampleRate;
    float freq = [[self.biquadParams objectForKey:@"freq"] floatValue];
    float Q    = [[self.biquadParams objectForKey:@"Q"] floatValue];
    float gain = [[self.biquadParams objectForKey:@"gain"] floatValue];
    clampfReturn(200.f, 3000.f, freq);
    clampfReturn(0.f, 1.f, Q);
    clampfReturn(-5.f, 10, gain);
    
    switch (biquadType)
       {
           case BiquadType_LOWPASS:
           {
               sf_lowpass(&bq_state, inputSampleRate, freq, Q);
               break;
           }
           case BiquadType_HIGHPASS:
           {
               sf_highpass(&bq_state, inputSampleRate, freq, Q);
               break;
           }
           case BiquadType_BANDPASS:
           {
               sf_bandpass(&bq_state, inputSampleRate, freq, Q);
               break;
           }
           case BiquadType_NOTCH:
           {
               sf_notch(&bq_state, inputSampleRate,  freq, Q);
               break;
           }
           case BiquadType_PEAKING:
           {
               sf_peaking(&bq_state, inputSampleRate, freq, Q, gain);
               break;
           }
           case BiquadType_ALLPASS:
           {
               sf_allpass(&bq_state, inputSampleRate, freq, Q);
               break;
           }
               
           case BiquadType_LOWSHELF:
           {
               sf_lowshelf(&bq_state, inputSampleRate, freq, Q , gain);
               break;
           }
           case BiquadType_HIGHSHELF:
           {
               sf_highshelf(&bq_state, inputSampleRate, freq, Q , gain);
               break;
           }
           default:
               break;
       }
}
-(void)pushBiquadData:(uint8_t*)data length:(int)dataLen finished:(void(^)(uint8_t* outData, int outLen))finished
{
    int numChannels = self.channels;
    int sampleRate = self.sampleRate;
    int numSamples = dataLen / 2;
    sf_snd snd = sf_snd_new(numSamples, sampleRate, false);
    int j = 0;
    int16_t L, R;
    for (int i = 0; i < numSamples; i++,j += 2)
    {
        uint16_t  b1 = data[j];
        uint16_t  b2 = data[j + 1];
        L = (b1) | (b2 << 8);
        if (numChannels == 1)
        {
            R = L; // expand to stereo
            
        }else
        {
            j += 2;
            uint16_t  b1 = data[j];
            uint16_t  b2 = data[j + 1];
            R =  (b1) | (b2 << 8);
        }
        
        if (L < 0)
        {
            snd->samples[i].L = (float)L / 32768.0f;
        }
        else
        {
            snd->samples[i].L = (float)L / 32767.0f;
        }
        
        if (R < 0)
        {
            snd->samples[i].R = (float)R / 32768.0f;
            
        }else
        {
            snd->samples[i].R = (float)R / 32767.0f;
        }
    }
    sf_snd output_snd = sf_snd_new(snd->size, snd->rate, false);
    sf_biquad_process(&bq_state, snd->size, snd->samples, output_snd->samples);
    uint8_t *outData = malloc(snd->size * 2 * numChannels);
    memset(outData, 0, snd->size * 2 * numChannels);
    
    for (int i = 0; i < snd->size; i++)
    {
        float L = clampf(output_snd->samples[i].L, -1, 1);
        float R = clampf(output_snd->samples[i].R, -1, 1);
        int16_t Lv, Rv;
        if (L < 0)
        {
            Lv = (int16_t)(L * 32768.0f);
            
        }else
        {
            Lv = (int16_t)(L * 32767.0f);
        }
        
        if (R < 0)
        {
            Rv = (int16_t)(R * 32768.0f);
        }else
        {
            Rv = (int16_t)(R * 32767.0f);
        }
        outData[i*2*numChannels] = Lv & 0xFF;
        outData[i*2*numChannels + 1] = (Lv >> 8) & 0xFF;
        if (numChannels == 2)
        {
            outData[i*2*numChannels + 2] = Rv & 0xFF;
            outData[i*2*numChannels + 3] = (Rv >> 8) & 0xFF;
        }
    }
    sf_snd_free(snd);
    sf_snd_free(output_snd);
    finished((uint8_t *)(outData), numSamples * 2 * numChannels);
}

#pragma mark ---Vibrato---
-(void)initVibrato
{
    _effectType = AudioEffectType_VIBRATO;
    
    self.berVibrato = [[BerVibrato alloc] init];
    [self.berVibrato initialize:self.sampleRate];
    [self.berVibrato setDepth:0.3];
    [self.berVibrato setFrequency:10];
}
-(void)pushVibratoData:(uint8_t*)data length:(int)dataLen finished:(void(^)(uint8_t* outData, int outLen))finished
{
    int numChannels = self.channels;
    int numSamples = dataLen / 2;
    float* samples = malloc(sizeof(float) * numSamples);
    int16_t L;
    for(int i = 0,j = 0; i < numSamples; i++, j += 2)
    {
        uint16_t  b1 = data[j];
        uint16_t  b2 = data[j + 1];
        L = (b1) | (b2 << 8);
        
        float Lf = 0.f;
        if (L < 0)
        {
            Lf = (float)L / 32768.0f;
        }
        else
        {
            Lf = (float)L / 32767.0f;
        }
        samples[i] = [_berVibrato processOneSample:Lf];
    }
    uint8_t* outData = malloc(sizeof(uint8_t) * 2 * numSamples);
    memset(outData, 0, sizeof(uint8_t) * 2 * numSamples);
    for (int i = 0; i < numSamples; i++)
    {
        int16_t Lv;
        
        float L = clampf(samples[i], -1, 1);
        if (L < 0)
        {
            Lv = (int16_t)(L * 32768.0f);
            
        }else
        {
            Lv = (int16_t)(L * 32767.0f);
        }
        
        outData[i*2*numChannels] = Lv & 0xFF;
        outData[i*2*numChannels + 1] = (Lv >> 8) & 0xFF;
        
    }
    free(samples);
    finished((uint8_t *)(outData), dataLen);
}

@end
