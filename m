Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:33103 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdCPHnU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Mar 2017 03:43:20 -0400
Received: by mail-ua0-f176.google.com with SMTP id u30so21575806uau.0
        for <fio@vger.kernel.org>; Thu, 16 Mar 2017 00:43:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fuie2p40.fsf@curie.anarc.at>
References: <87fuie2p40.fsf@curie.anarc.at>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 16 Mar 2017 07:42:48 +0000
Message-ID: <CALjAwxjrNpTQTitcZCFA205m6mtE04OC_R_zmsK593hEUK3bPg@mail.gmail.com>
Subject: Re: could fio be used to wipe disks?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Antoine Beaupre <anarcat@orangeseeds.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

1. It will try and use the whole area of the disk but if fio's
blocksize turns out not to the same as the disk's block size it may
miss the very end of the disk. Also if an error is encountered fio may
stop part way through and fail to overwrite the rest of the data. If
you're not paranoid about disk wiping then it is unlikely that fio
will be any faster than doing something like
dd if=3D/dev/zero of=3D/dev/mydisk bs=3D1M oflag=3Ddirect

Bear in mind that if you're worried about wiping disks properly you
will have to write particular pattern over the disk. Further it may
not easier than you think to get at stale internal mappings the "disk"
might have which is why you use SECURE ERASE on SSDs. fio does none of
this.

Since you mentioned stress you may want to look at using a deeper
iodepth with the libaio engine (assuming you're on Linux, other
platforms have asynchronous engines too) and only doing the sync at
the end.

2. What you are proposing is very dangerous. Assuming the filesystem
is unmounted you and you wanted to do writes you would need to read
the data and then write that same data back but fio has no facility
for such a thing at present. If the filesystem is mounted then I think
what you're asking for is impossible without introducing the
possibility of filesystem corruption.

On 15 March 2017 at 21:42, Antoine Beaupre <anarcat@orangeseeds.org> wrote:
> Hi,
>
> I'm writing a stress-testing tool and i'm looking at using fio to
> stress-test disks. The point is not exactly to benchmark the disks, but
> put sustained load on the disks to make sure they are generally in
> working order.
>
> Right now, I came up with something like this:
>
>       fio --name=3Dstressant --readwrite=3Drandrw  --filename=3D/dev/sdX =
\
>           --size=3D100% --numjob=3D4 --sync=3D1 --direct=3D1 --group_repo=
rting
>
> My question is:
>
>  1. will this reliably wipe the whole drive? i know that some data can
>     remain due to magnetic properties of the drive or nasty SSD tricks,
>     but assume we don't do crazy forensics
>
>  2. if not, is there a way to directly test write I/O directly through
>     the device (to ignore filesystem-related issues) non-destructively?
>
> Thanks!
>
> A.
>
> PS: for those curious, my prototype is available here:
>
> https://gitlab.com/anarcat/stressant/blob/master/stressant.py
>
> Nothing serious so far...
>
> --
> La publicit=C3=A9 est la dictature invisible de notre soci=C3=A9t=C3=A9.
>                         - Jacques Ellul
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Sitsofe | http://sucs.org/~sits/
