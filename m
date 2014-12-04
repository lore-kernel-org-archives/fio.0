Return-Path: <axboe@kernel.dk>
Message-ID: <54807D4F.9080207@kernel.dk>
Date: Thu, 04 Dec 2014 08:27:11 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Repeat given pattern with buffer_compress_percentage
References: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com> <547FCA1C.1000808@kernel.dk> <547FCBC7.20309@kernel.dk> <547FCDC0.3000005@kernel.dk> <CAGmU4NSC=7ZjjnieWxjFs8xqrVjY0gdMGWwJCTRogXKpUzBbcA@mail.gmail.com>
In-Reply-To: <CAGmU4NSC=7ZjjnieWxjFs8xqrVjY0gdMGWwJCTRogXKpUzBbcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Karthick Srinivasachary <karthick@pernixdata.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/04/2014 12:53 AM, Karthick Srinivasachary wrote:
> Hi Jens,
>
> Thanks for your response and quick fix.. Much appreciated.
> Tried few things and saw couple issues, summarizing below. Please let
> me know if I am missing something.
>
> 1. Looks like buffer_compress_percentage with verify option is not
> giving expected compression percentage
>
> fio --name=global --rw=write --buffer_compress_percentage=50
> --name=job1 --filename=/root/test1 --size=100m --refill_buffers
> --verify=md5
>
> lz4 could compress fio data file
>
> lz4 /root/test1
> Compressed 104857600 bytes into 104857715 bytes ==> 100.00%

The verify buffers are filled differently. It will take a bit more code 
juggling to make that honor the buffer_pattern as a fill pattern. I'll 
take a look at it.

> 2. buffer_compress_percentage with buffer_pattern + refill_buffers is
> not giving expected compression percentage (Data is highly
> compressible).
>
> fio --name=global --rw=write --buffer_compress_percentage=50
> --name=job1 --filename=/root/test1 --size=100m --refill_buffers
> --buffer_pattern=111
>
> root@ubuntu-base:~/fio-master# lz4 /root/test1
> Compressed filename will be : /root/test1.lz4
> Compressed 104857600 bytes into 463065 bytes ==> 0.44%

That's a bug in how we clear refill_buffers when we set a buffer 
pattern, that's not correct anymore with the combination of buffer 
compression and pattern. Fixed and pushed.

-- 
Jens Axboe


