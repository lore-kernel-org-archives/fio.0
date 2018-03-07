Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:34022 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754551AbeCGSOp (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Mar 2018 13:14:45 -0500
Received: by mail-it0-f49.google.com with SMTP id n128so16988092ith.1
        for <fio@vger.kernel.org>; Wed, 07 Mar 2018 10:14:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxiXQYQR6CVJjs6AukG=PGTqit3THSxCA3RSUFo6TbRCEA@mail.gmail.com>
References: <CAKwzdDrG3vgzMzttpZm4HgbziXUNsXiOgNP_PAty+KRasQ7szg@mail.gmail.com>
 <CALjAwxgH-QB_AUErVOu_zwWGLV-Zn1y1poOHXj0qQce_3tyCHw@mail.gmail.com>
 <CALjAwxjV5-GOzNpDHTJmMobyHExJD6Pkkpi=SBU04T=HQhHVLQ@mail.gmail.com>
 <CAKwzdDpwvgmWtCssGYNDv7BLgoPe56SqRCtFf_B0P1i9oR4fOw@mail.gmail.com>
 <CAKwzdDqbdDJqK-TKEss5H5+e0hiFns2Tv6Rj6hqHvxN7QBXPZA@mail.gmail.com>
 <CAKwzdDowpJ3FkUgySFJM1nE3YKP5Ru7c76KtNFBOA2wgHRWy+g@mail.gmail.com>
 <CALjAwxht9kUnEZPnjgE8nrFB6GhtJAUNX0JLobYw9ffTfYRB+g@mail.gmail.com>
 <CAKwzdDqOCQiQCFTYPd_tz9=DwvW+qNc=rTkW4Mu8yY8uL71fdg@mail.gmail.com>
 <CAKwzdDoFAARSxVQYLzBqqqeAJvGe4dkVjwsipP6zkSPc1rwyTw@mail.gmail.com> <CALjAwxiXQYQR6CVJjs6AukG=PGTqit3THSxCA3RSUFo6TbRCEA@mail.gmail.com>
From: abhishek koundal <akoundal@gmail.com>
Date: Wed, 7 Mar 2018 10:14:03 -0800
Message-ID: <CAKwzdDr2z-Z7YQK0GpSX_syvFDtdZ_Px7k5Fd1G0eaE12cy7_A@mail.gmail.com>
Subject: Re: FIO size parameter feedback
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi
Yes that is correct. The drive is showing :
2000398934016 and its not exact multiple of 128K

So do we think this is how the tool will behave or we have a bug here?

On Wed, Mar 7, 2018 at 12:17 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> What does
> blockdev --getsize64 /dev/nvme0n1
> say? I'm going to guess that whatever number comes out is not an exact
> multiple of 128Kbytes...
>
> On 7 March 2018 at 00:58, abhishek koundal <akoundal@gmail.com> wrote:
>> Sitsofe,
>> here is the log file when the size parameter is not give.
>> command line will be :
>> fio --name=global --time_based  --direct=1 --norandommap
>> --randrepeat=0 --buffered=0 --refill_buffers --name=job
>> --ioengine=libaio --group_reporting --filename=/dev/nvme0n1
>> --numjobs=1 --iodepth=128 --bs=128k --rw=rw --rwmixread=70
>> --runtime=10800 --write_iops_log=wr.log -write_lat_log=wr.clat.log
>> --log_avg_msec=1000
>>
>> On Tue, Mar 6, 2018 at 2:28 PM, abhishek koundal <akoundal@gmail.com> wrote:
>>> Sure Sitsofe
>>> fio --name=global --time_based --size=100% --direct=1 --norandommap
>>> --randrepeat=0 --buffered=0 --refill_buffers --name=job
>>> --ioengine=libaio --group_reporting --filename=/dev/nvme0n1
>>> --numjobs=1 --iodepth=128 --bs=128k --rw=rw --rwmixread=70
>>> --runtime=10800 --write_iops_log=wr.log -write_lat_log=wr.clat.log
>>> --log_avg_msec=1000
>>>
>>> On Tue, Mar 6, 2018 at 1:23 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>>> An example of an engine that can't deduce a size by itself is the null
>>>> engine. Most file based engines (e.g. pvsync, sync, libaio) are able
>>>> to.
>>>>
>>>> I'd really have to see the exact jobs that were run (i.e. the complete
>>>> command line and fio job file if there was one) and the exact output
>>>> that you mention showed the problem to say more. For example you say
>>>> 2TBytes but that's probably not granular enough. What is more
>>>> interesting is the size of the disk in bytes (from Linux's
>>>> perspective) because I'd need to know exactly what rounding occured to
>>>> understand what happened.
>>>>
>>>> On 6 March 2018 at 20:28, abhishek koundal <akoundal@gmail.com> wrote:
>>>>> Sitsofe
>>>>> The engine used is the libaio. I hope this helps.
>>>>> Can you elaborate on the ioengine part which are able to query the
>>>>> file/disk size and which wont be able to ? (I generally use libaio for
>>>>> QD>1)
>>>>>
>>>>> On Tue, Mar 6, 2018 at 11:47 AM, abhishek koundal <akoundal@gmail.com> wrote:
>>>>>> Hi,
>>>>>> The workload I used was SEQ_MX 70/30 BS 128 QD 128
>>>>>> FIO used 3.1
>>>>>> Drive SKU = 2TB
>>>>>>
>>>>>> On Tue, Mar 6, 2018 at 11:43 AM, abhishek koundal <akoundal@gmail.com> wrote:
>>>>>>> Hi,
>>>>>>> The workload I used was SEQ_MX 70/30 BS 128 QD 128
>>>>>>> FIO used 3.1
>>>>>>>
>>>>>>> On Tue, Mar 6, 2018 at 11:11 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>>>>>>>
>>>>>>>> On 6 March 2018 at 19:02, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>>>>>>> > Hi,
>>>>>>>> >
>>>>>>>> > On 6 March 2018 at 18:52, abhishek koundal <akoundal@gmail.com> wrote:
>>>>>>>> >> All
>>>>>>>> >> If the size parameter is not given for the runs, how does the tool
>>>>>>>> >> decide what % (LBA span) needs to be written on the drive?
>>>>>>>> >
>>>>>>>> > It will query the disk/file for its size (but this depends on the
>>>>>>>> > ioengine being able to do that and not all do/can).
>>>>>>>> >
>>>>>>>> >> Reason I am asking as I see different data for the same workloads when
>>>>>>>> >> size=100% and no size parameter used.
>>>>>>>> >
>>>>>>>> > Hmm this sounds like it might be due to a rounding issue - what size
>>>>>>>> > is your disk and what job were you running?
>>>>>>>>
>>>>>>>> https://github.com/axboe/fio/blob/master/filesetup.c#L1039-L1048 shows
>>>>>>>> that when in setup_files() using a size set in percent will round the
>>>>>>>> io_size down to the minimum block size whereas not setting size at all
>>>>>>>> looks like it will pass the determined size straight through
>>>>>>>> unrounded. I'm not sure what job you would see the difference on -
>>>>>>>> perhaps one that did backwards I/O?
>>>>
>>>> --
>>>> Sitsofe | http://sucs.org/~sits/
>>>
>>>
>>>
>>> --
>>> Life is too short for silly things so invest your time in some
>>> productive outputs!!
>>
>>
>>
>> --
>> Life is too short for silly things so invest your time in some
>> productive outputs!!
>
>
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Life is too short for silly things so invest your time in some
productive outputs!!
