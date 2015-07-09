Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:35283 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbbGIH5h convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 9 Jul 2015 03:57:37 -0400
Received: by ykee186 with SMTP id e186so29630222yke.2
        for <fio@vger.kernel.org>; Thu, 09 Jul 2015 00:57:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKXScpWjpfLCk4zczN=cjD5cYMSoVOb0hekLg-1+xreMznyH=A@mail.gmail.com>
References: <CAEg8mkz7MdEjZHukGX4AiaMF4hGKVPYcX3U3xszqAjjSFYEL4Q@mail.gmail.com>
	<CAM8G_BLZCApz3TVWXMfuc4vub5eLOVXws1MShFb9J-FRKTdoCg@mail.gmail.com>
	<CAEg8mkwoP0QZDBZDgEQPa7Yvhyu105Yq-CfBV7WQ7bX4sXZ7Kw@mail.gmail.com>
	<CAKXScpVU3HdvKKNR+bipyt+wOsezirL+QV7sz+y=TAV_0vbX6w@mail.gmail.com>
	<CAEg8mkyaAwXpzuJvS1t_CcWxDD+cgaPAG2qkhV-YND_Osthcnw@mail.gmail.com>
	<CAKXScpWjpfLCk4zczN=cjD5cYMSoVOb0hekLg-1+xreMznyH=A@mail.gmail.com>
Date: Thu, 9 Jul 2015 15:57:36 +0800
Message-ID: <CAEg8mkw76FZfGe-pgDX9znLLGCH4JT7M8mfTsnN1yeexkkbtHg@mail.gmail.com>
Subject: Re: ask a question about fio
From: john gong <johngong0791@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "danielabuggie ." <danielabuggie@gmail.com>
Cc: "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Daniel,

What am i doing is to simulate the ANTUTU benchmark on android 5.1.
We learned that ANTUTU benchmark do the below things sequentially in
the same process.
1) first sequentially write to a file with bs=8KB. the file's size is 16M.
2) after write finish, then read the same file  from the begin to the
end with bs=4KB.
3) after 2) finish, then sequentially overwrite to the same file with
bs=4KB, total size is 16M too,
    and every 4096 requests do a fsync.

all done with in the same process.
I have construct one job file to simulate that process. like:
--cut--
[antutu_io_first_write]
    ioengine=sync
    size=16m
    numjobs=1
    bs=8k
    ba=4k
    rw=write
    gtod_reduce=1
    disk_util=1
    name=antutu_io_first_write
    filename=/data/antutu_test
    stonewall
[antutu_io_first_read]
    ioengine=sync
    size=16m
    numjobs=1
    bs=8k
    ba=4k
    rw=read
    gtod_reduce=1
    disk_util=1
    name=antutu_io_first_read
    filename=/data/antutu_test
    stonewall
[antutu_io_second_write]
    ioengine=sync
    size=16m
    numjobs=1
    bs=4k
    ba=4k
    rw=write
    gtod_reduce=1
    disk_util=1
    name=antutu_io_second_write
    filename=/data/antutu_test
    fsync=4096
    stonewall
--cut--


But result is:
--cut--
antutu_io_first_write: (groupid=0, jobs=1): err= 0: pid=1451: Sat Feb
4 20:05:04 2012
  write: io=16384KB, bw=54613KB/s, iops=6826, runt=   300msec
  cpu          : usr=3.33%, sys=93.33%, ctx=13, majf=0, minf=25
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=2048/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1
antutu_io_first_read: (groupid=1, jobs=1): err= 0: pid=1452: Sat Feb
4 20:05:04 2012
  read : io=16384KB, bw=287439KB/s, iops=35929, runt=    57msec
  cpu          : usr=17.86%, sys=53.57%, ctx=7, majf=0, minf=27
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=2048/w=0/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1
antutu_io_second_write: (groupid=2, jobs=1): err= 0: pid=1453: Sat Feb
 4 20:05:04 2012
  write: io=16384KB, bw=45011KB/s, iops=11252, runt=   364msec
  cpu          : usr=16.48%, sys=74.18%, ctx=34, majf=0, minf=24
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=4096/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1
--cut--

Obviously it can not satisfy my demand. It forks 3 processes(
pid=1451, pid=1452, pid=1453) to finish these jobs.
I want to do all these actions in just one process.

Any clue？

Thanks in advance!

John Gong

On Thu, Jul 9, 2015 at 3:00 PM, danielabuggie . <danielabuggie@gmail.com> wrote:
> Unfortunately, I don't think there is an option then that will
> precisely do what you are asking then.  Perhaps if you clarify more
> about what you are looking to test someone can help you approximate it
> better.
>
> Some suggestions though for you to look into:
> * Use a randrw process with percentage_random set to an appropriate
> value to control roughly how many blocks would be read before seeking.
>
> * Also a randrw process with bssplit set to a mix of small and large
> blocks sizes would make "random" IO intermittently more sequential.
>
> Daniel
>
> On Wed, Jul 8, 2015 at 11:08 PM, john gong <johngong0791@gmail.com> wrote:
>> hi Daniel,
>>
>> Thanks for your suggestion.
>>
>> "stonewall" can not solve my problem.  "stonewall" just enforce the
>> processes which do the exact jobs run sequentially.
>> But what I want to do is that all things be done in one process, not
>> with one jobfile.
>>
>> B.R.
>>
>> On Thu, Jul 9, 2015 at 1:21 PM, danielabuggie . <danielabuggie@gmail.com> wrote:
>>> So you want to run them all with one jobfile, but sequentially and not
>>> simultaneously?
>>>
>>> In that case, stonewall is the option you want to add.
>>>
>>> Daniel
>>>
>>> On Wed, Jul 8, 2015 at 9:02 PM, john gong <johngong0791@gmail.com> wrote:
>>>> hello  Kulkarni & Alireza,
>>>>
>>>> Thanks for your attentions.
>>>> tiobench-example.fio will spawn 16 processes, each job consumes 4 processes.
>>>> But what i want is all things defined in the job description be done
>>>> in one process.
>>>> For example, executes below job description
>>>> --cut--
>>>> [global]
>>>> engine=sync
>>>> filename=/data/test
>>>> size=100m
>>>> [job1]
>>>> rw=write
>>>> stonewall
>>>> [job2]
>>>> rw=read
>>>> stonewall
>>>> [job3]
>>>> rw=randwrite
>>>> stonewall
>>>> [job4]
>>>> rw=randread
>>>> stonewall
>>>> --cut--
>>>>
>>>> This job description can satisfy the demand of sequential execute, but
>>>> they will be done in 4 different processes.
>>>> What i want is all things be done in the same process sequentilly.
>>>>
>>>> B.R.
>>>>
>>>> John.Gong
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> On Thu, Jul 9, 2015 at 11:19 AM, Kulkarni, Vasu <vasu.kulkarni@gmail.com> wrote:
>>>>> Here's one example with 4 jobs which you can customize
>>>>> https://github.com/axboe/fio/blob/master/examples/tiobench-example.fio
>>>>>
>>>>>
>>>>> On Wed, Jul 8, 2015 at 6:55 PM, john gong <johngong0791@gmail.com> wrote:
>>>>>> hello All,
>>>>>>
>>>>>> I wonder whether FIO can do below things in the same job?
>>>>>> 1) sequential write
>>>>>> 2) sequential read
>>>>>> 3) randomly write
>>>>>> 4) randomly read
>>>>>>
>>>>>> Namely FIO do not need to spawn other processes to do the things respectively.
>>>>>> All things will be done in the same process.
>>>>>>
>>>>>> Thanks in advance!
>>>>>>
>>>>>> John.Gong
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> A ship is safer in a harbor.  But that's not what ships are built for.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
