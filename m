Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5C2C4332F
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLAWOv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLAWOr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:14:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA04897932
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L7yV8VOzJznqlcFpf+xi56O1OHdcQy+5/t0nG46sbV0=;
        b=MjMhG1X2XkzxfVwEVzUzWXirkUpKtkwFf1MizEvKxW6wkAewUwSNysH7WCkPMta3QeD/og
        YIl/OqbTHIEz3K1yNdAYHZpFNc95xUzWZ94Rhrwn/HMjr+Gy7iWbgxal7el/ffoGZnkYo6
        6fsO6zdT09eQbr/tVdjYqwFwcSX6kYs=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-427-Y7xIqOO0M0GIHjohGR5F9w-1; Thu, 01 Dec 2022 17:13:41 -0500
X-MC-Unique: Y7xIqOO0M0GIHjohGR5F9w-1
Received: by mail-ot1-f69.google.com with SMTP id a66-20020a9d2648000000b0066db1bff57eso1419464otb.14
        for <fio@vger.kernel.org>; Thu, 01 Dec 2022 14:13:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L7yV8VOzJznqlcFpf+xi56O1OHdcQy+5/t0nG46sbV0=;
        b=vM07rGKj0LgxFi4BQLHMF/ARvazRa8jbwuQ5vIPVPIHqmIa61epIw/JeX3ktPA5b/P
         UtEBFHd2uB6HqKCBaRZcDXeHR0OViJEjsA7Bn/2PywKDLvFyR2cGfeucYOVMV5Tv1eO5
         iaHo5EseD6/GBMDfPBC1vo3N8EOswHrldDp/+CoqBuTIkG2s2YJwuNq8WLDF1nqpiLuP
         UUJLgnyIpf67RHxg43K0ju10yNahNwOtF2DOV1MuUNGyoCHvofwnZL2/HVfhagdvC0Nq
         uZUXVW7K6YS7JkL2E7KXIUV8uC22KJt/Wun79sLh4kVlQwIFMGDMfQc31+1k8ClzhpyD
         vJWw==
X-Gm-Message-State: ANoB5pmc2X8Brw+JKmqRHQgRSbaiNHzxUoY5fXfojurrnvPrXzPz0LQg
        YNxvlzm34JU0MK6S6Y4eQB2RbjLi/zqF5rBritQnMU9jOM0e3ef9Lo6YiUz5p3dP64t+gbOinb5
        ZJlq9TEk9OAOAFshZb5qA5ryPWF4f
X-Received: by 2002:a05:6870:1b84:b0:143:f230:df22 with SMTP id hm4-20020a0568701b8400b00143f230df22mr7180622oab.10.1669932820811;
        Thu, 01 Dec 2022 14:13:40 -0800 (PST)
X-Google-Smtp-Source: AA0mqf74w89/IyCqRlYDzLGldrGLVu2PmBE8OOtGO45XAiwrsrYdte6N9/ShLLqi68cHAKQe9ubhzPvwT0F2EsVmh2s=
X-Received: by 2002:a05:6870:1b84:b0:143:f230:df22 with SMTP id
 hm4-20020a0568701b8400b00143f230df22mr7180614oab.10.1669932820641; Thu, 01
 Dec 2022 14:13:40 -0800 (PST)
MIME-Version: 1.0
References: <20221121182902.373491-1-afaria@redhat.com> <20221121182902.373491-6-afaria@redhat.com>
 <2fbfff28-30a4-97bd-fd2b-e48bb8b837d4@gmail.com>
In-Reply-To: <2fbfff28-30a4-97bd-fd2b-e48bb8b837d4@gmail.com>
From:   Alberto Faria <afaria@redhat.com>
Date:   Thu, 1 Dec 2022 22:13:05 +0000
Message-ID: <CAELaAXzDEnXdFG3JOi4ZWKRFbMjEnmEyUMk_CibABAjQsxwEnQ@mail.gmail.com>
Subject: Re: [PATCH 05/10] engines/libblkio: Add option libblkio_vectored
To:     Vincent Fu <vincentfu@gmail.com>
Cc:     fio@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Dec 1, 2022 at 5:11 PM Vincent Fu <vincentfu@gmail.com> wrote:
> On 11/21/22 13:28, Alberto Faria wrote:
> > When enabled, read and write requests are submitted as vectored requests
> > using blkioq_{readv,writev}(), instead of using blkioq_{read,write}().
> >
> > Signed-off-by: Alberto Faria <afaria@redhat.com>
> > ---
> >   HOWTO.rst          |  4 ++++
> >   engines/libblkio.c | 46 +++++++++++++++++++++++++++++++++++++++++-----
> >   fio.1              |  3 +++
> >   3 files changed, 48 insertions(+), 5 deletions(-)
> >
> > diff --git a/HOWTO.rst b/HOWTO.rst
> > index cdea3258..b9c7c8df 100644
> > --- a/HOWTO.rst
> > +++ b/HOWTO.rst
> > @@ -2875,6 +2875,10 @@ with the caveat that when used on the command line, they must come after the
> >       set after the engine sets any other properties, so those can be
> >       overriden.
> >
> > +.. option:: libblkio_vectored=bool : [libblkio]
>
> See my response to the hipri patch regarding the difference between
> booleans and FIO_OPT_STR_SET. I don't have strong feelings regarding
> whether this should be a boolean or FIO_OPT_STR_SET but if the type
> listed in the HOWTO and manpage is boolean then the type in the options
> struct should be FIO_OPT_BOOL. No type should be listed when it's
> FIO_OPT_STR_SET.

Thanks, I went with keeping FIO_OPT_STR_SET and not listing the type
in the docs in v2.

Alberto

