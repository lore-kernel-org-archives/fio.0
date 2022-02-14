Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5381AC433EF
	for <fio@archiver.kernel.org>; Mon, 14 Feb 2022 21:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiBNVG0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:06:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiBNVGX (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Feb 2022 16:06:23 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08567107D03
        for <fio@vger.kernel.org>; Mon, 14 Feb 2022 13:05:56 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id t21so708921edd.3
        for <fio@vger.kernel.org>; Mon, 14 Feb 2022 13:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kq/ViMox6Fl1aJ2Rtj6oDUK8FqdHlM3f471qTdaSPZE=;
        b=c/v1xsppN4jc7uAe9jWTbXOzOmSA51YtTzPgY/kl3hmcd2I9DHXOKwME8sls5LD9s/
         S8DfJx35a5AEpyT8hroG9LxobMh7gAPqAOsFoJAQO8wk+mkCbVVZWHZ/Cx5K3BHodInW
         xmQXLQEGJ3+EpovnxT8ArAGvoWWS4mpPGG/5oO5VoT6nogWQomrp0Q9QSuc9dWJhtInx
         i4TMlWmpYx+JstjezCCr6Jb8Lb2gfknScPNoYw4k5oGw5EZ/Ez8+OEksw35n2h5XIKWg
         Z9bU9moX4oeQkfKis1Hl9qughlxD7lulk7rhGl7iskD1eVrxXcfi7dHIH3ehysswCpT2
         2/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kq/ViMox6Fl1aJ2Rtj6oDUK8FqdHlM3f471qTdaSPZE=;
        b=T97qRqTFYwB3DVod23KZeHTnfQ43kr4doqWTDRrRaJ1wlWjAEJ08rKJ5cKf8g2r7YX
         2mDHvaRoZRQcSXkUQXXLMbmoKaHHcD3/wjTGcUiSrAvUM/2X2RAjVhMVGbG1X9NxqbW4
         b/RacKRoriBJ84IJmC7rDn8HqKJPsiTU59PBr9MAArKMyqOfSt54ke23bHdreXQkpcyM
         OqSfjtJnwFvSPZ03pbyy+ZSnYr4orw85d2Ybf2ZxU3qAcskHHmNUrns38V0MShgMr9sD
         /S97wOo+QlC0rmwesJ4SjWXfFpFZB1coVmwb4JUIVR4DE0DE+RgQUsgsDJ0gPzFLbsKz
         49ZA==
X-Gm-Message-State: AOAM531gqp2upmZW1iZNDAUlFvMWPeZunEJt8SEoaHX6J5wsRGrgy3jr
        16B05JU0q8Xm4FzO2TUySs4kTL9SFiYKV2gW6HeL2bsdNz8=
X-Google-Smtp-Source: ABdhPJx1q/5646UpEWiZapL3ML4NWN9zvEkZjfPytvuL9E9hprkEqfhyEVl6XVLDHXfi8cfyylvv8AiwZSqsWmvL1fU=
X-Received: by 2002:a5d:5446:: with SMTP id w6mr484680wrv.12.1644868227999;
 Mon, 14 Feb 2022 11:50:27 -0800 (PST)
MIME-Version: 1.0
References: <20220214142948.GJ487@angmar.tmp.com.br>
In-Reply-To: <20220214142948.GJ487@angmar.tmp.com.br>
From:   Sitsofe Wheeler <sitsofe@gmail.com>
Date:   Mon, 14 Feb 2022 19:50:01 +0000
Message-ID: <CALjAwxgdZA0Y0nXirAXDQcaT57R7gkExxFHw1u0AKQ68kq1foQ@mail.gmail.com>
Subject: Re: Samsung PM863 SSD: surprisingly high Write IOPS measured using
 `fio`, over 4.6 times more than spec!?
To:     Durval Menezes <jmmml@durval.com>
Cc:     fio <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

On Mon, 14 Feb 2022 at 18:44, Durval Menezes <jmmml@durval.com> wrote:
>
> Hello everyone,
>
> I've arrived at a very surprising number measuring IOPS write performance
> on my SSDs' "bare metal" (ie, straight on the /dev/$DISK, no filesystem
> involved):
>
>         export COMMON_OPTIONS='--ioengine=libaio --direct=1 --runtime=120 --time_based --group_reporting'
>
>         ls -l /dev/disk/by-id | grep 'ata-.*sda'
>                 lrwxrwxrwx 1 root root  9 Feb 13 17:19 ata-SAMSUNG_MZ7LM1T9HCJM-00003_XXXXXXXXXXXXXX -> ../../sda
>
>         TANGO=/dev/disk/by-id/ata-SAMSUNG_MZ7LM1T9HCJM-00003_XXXXXXXXXXXXXX
>         sudo fio --filename=${TANGO} --name=device_iops_write --rw=randwrite --bs=4k  --iodepth=256 --numjobs=4 ${COMMON_OPTIONS}
>                 [...]
>                 write: *IOPS=83.1k*, BW=325MiB/s (341MB/s)(38.1GiB/120007msec)
>                 [...]
>
> (please find the complete output at the end of this message, in case I should
> have looked at some other lines and/or you are curious)
>
> As per the official manufacturer specs (both in this whitepaper at their
> website[1]), and also in this datasheet I found somewhere else[2]), it's
> supposed to be only *18K IOPS*.
>
> All the other base performance numbers I've measured (read IOPS, read and
> write MB/s, read and write latencies) are at or very near the manufacturer
> specs.
>
> What's going on?
>
> At first I thought that, despite `--direct=1` being explicitly indicated,
> my machine's 64GB RAM (via the Linux buffer cache) could be caching the
> writes (even if the number, in that case, should have been much higher)...
> so, I tested it again with `--runtime=120` to saturate the buffer cache in
> case it was really the 'culprit'... lo and behold, the result was:
>
>         [...]
>         write: IOPS=83.1k, BW=325MiB/s (341MB/s)(190GiB/600019msec)
>         [...]
>
>
> So, the surprising over-4.6x-times-the-spec Write IOPS is mantained, even
> for 190GiB total data.
>
> And with 190GiB data written (about 10% the total device capacity), I do
> not believe it's any kind of cache (RAM, MLC or whatever) inside the SSD
> either.

You're running your workload for a comparatively short time and
additionally we don't know how "fresh" your SSD is. The 18K IOPS value
might be when the drive has been fully written and there are no
pre-erased blocks available (via so-called preconditioning)... I'll
also note the whitepaper [1] mentions this:

> SSD Precondition: Sustained state (or steady state)

[...]

> It's important to note that all performance items mentioned in this white paper have been measured at the sustained state, except the sequential read/write performance

I notice that your SSD appears to be SATA (sda) so I'd be surprised
that a total queue depth greater than 32 makes a difference (your
total queue depth is 1024). Do you get a similar result with just the
one job with an iodepth=32?

It's unlikely but if the jobs were submitting I/O to the same areas as
other jobs at the same time then some of the I/O could be elided but
given what you've posted this should not be the case.

-- 
Sitsofe
