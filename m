Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33205 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbbEPLrA (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 16 May 2015 07:47:00 -0400
Received: by lagr1 with SMTP id r1so76400566lag.0
        for <fio@vger.kernel.org>; Sat, 16 May 2015 04:46:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55551D18.2000405@micxer.de>
References: <55551D18.2000405@micxer.de>
Date: Sat, 16 May 2015 12:46:58 +0100
Message-ID: <CALjAwxgWOokmtXWtN3GvZnvNoC-FTCJX=c3xFiuH5PrB97_kBw@mail.gmail.com>
Subject: Re: Testing write master and multiple read clients on NFS share
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michael Weinrich <micxer@micxer.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 14 May 2015 at 23:09, Michael Weinrich <micxer@micxer.de> wrote:
> Hi,
>
> in my company we have some sort of database that operates on bit lists read
> directly from the files on the hard disk. While this is ok if you have an
> SSD in your server it gets tricky to keep performance up when using an NFS
> share.
>
> While I was trying to assess different solutions I stumbled upon fio and was
> happy to see that it can also run in client-server-mode. So I was trying to
> emulate the following scenario:
>
> - 1 node that takes care of updating the bit lists in the db files,
>   nothing else
> - 5 nodes that only read from those files and respond to queries, hopefully
> leveraging the local filesystem or NFS client cache
>
> I read through the HOWTO and tried to pick the options that should simulate
> the scenario as best as possible. This is what I came up with:
>
> [global]
> ioengine=sync
> iodepth=1
> size=100%
> io_size=4g
> filesize=4g
> blocksize=64k
> direct=0
> numjobs=4
> directory=/mnt/nfs
> filename_format=index.$filenum
> fadvise_hint=0
> lockfile=readwrite
> randrepeat=1
> nrfiles=8
> openfiles=4
> runtime=120
> ramp_time=10
> blocksize=64k
> file_service_type=random:8
> overwrite=1
> fsync_on_close=1
> random_distribution=zipf:0.6
> norandommap
> file_append=0
> rate=1m
>
> [reader]
> rw=randread
>
> [writer]
> rw=randrw
> rwmixwrite=80
>
>
> Is this a viable approach or is this scenario not really testable with fio?

I could be wrong but won't this make 4 readers and 4 writers. If
that's not what you wanted perhaps numjobs could be moved to the
reader entry only?

-- 
Sitsofe | http://sucs.org/~sits/
