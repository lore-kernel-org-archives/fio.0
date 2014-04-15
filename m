Return-Path: <sendtold@gmail.com>
MIME-Version: 1.0
In-Reply-To: <534C9859.2050801@kernel.dk>
References: <CAEyTGCffvRyGUgXaFP8k6X_kF9sDFbw_nP6T-LQS0bsQO8+D9A@mail.gmail.com>
	<534C9859.2050801@kernel.dk>
Date: Tue, 15 Apr 2014 16:20:49 -0500
Message-ID: <CAEyTGCfciMGgrqp+OTSKxfeV0qk-0m83uB6_nNx++fnfkWp5uA@mail.gmail.com>
Subject: Re: ( file:io_u.c:1550, func=io_u error, error=No space left on
 device) when using libaio ioengine
From: Lakshmi <sendtold@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Actually never mind Jens, I had a memory leak in my source code that
generated the binary files. hence the error. I have fixed it. Thanks

-Lakshmi

On Mon, Apr 14, 2014 at 9:24 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-04-14 16:30, Lakshmi wrote:
>>
>> Hi Jens,
>>    I am trying to run a replay job with ioengine set as libaio. the
>> other paratemers are shown below.
>> ===================================================
>> [global]
>> #replay_no_stall=1
>> ioengine=libaio
>> iodepth=60
>> direct=0
>>
>> group_reporting=1
>>
>> [job1]
>>
>> read_iolog=/home/TRACE_REPLAY_1/MarkTrace_Replay_1/pBlock_4kBusy_nanosec_device/file_54657438.bin
>> ===================================================
>> however when i run the Job i keep getting the below error
>>
>> job1: (groupid=0, jobs=90): err=28 (file:io_u.c:1550, func=io_u error,
>> error=No space left on device): pid=13103: Mon Apr 14 17:24:36 2014
>>    read : io=10288KB, bw=7788.4KB/s, iops=1947, runt=  1321msec
>>      slat (usec): min=4, max=3311, avg= 7.03, stdev=65.18
>>      clat (usec): min=107, max=28167, avg=4105.30, stdev=2070.77
>>       lat (usec): min=114, max=31479, avg=4112.50, stdev=2086.66
>>    ........................................
>>      bw (KB  /s): min= 7720, max= 7888, per=100.00%, avg=7804.00,
>> stdev=118.79
>>    write: io=179568KB, bw=135933KB/s, iops=33868, runt=  1321msec
>>      slat (usec): min=3, max=24637, avg=686.05, stdev=1486.47
>>      clat (usec): min=14, max=70161, avg=5362.90, stdev=3996.05
>> =========================================
>>
>> I don't get this when i try with sync or posixaio. Am I missing something
>> here?
>> Please let me know what is causing this in libaio engine.
>
>
> That sounds odd. Can you send me the file_54657438.bin blktrace file?
> Probably compress it first.
>
> --
> Jens Axboe
>

