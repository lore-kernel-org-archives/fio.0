Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgGKHwq (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 11 Jul 2020 03:52:46 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20933C08C5DD
        for <fio@vger.kernel.org>; Sat, 11 Jul 2020 00:52:46 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so8332103wme.5
        for <fio@vger.kernel.org>; Sat, 11 Jul 2020 00:52:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAJzzwJz7a=z6x0pOQeyFB3p0=Ou2A=hb_F4vRLbYoHoWA0mGxw@mail.gmail.com>
In-Reply-To: <CAJzzwJz7a=z6x0pOQeyFB3p0=Ou2A=hb_F4vRLbYoHoWA0mGxw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 11 Jul 2020 08:52:19 +0100
Message-ID: <CALjAwxgZcEokm2cmNYAQi-aSV-ACdbOu1FuQdpuotfmF_OWexA@mail.gmail.com>
Subject: Re: Fio SG Engine not allowing iodepth > 16
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kurt Dorsey <batlin@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Fri, 10 Jul 2020 at 22:16, Kurt Dorsey <batlin@gmail.com> wrote:
>
> I am trying to utilize the Fio SG engine and am finding it errors out
> with an iodepth > 16.

This stems from a limit in the kernel sg driver itself where only a
maximum of 16 commands can be queued on a file descriptor. See
SG_MAX_QUEUE  in
https://github.com/torvalds/linux/blob/bef7b2a7be28638770972ab2709adf11d601c11a/include/scsi/sg.h#L236
and its usage in
https://github.com/torvalds/linux/blob/bef7b2a7be28638770972ab2709adf11d601c11a/drivers/scsi/sg.c
.

> I have no issues running multiple jobs to get the effected outstanding
> IO to the device higher than 16 but it would be really nice
> (especially for Sequential IO) to be able to run it on a single job.
>
> Is there a way to allow for iodepths > 16 for the sg engine?

You would have to modify your kernel - this isn't due to fio...

> /usr/local/bin/fio --group_reporting=1 --name=4K_Random_Writes_32qd
> --filename=/dev/sg12 --iodepth=32 --rw=randrw --rwmixwrite=100
> --percentage_random=100 --bs=4K --random_generator=tausworthe64
> --randrepeat=0 --runtime=600 --ramp_time=0 --time_based --numjobs=1
> --ba=4k --ioengine=sg --norandommap --buffered=0 --thread=0 --direct=0
> 4K_Random_Writes_32qd: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W)
> 4096B-4096B, (T) 4096B-4096B, ioengine=sg, iodepth=32
> fio-3.19-dirty
> Starting 1 process
> fio: pid=67809, err=33/file:engines/sg.c:676, func=xfer,
> error=Numerical argument out of domain

Your kernel is telling you this. From
https://github.com/torvalds/linux/blob/bef7b2a7be28638770972ab2709adf11d601c11a/include/scsi/sg.h#L234
:
/* maximum outstanding requests, write() yields EDOM if exceeded */
#define SG_MAX_QUEUE 16

Hunting around it looks like Douglas Gilbert is proposing a v4 sg
interface that would lift that restriction (see
http://sg.danny.cz/sg/sg_v40.html#__RefHeading___Toc1536_4294551682
which mentions "remove limit of 16 outstanding commands/requests per
file descriptor"). However, at the time of writing the v4 interface
doesn't appear to be in any mainline kernel (5.8 is currently in rc).
Last I see there's a patcheset from April proposing the v4 interface
over on https://lore.kernel.org/linux-scsi/20200421215258.14348-1-dgilbert@interlog.com/
and even if it eventually goes in I don't know if you would then have
to adapt the fio sg ioengine to use it...

-- 
Sitsofe | http://sucs.org/~sits/

