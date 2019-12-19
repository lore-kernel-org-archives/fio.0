Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33215 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfLSDmx (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Dec 2019 22:42:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so4510669wrq.0
        for <fio@vger.kernel.org>; Wed, 18 Dec 2019 19:42:52 -0800 (PST)
MIME-Version: 1.0
References: <CAHc6FU7ai7HPQA8PP31wkJzz6LYJEn97Z-nJXn=EgvDy0LoBtA@mail.gmail.com>
In-Reply-To: <CAHc6FU7ai7HPQA8PP31wkJzz6LYJEn97Z-nJXn=EgvDy0LoBtA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 19 Dec 2019 03:42:25 +0000
Message-ID: <CALjAwxj8fYoF-J8jN6Ot02xijHOG2pbEgs8PXYZ9oOBfYGJvRg@mail.gmail.com>
Subject: Re: fio verify and short writes
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: fio <fio@vger.kernel.org>

On Tue, 3 Dec 2019 at 15:27, Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> Hi,
>
> I've run into a verify issue with fio in xfstest generic/300 [*]:
>
> * The aio-dio-verifier thread in that test case writes 4k buffers and
> then reads them back in.
> * The filesystem has a block size if 1k.
> * The test case is designed to run the filesystem out of space. When
> that happens, some writes can end up short before they all fail with
> -ENOSPC. (That doesn't seem to happen on ext4 or xfs filesystems with
> a 1k block size --- possibly just because the test always runs on a
> scratch filesystem --- but it does trigger on gfs2.)
> * When the aio-dio-verifier thread reads a short 4k buffer back in,
> part of the buffer will be zero-filled, so verification will fail.
>
> This is with a current fio and kernel.
>
> Any thoughts?

Hmm I don't know what fio could do here - you're explicitly ignoring
the ENOSPC error on the write phase so fio just says "OK it's not an
error" and logs the write I/O as successful. Fio verification depends
on a whole blocks worth of data being written so the best you could do
is simply to not verify the data in the final "short" block...

I suppose you could write a new feature in fio ("ignore_without_log")
that could take error codes and say "ENOSPC isn't a failure but don't
record any I/O that fails with it" so it would learn not to log that
last block. Maybe such a feature would be complicated because in many
cases it means you break the rule that you can check the rest of the
sequence of I/O that follows...

> Thanks,
> Andreas
>
> [*] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/generic/300

-- 
Sitsofe | http://sucs.org/~sits/

