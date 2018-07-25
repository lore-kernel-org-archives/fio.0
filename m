Return-Path: <axboe@kernel.dk>
Subject: Re: Understanding fio results on a new ZFS server
References: <1532522139.3603237.1452331920.220D1ABD@webmail.messagingengine.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <84eefa1e-71a9-fd85-aba4-c82786210a85@kernel.dk>
Date: Wed, 25 Jul 2018 12:03:47 -0700
MIME-Version: 1.0
In-Reply-To: <1532522139.3603237.1452331920.220D1ABD@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Aravindh Sampathkumar <aravindh@fastmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 7/25/18 5:35 AM, Aravindh Sampathkumar wrote:
> Hello fio users.
> 
> This is my first attempt at using fio, and I'm puzzled by the results I obtained while running fio on a ZFS server I built recently. I'm running these commands mostly out of curiosity, and just to understand what the server is capable of in a ballpark range.
> 
> Here goes my naive attempts and results. 
> 
> Context: FreeBSD 11.2, ZFS, Compression enabled, Deduplication disabled, 120 X 10TB SAS HDD disks, no SSD caching, 768GB of DDR4 memory, 2X intel Xeon silver 4110 processors.
> All commands were run directly on the FreeBSD server.
> Running fio-3.8
> 
> *_Test # 1:_*
> Use dd to create a 16 GiB file with random contents.
> 
> root@delorean:/sec_stor/backup/fiotest # time dd if=/dev/random of=./test_file bs=128k count=131072
> 131072+0 records in
> 131072+0 records out
> 17179869184 bytes transferred in 137.402721 secs (125032962 bytes/sec)
> 0.031u 136.915s 2:17.40 99.6% 30+172k 4+131072io 0pf+0w
> 
> This shows that I was able to create a 16GiB file with random data in 137 secs with a throughput of approx. *117 MiB/s.*

Please send an email per issue you think you see, this is unwieldy. For
this test case, you are measuring writes into the cache. It'll be wildly
timing dependent. You want end_fsync=1 for fio, and you want the dd
timing to include a sync at the end.


-- 
Jens Axboe


