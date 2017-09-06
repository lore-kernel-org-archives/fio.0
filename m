Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:38417 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbdIFR4b (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Sep 2017 13:56:31 -0400
Received: by mail-ua0-f195.google.com with SMTP id l24so2425627uaa.5
        for <fio@vger.kernel.org>; Wed, 06 Sep 2017 10:56:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457AD82F545E4C85F2CA5858F9C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457AD82F545E4C85F2CA5858F9C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Wed, 6 Sep 2017 20:55:50 +0300
Message-ID: <CAHndrB=HBqHEUT-5u5JXzQaLTzfwMDsvKT7rvvWO3wvShaAPGg@mail.gmail.com>
Subject: Re: fio patch question on filesetup: align layout buffer
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

2017-08-31 1:27 GMT+03:00 Jeff Furlong <jeff.furlong@wdc.com>:
> Hi All,
> I see the patch at http://git.kernel.dk/cgit/fio/commit/?id=8c43ba6259409244de64f0b1d388a029e38cf3e5 and just wondered if it is still compatible with:
>
> .. option:: iomem_align=int, mem_align=int
>
>         This indicates the memory alignment of the I/O memory buffers.  Note that
>         the given alignment is applied to the first I/O unit buffer, if using
>         :option:`iodepth` the alignment of the following buffers are given by the
>         :option:`bs` used. In other words, if using a :option:`bs` that is a
>         multiple of the page sized in the system, all buffers will be aligned to
>         this value. If using a :option:`bs` that is not page aligned, the alignment
>         of subsequent I/O memory buffers is the sum of the :option:`iomem_align` and
>         :option:`bs` used.
>
> For example, if we set mem_align to something larger than page_size or bs, what does fio_memalign use?  And if we set mem_align to something between page_size and bs, what does fio_memalign use?  Thanks.

mem_align wasn't used in the layout thing, and never needed.
fio_memalign() is an alternative for posix_memalign() rather than
something to do with that option. fio_memalign() takes an alignment by
argument, and the argument for this was page_size. page_size works for
direct i/o, as it meets sector size alignment (at least for 512, 2K,
4K on all supported archs), which is what Linux and many others
require.

Btw, I'm not completely sure why fio_memalign() allocates doubled
`size'. Some of the aligned malloc implementations I've seen did take
of size*2 or alignment*2, but those didn't explicitly take the footer
(or header) size, whereas in fio it explicitly has sizeof(*f) after
the data size and max possible space for alignment. Since f->offset is
always smaller than the alignment size, it seems to me size*1 is
enough, but I might be missing something.


>
> Regards,
> Jeff
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
