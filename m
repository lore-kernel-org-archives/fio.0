Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31F8C433FE
	for <fio@archiver.kernel.org>; Wed,  9 Feb 2022 21:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiBIVlJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Feb 2022 16:41:09 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbiBIVlG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Feb 2022 16:41:06 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61301DF28A39
        for <fio@vger.kernel.org>; Wed,  9 Feb 2022 13:41:04 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id g4so2449523qto.1
        for <fio@vger.kernel.org>; Wed, 09 Feb 2022 13:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=JlT97AhYpaTO2vdc1e5MizOolQMqEfteUIViHkaIEhY=;
        b=ok0tEHbY694IazeFQkTNwfA4BPdHOtrbFt8Z6vIOMJnYakhV9KiQFjf0gjW/EJ9V7N
         a6X19oZ7d3ls6APGAnF6uLpxpVoPE77Lgl9zYoZE5xlZjmojMC3vOaOsbWsFgEnl1wkQ
         NOJpYG5XiIxVX8F0RXVpKACSug13URSIzRUX3k6+YM8VC6B7p28993PbC7KkLndrmDif
         O3CYQ2I94aqNYHjrLbmxGLGbdP2hkAmfmHRNCvoCRsn2/2P9txODVYjj67W4EDUs54f7
         tXadgmfsLjRr2MYL0VS3Xfo9ug+6JwrR0fwwOPxWUA7Mh2KA3Hi2+OobfP5ndxpBZ3Z0
         QzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JlT97AhYpaTO2vdc1e5MizOolQMqEfteUIViHkaIEhY=;
        b=QE0lzoRfndhXTpTKbLzZzdW0SVkUpfXNI4vvL7EWu6iwaKr5Ri4Di3feIcMEsiES0E
         OB9RlCm4WQLRaCkZDXGzvDa7E/6hHIP+dUu6qDyqvOm0zGTYuLPQpbhRRa1pkJhBedNw
         D0ACYyNwroBhNhsyYPPD4pxSyT05mbB7NYyKj/uRVc3Fhfr0g7VKe5d6OofHbdKg5Pml
         5sR61pvhxFp5fEzBJ0bSlcbWr2YJjeCMQA/IgKRqkLfW8ytU07sgbunSNN2tLdHZeXOJ
         Pd/ynaFj0cJh0sMJMs4WlkXAp+IBgDJb9hlzUt1G0IYGDDwnSFXBsALO19yYcwLLi86u
         eKgw==
X-Gm-Message-State: AOAM531cUd6bJDxETerRZmFU9LBHkkJSFh9HlTj0kkRYuOgPPboeDz0Y
        r+IHdUApOBiNWlBg212GXBVBXtprsxAPFD/kN1aDSCPlJrI=
X-Google-Smtp-Source: ABdhPJxjrpMWDnXdo0Czzvy4CuXqwLv/zGSnZv6d+wdFdcR599c1gotkO/au7ycE9sUq3vUVLYR+vOiasqhiVNpofjk=
X-Received: by 2002:a05:622a:d1:: with SMTP id p17mr2861600qtw.441.1644442863277;
 Wed, 09 Feb 2022 13:41:03 -0800 (PST)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Wed, 9 Feb 2022 15:40:49 -0600
Message-ID: <CADqNVToXpXgH-1XVeSyrv-Hw0bMfkPPhQSm1=-iLjBxnkGN1+Q@mail.gmail.com>
Subject: Problems with check_min_rate and io_submit_mode=offload ?
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I started trying to use the rate_min and rate_iops_min options. I was
trying to use them with io_submit_mode=offload. There appear to be
some significant issues with it though.

The first is that it will intermittently assert and generally ignore
any minimum specified rate. Why? Because in do_io in backend.c, in the
IO_OFFLOAD case, comp_time is never set. This means that later when
check_min_rate is passed comp_time, it is checking using a time for
"now" that is an uninitialized variable. Sometimes that will trip the
assert in rel_time_since, sometimes not. And when not, any rate
checking is not going to be right.

So I added a call to fio_gettime in the IO_OFFLOAD case under the
if(should_check_rate(td)...)

Now the job will catch when rate_min is not met, but something goes
wrong in the shutdown. Fio ends up in a state where IO appears to
stop, but fio doesn't exit, and ctrl-C will not cause an exit either.
This is because td->error is (rightly) set, so the code after the main
loop in do_io will enter the "else cleanup_pending_aio(td)" and hang
in its second call to io_u_queued_complete.

I think the right fix is to call workqueue_flush before
cleanup_pending_aio (in the error, offload case), so that there is
nothing left in the work queues and cleanup can proceed as it does in
the non-offload case.

Two questions before I submit a PR for this:
1) Does adding the fio_gettime() call in the offload case seem right?
2) Does adding the workqueue_flush in the error case before cleanup seem right?

Thanks,
Nick
