Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:34582 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdELT0v (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 May 2017 15:26:51 -0400
Received: by mail-vk0-f52.google.com with SMTP id y190so23240610vkc.1
        for <fio@vger.kernel.org>; Fri, 12 May 2017 12:26:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACgm0dh1M1-3xMMzzPm5FbQAnY+WLeuucmOjRL=5H6eJs+BVEg@mail.gmail.com>
References: <CACgm0dh1M1-3xMMzzPm5FbQAnY+WLeuucmOjRL=5H6eJs+BVEg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 12 May 2017 20:26:20 +0100
Message-ID: <CALjAwxjg9Om7=hrZH5WBGkjetVtpAtdyO8pmUFe8G03Cg1K6zw@mail.gmail.com>
Subject: Re: ZFS Testing Methodology
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Spencer Hayes <spencer@jshayesinc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 12 May 2017 at 18:45, Spencer Hayes <spencer@jshayesinc.com> wrote:
>
> We're attempting to run some performance tests on a Solaris 11.2
> system with ZFS. The system has a sizable amount of memory which is
> currently more than the available space left in ZFS. Given that ZFS
> does not provide for direct IO, we're looking for options on how to
> exhaust the caching and actually test the throughput of the underlying
> disks.

If you're doing writes you can wait for synchronisation on stable
media either at the end of periodically by using the sync / fsync
options. For reads... well I guess you can start from an empty cache
by unmounting/remounting the filesystem before starting your tests?
I'm not sure you want to test a filesystem for non-cached I/O
performance unless your application is going to somehow depend on it
though.

> I've looked through several of the fio options but so far have not
> been able to find a mix that would let us do more total IO than is
> actually used as space on disk. The idea we had was to lay down say a
> 100GB file, but do 200-300GB of actual IO within that single (or
> multiple) file(s).

You probably want to use size with offset and io_size/loops (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-size ,
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset
, http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-io-size
, http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-loops
)

> Does anyone have experience perf testing ZFS and might have some
> suggestions to tackle this scenario?

You might get some good suggestions on a Solaris related ZFS mailing
list - https://illumos.topicbox.com/groups/zfs/discussions .

-- 
Sitsofe | http://sucs.org/~sits/
