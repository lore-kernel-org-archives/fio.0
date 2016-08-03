Return-Path: <axboe@kernel.dk>
Subject: Re: create_on_open fails with "err=5/file:backend.c:498"
References: <CABtFm2X1th74qPOKaT+UG7rA-X8bjiADLE7x3n3qBjS7YAibNg@mail.gmail.com>
 <185b7fb1-e59a-c0e4-9a8a-ed5a21b441e8@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <93206ce7-e4ea-2188-7809-48ea44f1aafa@kernel.dk>
Date: Wed, 3 Aug 2016 08:54:44 -0700
MIME-Version: 1.0
In-Reply-To: <185b7fb1-e59a-c0e4-9a8a-ed5a21b441e8@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/03/2016 08:42 AM, Jens Axboe wrote:
> On 08/02/2016 07:29 AM, Srinivasa Chamarthy wrote:
>> Hi All,
>>
>> With the latest version of FIO, i see that create_on_open failing
>> always with error "err=5/file:backend.c:498"
>>
>> # fio --name=test --directory=/testdata --nrfiles=10 --size=1g
>> --refill_buffers=1 --direct=1 --create_on_open=1
>> test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
>> fio-2.13-28-g059b6
>> Starting 1 process
>> fio: pid=8439, err=5/file:backend.c:498, func=full resid,
>> error=Input/output error
>>
>> test: (groupid=0, jobs=1): err= 5 (file:backend.c:498, func=full
>> resid, error=Input/output error): pid=8439: Tue Aug  2 10:24:08 2016
>>   cpu          : usr=0.00%, sys=0.00%, ctx=1, majf=0, minf=57
>>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>> >=64=0.0%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >=64=0.0%
>>      complete  : 0=50.0%, 4=50.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >=64=0.0%
>>      issued    : total=r=1/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>>      latency   : target=0, window=0, percentile=100.00%, depth=1
>>
>> Run status group 0 (all jobs):
>>
>> Disk stats (read/write):
>>     dm-0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
>> aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0,
>> aggrutil=0.00%
>>   sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>>
>> # fio --version
>> fio-2.13-28-g059b6
>>
>> The execution was on RHEL7.2 and CentOS7.2
>
> Did that ever work for readable workloads? For a writeable workload it
> should be fine.

I take it back, it should still work. Try current -git, I think I fixed
it for you.

-- 
Jens Axboe


