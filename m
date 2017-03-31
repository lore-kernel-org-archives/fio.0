Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:35931 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932942AbdCaNru (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2017 09:47:50 -0400
Received: by mail-qt0-f178.google.com with SMTP id r45so65504707qte.3
        for <fio@vger.kernel.org>; Fri, 31 Mar 2017 06:47:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACqzM2AwbutwGND4PiC+EaH-DHCr=xQiz6HZTApAcjv8qNczxw@mail.gmail.com>
References: <CACqzM2CTN9w45owkjvoTR+Ca4QJFvM_MnOZE9+BU+dCxo2nuEQ@mail.gmail.com>
 <CALjAwxgZx+QHcM74ERtj1zUZo1r+aCfgCP8wnhNicJ01b768FA@mail.gmail.com>
 <CACqzM2AmmgacpGd+QVt42=SdqQrDENigb7TUs-x50iuD9KWt6Q@mail.gmail.com>
 <CALjAwxiHDO0AwQWNYR4J_TL821hhbjn6J0Arm5p73t5dZotV3w@mail.gmail.com> <CACqzM2AwbutwGND4PiC+EaH-DHCr=xQiz6HZTApAcjv8qNczxw@mail.gmail.com>
From: Guruganesh Hegde <guruhegde4u@gmail.com>
Date: Fri, 31 Mar 2017 19:17:48 +0530
Message-ID: <CACqzM2DuU22spqRO3n78zpfMNJ+FiDTYPmSv3ZOpQhVCb2WAQQ@mail.gmail.com>
Subject: Re: numberio failure with numjobs=1
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

I am able to reproduce this issue even in fio 2.18 with Size 1G & 256M

I have figured out a work around,
If I set loops=1 in a config file and launch fio from a shell script,
this issue is not seen.

However if I set loops > 1, then most likely this issue is seen.

Another interesting observation, if combination of loop & size results
into very small amount of data and if fio test finishes in few seconds
this issue is not seen.
For example,
if I set size=1M & loops=10, then test runs without failure.

One another observation is,
I had run test with loops=1 size=32 for 100 iterations. (Launching
from shell scripts) and no single failure is observed.
After finishing above test, repeated test with loops =1 and size=64G,
test failed in 1st iteration remaining iterations are fine. (This test
is still running currently at 8th iteration)

Failing log

Jobs: 1 (f=1): [V(1)][72.1%][r=587MiB/s,w=0KiB/s][r=150k,w=0 IOPS][eta
00m:57s]^Mfio: pid=16009, err=84/file:io_u.c:1982,
func=io_u_queued_complete, error=Invalid or incomplete multibyte or
wide character

write-phase: (groupid=0, jobs=1): err=84 (file:io_u.c:1982,
func=io_u_queued_complete, error=Invalid or incomplete multibyte or
wide character): pid=16009: Fri Mar 31 06:23:47 2017
   read: IOPS=165k, BW=643MiB/s (674MB/s)(28.3GiB/45039msec)

Disk stats (read/write):
  nvme0n1: ios=7392130/16777216, merge=0/0, ticks=1261335/792207,
in_queue=2052208, util=99.94%



Thanks,
Guru







On Fri, Mar 31, 2017 at 11:55 AM, Guruganesh Hegde
<guruhegde4u@gmail.com> wrote:
> Thanks..
> I will try that out
>
> Regards,
> Guru
>
> On Fri, Mar 31, 2017 at 11:41 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> (Please use reply to all so mails continue going to the mailing list)
>>
>> On 31 March 2017 at 07:05, Guruganesh Hegde <guruhegde4u@gmail.com> wrote:
>>> Thanks for the suggestions.
>>>
>>> I will tryout suggested tests and share the observations.
>>>
>>> The device which I am using is supporting only 4k block size, I will
>>> not be able to try different block sizes, however I will try with
>>> different sizes(1G or 256M etc).
>>
>> Bigger blocks that are still a multiple of 4Kbytes should work
>> though... Further by default bsrange will only picks block sizes that
>> are multiples of the minimum specified blocksize so bsrange=4k-64k
>> should pick 4k, 8k, 16k, 32k, 64k (see
>> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-blocksize-range
>> ). Is that clearer?
>>
>> --
>> Sitsofe | http://sucs.org/~sits/
