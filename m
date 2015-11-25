Return-Path: <axboe@kernel.dk>
Subject: Re: Bug with --buffer_compress_percentage
References: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
 <56533A11.4050706@kernel.dk> <56533BE5.3010606@kernel.dk>
 <CAF+0mv=KWZ-_VGEFLhDzh70E2ztr7esdjOpQR-wdLJ-eQ-mRng@mail.gmail.com>
 <5653D5EA.1060201@kernel.dk>
 <CAF+0mvnKfMNX-Pb1mYrQYubDqJJj84C0NQKVzMAGOoR84Qt8zg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5655F003.1000208@kernel.dk>
Date: Wed, 25 Nov 2015 10:29:39 -0700
MIME-Version: 1.0
In-Reply-To: <CAF+0mvnKfMNX-Pb1mYrQYubDqJJj84C0NQKVzMAGOoR84Qt8zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/25/2015 10:16 AM, Matthew Eaton wrote:
>> Perfect, thanks for reporting and followup testing.
>>
>> --
>> Jens Axboe
>
> Unfortunately I am having an issue with buffer_compress_chunk in the
> 2.2.12 release.  Removing buffer_compress_chunk from the tests below
> fixes the issues.
>
> fio --name=test --rw=write --bs=4k --ioengine=libaio --direct=1
> --iodepth=32 --size=1g --refill_buffers
> --buffer_compress_percentage=50 --buffer_compress_chunk=32k
> --filename=testfile
> test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> fio-2.2.12
> Starting 1 process
> fio: pid=24516, got signal=11
>
>
> Run status group 0 (all jobs):
>
> Disk stats (read/write):
>    sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
> fio: file hash not empty on exit
>
>
> fio --name=test --rw=write --bs=128k --ioengine=libaio --direct=1
> --iodepth=32 --size=1g --refill_buffers
> --buffer_compress_percentage=50 --buffer_compress_chunk=32k
> --filename=testfile
> test: (g=0): rw=write, bs=128K-128K/128K-128K/128K-128K,
> ioengine=libaio, iodepth=32
> fio-2.2.12
> Starting 1 process
> Segmentation fault (core dumped)

That's odd, I can't reproduce that. Could this just be a bad build? Fio 
sometimes fails to rebuild correctly between version. Does it persist 
across a make clean && make?


-- 
Jens Axboe


