Return-Path: <axboe@kernel.dk>
Message-ID: <548EFB15.8080704@kernel.dk>
Date: Mon, 15 Dec 2014 08:15:33 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: SSD write latency lower than read latency
References: <2028599731.63796.1418644100540.JavaMail.zimbra@thomas-krenn.com>
In-Reply-To: <2028599731.63796.1418644100540.JavaMail.zimbra@thomas-krenn.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/15/2014 04:48 AM, Georg Schönberger wrote:
> Hi Fio users and Jens,
>
> I am currently analyzing read and write latencies of Solid State Disks (SSDs). My assumption was that
> write latencies are usually higher than read latencies. But my tests with Fio on an Intel DCS3500 show
> that average latency while writing is lower than while reading (using fio-2.1.3):
>
> * $ sudo /usr/bin/fio --rw=randrw --name=intelDCS3500 --bs=4k --direct=1 --filename=/dev/sda --rwmixread=0
>      --numjobs=1 --ioengine=libaio --runtime=60 --iodepth=1 --time_based
>      [...]
>      lat (usec): min=30, max=1010, avg=43.32, stdev= 3.42
>      [...]
> * $ sudo /usr/bin/fio --rw=randrw --name=intelDCS3500 --bs=4k --direct=1 --filename=/dev/sda --rwmixread=100
>      --numjobs=1 --ioengine=libaio --runtime=60 --iodepth=1 --time_based
>      [...]
>      lat (usec): min=103, max=2315, avg=121.92, stdev=11.02
>
> I have made this observation on two different machines with different SSDs, always producing similar results.
> Am I doing anything wrong with my tests?
> Are write latencies in general lower than read latencies?
>
> One guess I have is a SSD cache to enhance write access (in particular the Intel datacenter SSDs, as they have
> a "Enhanced power-loss data protection" feature).

Your guess is exactly right, that's what most flash based devices (worth 
their salt) do. That's also why sync write latencies are mostly 
independent of the type of nand used, whereas the read latency will 
easily reflect that.

-- 
Jens Axboe


