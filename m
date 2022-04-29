Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB04C433EF
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 20:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357399AbiD2USt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380651AbiD2USs (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Apr 2022 16:18:48 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5FB5B886
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 13:15:27 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
        by gnuweeb.org (Postfix) with ESMTPSA id DB08A7E7C9
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 20:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651263326;
        bh=5iABh0xNSnY8Lr86zlw1rYPeqGBmpPrNGv5340RO0dA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HUyFb5EMfz/xsIV9wHue95wV99frgpTkB3AjBJdQP5HT6dNWuUEE4eceIvaLkaQYY
         uI9ppG+7C1Cjrl31ZjrADf3niTxsbqPczaNtSB/OKltcipqiJN2nQlDoaoCwRIz8zs
         LYTC3lVJ9ec4rPRtNI0qtyx4O+UorSAE0VML7S4aCnsGUhxosN1dRdgPJwCXjNkYKh
         gzzgUqxSQqlEYyiiJgmukB25twmCM2zU74MYGcZ25e6KiU6yysusFsq7eNjBDf2vYa
         y6IeHj2E4FMK0SZqvreZzO1EEQqoFYW7fD9geC8VZBKHvu8NXcFBzpkEeNkwqTrs+N
         mEADotgphQBWQ==
Received: by mail-lf1-f53.google.com with SMTP id p12so15938565lfs.5
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 13:15:26 -0700 (PDT)
X-Gm-Message-State: AOAM532LW9n/zi4sn0ks12mP6wUtvUr0jLg7mdI4cT6bvE0CCPBL0/oN
        C9kedv7gYCNcExba/ZgzAKnTmBDV4gLw+yffurU=
X-Google-Smtp-Source: ABdhPJzLlfDWJ9/ktfUaHn+gwF1igi7Q/NoQfyVCs0ha5RTj1lIAYWcTmnjWHjWKoKZnI03sfTrKA1rqgtE/9Pb7Eck=
X-Received: by 2002:ac2:4102:0:b0:472:30ed:e971 with SMTP id
 b2-20020ac24102000000b0047230ede971mr670000lfi.682.1651263324935; Fri, 29 Apr
 2022 13:15:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org> <5a686d0d-63e8-33c5-d59b-dad1bceaae4c@kernel.dk>
In-Reply-To: <5a686d0d-63e8-33c5-d59b-dad1bceaae4c@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date:   Sat, 30 Apr 2022 03:15:07 +0700
X-Gmail-Original-Message-ID: <CAFBCWQKun4kpe-tHKsTUpERwh0zxeUfn1=b6yNU-aRYt8Fdfgg@mail.gmail.com>
Message-ID: <CAFBCWQKun4kpe-tHKsTUpERwh0zxeUfn1=b6yNU-aRYt8Fdfgg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] fio error handling fixes
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Vincent Fu <vincent.fu@samsung.net>,
        fio Mailing List <fio@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Sat, Apr 30, 2022 at 1:21 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 4/28/22 6:46 PM, Ammar Faizi wrote:
> > From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> >
> > Hi Jens,
> >
> > This series contains patches that were dropped from my previous thread:
> >
> >   https://lore.kernel.org/fio/20220428203954.222165-1-ammarfaizi2@gnuweeb.org
> >
> > Plus, I have more patches in this series. This series contains error
> > handling fixes, mostly about ENOMEM. There are 8 patches in this
> > series. All of them are ENOMEM handling stuff except that patch #4 has
> > extra fixes and a bit of refactoring.
>
> While I agree on good error handling in general, I'm a bit dubious at
> malloc() related NULL returns. Have you ever seen malloc() return NULL?
> On Linux, or somewhere else? Most systems overcommit themselves to
> death, and things will death spiral before you ever get NULL.

Yes, you're right. malloc() returns NULL is a very rare case. I don't
think fio users will ever see that in general.

I have seen malloc() return NULL when a program is in jail (e.g.
inside cgroup, or whatever that puts a limit on the memory resource).
But obviously, it is not reasonable for fio. Although that's one of my
motivations, it's actually not the main one that brought me to do this
series.

> I'm happy to be convinced otherwise, just naturally skeptical that
> there's any real value in making changes like this.

I am a bit bothered seeing inconsistent error handling in the
codebase. From what I see in the fio codebase today, sometimes we
handle ENOMEM cases, sometimes we don't. I want to make it consistent
in the hope we can improve the quality of the overall error handling.

If you are fine with that, I can send more incremental patches for
review in the future to fix those inconsistencies. It may be tiring
and progressive work. But I am okay doing that.

However, if you NAK this series. I will start fixing other broken
things I can find, like in patch #4 for example. And that's fine.

-- 
Ammar Faizi
