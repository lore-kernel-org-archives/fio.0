Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:12513 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab0KKVZi convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 11 Nov 2010 16:25:38 -0500
Received: from wpaz17.hot.corp.google.com (wpaz17.hot.corp.google.com [172.24.198.81])
	by smtp-out.google.com with ESMTP id oABLPbDK020187
	for <fio@vger.kernel.org>; Thu, 11 Nov 2010 13:25:37 -0800
Received: from iwn37 (iwn37.prod.google.com [10.241.68.101])
	by wpaz17.hot.corp.google.com with ESMTP id oABLPaoG016286
	for <fio@vger.kernel.org>; Thu, 11 Nov 2010 13:25:36 -0800
Received: by iwn37 with SMTP id 37so2614407iwn.39
        for <fio@vger.kernel.org>; Thu, 11 Nov 2010 13:25:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101111162222.GO28050@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de>
	<AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com>
	<20101110082223.GB14261@sebastiankayser.de>
	<20101111162222.GO28050@sebastiankayser.de>
Date: Thu, 11 Nov 2010 13:25:35 -0800
Message-ID: <AANLkTi=hTTmURQ8q9SJgDrPGx80F+Gjn6E1EBdLkoVwz@mail.gmail.com>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
From: Shawn Lewis <shawnlewis@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: fio@vger.kernel.org

On Thu, Nov 11, 2010 at 8:22 AM, Sebastian Kayser <sebastian@skayser.de> wr=
ote:
> * Sebastian Kayser <sebastian@skayser.de> wrote:
>> Just to make sure my understanding is correct:
>> - direct=3D1 should mitigate (disable?) OS caching effects
>> - sync=3D1, iodepth=3D1 should make sure that an I/O has really made it =
to
>> =EF=BF=BD disk before the next on is issued, i.e. should de-facto disable
>> =EF=BF=BD I/O coalescing or device caching
>>
>> Are these sane/valid assumptions?
>
> Shawn Lewis sent me an email off-list and suggested that the disk itself
> will still do write-caching (despite O_SYNC) unless this has been
> explicitly disabled. I dug into the storage configuration and found an
> option which sounded promising ("Drive Delayed Write", not to be confused
> with the RAID controller write cache which was disabled from the start).
> Disabled the delayed writes and the IOPS went down from ~240 to
>
> * ~100 for a filesystem test (size=3D100g out of 2TB)
> * ~110 for a raw device test
>
> Still a bit more than I would expect [1], but definitely closer. I am not
> sure whether this can be brought down any further, i.e. whether there's
> another caching effect hidden somwhere or if these figures now actually
> reflect the "raw" harddisk performance.
Sorry, I didn't mean to send that off list. There shouldn't be any other ca=
ches.

Did any of your tests use the full device or were you still setting
the size=3D parameter? Set size=3D2T or get rid of the size=3D parameter
entirely for the raw device test and you should see more like 70 or 80
iops.

I believe part of the reason the gain is so huge with the drive cache
is that you were also only using the outer diameter of the disk. If
you use the full disk but enable drive cache I think you'll see about
140 or 150iops.
>
> Either way, I am surprised how much gain in IOPS a simple hard drive cache
> delivers ... and I am also very grateful for all the suggestions so far!
> Thanks guys!
>
> Sebastian
>
> [1] http://www.spinics.net/lists/fio/msg00558.html
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
>
