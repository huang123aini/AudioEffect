//
//  snd.h
//  ReEncoder
//
//  Created by huangshiping on 2019/11/1.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#ifndef snd_h
#define snd_h

#include <stdbool.h>
#include <stddef.h>

typedef struct
{
    float L; // left channel sample
    float R; // right channel sample
} sf_sample_st;

typedef struct
{
    sf_sample_st *samples;
    int size; // number of samples
    int rate; // samples per second
} sf_snd_st, *sf_snd;

sf_snd sf_snd_new(int size, int rate, bool clear);
void   sf_snd_free(sf_snd snd);

//mem
typedef void *(*sf_malloc_func)(size_t size);
typedef void (*sf_free_func)(void *ptr);

extern sf_malloc_func sf_malloc;
extern sf_free_func sf_free;

#endif /* snd_h */
