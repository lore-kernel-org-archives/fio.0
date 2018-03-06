Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:50814 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753747AbeCFU3e (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Mar 2018 15:29:34 -0500
Received: by mail-it0-f49.google.com with SMTP id d13so487863itf.0
        for <fio@vger.kernel.org>; Tue, 06 Mar 2018 12:29:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDqbdDJqK-TKEss5H5+e0hiFns2Tv6Rj6hqHvxN7QBXPZA@mail.gmail.com>
References: <CAKwzdDrG3vgzMzttpZm4HgbziXUNsXiOgNP_PAty+KRasQ7szg@mail.gmail.com>
 <CALjAwxgH-QB_AUErVOu_zwWGLV-Zn1y1poOHXj0qQce_3tyCHw@mail.gmail.com>
 <CALjAwxjV5-GOzNpDHTJmMobyHExJD6Pkkpi=SBU04T=HQhHVLQ@mail.gmail.com>
 <CAKwzdDpwvgmWtCssGYNDv7BLgoPe56SqRCtFf_B0P1i9oR4fOw@mail.gmail.com> <CAKwzdDqbdDJqK-TKEss5H5+e0hiFns2Tv6Rj6hqHvxN7QBXPZA@mail.gmail.com>
From: abhishek koundal <akoundal@gmail.com>
Date: Tue, 6 Mar 2018 12:28:52 -0800
Message-ID: <CAKwzdDowpJ3FkUgySFJM1nE3YKP5Ru7c76KtNFBOA2wgHRWy+g@mail.gmail.com>
Subject: Re: FIO size parameter feedback
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Sitsofe
The engine used is the libaio. I hope this helps.
Can you elaborate on the ioengine part which are able to query the
file/disk size and which wont be able to ? (I generally use libaio for
QD>1)

On Tue, Mar 6, 2018 at 11:47 AM, abhishek koundal <akoundal@gmail.com> wrote:
> Hi,
> The workload I used was SEQ_MX 70/30 BS 128 QD 128
> FIO used 3.1
> Drive SKU = 2TB
>
> On Tue, Mar 6, 2018 at 11:43 AM, abhishek koundal <akoundal@gmail.com> wrote:
>> Hi,
>> The workload I used was SEQ_MX 70/30 BS 128 QD 128
>> FIO used 3.1
>>
>> On Tue, Mar 6, 2018 at 11:11 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>>
>>> On 6 March 2018 at 19:02, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>> > Hi,
>>> >
>>> > On 6 March 2018 at 18:52, abhishek koundal <akoundal@gmail.com> wrote:
>>> >> All
>>> >> If the size parameter is not given for the runs, how does the tool
>>> >> decide what % (LBA span) needs to be written on the drive?
>>> >
>>> > It will query the disk/file for its size (but this depends on the
>>> > ioengine being able to do that and not all do/can).
>>> >
>>> >> Reason I am asking as I see different data for the same workloads when
>>> >> size=100% and no size parameter used.
>>> >
>>> > Hmm this sounds like it might be due to a rounding issue - what size
>>> > is your disk and what job were you running?
>>>
>>> https://github.com/axboe/fio/blob/master/filesetup.c#L1039-L1048 shows
>>> that when in setup_files() using a size set in percent will round the
>>> io_size down to the minimum block size whereas not setting size at all
>>> looks like it will pass the determined size straight through
>>> unrounded. I'm not sure what job you would see the difference on -
>>> perhaps one that did backwards I/O?
>>>
>>> --
>>> Sitsofe | http://sucs.org/~sits/
>>
>>
>>
>>
>> --
>> Life is too short for silly things so invest your time in some productive
>> outputs!!
>
>
>
> --
> Life is too short for silly things so invest your time in some
> productive outputs!!



-- 
Life is too short for silly things so invest your time in some
productive outputs!!
