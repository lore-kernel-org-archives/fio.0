Return-Path: <axboe@kernel.dk>
Subject: Re: Can't setup io_uring for buffered IO
References: <YRpT0019mbS1jSE4@T590> <YRp7Nx30QAXORcsN@T590>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <15ab7b20-0228-3770-b186-657d8a5236b2@kernel.dk>
Date: Tue, 17 Aug 2021 12:28:12 -0600
MIME-Version: 1.0
In-Reply-To: <YRp7Nx30QAXORcsN@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/16/21 8:50 AM, Ming Lei wrote:
> On Mon, Aug 16, 2021 at 08:02:27PM +0800, Ming Lei wrote:
>> Hello Guys,
>>
>> I tried to use the following script to run buffered io with io_uring,
>> but looks it always complains with 'Operation not supported', and any
>> idea to make it working?
>>
>> ++ /root/git/fio/fio --readonly --name=onessd --filename=/dev/nvme0n1 --filesize=16m --rw=randread --bs=4k --direct=0 --overwrite=0 --numjobs=1 --iodepth=1 --time_based=1 --runtime=1 --ioengine=io_uring --registerfiles --fixedbufs --hipri=1 --gtod_reduce=1 --group_reporting
>> onessd: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=1
>> fio-3.25-229-gdf9e8
>> Starting 1 process
>> fio: io_u error on file /dev/nvme0n1: Operation not supported: read offset=1011712, buflen=4096
>> fio: pid=3278, err=95/file:io_u.c:1841, func=io_u error, error=Operation not supported
>>
>> onessd: (groupid=0, jobs=1): err=95 (file:io_u.c:1841, func=io_u error, error=Operation not supported): pid=3278: Mon Aug 16 12:01:17 2021
> 
> Just figured out that --hipri can't be applied for buffered IO.

Yes, and we may want to catch that in fio setup. But hipri (polled IO) is only
available with O_DIRECT.

-- 
Jens Axboe


