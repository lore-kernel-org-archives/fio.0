Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f46.google.com ([209.85.128.46]:36880 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfDZIGR (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Apr 2019 04:06:17 -0400
Received: by mail-wm1-f46.google.com with SMTP id y5so2046341wma.2
        for <fio@vger.kernel.org>; Fri, 26 Apr 2019 01:06:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAPqbHXjNdcEwM_nfVaRu6BxVzg2HjBVZo0jdPGqJV=xw4=UHfw@mail.gmail.com>
In-Reply-To: <CAPqbHXjNdcEwM_nfVaRu6BxVzg2HjBVZo0jdPGqJV=xw4=UHfw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 26 Apr 2019 09:05:49 +0100
Message-ID: <CALjAwxgYk51y7hap2aHKwMrKWPjDdkS0CAyk=wf4-5DW6OaDwg@mail.gmail.com>
Subject: Re: Sequential Writes and Random Reads in parallel
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Prabhakaran <prabhugce@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Fri, 26 Apr 2019 at 06:34, Prabhakaran <prabhugce@gmail.com> wrote:
>
> Hi,
>
> I=E2=80=99m trying to do both Random and Sequential operations simultaneo=
usly
> in one job. In specific, I would like to do Sequential Writes and
> Random Reads in parallel. Here is what I have got so far.
>
> [global]
> ioengine=3Dlibaio
> disable_slat=3D1
> disable_lat=3D1
> thread
> direct=3D1
>
> [job2]
> stonewall
> bs=3D128kb,4kb
> ba=3D128kb,4kb
> rw=3Drandrw
> iodepth=3D256
> runtime=3D5s
> time_based=3D1
> log_avg_msec=3D0
> randrepeat=3D0
> norandommap
> refill_buffers
> write_bw_log=3Djob2
> write_iops_log=3Djob2
> write_lat_log=3Djob2
> bs_is_seq_rand=3D1
> rwmixread=3D1
> percentage_random=3D50
>
> I=E2=80=99m assuming the above job would do 128k Sequential and 4k Random=
 (50%
> each), writes and reads (with reads=3D1%) combined for both Sequential
> and Random, for 5s.
> I=E2=80=99m still not able to do just Sequential Writes and Random Reads =
alone
> in parallel.
>
> Thanks,
> Prabhu

percentage_random can be split into reads/writes/trims with commas
(see https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-percen=
tage-random
) so that might help you out... Alternatively because you have a 50/50
split you can use two separate jobs and tie them together with flow
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow
).

--=20
Sitsofe | http://sucs.org/~sits/

