Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C68C433F5
	for <fio@archiver.kernel.org>; Thu, 12 May 2022 06:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350165AbiELG3I (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 May 2022 02:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350355AbiELG3G (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 May 2022 02:29:06 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF88E19FB03
        for <fio@vger.kernel.org>; Wed, 11 May 2022 23:29:04 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id bx33so5208009ljb.12
        for <fio@vger.kernel.org>; Wed, 11 May 2022 23:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LyZ/ievhzXZWJ7bmer/AqeSBMGIoRyt2Nory/Zb/TKU=;
        b=Len2vx9OOXakxww8YX/oR6YPwjGGvx01KczoOr/ESRZqeC2VkfG/pxoBx6/VKu5gXq
         s523xJG9P9jaEaU2txZ9MCPVmD68fYTsANjiwraIcKEWXK5Yb4Xev1WkUwqLlPvefWr4
         NMXmjcZfuI5Prs47GoFW/NMnHmCV7f4wrWqvyNfyvqmceUpIu/gapRWCbIqCIjdGErPU
         /YVo+ZVQ4lai3faNdUQmSDnFsatOuG8d5UqLtinEFTmWtI7vfMOz67pH953xJ6cJR7eC
         UshZIrH4hdQuCu6WjLN6molbqyceoxEJxwFT3k2uEfmogn2HXFLIl8Nv7Z8jZEt4R4eQ
         Yjeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LyZ/ievhzXZWJ7bmer/AqeSBMGIoRyt2Nory/Zb/TKU=;
        b=YveswGYoU7nIIhyysqoywik00g4TyJot+JWU1Mc1bh9paAkfGxuhPv7orDLQN/lqJj
         pMutd4OdMToOn0Ikc0RtLeXbGtd4HFDYciWYNp2NQj9u6MqwbldkDGSajDl5LcmUWDta
         6VVEBNqVUR0fGs4ijjJOV4FklMCu5MlmkLHilN3odXHS0cFeNEdExC39hlxzn+hv7edn
         sUcPrb9FB3dneJ8ux1aBheLxvgBBkWNMssDDlZc27phHUUom0Bw77L9/bDAki1nHQZaa
         bx00dNY29tVCLZvUDnwcwoVcMgZddoX/Lu2eDVwoMEFoCZEB3pzuGwZOeR8JxdQF7pTA
         QBpw==
X-Gm-Message-State: AOAM530vvilqwaqgRXX2vdJVabXcwxhUOm3FmZRr6dpFK/s11mtFjaW/
        Ghy8CbgsiUHRpLkd3I3OsZQ6k8JLWryp+SRxheE=
X-Google-Smtp-Source: ABdhPJwsh/rGvFAo13tXpIw/RAZeMaEAnBnChy+uufizs/NfbcsG/tiQDwSWhOOJaIZaqgz4ierOjUJn9Dg/I09KSP8=
X-Received: by 2002:a2e:bd13:0:b0:246:1ff8:6da1 with SMTP id
 n19-20020a2ebd13000000b002461ff86da1mr19652857ljq.219.1652336942802; Wed, 11
 May 2022 23:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220511163552epcas5p4c2e1b204a47a543c24f84da89ef0c89a@epcas5p4.samsung.com>
 <20220511163019.5608-1-ankit.kumar@samsung.com> <698673c0-0fc4-671c-15da-0fb7a053da41@kernel.dk>
In-Reply-To: <698673c0-0fc4-671c-15da-0fb7a053da41@kernel.dk>
From:   Ankit Kumar <ankit1455@gmail.com>
Date:   Thu, 12 May 2022 11:58:52 +0530
Message-ID: <CAKi7+wew31=A5ZF+t2b479-zkrObRs+ze+-o0MVKX6kcfWP9UA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] fio: add xnvme engine
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ankit Kumar <ankit.kumar@samsung.com>, fio@vger.kernel.org,
        krish.reddy@samsung.com, simon.lund@samsung.com,
        joshiiitr@gmail.com, anuj1072538@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Yes we are using xnvme on various platforms, and it would be great if
it gets included as part of FIO.
For supporting io_uring engine with passthrough, yes we also have a
plan in place to clean up the code and send it for review.

On Thu, May 12, 2022 at 2:52 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/11/22 10:30 AM, Ankit Kumar wrote:
> > This patch introduces a new xnvme fio engine.
> >
> > xNVMe provides an API for synchronous and asynchronous I/O.
> > A library backs the API, libxnvme, which provides implementations for API users to
> > run their I/O application on Linux, FreeBSD, macOS, and Windows without changing the application code.
> >
> > Implementations of sync. interfaces include:
> > * psync (preadv/pwritev)
> > * Linux NVMe driver-ioctl
> > * FreeBSD NVMe driver-ioctl
> >
> > Implementations of async. interfaces include:
> > * io_uring
> > * io_uring_cmd (experimental)
> > * libaio
> > * POSIX aio
>
> Is the plan also to cleanup the passthrough support for the io_uring engine
> and submit that? I'd personally find that a lot more useful than this xnvme
> engine. I don't mind including it if you guys are using it and find it
> useful for testing xnvme on various platforms, but it's not something
> I'd personally use.
>
> --
> Jens Axboe
>
