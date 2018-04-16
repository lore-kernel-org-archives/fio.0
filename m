Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:45066 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753918AbeDPIXs (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Apr 2018 04:23:48 -0400
Received: by mail-ua0-f170.google.com with SMTP id j18so9536721uae.12
        for <fio@vger.kernel.org>; Mon, 16 Apr 2018 01:23:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAOwsrdmf4HgJqVnGvz5GU58h-BrpHk1SnckWvYYsje2mOvhFg@mail.gmail.com>
References: <CAAOwsrdmf4HgJqVnGvz5GU58h-BrpHk1SnckWvYYsje2mOvhFg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 16 Apr 2018 09:23:17 +0100
Message-ID: <CALjAwxj4un3+tPfFBX2Qscf9yJ68UWL3dbZJw5BW4QwKbhWBeg@mail.gmail.com>
Subject: Re: How to use ceph rados ioengine? How to config rados.job for
 parallel reading and writing?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Igor Fedotov <ifedotov@suse.com>
Cc: fio <fio@vger.kernel.org>, =?UTF-8?B?6ams5bCR5qWg?= <shaonan.ma@gmail.com>

(CC'ing Igor)

On 16 April 2018 at 07:56, =E9=A9=AC=E5=B0=91=E6=A5=A0 <shaonan.ma@gmail.co=
m> wrote:
> Hi List,
>
> I am a beginner, and now I am testing performance of rados of ceph. I
> use the ioengine of rados but when I used the example in Github, the
> ceph pool is empty as following:
>
> data:
>     pools:   1 pools, 100 pgs
>     objects: 0 objects, 0 bytes
>     usage:   72611 MB used, 349 TB / 349 TB avail
>     pgs:     100 active+clean
>
> $ ceph df
> GLOBAL:
>     SIZE     AVAIL     RAW USED     %RAW USED
>     349T      349T       72611M          0.02
> POOLS:
>     NAME       ID     USED     %USED     MAX AVAIL     OBJECTS
>     ecpool     1         0         0          221T           0
>
> And my configure file rados.job is as following:
>
> [global]
> ioengine=3Drados
> clientname=3Dadmin
> pool=3Decpool
> busy_poll=3D0
> rw=3Dwrite
> bs=3D4M
>
> [job1]
> size=3D100G
> io_size=3D100G
> iodepth=3D2048
>
> I want to know whether the result that fio got could be considered
> effective without any ojbect been written in the pool.
>
> And I want to ask what I need to do if I want to test parallel reading
> and write of rados. Should I create N pools in ceph and create N jobs
> in fio configure file?
>
> Thanks.
>
> Regards,
> Shaonan Ma

--=20
Sitsofe | http://sucs.org/~sits/
