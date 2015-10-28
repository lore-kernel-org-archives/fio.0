Return-Path: <katsumi@gmail.com>
MIME-Version: 1.0
Sender: katsumi@gmail.com
In-Reply-To: <56301736.1000302@kernel.dk>
References: <CAKPij3xg4=H0R506nT5gV7Lrz3Lpn_a3ML27F0ZNt6ws5svp-Q@mail.gmail.com>
	<562FE8E3.90106@kernel.dk>
	<563014DE.60400@kernel.dk>
	<56301736.1000302@kernel.dk>
Date: Tue, 27 Oct 2015 22:19:07 -0400
Message-ID: <CAP85WCBF-gq7O2odW7EVQL4uRAsrEjT2shO4Naa3CBKniFqK_w@mail.gmail.com>
Subject: Re: FIO creating empty latency log files
From: DoubleDensity <doubledense@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This worked! I am in your debt, it is extremely cool to have this
operational now.

Please let me know if there is anything I may do to help test or
validate this fix or otherwise repay the favor!

On Tue, Oct 27, 2015 at 8:30 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 10/28/2015 09:20 AM, Jens Axboe wrote:
>>
>> On 10/28/2015 06:13 AM, Jens Axboe wrote:
>>>
>>> On 10/28/2015 12:41 AM, Buttetsu Batou wrote:
>>>>
>>>> On 06/04/2015 05:09 PM, Reed Crowe wrote:
>>>>>
>>>>> Using this version of FIO:
>>>>> * io-threads
>>>>>      master
>>>>> rcrowe@rcrowe-desktop:~/fio_iothreads/fio$ ./fio --version
>>>>> fio-2.2.7-14-g00b2
>>>>>
>>>>> I have a job file which looks like this:
>>>>>
>>>>> [global]
>>>>> ioengine=libaio
>>>>> direct=1
>>>>> numjobs=1
>>>>> bs=4k
>>>>> iodepth=300
>>>>> rw=randwrite
>>>>> randrepeat=0
>>>>> io_submit_mode=offload
>>>>> rate_iops=8070
>>>>> time_based=1
>>>>> runtime=1m
>>>>>
>>>>> [slow_write]
>>>>> filename=/mnt/test1/testfile.io
>>>>> write_lat_log=/tmp/fio_lat
>>>>>
>>>>> And it produces empty files:
>>>>> -rw-r--r-- 1 root   root         0 Jun  4 14:34 fio_lat_clat.1.log
>>>>> -rw-r--r-- 1 root   root         0 Jun  4 14:34 fio_lat_lat.1.log
>>>>> -rw-r--r-- 1 root   root         0 Jun  4 14:34 fio_lat_slat.1.log
>>>>>
>>>>> What am I missing?
>>>>
>>>>
>>>> I am seeing this behavior in the latest release fio-2.2.10 and in
>>>> master fio-2.2.10-29-g8a68 but I am not using offload.
>>>>
>>>> Is anyone currently able to successfully generate log output? If so
>>>> could you share your fio version and your config?
>>>>
>>>> Here is the job file I am using at the moment.. have tried variations
>>>> on these settings and different fio versions back to 2.0.15 but always
>>>> the same empty output:
>>>>
>>>> [write]
>>>> group_reporting=1
>>>> numjobs=8
>>>> ioengine=posixaio
>>>> io_submit_mode=inline
>>>> stonewall
>>>> rw=write
>>>> bs=32k
>>>> time_based=1
>>>> runtime=10
>>>> filesize=64k
>>>> directory=/tmp
>>>> per_job_logs=1
>>>> write_bw_log=write_bw
>>>> write_iops_log=write_iops
>>>>
>>>> Updated the issue reported here:
>>>>
>>>> https://github.com/axboe/fio/issues/29
>>>>
>>>> Thank you for any ideas you may have!
>>>
>>>
>>> I think your issue is because you set filesize=64k. Your job basically
>>> sets up 8 files of 64k each, then writes to them for 10 seconds. This
>>> means that the fio main loop keeps re-entering for every 64k for each
>>> thread. The bandwidth/iops is averaged over a window of 500msec by
>>> default, and the main loop runs for much shorter than that since it only
>>> does 64k each time. Hence you never get logged any entries.
>>>
>>> Now, it should work. If you comment out these two lines:
>>>
>>> memcpy(&td->bw_sample_time, &td->start, sizeof(td->start));
>>> memcpy(&td->iops_sample_time, &td->start, sizeof(td->start));
>>>
>>> in backend.c around 1568/1569, then I suspect the logging should improve
>>> for you. I'll have to see if we can safely do that without making other
>>> changes, before committing a change like that.t
>>
>>
>> Try the attached patch, we need to retain the stat block and byte counts
>> too.
>
>
> Just run current -git, I committed a similar patch.
>
> --
> Jens Axboe
>

