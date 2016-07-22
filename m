Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36309 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbcGVTGJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 Jul 2016 15:06:09 -0400
Received: by mail-vk0-f53.google.com with SMTP id n129so124162006vke.3
        for <fio@vger.kernel.org>; Fri, 22 Jul 2016 12:06:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <nmthlt$4m6$1@ger.gmane.org>
References: <nmthlt$4m6$1@ger.gmane.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 22 Jul 2016 20:06:08 +0100
Message-ID: <CALjAwxi_XeY4_yWf=xrNbNpF+a5-p5MjUSXUNQk=o0e0s7ASNw@mail.gmail.com>
Subject: Re: "errror=Invalid or incomplete multibyte or wide character" &
 "verify: bad header numberio" errors
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saeed <ionictea@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 22 July 2016 at 17:29, Saeed <ionictea@gmail.com> wrote:
> Has anyone seen these errors before?
>
> Here's the job file:
>
> bs=4k
> ioengine=libaio
> iodepth=32
> size=1g
> direct=1
> runtime=60
> filename=/dev/sdb
> group_reporting
> numjobs=10
>
> # validation
> do_verify=1
> verify_fatal=1
> verify_dump=1
>
> verify_pattern=0x01020304
>
> [mixed-a]
> rw=readwrite
> stonewall
>
> [mixed-b]
> rw=randrw
> stonewall
[...]
> fio: pid=5809, err=84/file:io_u.c:1968, func=io_u_queued_complete,
> error=Invalid or incomplete multibyte or wide character

I forgot to say that you might be getting these errors because you
limit the runtime of individual jobs to 60 seconds and that might not
be enough time for your mixed-a job to overwrite the entire 1GByte of
the file before it stopped due to running out of time. If later
verification jobs try to verify an area not written to, the header may
not be there or/malformed thus generating error messages.

-- 
Sitsofe | http://sucs.org/~sits/

On 22 July 2016 at 17:29, Saeed <ionictea@gmail.com> wrote:
> Has anyone seen these errors before?
>
> Here's the job file:
>
> bs=4k
> ioengine=libaio
> iodepth=32
> size=1g
> direct=1
> runtime=60
> filename=/dev/sdb
> group_reporting
> numjobs=10
>
> # validation
> do_verify=1
> verify_fatal=1
> verify_dump=1
>
> verify_pattern=0x01020304
>
> [mixed-a]
> rw=readwrite
> stonewall
>
> [mixed-b]
> rw=randrw
> stonewall
>
> [mixed-c]
> rw=readwrite:4k
> stonewall
>
> [mixed-d]
> rw=randrw:4k
> stonewall
>
> Errors:
>
> Multiple writers may overwrite blocks that belong to other jobs. This can
> cause verification failures.
> mixed-verify-random-with-holes-4k: (g=3): rw=randrw, bs=4K-4K/4K-4K/4K-4K,
> ioengine=libaio, iodepth=32
> ...
> fio-2.12
> Starting 40 processes
> fio: pid=5809, err=84/file:io_u.c:1968, func=io_u_queued_complete,
> error=Invalid or incomplete multibyte or wide character
> fio: pid=5814, err=84/file:io_u.c:1968, func=io_u_queued_complete,
> error=Invalid or incomplete multibyte or wide character
> fio: pid=5808, err=84/file:io_u.c:1968, func=io_u_queued_complete,
> error=Invalid or incomplete multibyte or wide character
>
> verify: bad header numberio 2985, wanted 11 at file /dev/sdb offset 1224704,
> length 4096
>       hdr_fail data dumped as sdb.1224704.hdr_fail
> verify: bad header numberio 2986, wanted 12 at file /dev/sdb offset 1228800,
> length 4096
>       hdr_fail data dumped as sdb.1228800.hdr_fail
> verify: bad header numberio 23727, wanted 22903 at file /dev/sdb offset
> 106496, length 4096
>       hdr_fail data dumped as sdb.106496.hdr_fail
> verify: bad header numberio 13399, wanted 1319 at file /dev/sdb offset
> 311296, length 4096
>       hdr_fail data dumped as sdb.311296.hdr_fail
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Sitsofe | http://sucs.org/~sits/
