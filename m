Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:45036 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbeGGEnj (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 7 Jul 2018 00:43:39 -0400
Received: by mail-ua0-f169.google.com with SMTP id v15-v6so8759137ual.11
        for <fio@vger.kernel.org>; Fri, 06 Jul 2018 21:43:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB032082F03EB254879C04F26B8F470@MWHPR04MB0320.namprd04.prod.outlook.com>
References: <MWHPR04MB032082F03EB254879C04F26B8F470@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 7 Jul 2018 05:43:08 +0100
Message-ID: <CALjAwxi2tC+0G+V1qoQfcwha_v51ubXmDbBg3KTiH=-xzfr__w@mail.gmail.com>
Subject: Re: fio max blocksize
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 6 July 2018 at 22:15, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> Hi All,
> Currently it looks like fio has a max blocksize of uint32_t.  So commands=
 such as
>
> # fio --name=3Dtest --ioengine=3Dlibaio --direct=3D1 --rw=3Dtrim --iodept=
h=3D1 --bs=3D4g --filename=3D/dev/nvme1n1 --number_ios=3D1 max value out of=
 range: 4294967296 (4294967295 max)
> fio: failed parsing bs=3D4g
>
> will fail.  While I wouldn't normally do 4GB reads/writes, I would like t=
o issue 4GB trims.  Otherwise I need to invoke a tool such as blkdiscard, b=
ut then summarizing all job IO is very difficult.  I went through the proce=
ss of unsuccessfully changing the blocksize variables to uint64_t (failed g=
etting buflen), but not sure if I missed a minor detail or a major roadbloc=
k that would prevent it.  How could >4GB blocksizes be supported?  Thanks.

Wow! I was going to say "surely discards can't be that huge?" but I've
just checked and even a cheap SSD has a queue/discard_max_hw_bytes of
2GBytes and I see some NVMe drives have 4GBytes for that value. It's
not really fair on fio because in hardware the disk's blocksize
remains the same it's just that asking for a discard sends down an
offset+range of blocks so it is able to reach huge sizes...

As to your question I'm not sure if fio has assumptions in that expect
blocks not to be giant... I suspect it just seemed a sane limit and
tradeoff at the time - if/when we up the size I can just see someone
raising an issue about how using fio with 16GByte blocks at an iodepth
of 8 didn't work... :-p

--=20
Sitsofe | http://sucs.org/~sits/
