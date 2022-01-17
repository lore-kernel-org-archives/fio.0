Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11112C433F5
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 20:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbiAQUEC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 15:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiAQUEB (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 15:04:01 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709B6C061574
        for <fio@vger.kernel.org>; Mon, 17 Jan 2022 12:04:01 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id w26so22925438wmi.0
        for <fio@vger.kernel.org>; Mon, 17 Jan 2022 12:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJDCVdf91MjituI02xtOfySDiO/9z6NOPeINSZ5cREk=;
        b=GOq7wnAEbn+Z1W1cj3PakxDqIcXW5IqS+74tFJytJpJ/gleQii2GYf5N7Qcmsug8f6
         /8ejwZO/1HRd0rLRzanfDS5SDv8m+WrPtzAjmaiC0F4mJkmV0zjAc5aNx6kEc/Ruy9FR
         Y+MH7D0/lM+VI1P3jx77fj2xfnYaca52xgE4//L6VqNE0KVO3okw1n9FIfmG81v8Ratb
         XHKuyUpvsi0oZuay6Q0j9RPprfps1l+pDHqv9eujsk3BoohFKyvWNRE+4F98sClFSMD4
         0V5cguksJE8FTMbBzY3RaI/tldzZ/ErUYYzpvDdFIi9mibzqWaP+y4MDRJTGNiaqTCbn
         SCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJDCVdf91MjituI02xtOfySDiO/9z6NOPeINSZ5cREk=;
        b=QY1hcJNL0qNHJ0uCZ6gj2ICz11gBkMrmKkeJ5jrqLXYjZTQvLWMLuyED8cuX8o2Zn3
         zBMwM/K78cuCo4MQ+Wcrx8g30DFbJP/8zkFLhKc3z+MOuygGi+Q55KrhZAKYCRxRYRSH
         /k0r9EjYi+YATftZDQbL+bz72W/k/uPMgFcjHSU+eGbhac8oobXpc6tkAwvr1p175C1M
         2t97RqejMGXLiYCZZmc+0dg31nOKlk7+z0IzyyFuy0NgWL0AsbrRAbsDZHY8d4802XLL
         ROLtEE4FNhqIiP9pfLLcml/qLzBP8srt6ydqgK/4mdLe7oYzBuv5mQRKU+ytjI8bthZG
         02YA==
X-Gm-Message-State: AOAM530WaSesJtIccf+Ma9Kwgjyp8gWvgp3ukgKLppKMTzweVrJ/hdeJ
        0EljY7aq8DQpsHXgkdMoC/Ru30jx97NvzSFed6yMtQ0ylQY=
X-Google-Smtp-Source: ABdhPJzBVFR4sRTxQNzv3uHc1ZOQw194SJFScTzFynjFjDKT7cvl+f++zsM/EQjVTC/Qq4sYImiUE2cItW+7w7k9780=
X-Received: by 2002:a05:6000:168e:: with SMTP id y14mr12485184wrd.267.1642449840031;
 Mon, 17 Jan 2022 12:04:00 -0800 (PST)
MIME-Version: 1.0
References: <SJ0PR84MB1434F97AE046381C181A3514F4529@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
 <SJ0PR84MB1434CE895980F3953C93BA6FF4529@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
 <SJ0PR84MB143421DA1431C54AAEA77699F4529@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxiV7s8FgH7c4K+2zWEU_8Ds_XKntr1GF-NPujDfd9gfEQ@mail.gmail.com> <SJ0PR84MB143421C31B114BEB957C925DF4559@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <SJ0PR84MB143421C31B114BEB957C925DF4559@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
From:   Sitsofe Wheeler <sitsofe@gmail.com>
Date:   Mon, 17 Jan 2022 20:03:33 +0000
Message-ID: <CALjAwxiy0oa9CoXTbj-WzYapsHUxVzhgGaX56xK4bnyCEqe_fw@mail.gmail.com>
Subject: Re: FW: re; fio / test result diffs
To:     "Gibson, Thomas" <thomas.gibson@hpe.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Sat, 15 Jan 2022 at 22:41, Gibson, Thomas <thomas.gibson@hpe.com> wrote:
>
> I wasn't sure if I should reply to you directly or not.  So I did for now.
> But I cc'c the fio mailing list as well.
>
> I've attached a test data tarfile on the fio test runs for each fio test.
> tom...

From SSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-randrd_seqwr.txt:
[...]
SSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-RandRd: (groupid=0, jobs=1):
err= 0: pid=42215: Mon Dec 20 16:53:45 2021
   read: IOPS=597, BW=146MiB/s (153MB/s)(1026GiB/7200022msec)
    slat (nsec): min=5512, max=99489, avg=8598.67, stdev=981.29
    clat (usec): min=1156, max=329247, avg=26747.47, stdev=8216.72
     lat (usec): min=1223, max=329255, avg=26756.16, stdev=8216.72
[...]
  cpu          : usr=0.15%, sys=0.64%, ctx=4305429, majf=0, minf=1267
SSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-SeqWr: (groupid=0, jobs=1):
err= 0: pid=42216: Mon Dec 20 16:53:45 2021
  write: IOPS=597, BW=146MiB/s (153MB/s)(1026GiB/7200021msec)
    slat (usec): min=7, max=143, avg=14.13, stdev= 2.23
    clat (msec): min=9, max=329, avg=26.74, stdev= 8.21
     lat (msec): min=9, max=329, avg=26.76, stdev= 8.21
[...]
  cpu          : usr=0.51%, sys=0.59%, ctx=4137284, majf=0, minf=270
[...]
Disk stats (read/write):
  sde: ios=4305116/4304491, merge=0/0, ticks=115166190/115134060,
in_queue=18446744069644883850, util=100.00%

You have plenty of CPU left but your disk utilisation is 100% so for
whatever reason the disk can't accept more I/O. Your problem is that
for whatever reason something below the kernel is bottlenecking...

My only thought is maybe your mixed workloads are better at exhausting
the disk's cache than a solo workload does?

-- 
Sitsofe
