Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750EBC6FA83
	for <fio@archiver.kernel.org>; Sat, 10 Sep 2022 04:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIJEEB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 10 Sep 2022 00:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiIJEEB (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Sep 2022 00:04:01 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327E77E30B
        for <fio@vger.kernel.org>; Fri,  9 Sep 2022 21:04:00 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id q8so2728047qvr.9
        for <fio@vger.kernel.org>; Fri, 09 Sep 2022 21:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=s4NjpYhXNmtB9XVPbzVJjou3m0oWcjsJTpLmiWIStpc=;
        b=JOxqUyR8czj/rKtW213QEBPcnTugQsCdJrFLNyTB45+CaIV9Bw4owDlNu9vNFFugzF
         da7vgS9p9rQq23OTyk+ezyA+vLFFsvWEtsKYMdOGoby0LdUtSyBhD07DBYH31vb+wIWl
         UCpx268xIUE96Ck2bu3/fbrYFZNUKuMxwlwGaBZK4I8Jo+wLOtx9b0pu6pgu+06HdomU
         cTvOyhNk1oMIHI1Cxt0PqwXqnMWjyPitE106rYDeSvZJvaLe5+nsx25o3dNKC3SrqBFn
         fvmtaQJUYaCSVR53cOxdXmb3gC2e3yR37OejhlEzM6ri0PxJWCS441cp5NFO7VdkElEA
         QGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=s4NjpYhXNmtB9XVPbzVJjou3m0oWcjsJTpLmiWIStpc=;
        b=M6a/9X6WRswUmBkt8dyQoE2TR+F2H9lBAqUHIYc0Tfw3GnBPjkU8mB9RYVh4x9/lIi
         hLbBP/GNZ5HurpZZUowWXNJ1uqf9yqqnAOcAyvsHMXDasHeHkIsaMQdVsXCgzF3gptwc
         PEQpL8arUJ2SNgXI8LOzv1Rm/0AJT5b3IfWT6BC1BtyZE4m6mlDypwrsuFAELjyeMsL1
         iQzZPASf4pYsh5g6T08va+MO7QOqzIY9YjCVrkF3Zs1JAvfoEKxik8WtUkdrtBHbklan
         XRmRnQnz2Xdh3C3/NuWwHq1UOJf1x4++2/Hkw/M/DWmWXjg+lEGFa41ODSaqxU5thdzM
         sJLA==
X-Gm-Message-State: ACgBeo16YL9aC0BK8ZZiVwEymk6mj6J/o7SksRt/voXIchLtL1PiKKMf
        COHshs/H0nMb1nBkUEZmPxN09CF3mOhIt12yvuCygdxExJjGGg==
X-Google-Smtp-Source: AA6agR4ebn97PfluCDZ5Z3gmbQ3Q+dccwCCR+hW5KuZADNnPuOXPABn509ZxDEbIIbWfHYKZIggtc9KbT1L+xot6EEo=
X-Received: by 2002:a05:6214:f27:b0:476:9d88:2597 with SMTP id
 iw7-20020a0562140f2700b004769d882597mr14496593qvb.45.1662782639304; Fri, 09
 Sep 2022 21:03:59 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220907155824uscas1p14b8cddb2c97e9b29b194f25ec3edc4b1@uscas1p1.samsung.com>
 <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
 <99cd72aca6274227825d5a50b263bab8@samsung.com> <CADqNVTpvftJZaJ2AepPMcbaJJr7vYMaLdivCf85j8Rwrq_02Fw@mail.gmail.com>
 <CADqNVTpkMUVx2+tUXTRivNqsejbP_Sto90pihzm+L210=MC25A@mail.gmail.com> <9b0021d903894664ab0a698ff19588d0@samsung.com>
In-Reply-To: <9b0021d903894664ab0a698ff19588d0@samsung.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Fri, 9 Sep 2022 23:03:46 -0500
Message-ID: <CADqNVTr6TaBA9MoMRFkxFrdu-KtsELe3c=N2N-tByLf9SBTqww@mail.gmail.com>
Subject: Re: Best practices for handling drive failures during a run?
To:     Vincent Fu <vincent.fu@samsung.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Sep 9, 2022 at 10:56 PM Vincent Fu <vincent.fu@samsung.com> wrote:
> You could test your theory about max_retries by creating an NVMe fabrics
> loopback device backed by null_blk with error injection. Then try to access one
> of the bad blocks via the nvme device and see if the delay before fio sees
> the error depends on io_timeout and max_retries in the way that you expect.

Oooh, that sounds great. Thanks for the suggestion. I'll get to it
Monday if I don't find some time this weekend.

Coincidentally, one of the things I found googling was someone using
NVMe fabrics complaining that nvme_core/io_timeout and
nvme_core/max_retries were not being honored. It was from 2019 but
seemed relevant.(https://lore.kernel.org/all/EA2BFA4D4BAD49629F533A98F74DCE42@alyakaslap/T/#m26b5c91ec59de5159961a26a6cb0340c32a05ec9)

I'll report back with what I see.

Thanks,
Nick
