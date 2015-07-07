Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vn0-f54.google.com ([209.85.216.54]:45753 "EHLO
	mail-vn0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbbGGUd5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Jul 2015 16:33:57 -0400
Received: by vnbg7 with SMTP id g7so28634680vnb.12
        for <fio@vger.kernel.org>; Tue, 07 Jul 2015 13:33:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANEJEGu60H0_2q8NOd9GPWTqw5CcxS2sr2omWeReLhhmfXiy-A@mail.gmail.com>
References: <CAB-428kbc6uE0fViU9ahW15BtPZi1txKcKnBdgzyb+083SfRZg@mail.gmail.com>
	<CANEJEGu60H0_2q8NOd9GPWTqw5CcxS2sr2omWeReLhhmfXiy-A@mail.gmail.com>
Date: Tue, 7 Jul 2015 13:33:55 -0700
Message-ID: <CANEJEGuL=W7znQGjd1rCp=_s=55R6R54dbOMjtCzGrty+2Q9pg@mail.gmail.com>
Subject: Fwd: Question about data integrity check
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: FIO_list <fio@vger.kernel.org>

[resending without any HTML parts]

---------- Forwarded message ----------
From: Grant Grundler <grundler@chromium.org>
Date: Tue, Jul 7, 2015 at 1:31 PM
Subject: Re: Question about data integrity check
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: Grant Grundler <grundler@chromium.org>, Gwendal Grignou
<gwendal@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>,
FIO List <fio@vger.kernel.org>


Hi Alireza!

Thanks for the feedback - comments below.

On Mon, Jun 29, 2015 at 6:17 PM, Alireza Haghdoost <alireza@cs.umn.edu> wrote:
>
> Dear Chrome OS developers,
>
> Thanks a lot for your contribution on this mailing list to develop
> data integrity test for fio. I am in need to extend this tool for
> almost similar purpose.


Excellent! That's exactly why I ask Juan to work on fio instead of
writing his own. :)

>
> Therefore, I did some research to understand
> what you and your intern (Juan) has been done so far and have some
> comments on your approach:
>
> Based on my understanding the integrity test framework works like this:
>     - First, run the write intensive job with verify_only=0 option to
> write initial contents and headers on the media
>     - Second, run the same job with verify_only=1 option to read what
> has been written in the previous run and checks a) header rand_seed b)
> in case of verify=meta check numberio


I think that is correct.

>
> Refering to sample job file posted in here :
> https://chromium.googlesource.com/chromiumos/third_party/autotest/+/master/client/site_tests/hardware_StorageFio/8k_async_randwrite
>
> This kind of integrity checking failed to detect stale writes in
> following cases. Please correct me if I am wrong but here is why I
> think this is not a good method to do integrity checking:
>
>    1. The logic does not work for multiple integrity check on the same
> target (file,raw device) since it write exactly the same contents and
> headers every time we run the test on the target media.


Correct. But this was NOT the intent. The intent was to write once and
then repeatedly verify the contents have been retained over a 72h or
longer period. (and we needed verify=meta as you point out below.)

> Therefore, if
> the test pass for the 1st time, it will pass forever regardless of
> future stale writes. You are using randrepeat=1 which essentially
> force FIO to use 0 for rand_seed and follow exact the same random IO
> blocks every time/run.


You are correct for rotational media (aka "spinning rust").

But not for SSDs. Even if I write the exact same contents to the same
LBA (*LOGICAL* block address), the data is _never_ going to land on
the same physical location ("new" contents are written to a different
physical location, old block is marked stale in the FTL).

The "sponsor" for Juan's work (ChromeOS) only cares about SSDs (eMMC and SATA).

BTW, it's important that every run start with the same seed so if we
get corruption: we can determine the origin of the corrupt data (ie
which LBA was targeted if the corruption was caused by an fio write).

>    2. The logic does not work for 0 initialized target media with
> verify != meta. This is exactly similar to the 8K_async_randwrite job
>
> file that sounds like you are using. In this case, since verify !=
> meta then the verify_only phase just check the rand_seed value of
> written data with default rand_seed value of FIO. It turns out the
> default rand_seed value of FIO is 0 if you have randrepeat=1.
> Therefore, assuming the target media is already initialized to 0
> (which is a valid case for most of new drives) regardless of what has
> been written in first phase, the header rand_write check will pass.


You are probably right (in particular about verify != meta) - but I'm
going to punt on this for two reasons:
1) I just got back from 4 months off work (I've documented some of my
blacksmithing and travels in my G+ profile)

2) Gwendal has been dealing with Storage Qualification and is much
more likely to give you an intelligent, informed response at this
point.

I also suspect 8K_async_randwrite isn't intended to be the
"verification" test  - I'm sure other tests are used for storage
verification instead. Thus, the weak verification is probably
sufficient here.

cheers!
grant


>
>
> --Alireza
> PhD Candidate,
> Center for Research in Intelligent Storage,
> University of Minnesota - Twin Cities
