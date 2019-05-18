Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33031 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfERHNU (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 18 May 2019 03:13:20 -0400
Received: by mail-wr1-f68.google.com with SMTP id d9so9292041wrx.0
        for <fio@vger.kernel.org>; Sat, 18 May 2019 00:13:19 -0700 (PDT)
MIME-Version: 1.0
References: <CA+=P2MuECGCj+zdvP-=3DfPD71VyYHX1RoOxCCDz2Uea=ZL9_g@mail.gmail.com>
In-Reply-To: <CA+=P2MuECGCj+zdvP-=3DfPD71VyYHX1RoOxCCDz2Uea=ZL9_g@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 18 May 2019 08:12:57 +0100
Message-ID: <CALjAwxjDh5UhbeP=VATCPq0vBcoUmms=nbQoh8cqrFsK-xfJjw@mail.gmail.com>
Subject: Re: How is numjobs & iodepth related?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Manu K.S." <cse.manuks@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Fri, 17 May 2019 at 16:20, Manu K.S. <cse.manuks@gmail.com> wrote:
>
> Hi, what will be the iodepth for each job with below 3 commands?
>
> COMMAND 1
> -----------------
> fio --name=fiotest --filename=/dev/sdb --rw=read --numjobs=1
> --iodepth=4 --size=1G --bs=4k --runtime=120 --time_based
>
> COMMAND 2
> -------------------
> fio --name=fiotest --filename=/dev/sdb --rw=read --numjobs=2
> --iodepth=4 --size=1G --bs=4k --runtime=120 --time_based
>
> COMMAND 3
> -------------------
> fio --name=fiotest --filename=/dev/sdb:/dev/sdc --rw=read --numjobs=2
> --iodepth=4 --size=1G --bs=4k --runtime=120 --time_based

Hard to say without more context but assuming you're on Linux:

COMMAND 1
You're going to get a depth of 1 because the default ioengine chosen
when you don't specify one on Linux is synchronous (see the iodepth
description in the fio help for warnings about depth and synchronous
ioengines - https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth
). Maybe you wanted to use libaio with direct=1 (see the libaio
section in https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-ioengine
for more details)?

COMMAND 2
I'd guess you will get an overall depth of 2 (1 per job).

COMMAND 3
I'd guess you will get an overall depth of 2 (1 per job). Multiple
files in filename won't impact the depth only which file each I/O goes
to (which is roundrobin by default -
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-file-service-type
).

NB: fio will try and report the depths it is achieving see the "IO
depths" output in the example on
https://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output
. What your disk actually sees can be different though depending on
what the kernel chooses to do with the submitted I/O.

-- 
Sitsofe | http://sucs.org/~sits/

