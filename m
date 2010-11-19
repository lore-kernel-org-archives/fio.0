Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63093 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0KSOhp convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 19 Nov 2010 09:37:45 -0500
Received: by gyh4 with SMTP id 4so2694488gyh.19
        for <fio@vger.kernel.org>; Fri, 19 Nov 2010 06:37:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4C6CAE54C846144981BCE6F26B203FFA5E05341587@GVW1098EXB.americas.hpqcorp.net>
References: <AANLkTimn=cJXQN-=wC4v8AeMEYGXUUfrM5nvVMzLkwEY@mail.gmail.com>
 <AANLkTiknYzSOx8Othcvb4UA=Vvyb4WTPd8jy9t-2CV+b@mail.gmail.com> <4C6CAE54C846144981BCE6F26B203FFA5E05341587@GVW1098EXB.americas.hpqcorp.net>
From: Dan Le <wb.danle@gmail.com>
Date: Fri, 19 Nov 2010 09:32:05 -0500
Message-ID: <AANLkTind0mPTU4GPDUFu9ch-a2C4orSS8Oym1HxQ5cLy@mail.gmail.com>
Subject: Re: How to flush the writing cache before a test with read
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Jenkins, Lee (ISS Houston)" <Lee.Jenkins@hp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

I tried fsync to drop the cache upon 5 - 10 I/Os. So far, it seems to
work to me. I will try with fsync=1 later.

Jenkins, suppose that cache will be cleared out before FIO is
performed, it still can be dirty because of I/Os from other processes
when FIO's writes are performed, how could you accurately calculate
the flush time ahead?  And how could you smoothly handle the wait time
in FIO?

Thanks,

Dan


On Thu, Nov 18, 2010 at 5:32 PM, Jenkins, Lee (ISS Houston)
<Lee.Jenkins@hp.com> wrote:
> The safest and least test-intrusive way is to calculate the flush time ahead of time and insert the appropriate wait time into the test. I encountered the same issue when testing RAID volumes attached to (shameless plug) HP Smart Array controllers with battery-backed write cache. When the cache (512MB at max config) was filled with random write data it could take a long time for the flush to complete. It was the only way to ensure that the subsequent read-only test data was accurate.
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Dan Le
> Sent: Thursday, November 18, 2010 3:13 PM
> To: fio@vger.kernel.org
> Subject: How to flush the writing cache before a test with read
>
> Greetings,
>
> FIO needs to write data files in order to read them. Without disabling
> the write-cache of the disk, I was wondering if there's a way to flush
> these data cache to disk right before FIO starts to read these files.
>
> I don't want to run every second "sync && echo 3 >
> /proc/sys/vm/drop_caches" at the same time with FIO because of its
> incurred overhead. Please help.
>
> Thank you,
>
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
