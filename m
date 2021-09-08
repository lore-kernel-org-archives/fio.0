Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49CDC433EF
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 11:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914C660187
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 11:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbhIHLzU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 07:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344680AbhIHLzU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 07:55:20 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57826C061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 04:54:12 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id c6so3620813ybm.10
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 04:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=guPTVDMfMGoreIPs2jU3dC3bPzU9cD9Yg2J+X8/N25M=;
        b=aufXl+6bwMUtgvbixcMb0HhrEfFTT7+loeWlfI3ICn5UCSPkz1VaBX7tRdQNTq2P2t
         o8uHuy8XoSHH+ynGFmgTp1q8fwT7VBVu0sl+Qv3y4sOjk/d0+TlXoTk1JHSp4LlxjOHt
         k8p4IgQ2/Nvpxzwx3+B9PQBsjN3usRzD9O+X2Ms17TTa72ZUZGjg81GZIhlJrB9FETL3
         y3R2Jx/z4Csi3Q6B0w+YDvBPMCqyhuuw2kYU9tB64zs2RQcRedheIPMaJJQp9TNyw3yx
         Uz0Xtb4DpE99wCEdgZpsG6yvAToAva0ca7DFFGgFeM5SyVAMLxvfpDnUo0t1xHpjqmRh
         tYVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=guPTVDMfMGoreIPs2jU3dC3bPzU9cD9Yg2J+X8/N25M=;
        b=2jyD+9UWNhQtvAl+RY84ShDf/ToL+BHM2CyUtJx85Mc0HOE+BcpeePG4+6kkr4piXM
         ZL7328pLEefhW0eOs5OLDZTImamMM7z4W0BagRStCQAoWUY6nNWEPuhwIn2SZa6ZF5wd
         B0i5hoZdcv+nfo1qg6GZK/njhNp9vOrq3TaA+xDxKeiMIFMagpUABtmklyNXeOoN3nJD
         nqqyW5d1WREutuSkF27k7phm0Vdp/3+KPu5WDw3T4bnC9/peQcMoMcirwyQIG+cFC11M
         CsODtQWeOKoitqkdQNkhrp148n4wyJDMpN4uBzAIPflPqiok9eXSj8cyygL009ezV2Po
         92og==
X-Gm-Message-State: AOAM533ukIPP9utaLrp3A2T6ztJI20mjENNRu8KwBcMxgywMx6kAHrHD
        hYnApafZc5h4fOQwu6AdFnvw5y5tqotSA8Eu8yI=
X-Google-Smtp-Source: ABdhPJzU338oK0BjWBM4L/pu/MmGiM4Qu5hGZ2aKepfJPynKkITvUg/Fy5VERYJmfoXkkJWdV14B/EfbDH8unJCDAQg=
X-Received: by 2002:a25:dd6:: with SMTP id 205mr3260562ybn.82.1631102051630;
 Wed, 08 Sep 2021 04:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu> <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
 <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu> <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
 <1b1c961d-ddba-18de-e0ff-fd8cf60f5da8@kit.edu> <74c59a8b-9475-6554-7d93-f9c5f26cc652@criteo.com>
 <2df22c68-6040-298e-4512-752cd10b7201@kit.edu> <5015f1e3-eaeb-ef9e-e530-83c21db5aeb7@criteo.com>
 <e41a49a8-f5ea-9f50-0327-dd2af9487153@criteo.com> <77b67cc0-30c1-70a8-438b-f1bcf1fdb295@kit.edu>
In-Reply-To: <77b67cc0-30c1-70a8-438b-f1bcf1fdb295@kit.edu>
From:   Sitsofe Wheeler <sitsofe@gmail.com>
Date:   Wed, 8 Sep 2021 12:53:45 +0100
Message-ID: <CALjAwxgM65_vfrBkvGksoyO6vgR1dx4aPtGJSqRhm-gieHKgyA@mail.gmail.com>
Subject: Re: Question: t/io_uring performance
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Erwan Velu <e.velu@criteo.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

(CC'ing Jens directly in case he missed the previous messages)

On Mon, 6 Sept 2021 at 15:28, Hans-Peter Lehmann
<hans-peter.lehmann@kit.edu> wrote:
>
> Hi Jens,
>
> not sure if you have read the emails in this thread - now trying to addre=
ss you directly. Both Erwan and me are unable to reproduce your single-thre=
aded IOPS measurements - we don't even get close to your numbers. The bottl=
e-neck seems to be the CPU, not the SSDs. Did you use some special configur=
ation for your benchmarks?
>
> Best regards
> Hans-Peter
>
> (I have also reproduced the behavior with an Intel processor now - the si=
ngle-threaded throughput is also capped at around 580k IOPS, even though th=
e SSDs can handle more than that when using multiple threads)



--=20
Sitsofe
