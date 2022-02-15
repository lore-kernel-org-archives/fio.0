Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550AFC433F5
	for <fio@archiver.kernel.org>; Tue, 15 Feb 2022 18:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbiBOSIP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Feb 2022 13:08:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiBOSIO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Feb 2022 13:08:14 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B25DD97B
        for <fio@vger.kernel.org>; Tue, 15 Feb 2022 10:08:03 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id de39so8522886qkb.13
        for <fio@vger.kernel.org>; Tue, 15 Feb 2022 10:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AojnWI93zgG6oQpd+pDQGsgLg4Q1otU9FPREZn8isRI=;
        b=ORvSLPLlC0Oc+S7w5pg5yF44qMQZvdF3zCJ7EE8h438aKWYjZZaurFYDqQG1WULy6a
         V5aaobGRDklolbxxJ2xh9d+gGibeeqZ/dIIZTcEsvZtbuSxUeFwISzK01K3nDyxLWFdC
         nmi1GNkBzkXMAaFCysGcS/wYuSj03JKn3/ZZH44klKaPP9tbmn8xR2BQb1j81H7tARx9
         5Vth7+LgOGs4g9UJ6ipiCobvA6e/iutPuJ4QubiHvm5oN84g2GeyijPwFVYyMqWh74NC
         3ppupXuhvj8J+3ypb1g/1144hD+NEh5G3DPdugFMflyuiUjHHFtBDghmz0J9C5MB8OnN
         /68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AojnWI93zgG6oQpd+pDQGsgLg4Q1otU9FPREZn8isRI=;
        b=6peEOChlhi8fsezT+V+TdepRZAsIPHh9Nz86FlwuXTNtrS9ZaagooUW5tt7AG+7egA
         2DFEL72uzjWRKOznAOyPBbzK+Rs6eTgqcEptVfGG44Ua4L2dqj8M+tZe8wc8LzVReAXD
         oRudthpxjwtRNZY0gGuagbNUnkvt1VC9Oaz0OSJg+z223xtJQncy2SIIEbK6CKCiJPDG
         xaKfYdy+FjIfHkvxva8m5mWj5MV0aTiSTRLHN1icGRNp22VlVNJmtbCUe/U45Zvler+X
         H8KWg8zonLR5PlVtxlhtPXrVkhPnYqdQPrPEWr30URuGiMexMWR7feYefPnXMTy3G1R6
         5tmQ==
X-Gm-Message-State: AOAM533G/Gmwv/pE5SMRBK/Hh46yI7237iw2U2Xr83+q5WR7BJRcxCID
        ONSsuW4w3nee9uXxAXFE7FCxOSZmDopVbVwWpB09gEp3zkI=
X-Google-Smtp-Source: ABdhPJx75lFHtsxKO6mzSceoCHCXXkNHy4Wgeqe/TVUGfpWV5lu9PyEAHAAhJTP8jmOv9uFcWxFgLeSIhdPJu9b63VE=
X-Received: by 2002:a05:620a:4251:: with SMTP id w17mr136014qko.284.1644948482626;
 Tue, 15 Feb 2022 10:08:02 -0800 (PST)
MIME-Version: 1.0
References: <CADqNVTovL9-2wkZFhu8=FXU09aNZP4+4Vj1wEvpvyrr79KXrcw@mail.gmail.com>
In-Reply-To: <CADqNVTovL9-2wkZFhu8=FXU09aNZP4+4Vj1wEvpvyrr79KXrcw@mail.gmail.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Tue, 15 Feb 2022 12:07:51 -0600
Message-ID: <CADqNVTpKgHTW5vUjLndp3igLWMXAqiLhy=_2B3H-OtwGcAkBsw@mail.gmail.com>
Subject: Re: Two points of confusion on offloading and workqueue.c
To:     fio@vger.kernel.org
Cc:     axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Feb 10, 2022 at 10:34 PM Nick Neumann <nick@pcpartpicker.com> wrote:
>
> I'm trying to fix a couple bugs I've talked about in a previous post
> related to offloading, and in diving into workload.c I've hit some
> things that have me confused. If someone understands the code well and
> can give some pointers I'd be very grateful.
>
> First, is the reading of sw->flags in __get_submit_worker
> intentionally not protected by the sw->lock? I'm guessing so, with the
> intention that the worst that happens is a submit worker is seen as
> busy when it is actually idle.
>
> But this approach confuses me for a couple reasons. First, the
> td->io_u_freelist seems to have the same sort of thread contention
> issues when doing offloading. The main td thread is removing things
> from the freelist while any worker thread can insert into the
> freelist, so they all coordinate with the td->io_u_lock. Why not just
> use the same approach for maintaining the list of free submit workers?
>
> My second bit of confusion is that the number of io_u's allocated is
> exactly iodepth. That's also the number of submit workers allocated by
> the workqueue when offloading. Unless I'm mistaken (that's totally
> possible), a free io_u will be obtained by get_io_u, will be handed
> off to a submit worker, and when done, will become free again and the
> submit worker will become idle. So aren't there enough submit workers
> that there should always be one idle for any io_u that needs one?
>
> Thanks in advance for your help.
> - Nick

cc'ing Jens in case this is something he might have some thoughts on
