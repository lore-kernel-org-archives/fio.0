Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A41C4332F
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiLAWMB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiLAWL6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:11:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB4743869
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tQdSlEz/2eMuvr1VjZt7oosqgFr8f1NbzyKpqREdzfw=;
        b=WabvNrCNExJ9srCjPxf3DsDlZas9839mdsS9s1bNPTTAy72vAHULYC7pS7iu2NwF80douM
        eG3zOwH8Io+nyau1J3krQt3S/VHCvrP7irvVGPt9jtyQGx4E0LZNZ/YlhI4H+HMn72won+
        9PshtHBq2I/XiF4GDAIKXErPT1MPV6k=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-295-ihOG4gQWMQarBuDP6JFXog-1; Thu, 01 Dec 2022 17:10:56 -0500
X-MC-Unique: ihOG4gQWMQarBuDP6JFXog-1
Received: by mail-oo1-f69.google.com with SMTP id x13-20020a4a9b8d000000b0049eeca57fbcso951087ooj.9
        for <fio@vger.kernel.org>; Thu, 01 Dec 2022 14:10:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tQdSlEz/2eMuvr1VjZt7oosqgFr8f1NbzyKpqREdzfw=;
        b=RdRh1t2c/B+a2wyKsU8ET9izv8JaY8kpv8v5uMnhd99QxZgebQegRpPx4bGNB8FVFW
         XUiFbUHrfToZdXJpe3kunBqtn4DinS2i7x/YroU1e0z42H1KfoSBp7fo1K+Vo1piZQJw
         eJItjd5OfbyZ00CjBKgtIJX40PeqxaP5Uf4+Ou+bA3NFnTmQzeKl5dbyNx78X2W7cWwH
         h6rY2jmms4Gy9zjbeI5A4zT7hVMaDC2iMnim5YOvaTyddi6SwJp18hyl8GUTJz4BS91X
         JGhA6LwVuaJrj5CT28uZH/KlbuW3YfHmwtY6+/4r2btKD6ngtl0jDzXRzwoBtiNeZYli
         FjNQ==
X-Gm-Message-State: ANoB5pm4cnGEApXLb6PsxUkCYAto1CcN01phdWjUcBRprBLD1nDyE85R
        pSHcfqVzYfGCltqR45KVNqDUQgiQqzCt9gKS1Qd9Dgftzfb3bWh+3QazgrGhG7vclBMYo4K0bkb
        by2FgDSEwr2CzVsm6YNyJ4VNcsRSW
X-Received: by 2002:a05:6830:1459:b0:661:b84c:6b0a with SMTP id w25-20020a056830145900b00661b84c6b0amr23945104otp.186.1669932655819;
        Thu, 01 Dec 2022 14:10:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4P57nDGK3/PsyxvX+LsPkEiaLxQGaxrbs0Va4JvFL6NSp/+2u9mlrdYtAwh8jtqFfhcQj1zkoGnWWCqd9AYiQ=
X-Received: by 2002:a05:6830:1459:b0:661:b84c:6b0a with SMTP id
 w25-20020a056830145900b00661b84c6b0amr23945091otp.186.1669932655565; Thu, 01
 Dec 2022 14:10:55 -0800 (PST)
MIME-Version: 1.0
References: <20221121182902.373491-1-afaria@redhat.com> <20221121182902.373491-2-afaria@redhat.com>
 <1cf55b08-ed07-4f3a-6155-0fb0027555ff@opensource.wdc.com>
In-Reply-To: <1cf55b08-ed07-4f3a-6155-0fb0027555ff@opensource.wdc.com>
From:   Alberto Faria <afaria@redhat.com>
Date:   Thu, 1 Dec 2022 22:10:19 +0000
Message-ID: <CAELaAXzwM48bFiCoS9kgoCx3Mw5T_XvXmQ-+Y3AanxKjPizoWA@mail.gmail.com>
Subject: Re: [PATCH 01/10] Add a libblkio engine
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     fio@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Nov 22, 2022 at 9:17 AM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
> On 11/22/22 03:28, Alberto Faria wrote:
> > The libblkio library provides a unified API for efficiently accessing
> > block devices using modern high-performance block I/O interfaces like
> > io_uring and vhost-user-blk. Using libblkio reduces the amount of code
> > needed for interfacing with storage devices and allows developers to
> > focus on their applcations.
> >
> > Add a libblkio engine that uses libblkio to perform I/O. This is useful
> > to benchmark the library itself, and also adds support for storage
> > interfaces and devices otherwise not supported by fio, such as
> > virtio-blk PCI, vhost-user, and vhost-vDPA devices.
> >
> > See the libblkio documentation [2] or KVM Forum 2022 [3] presentation
> > for more information on the library itself.
> >
> > [1] https://gitlab.com/libblkio/libblkio
> > [2] https://libblkio.gitlab.io/libblkio/index.html
> > [3] https://static.sched.com/hosted_files/kvmforum2022/8c/libblkio-kvm-forum-2022.pdf
> >
> > Signed-off-by: Alberto Faria <afaria@redhat.com>
> > ---
> >  HOWTO.rst                                 |  26 ++
> >  Makefile                                  |   6 +
> >  configure                                 |  25 ++
> >  engines/libblkio.c                        | 463 ++++++++++++++++++++++
> >  examples/libblkio-io_uring.fio            |  19 +
> >  examples/libblkio-virtio-blk-vfio-pci.fio |  18 +
> >  fio.1                                     |  19 +
> >  optgroup.h                                |   2 +
> >  8 files changed, 578 insertions(+)
> >  create mode 100644 engines/libblkio.c
> >  create mode 100644 examples/libblkio-io_uring.fio
> >  create mode 100644 examples/libblkio-virtio-blk-vfio-pci.fio
> >
> > diff --git a/HOWTO.rst b/HOWTO.rst
> > index e796f961..d5a2749c 100644
> > --- a/HOWTO.rst
> > +++ b/HOWTO.rst
> > @@ -2192,6 +2192,12 @@ I/O engine
> >                       the SPDK NVMe driver, or your own custom NVMe driver. The xnvme engine includes
> >                       engine specific options. (See https://xnvme.io).
> >
> > +             **libblkio**
> > +                     Use the libblkio library
> > +                     (https://gitlab.com/libblkio/libblkio). The specific
> > +                     *driver* to use must be set using
> > +                     :option:`libblkio_driver`.
> > +
> >  I/O engine specific parameters
> >  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > @@ -2842,6 +2848,26 @@ with the caveat that when used on the command line, they must come after the
> >
> >       If this option is set. xnvme will use vectored read/write commands.
> >
> > +.. option:: libblkio_driver=str : [libblkio]
> > +
> > +     The driver to be used by libblkio (e.g. **virtio-blk-vfio-pci**).
>
> It would be nice to list the possible values and their meaning here.
>
> > +
> > +.. option:: libblkio_pre_connect_props=str : [libblkio]
> > +
> > +     A colon-separated list of libblkio properties to be set after creating
> > +     but before connecting the ``struct blkio``. Each property must have the
> > +     format ``<name>=<value>``. Colons can be escaped as ``\:``. These are
> > +     set after the engine sets any other properties, so those can be
> > +     overriden.
>
> "struct blkio" has no meaning whatsoever for the fio command line
> interface. So could this be reworded without using struct names ? E.g.
> "without connecting the device accessed by libblkio" ?
>
> And we need to list the possible properties or have at least a link to
> some documentation listing the possible properties. Otherwise, how can
> the user find that out ?

In v2 I ended up linking to the libblkio docs. I avoided adding lists
of available drivers and properties since those would become
incomplete rather quickly and also depend on the installed version of
libblkio.

Thanks,
Alberto

