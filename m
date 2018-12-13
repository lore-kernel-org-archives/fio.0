Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f52.google.com ([209.85.222.52]:41684 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbeLMGdt (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Dec 2018 01:33:49 -0500
Received: by mail-ua1-f52.google.com with SMTP id z24so325428ual.8
        for <fio@vger.kernel.org>; Wed, 12 Dec 2018 22:33:48 -0800 (PST)
MIME-Version: 1.0
References: <DM5PR19MB1402B69B8FE2C5019A8926D1DBA70@DM5PR19MB1402.namprd19.prod.outlook.com>
In-Reply-To: <DM5PR19MB1402B69B8FE2C5019A8926D1DBA70@DM5PR19MB1402.namprd19.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 13 Dec 2018 06:33:21 +0000
Message-ID: <CALjAwxgbUo+ij_=XHDt7ymO0fmk1FTQrMiOK5W6gbDKUoGVH9Q@mail.gmail.com>
Subject: Re: Testing --blocksize_range
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: mohan@ertino.com
Cc: fio <fio@vger.kernel.org>

Hi,

On Wed, 12 Dec 2018 at 13:43, Mohan Mohan <mohan@ertino.com> wrote:
>
> I am testing fio with bs ranges 1k-10k 2k-10k 3k-10k 4k-10k 5k-10k 6k-10k.
>
> The test works fine for the below run:
> fio --name=App2 --size=10m --rw=read --blocksize_range=1k-10k
> # fio --name=App2 --size=10m --rw=read --blocksize_range=2k-10k
> # fio --name=App2 --size=10m --rw=read --blocksize_range=5k-10k
>
> But error throws on below runs
> # fio --name=App2 --size=10m --rw=read --blocksize_range=3k-10k
> # fio --name=App2 --size=10m --rw=read --blocksize_range=4k-10k
> # fio --name=App2 --size=10m --rw=read --blocksize_range=6k-10k
>
> App2: (g=0): rw=read, bs=(R) 3072B-10.0KiB, (W) 3072B-10.0KiB, (T) 3072B-10.0KiB, ioengine=psync, iodepth=1
> fio-3.12-17-g0fcbc0
> Starting 1 process
> *** Error in `fio': double free or corruption (!prev): 0x0000555f92a80a60 ***
> fio: pid=1468, got signal=6

[snip]

> I believe the expected test has run properly but why the error has thrown for the particular ranges.

This is a real bug and it's occurring because the end of the range is
not a multiple of the start of the range (10k is a multiple of 1k but
10k is not a multiple of 3k). I've reproduced it here:

$ rm fio.tmp; ./fio --name=App2 --size=128k --rw=read
--blocksize_range=3k-10k --filename=fio.tmp
App2: (g=0): rw=read, bs=(R) 3072B-10.0KiB, (W) 3072B-10.0KiB, (T)
3072B-10.0KiB, ioengine=psync, iodepth=1
fio-3.12-20-g4cf3
Starting 1 process
App2: Laying out IO file (1 file / 0MiB)
=================================================================
==2593==ERROR: AddressSanitizer: heap-buffer-overflow on address
0x626000005900 at pc 0x7f7053ff346e bp 0x7ffc0e6a1bb0 sp
0x7ffc0e6a1358
WRITE of size 12288 at 0x626000005900 thread T0
    #0 0x7f7053ff346d  (/usr/lib/x86_64-linux-gnu/libasan.so.4+0x4e46d)
    #1 0x55c316d440d5 in fio_psyncio_queue engines/sync.c:182
    #2 0x55c316cab788 in td_io_queue /home/user/git/fio/ioengines.c:331
    #3 0x55c316d9334e in io_u_submit /home/user/git/fio/backend.c:613
    #4 0x55c316d961ab in do_io /home/user/git/fio/backend.c:1063
    #5 0x55c316d9e871 in thread_main /home/user/git/fio/backend.c:1785
    #6 0x55c316da255f in run_threads /home/user/git/fio/backend.c:2362
    #7 0x55c316da338f in fio_backend /home/user/git/fio/backend.c:2498
    #8 0x55c316e1e60d in main /home/user/git/fio/fio.c:60
    #9 0x7f7052be2b96 in __libc_start_main
(/lib/x86_64-linux-gnu/libc.so.6+0x21b96)
    #10 0x55c316c7f2f9 in _start (/home/user/git/fio/fio+0x632f9)

0x626000005900 is located 0 bytes to the right of 10240-byte region
[0x626000003100,0x626000005900)
allocated by thread T0 here:
    #0 0x7f7054083b50 in __interceptor_malloc
(/usr/lib/x86_64-linux-gnu/libasan.so.4+0xdeb50)
    #1 0x55c316d118b5 in alloc_mem_malloc /home/user/git/fio/memory.c:200
    #2 0x55c316d11e90 in allocate_io_mem /home/user/git/fio/memory.c:318
    #3 0x55c316d9828d in init_io_u_buffers /home/user/git/fio/backend.c:1311
    #4 0x55c316d97e66 in init_io_u /home/user/git/fio/backend.c:1264
    #5 0x55c316d9d701 in thread_main /home/user/git/fio/backend.c:1704
    #6 0x55c316da255f in run_threads /home/user/git/fio/backend.c:2362
    #7 0x55c316da338f in fio_backend /home/user/git/fio/backend.c:2498
    #8 0x55c316e1e60d in main /home/user/git/fio/fio.c:60
    #9 0x7f7052be2b96 in __libc_start_main
(/lib/x86_64-linux-gnu/libc.so.6+0x21b96)

SUMMARY: AddressSanitizer: heap-buffer-overflow
(/usr/lib/x86_64-linux-gnu/libasan.so.4+0x4e46d)
Shadow bytes around the buggy address:
  0x0c4c7fff8ad0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c4c7fff8ae0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c4c7fff8af0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c4c7fff8b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c4c7fff8b10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x0c4c7fff8b20:[fa]fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c4c7fff8b30: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c4c7fff8b40: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c4c7fff8b50: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c4c7fff8b60: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c4c7fff8b70: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
==2593==ABORTING

Perhaps it would make sense to file this one over on Github so it
doesn't get lost but regardless, thank you for the very clear
reproduction steps!

-- 
Sitsofe | http://sucs.org/~sits/

