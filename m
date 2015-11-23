Return-Path: <axboe@kernel.dk>
Subject: Re: Bug with --buffer_compress_percentage
References: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56533A11.4050706@kernel.dk>
Date: Mon, 23 Nov 2015 09:08:49 -0700
MIME-Version: 1.0
In-Reply-To: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/20/2015 10:29 AM, Matthew Eaton wrote:
> I noticed that sometimes using --buffer_compress_percentage would not
> result in the desired compression.  After running some tests I found
> that only some block sizes are affected.
>
> 512b, 4K, 8K, 16K, and 32K seem to work as expected.
>
> 64K, 128K, 256K, 512K, and 1024K exhibited the bug.  I have not tested
> beyond 1024K.
>
> Here is the test script I used only changing block size for each test.
>
> for i in {0..100}; do
>    fio --name=test --rw=write --bs=128k --ioengine=libaio --direct=1
> --iodepth=32 --size=512m --refill_buffers
> --buffer_compress_percentage=$i --filename=testfile.$i --eta=never
> --output=/dev/null
> done
>
> for i in {0..100}; do
>    gzip -v testfile.$i &>> gzip.txt
> done
>
> rm *.gz
>
> Below are compression results for 4K and then 128K.  For 128K, you can
> see compression stops matching at around 50%.

I think this is an artifact of how gzip compression works, it doesn't 
have an unlimited size window. It's 32k, iirc. Fio should fill so that 
it ideally would compress to the given size with an ideal compression 
algorithm.

You'd probably want to use buffer_compress_chunk=x to always force fio 
to operate in sizes of that for compression, if you want to ensure that 
gzip would be able to compress to the specified ratio. I do think we 
have a loop missing though for that to do what you need, let me test 
that and report back.

-- 
Jens Axboe


