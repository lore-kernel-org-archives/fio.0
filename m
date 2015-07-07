Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.35.201]:41214 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933256AbbGGVYF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Jul 2015 17:24:05 -0400
Received: from mail-vn0-f48.google.com (mail-vn0-f48.google.com [209.85.216.48])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id 396323DEE81
	for <fio@vger.kernel.org>; Tue,  7 Jul 2015 16:18:38 -0500 (CDT)
Received: by vnbg190 with SMTP id g190so28306834vnb.13
        for <fio@vger.kernel.org>; Tue, 07 Jul 2015 14:18:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANEJEGu60H0_2q8NOd9GPWTqw5CcxS2sr2omWeReLhhmfXiy-A@mail.gmail.com>
References: <CAB-428kbc6uE0fViU9ahW15BtPZi1txKcKnBdgzyb+083SfRZg@mail.gmail.com>
 <CANEJEGu60H0_2q8NOd9GPWTqw5CcxS2sr2omWeReLhhmfXiy-A@mail.gmail.com>
From: Alireza Haghdoost <alireza@cs.umn.edu>
Date: Tue, 7 Jul 2015 16:17:58 -0500
Message-ID: <CAB-428mNs=gPV4yCts16YXMVLSE_HJwAf1KsKah+4qiKxoTGVQ@mail.gmail.com>
Subject: Re: Question about data integrity check
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@chromium.org>
Cc: Gwendal Grignou <gwendal@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>, FIO List <fio@vger.kernel.org>

On Tue, Jul 7, 2015 at 3:31 PM, Grant Grundler <grundler@chromium.org> wrote:
> Hi Alireza!
>
> Thanks for the feedback - comments below.
>
> On Mon, Jun 29, 2015 at 6:17 PM, Alireza Haghdoost <alireza@cs.umn.edu>
> wrote:
>>
>> Dear Chrome OS developers,
>>
>> Thanks a lot for your contribution on this mailing list to develop
>> data integrity test for fio. I am in need to extend this tool for
>> almost similar purpose.
>
> Excellent! That's exactly why I ask Juan to work on fio instead of writing
> his own. :)
>>
>> Therefore, I did some research to understand
>> what you and your intern (Juan) has been done so far and have some
>> comments on your approach:
>>
>> Based on my understanding the integrity test framework works like this:
>>     - First, run the write intensive job with verify_only=0 option to
>> write initial contents and headers on the media
>>     - Second, run the same job with verify_only=1 option to read what
>> has been written in the previous run and checks a) header rand_seed b)
>> in case of verify=meta check numberio
>
>
> I think that is correct.
>
>>
>> Refering to sample job file posted in here :
>>
>> https://chromium.googlesource.com/chromiumos/third_party/autotest/+/master/client/site_tests/hardware_StorageFio/8k_async_randwrite
>>
>> This kind of integrity checking failed to detect stale writes in
>> following cases. Please correct me if I am wrong but here is why I
>> think this is not a good method to do integrity checking:
>>
>>    1. The logic does not work for multiple integrity check on the same
>> target (file,raw device) since it write exactly the same contents and
>> headers every time we run the test on the target media.
>
>
> Correct. But this was NOT the intent. The intent was to write once and then
> repeatedly verify the contents have been retained over a 72h or longer
> period. (and we needed verify=meta as you point out below.)
>
>> Therefore, if
>> the test pass for the 1st time, it will pass forever regardless of
>> future stale writes. You are using randrepeat=1 which essentially
>> force FIO to use 0 for rand_seed and follow exact the same random IO
>> blocks every time/run.
>
>
> You are correct for rotational media (aka "spinning rust").
>
> But not for SSDs. Even if I write the exact same contents to the same LBA
> (*LOGICAL* block address), the data is _never_ going to land on the same
> physical location ("new" contents are written to a different physical
> location, old block is marked stale in the FTL).
>
> The "sponsor" for Juan's work (ChromeOS) only cares about SSDs (eMMC and
> SATA).
> BTW, it's important that every run start with the same seed so if we get
> corruption: we can determine the origin of the corrupt data (ie which LBA
> was targeted if the corruption was caused by an fio write).
>
>>    2. The logic does not work for 0 initialized target media with
>> verify != meta. This is exactly similar to the 8K_async_randwrite job
>>
>> file that sounds like you are using. In this case, since verify !=
>> meta then the verify_only phase just check the rand_seed value of
>> written data with default rand_seed value of FIO. It turns out the
>> default rand_seed value of FIO is 0 if you have randrepeat=1.
>> Therefore, assuming the target media is already initialized to 0
>> (which is a valid case for most of new drives) regardless of what has
>> been written in first phase, the header rand_write check will pass.
>
>
> You are probably right (in particular about verify != meta) - but I'm going
> to punt on this for two reasons:
> 1) I just got back from 4 months off work (I've documented some of my
> blacksmithing and travels in my G+ profile)
>
> 2) Gwendal has been dealing with Storage Qualification and is much more
> likely to give you an intelligent, informed response at this point.
>
> I also suspect 8K_async_randwrite isn't intended to be the "verification"
> test  - I'm sure other tests are used for storage verification instead.
> Thus, the weak verification is probably sufficient here.
>
> cheers!
> grant
>

Hi Grant,

Thanks for the reply. These additions to FIO that has been done by
your team in my opinion are truly valuable. However, as you mentioned
it is sufficient but not intended for a robots data integrity check. I
am planing to propose some changes and additions to the verification
frameworks in a couple of days. It would be great if I have your
attention and comments on that.

Thanks
--Alireza
