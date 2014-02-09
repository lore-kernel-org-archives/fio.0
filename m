Return-Path: <axboe@kernel.dk>
Message-ID: <52F7E9D9.4040208@kernel.dk>
Date: Sun, 09 Feb 2014 13:49:29 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Mutex destruction, invalid memory accesses, leaks
References: <20140206192135.GB3950@kernel.dk> <20140207034439.GA17588@sucs.org> <52F505A8.30004@kernel.dk> <20140209195042.GA17058@sucs.org>
In-Reply-To: <20140209195042.GA17058@sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-02-09 12:50, Sitsofe Wheeler wrote:
> On Fri, Feb 07, 2014 at 09:11:20AM -0700, Jens Axboe wrote:
>> On 2014-02-06 20:44, Sitsofe Wheeler wrote:
>>> On Thu, Feb 06, 2014 at 12:21:35PM -0700, Jens Axboe wrote:
>>>>
>>>> ./fio.exe --debug=all --filename=fiojob --thread --size=512 --rw=read --bs=512 --ioengine=sync --verify_pattern=0xdeadbeef --name=fiojobname
>>>>
>>>> The problem appears to be that the mutex is being destroyed while it
>>>> is still being held by a different thread. Adding return; to the first
>>>> line of fio_mutex_remove in mutex.c papers over the problem...
>>>
>> Does this still happen in current -git? The bug is a weird one - it
>> looks like it's crashing in bringing up the thread, but the
>> synchronization around that should ensure that it never gets to
>> touch td->mutex. If the mutexes are broken somehow and the thread
>> doesn't properly wait for the main thread to bring it up, then I can
>> see it happening. Hence my question whether it's still happening
>> after Bruce fixed the pthread linkage in current -git.
>
> Yes it's still happening with -git from a moment ago. What is stopping a
> sleeping thread from holding a mutex that is destroyed and then waking
> up on it after the memory has been unmapped?

If you look at the particular use case, it looks like this:

[io thread]		[main thread]
mutex_down(mutex);
			mutex_up(mutex);
mutex_kill(mutex);

and mutex isn't used after that kill. The trace you sent looks like the 
io thread doing down successfully (which it should not), then proceeding 
to killing the mutex. The main thread then runs into problems attempting 
to up a mute that has been freed. Hence why I think this is an issue in 
the windows pthread mutexes, that should not happen.

>>> Additionally Dr Memory is also flagging up an invalid memory access on
>>> the Windows version of fio (one is in a macro which makes a for loop but
>>> I only have a non-macro fix for it at the moment) and some memory leaks
>>> around string_to_cpu and init_io_u.
>>
>> I'm going to need more info on the invalid mem access. Not surprised
>> there are a few leaks around the init functions. Would be nice to
>> get fixed up, but not a ship-stopper.
>
> Here's the Dr Memory output:
> Error #1: UNADDRESSABLE ACCESS: reading 2 byte(s)
> # 0 __get_mult_bytes.constprop.5               [fio/parse.c:168]
> # 1 str_to_decimal                             [fio/parse.c:237]
> # 2 __handle_option                            [fio/parse.c:285]
> # 3 handle_option                              [fio/parse.c:861]
> # 4 fill_default_options                       [fio/parse.c:1174]
> # 5 main                                       [fio/fio.c:40]
> Note: refers to 0 byte(s) beyond last valid byte in prior malloc
>
> Error #2: LEAK 11 bytes
> # 0 replace_malloc                     [d:\drmemory_package\common\alloc_replace.c:2292]
> # 1 msvcrt.dll!_strdup
> # 2 __handle_option                    [fio/parse.c:615]
> # 3 handle_option                      [fio/parse.c:861]
> # 4 fill_default_options               [fio/parse.c:1174]
> # 5 main                               [fio/fio.c:40]
>
> Error #3: LEAK 26 bytes
> # 0 replace_malloc               [d:\drmemory_package\common\alloc_replace.c:2292]
> # 1 msvcrt.dll!_strdup
> # 2 fio_test_cconv               [fio/cconv.c:10]
> # 3 main                         [fio/fio.c:40]
>
> Error #4: LEAK 11 bytes
> # 0 replace_malloc               [d:\drmemory_package\common\alloc_replace.c:2292]
> # 1 msvcrt.dll!_strdup
> # 2 fio_test_cconv               [fio/cconv.c:10]
> # 3 main                         [fio/fio.c:40]
>
> Error #5: POSSIBLE LEAK 35 bytes
> # 0 replace_malloc                                     [d:\drmemory_package\common\alloc_replace.c:2292]
> # 1 emutls_alloc                                       [/usr/src/debug/mingw64-i686-gcc-4.8.2-2/libgcc/emutls.c:110]
> # 2 __fio_gettime                                      [fio/gettime.c:165]
> # 3 _fu0___set_invalid_parameter_handler               [/usr/src/debug/mingw64-i686-runtime-3.1.0-1/crt/crtexe.c:332]
> # 4 KERNEL32.dll!BaseThreadInitThunk
>
> Error #6: LEAK 136 bytes
> # 0 replace_calloc                       [d:\drmemory_package\common\alloc_replace.c:2310]
> # 1 __emutls_get_address                 [/usr/src/debug/mingw64-i686-gcc-4.8.2-2/libgcc/emutls.c:159]
> # 2 __fio_gettime                        [fio/gettime.c:165]
> # 3 pthread_create_wrapper               [/usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/thread.c:1381]
> # 4 msvcrt.dll!_endthreadex
> # 5 msvcrt.dll!_endthreadex
> # 6 KERNEL32.dll!BaseThreadInitThunk
>
> Error #7: POSSIBLE LEAK 35 bytes
> # 0 replace_malloc                       [d:\drmemory_package\common\alloc_replace.c:2292]
> # 1 emutls_alloc                         [/usr/src/debug/mingw64-i686-gcc-4.8.2-2/libgcc/emutls.c:110]
> # 2 __fio_gettime                        [fio/gettime.c:165]
> # 3 pthread_create_wrapper               [/usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/thread.c:1381]
> # 4 msvcrt.dll!_endthreadex
> # 5 msvcrt.dll!_endthreadex
> # 6 KERNEL32.dll!BaseThreadInitThunk

I'll take a look at these. How did you invoke fio for the above report?

-- 
Jens Axboe


