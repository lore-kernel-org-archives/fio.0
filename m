Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:34578 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754209AbdHZDoh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 25 Aug 2017 23:44:37 -0400
Received: by mail-ua0-f170.google.com with SMTP id j46so4843557uag.1
        for <fio@vger.kernel.org>; Fri, 25 Aug 2017 20:44:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF+0mvk-1dfYeJ2XBFoi7afSPVAb1r0w=sDF0Eb-c5KvRtbeEQ@mail.gmail.com>
References: <CAF+0mvk-1dfYeJ2XBFoi7afSPVAb1r0w=sDF0Eb-c5KvRtbeEQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 26 Aug 2017 04:44:05 +0100
Message-ID: <CALjAwxiWa7fRLS4nBxiL0C+ZjRDNz09oxyn4J+gXKhhsEq00XQ@mail.gmail.com>
Subject: Re: File Servicing
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 25 August 2017 at 23:11, Matthew Eaton <m.eaton82@gmail.com> wrote:
> Hello fio group.
>
> I have a volume with 3573 files and I am trying to write to them 10 at
> a time in sequential order so I have:
>
> [job]
> direct=1
> bs=128k
> rw=write
> refill_buffers
> opendir=/media/sped/rmfs
> openfiles=10
> file_service_type=sequential
>
> The above is close to what I want. Fio sees all 3573 files but only
> services 1 file at a time.
>
> If I remove file_service_type=sequential fio services 10 files at a
> time but using lsof I see only the last file incrementing:
>
> fio       6003                  root    3u      REG               8,17
> 134217728      84934 /media/sped/rmfs/0001
> fio       6003                  root    4u      REG               8,17
> 134217728      84935 /media/sped/rmfs/0002
> fio       6003                  root    5u      REG               8,17
> 134217728      84936 /media/sped/rmfs/0003
> fio       6003                  root    6u      REG               8,17
> 134217728      84937 /media/sped/rmfs/0004
> fio       6003                  root    7u      REG               8,17
> 134217728      84938 /media/sped/rmfs/0005
> fio       6003                  root    8u      REG               8,17
> 134217728      84939 /media/sped/rmfs/0006
> fio       6003                  root    9u      REG               8,17
> 134217728      84940 /media/sped/rmfs/0007
> fio       6003                  root   10u      REG               8,17
> 134217728      84941 /media/sped/rmfs/0008
> fio       6003                  root   11u      REG               8,17
> 134217728      84942 /media/sped/rmfs/0009
> fio       6003                  root   12u      REG               8,17
> 134217728      90617 /media/sped/rmfs/0058
>
> Fio version is latest from git: fio-3.0-9-gb427
>
> Is this the correct behavior?

Not having file_service_type seems to workforme:

rm -rf /tmp/fio/
mkdir /tmp/fio/
for i in $(seq -w 1 20); do dd if=/dev/zero of=/tmp/fio/fiofile.$i
bs=16k count=1; done
fio --number_ios=5 --bs=4 --rw=write --refill_buffers
--opendir=/tmp/fio/ --openfiles=10 --buffer_pattern='"fio "' --name=rr
grep fio /tmp/fio/fiofile.*
Binary file /tmp/fio/fiofile.01 matches
Binary file /tmp/fio/fiofile.02 matches
Binary file /tmp/fio/fiofile.03 matches
Binary file /tmp/fio/fiofile.04 matches
Binary file /tmp/fio/fiofile.05 matches

Reading http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-file-service-type
gives a few clues and tells us about the :postfix to get fio to "pick"
a different file after postfix I/Os. It's kind of subtle but when you
don't set the postfix it actually defaults to 1 so when
file_service_type=roundrobin (the default) you should have gotten the
behaviour you desired because behind the scenes it is actually
behaving as if file_service_type=roundrobin:1 .

The difference comes when you use file_service_type=sequential (which
using the above logic will be quietly converted to
file_service_type=sequential:1) which is something you can't really
arrange with roundrobin. file_service_type=sequential is actually
interpreted as "ignore the postfix" so you always stay on the current
file until it is finished (i.e. fully written). Here the help is
misleading as it implies the postfix is used with
file_service_type=sequential when it never is. I can definitely see a
case for the help to be clarified and if you have a patch to do this
I'm sure it would be considered!

The above guesswork was based on reading the HOWTO and
https://github.com/axboe/fio/blob/2f282cecc27c58ed3aa1204f5bda98433502d7ff/io_u.c#L1269
.

If you use --debug=file are there any more clues?

-- 
Sitsofe | http://sucs.org/~sits/
