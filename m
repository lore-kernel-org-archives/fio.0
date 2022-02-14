Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B756C433EF
	for <fio@archiver.kernel.org>; Mon, 14 Feb 2022 23:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiBNX4h (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Feb 2022 18:56:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiBNX4g (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Feb 2022 18:56:36 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6FE5FB9
        for <fio@vger.kernel.org>; Mon, 14 Feb 2022 15:56:28 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id f19so5651830qvb.6
        for <fio@vger.kernel.org>; Mon, 14 Feb 2022 15:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3qbvpZ8nlC0fjHQwcmQNVvGyqSHSsgsplAF2/rWyCGI=;
        b=gFqwizyz2hwX5+q86Rvo8ibcSq7NHjKEap7GOUP8Mt9YzfnYhVJC4mYAZCNWR0Drnn
         jkW62RUWyvqElAGzC4xMgB9cIPd6aPeZKrSXru0Ovu+tC1qp2DDbZae9b3MbeKGWOARC
         9fl0uJ2RbaPx4LCK95sxiiJF/nBGqvnkq14TJLbXB0ZMtiLFuluxOLsj73IrkyEJQkDt
         1o36ZukgoWntuodeNcHbMCkcLLAwcqTGfobycPDdXvRFoTuhE1UkI7rMkAN62j2OdyQ6
         5j2KnSQPuMGniapKay/CblYqj5tmz6uknOJm1ZIH68kM5K/ayVcqf9ulqBqnlYx5Rgpe
         pR5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3qbvpZ8nlC0fjHQwcmQNVvGyqSHSsgsplAF2/rWyCGI=;
        b=gN32DP4I5kjbyOrtk1di3kVFYcBdr60N+vjXyEMe6VqYwQq5E5gM3B7a95WPRU104R
         iuFko+zpA3qLxycA0beIdxEUwQnkk4WbNoJmu6EN0LFWNjuPsZFVAz9m2QVoMcKxIcvc
         Wyb3rws2gUUAQPCZFQ+0QYoXvECtLkykGjTG0hd/Vy7X5372unbL5itreVkKI7t1E+Lu
         gk5i4GYGhoCtAZaXe+fmG0FLhm0LfW1KWSR3Em/4qVFiroqRgJ72PAto9yzFc2EMms11
         DFGq6RA9scuTs7AHbq3AH2eWroEkBbdwkMeeP3wek/PT1D3NjuzJ+koYnLtNLpG75X84
         wTog==
X-Gm-Message-State: AOAM532edtQ6hVRS5YL4u3sOFc5ChRBc997yfmSaC737/2IUMcmGHG/r
        NnaePWCykM9nw/R1iUiL1iAJlh+K/eQj4RHuQY55l/lEALbSDw==
X-Google-Smtp-Source: ABdhPJzEO+CGkYcAXepr9QgY87oSBd6pNSgP7kU5tT6Nxc37u1bq++RRE5b/XgUcUG2h/1Ze1ONljcrXljzcOjK7FX0=
X-Received: by 2002:a05:6214:3cd:: with SMTP id ce13mr820240qvb.54.1644882986923;
 Mon, 14 Feb 2022 15:56:26 -0800 (PST)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Mon, 14 Feb 2022 17:56:13 -0600
Message-ID: <CADqNVTrp==vpb5H5Ti2o52zbAYqskfT4hG10QBtkBhd2yn1eFA@mail.gmail.com>
Subject: Still some cases where min rate checking will fail - how to fix?
To:     fio@vger.kernel.org
Cc:     axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I recently submitted a PR that was merged to call fio_gettime in do_io
in the IO_MODE_OFFLOAD case because comp_time was uninitialized in
that case and so the minimum rate checking didn't work, and would
sometimes assert b/c we were dealing with a time that was
uninitialized:

https://github.com/axboe/fio/commit/5b28b75b8cca843d616d2d54a77fdb5797c00f54

After fixing this, I noticed I was still getting intermittent asserts
for the same reason in the non-offload (e.g. regular) case. Indeed,
the calls made in do_io in the non-offload case are to io_queue_event
and wait_for_completions. But it is possible that wait_for_completions
is not called and both io_queue_event and wait_for_completions do not
always fill out comp_time. So the same problem can still happen. Once
comp_time is filled out for the first time, asserts will not happen,
so an easy fix is to initialize comp_time to now at the beginning of
do_io, but I have no idea if that is actually the correct fix.

To fix properly I need to understand the idea behind what comp_time is
supposed to represent and why it is not filled out sometimes by calls
to io_queue_event. Should we just always be calling it when doing rate
checking before we call check_min_rate, or is there some reason we
don't want to do that? Was it ok to always call it in the offload
case?

Thanks,
Nick
