Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 650B0C433EF
	for <fio@archiver.kernel.org>; Wed,  2 Mar 2022 18:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244750AbiCBSuq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Mar 2022 13:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiCBSup (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Mar 2022 13:50:45 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB5AC5DA5
        for <fio@vger.kernel.org>; Wed,  2 Mar 2022 10:50:01 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id b20so2049256qkn.9
        for <fio@vger.kernel.org>; Wed, 02 Mar 2022 10:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2WXi8xomq8guExdW0mSKQYmjtr7/39eEADRvkRNIfu0=;
        b=npURl+Zbwii+nWleIVYwdYK6xc7W8eyOXYSI8vCrwpJ6gme8Wt+jtw4cqRGGuuS7RN
         FCVGTcCUfClIySHdTdP2LXseWmGNmvLhi69xP4Th6cQXrXkqlmVawAeD/cmMAPwthUXn
         jHzUMwSTNJLJXSZ+4imv4OHeRFmmnhYULDOLTPDn+Fw++8pVjxS74Uh9CIrtTGsbgQW9
         G96qeVrP22rPKfHhjcqTKkKx8Ht/oLF+s/60IH3IXGPbC9i8YDZB6Zfaftj0T5JgmzOk
         XWYlzIH8Jj5dj3xCLeVjpEK8G5EBoMs9hvkbshk4yCItFKE9wkmLdj6uOvmyG0ST2hAo
         Ea3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2WXi8xomq8guExdW0mSKQYmjtr7/39eEADRvkRNIfu0=;
        b=bcRHk70D3zDqcc5SMMpyppTO3syRcMVgmy0wPRbHW5VDzgxK4Zh44v6+FLea1W/Ltc
         855b9XxGm8aBuPSc787h7CbRgZULL2oRwHiHC+o+bv5NCTSEcBFukheT4Sf9ocTJuamA
         nzIpacK5SsKfPZXnp3gw0T9cL89duBlHrB5lUvBMU6ZnhKOF+Mu4ab+Bq64aFhvjM4Bi
         bY0Mlb1m6RcbkTddGcRTEivkqpdhf4bugkVRZEr01zyIqohmFJcQXve++77HNEbOts6u
         LdI7SsqhBGGdqST4AHMGoEldLojhsNbqf74/H/GnuAd3GTwCMyTwwmqv3D6Db5femH/s
         Y7sQ==
X-Gm-Message-State: AOAM5332oZToWjrlvG8NJROBwoAyGHVP/ZSQ6TyrZQOmLmjlHjqdP3EL
        wQgGogWy+Wi17hg1bt32kCvq+V43p8M3BtQgORHyiQsg6+Q=
X-Google-Smtp-Source: ABdhPJzSQJyD8BF1F++D/2yqwxNcQPRLVHKkRUJ+LnrloXBEZFK/7O42La5Zb69rG9aU5xEUAucpcixqBitSi6dk4KI=
X-Received: by 2002:a37:4649:0:b0:47e:cf47:48af with SMTP id
 t70-20020a374649000000b0047ecf4748afmr17745817qka.605.1646247000569; Wed, 02
 Mar 2022 10:50:00 -0800 (PST)
MIME-Version: 1.0
References: <CGME20220302152806uscas1p15ec3066c15b2e0d2ce9974e37d80ee2a@uscas1p1.samsung.com>
 <20220302152122.64596-1-vincent.fu@samsung.com> <41bcb630c61d4ecd965654d328e95c96@samsung.com>
In-Reply-To: <41bcb630c61d4ecd965654d328e95c96@samsung.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Wed, 2 Mar 2022 12:49:49 -0600
Message-ID: <CADqNVTpS73RtmkcbF=-w3WfKF3Z4QY6-Qvka7JV-DY-0EHOweQ@mail.gmail.com>
Subject: Re: [PATCH] docs: generate manpage from README and HOWTO
To:     Vincent Fu <vincent.fu@samsung.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "martin.steigerwald@proact.de" <martin.steigerwald@proact.de>,
        "sandeen@redhat.com" <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Mar 2, 2022 at 9:28 AM Vincent Fu <vincent.fu@samsung.com> wrote:
>
> > -----Original Message-----
> > From: Vincent Fu
> > Sent: Wednesday, March 2, 2022 10:22 AM
> > To: fio@vger.kernel.org; axboe@kernel.dk; martin.steigerwald@proact.de;
> > sandeen@redhat.com
> > Cc: Vincent Fu <vincent.fu@samsung.com>
> > Subject: [PATCH] docs: generate manpage from README and HOWTO
> >
> > We have a longstanding problem where fio documentation updates must be
> > made to both the HOWTO and manpage.
> >
> > Here is a solution that generates a manpage from the README and HOWTO
> > using Sphinx.
> >
> > The downside to being able to maintain only one version of the
> > documentation is that this will cause a bit of trouble for those who package
> > fio and users building fio without Sphinx support will no longer have a
> > manpage.
> >
> > Does this seem like a reasonable tradeoff? If so, I will follow up with patches
> > to remove the original manpage and update the Sphinx-generated manpage
> > to have the standard NAME, SYNOPSIS, DESCRIPTION, etc layout.
> >
>
> Oops, this was intended to be a RFC.

I'm fairly green in linux so I'm not sure about the Sphinx
implications, but single-sourcing the HOWTO/manpage would be really
nice. Also, the documentation for command-line options is actually
currently triple-sourced (HOWTO.rst, fio.1, and options.c). It would
also be nice (not asking for now, just wishing for someday) if all of
the options documentation could be single-sourced, likely from
options.c.
