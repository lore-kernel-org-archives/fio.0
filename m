Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:40481 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbeADGsa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Jan 2018 01:48:30 -0500
Received: by mail-vk0-f49.google.com with SMTP id w75so393198vkd.7
        for <fio@vger.kernel.org>; Wed, 03 Jan 2018 22:48:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPSTwmT+iOh5+THJAnyBHMcRf6AqURTq+M=rwWc6NayuuxW5nA@mail.gmail.com>
References: <CAPSTwmSgrDt1i2m0hzHpAh9ncM1vWWSQmjcOY6mkpik-c-vwxg@mail.gmail.com>
 <CALjAwxgT9ZPYAZbBQbwuqfpmBPLHSfK_kqE2mKMaMOmyF_Q6HA@mail.gmail.com>
 <CAPSTwmS=D=jJ=wXNZRc7QZr4kcCA31v+A-wsxGpz4XJgaxQ0_g@mail.gmail.com>
 <CALjAwxj5oinoiFhFp18C8CmthwX_OP3231+PMHbAs8EHMQeHJw@mail.gmail.com> <CAPSTwmT+iOh5+THJAnyBHMcRf6AqURTq+M=rwWc6NayuuxW5nA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 4 Jan 2018 06:47:59 +0000
Message-ID: <CALjAwxh9JT4v=WS_Sj-gxgBLGVcSU09qWF2Ooeuf5sCm0p8HBw@mail.gmail.com>
Subject: Re: LBA selection in FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: fio@vger.kernel.org

Hi,

What version of fio are you using? Here's what I got with post fio 3.3
with --buffer_pattern=0:

$ ./fio --gtod_reduce=1 --filename=/tmp/fio.tmp --size=4k
--buffer_pattern=0 --name=zero --rw=write
zero: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=psync, iodepth=1
fio-3.3-17-gdb43a
Starting 1 process

zero: (groupid=0, jobs=1): err= 0: pid=10681: Thu Jan  4 06:40:44 2018
  write: IOPS=1000, BW=4000KiB/s (4096kB/s)(4096B/1msec)
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=77
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwt: total=0,1,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=4000KiB/s (4096kB/s), 4000KiB/s-4000KiB/s
(4096kB/s-4096kB/s), io=4096B (4096B), run=1-1msec
$ hexdump -C /tmp/fio.tmp
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00001000

--buffer_pattern=0x0 also works without issue for me. If you're able
to reproduce the problem with fio 3.3 or above then can you post the
command line + job file you're using?

On 3 January 2018 at 21:12, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> I did try the buffer pattern of 0x0 and it doesn't work
> fio throws out error of "failed parsing pattern `0x0`"
>
> Regards,
> Gnana
>
> On Wed, Jan 3, 2018 at 12:17 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> Hi Gnana,
>>
>> On 3 January 2018 at 17:47, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>>>
>>> Basically I am looking to see if FIO has the below option
>>> 1. Pass the LBA count as an argument. From your explanation my
>>> understanding is currently FIO doesn't have that option
>>
>> Well I'm still unsure what LBA count means in this context. If my
>> blocks are 512 bytes big and I want a single write to cover LBA 0 - 3
>> then isn't the blocksize of 4k controlling the LBA count? Sorry to
>> keep asking I just don't understand the request.
>>
>>> 2. On the buffer pattern I wasn't able to specify the buffer pattern
>>> to be all 0(zero) but --buffer_pattern=1 works fine. Do I have to use
>>> zero_buffers to fill buffers with zero and not buffer_pattern
>>
>> Hmm! 0 is going to be interpreted as "this option is unset". Does 0x0 work?

-- 
Sitsofe | http://sucs.org/~sits/
