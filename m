Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB2AC433F5
	for <fio@archiver.kernel.org>; Fri, 11 Feb 2022 04:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbiBKEfQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 10 Feb 2022 23:35:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiBKEfQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 10 Feb 2022 23:35:16 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4C2F4B
        for <fio@vger.kernel.org>; Thu, 10 Feb 2022 20:35:14 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id p14so7940359qtx.0
        for <fio@vger.kernel.org>; Thu, 10 Feb 2022 20:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=GbczPbvUXfWHUfZcmpjaihwul/Tm6Yh5kwknHuOMphw=;
        b=m1see04peOPQDudLmCJ+TB6jckmiR3B7+PiX0wJWIi+rrrntKVO2orGfZhVyRRvOu/
         uACZ3iK77YcBwcspe9Rhuc+SyO+gqMV+/VdiMiueJRQ4iQx40QWCE4on3wWFvMvv6FGc
         ElOC4bYdRbv3exWA+Dpe4iS39AVkBz3jJYP+E6tMuKqUJIMBB9/sQP0ELzOoxdMP8vbl
         6hBR3Au7ZHo9znu/7M1ljT9wmtDj4+mxR7ntc7YXCtKd/M7jO5HDTPCi+QLsm7NW+KzC
         yXT2I9GUkuXc2k84pagv9oefT7johvFXs1Vfmwtakekk7Z6TovIcT6oM3xPqRltISW8n
         iTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GbczPbvUXfWHUfZcmpjaihwul/Tm6Yh5kwknHuOMphw=;
        b=YkNBcYV2ahKsne/HsSumEUXF0pLa/Y1U0AL1zc1EnXOdWsl+E0pgEe9KNbOjqSiPMp
         ewXpoTLd/qBDUGYci+ydoO2VOw71VDeaRLuc/eZhiQ/lJ03nuYFgVrO4/SO4d0M3iGMr
         x7+dr0U6OWGvOzvfrZDkML495RZDzQPgz5x6K5mQxrkffH3J8r7rxgmikTEnIdNFr2jH
         BXkcl1nbBi9H/k/QDVhyjm7dOQ6qfvYttPF0/4LxNKrL22WlMFcqTyMtYXKqzd1MYtDN
         yczV2nvOVeHr/ZT5O1BpL6q+pdEK7Vx38JE30Uskh4lAf64q2C4R3J5DTPPAc35/1YwI
         OnyA==
X-Gm-Message-State: AOAM531GGaFwIBO0Xz8x3o9P34NNg4Jb3KiG06nJ7AUhhNqQQguTi+UM
        prXjKk6/OKYpR6pRHH4ghDPxbqJpnU3hmko9iD07fcmQcYw=
X-Google-Smtp-Source: ABdhPJwl2zTSNn0IZtGdvtyqcIBKPyivesKnYJgvn7WKYykncyOcK6f4keYTtJrv7iqvL4ySaLg0VB+rkwodjqZsG+U=
X-Received: by 2002:ac8:5c95:: with SMTP id r21mr7086879qta.27.1644554112493;
 Thu, 10 Feb 2022 20:35:12 -0800 (PST)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Thu, 10 Feb 2022 22:34:58 -0600
Message-ID: <CADqNVTovL9-2wkZFhu8=FXU09aNZP4+4Vj1wEvpvyrr79KXrcw@mail.gmail.com>
Subject: Two points of confusion on offloading and workqueue.c
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I'm trying to fix a couple bugs I've talked about in a previous post
related to offloading, and in diving into workload.c I've hit some
things that have me confused. If someone understands the code well and
can give some pointers I'd be very grateful.

First, is the reading of sw->flags in __get_submit_worker
intentionally not protected by the sw->lock? I'm guessing so, with the
intention that the worst that happens is a submit worker is seen as
busy when it is actually idle.

But this approach confuses me for a couple reasons. First, the
td->io_u_freelist seems to have the same sort of thread contention
issues when doing offloading. The main td thread is removing things
from the freelist while any worker thread can insert into the
freelist, so they all coordinate with the td->io_u_lock. Why not just
use the same approach for maintaining the list of free submit workers?

My second bit of confusion is that the number of io_u's allocated is
exactly iodepth. That's also the number of submit workers allocated by
the workqueue when offloading. Unless I'm mistaken (that's totally
possible), a free io_u will be obtained by get_io_u, will be handed
off to a submit worker, and when done, will become free again and the
submit worker will become idle. So aren't there enough submit workers
that there should always be one idle for any io_u that needs one?

Thanks in advance for your help.
- Nick
