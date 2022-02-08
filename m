Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1445CC433EF
	for <fio@archiver.kernel.org>; Tue,  8 Feb 2022 22:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387552AbiBHWY5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386917AbiBHVUq (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Feb 2022 16:20:46 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336BEC0612B8
        for <fio@vger.kernel.org>; Tue,  8 Feb 2022 13:20:45 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id t17so268120qto.1
        for <fio@vger.kernel.org>; Tue, 08 Feb 2022 13:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IhtDGIlvmyShVevipdvmZMdQd1Y+Dq83OLckaqXRY3k=;
        b=GS3MTVzBjIfxJWXldfuqBz4TVkFlxgeKJ4nGmopCfdJOjTjmnPdWk46BRCDtaCqK7m
         l4raTONrEY6++ZaPhFQbKSUTGjk6dmHmekTLvSpDzuflQQ9I1TTEF+POq5LuFo8Fpd3h
         8dFFXJzGBuT5jWg4icXj25m4lNgOKP0wJ6iSsMU9J2fsP2sw43LKt9fSYmkqx8K6UFi6
         WMLqOz0nbHFIlkJDDT/+6tOdqoWZuSslmWLXQQ6lgfzmBNe50bTH95Z9NS1ckFYP6Lk5
         ysJS1H2SSdTXgMSwio7Ned82fzJTBwA83Ea57zYOQXGHoJKNWf96sKZNaGOcTJ8vjKG4
         zDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IhtDGIlvmyShVevipdvmZMdQd1Y+Dq83OLckaqXRY3k=;
        b=KPEef36QYW3XRyXFhE6IPbFz8+gtf0jxt0kiVggcwF7ydm2qVBdw0Ft59azRe3vx0+
         pEIIatBbmzhcywGKb2CjFnEsbPUIuCfz2DKASVxqrOSmCidRtywrY9Gm8BV2WfftFiSq
         HP4nQl11XgS9r8zUZN31nl+ALYbXyEr587RCeCw94HD4kUVabdwhY3wrnx2YfXOj+W5O
         cTQQ/CSJ4sMi3p0sGlygGnFr3Rn6XHLh42Ys7tj42PbmFpIsKbHfNbs6aF8e3ue4lWOQ
         DHSiiKQp6C5QV2lnohVeCFG8HNP3SsDS8j7scWc2oht46ltfgarYtk7Qe9rj+1bcRNdz
         waSQ==
X-Gm-Message-State: AOAM530edUkVoXaA3oprdKwL6wrVybNda5asXQEfo6SyiInx6UxmFrUe
        8Kr7AKxjrpigB6MMyqs8Ktd2SgXwcOmDN+v4/5ZfKAqB0L8=
X-Google-Smtp-Source: ABdhPJxxzxnlQvRQGDM+jjddVCOv21Dm+uJGTHzNvTbopPOUL6FwRuSbdn2dWDJVLg2z+xA++GQnzlAUHRVd3kc+S3Q=
X-Received: by 2002:ac8:578e:: with SMTP id v14mr4399051qta.345.1644355244259;
 Tue, 08 Feb 2022 13:20:44 -0800 (PST)
MIME-Version: 1.0
References: <CADqNVToxJ4e5ad+YESuhD5SMy9js4cwMd8=7xcXFf7rW8a3+ng@mail.gmail.com>
 <YgLOxOwzMOUfmKkF@x1-carbon>
In-Reply-To: <YgLOxOwzMOUfmKkF@x1-carbon>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Tue, 8 Feb 2022 15:20:32 -0600
Message-ID: <CADqNVTos8PGkv5py42zWR6DXY=97X5kxHANHLe0cRBMQb2c37A@mail.gmail.com>
Subject: Re: Fio docs say io_submit_mode=offload with async IO is not reliable?
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 8, 2022 at 2:12 PM Niklas Cassel <Niklas.Cassel@wdc.com> wrote:
> Original commit disallowed offload for all async ioengines:
> https://git.kernel.dk/cgit/fio/commit/?id=abfd235a05330eae8444f0e4c0039bbdf9f160a3
>
> Later it was changed to be disallowed only for io_uring:
> https://git.kernel.dk/cgit/fio/commit/?id=8bfe330eb42739d503d35d0b7d96f98c5c544204
>
> So I assume that offload works fine with libaio.
>
> Perhaps the HOWTO, man page, and the comment in check_engine_ops()
> should simply be updated?
>
>
> Kind regards,
> Niklas

Ah, thank you very much for finding and sharing those. That is very
helpful. If Jens or Jeff Furlong has any memories of some of the cases
with io_uring that are problematic, it would be great to know - I
could include mention of them while updating the howto/man/comment
Niklas mentioned.

At a higher level, would it be considered "unusual" or "non-standard"
to use offload with libaio (or really any async engine)? I guess in
some sense it is, because when your using offload, you've got a pool
of iodepth threads/workers running to perform the io, so using libaio
is not going to help those workers, but will really just be adding
another layer of async overhead after the async interface already
provided by the offload pool. Further, a real world app that is using
a threadpool to handle its IO is probably not using libaio as well.
Does that line of thinking (async engine with offload option is
unusual) make sense?

Thanks,
Nick
