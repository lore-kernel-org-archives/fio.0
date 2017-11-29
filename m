Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34589 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932288AbdK2RRd (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 29 Nov 2017 12:17:33 -0500
Received: by mail-vk0-f54.google.com with SMTP id j126so1697429vke.1
        for <fio@vger.kernel.org>; Wed, 29 Nov 2017 09:17:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <TU4PR8401MB0991FC9A2875B323D06B678FEC3B0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <903d418b-bac4-104b-28e5-3c529efab7f5@kernel.dk> <TU4PR8401MB0991DC48F1741A8F8F1DEF20EC240@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxh9bP38Uqsy=OmxqZKRxpKYEArYuT1RYC76jL6oqF3daQ@mail.gmail.com>
 <TU4PR8401MB099189C195BE973BED0D0C15EC250@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com>
 <b9bce0b0-9683-59b6-4c08-62f29d80935a@bluestop.org> <TU4PR8401MB0991F4C4CAD9858A3BF2AE9DEC3A0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB0387489EC42684D7FACF3E1EAB3A0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <TU4PR8401MB0991EBEF27D16271CD5361AAEC3B0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB03875F6DB61311D1D8B40419AB3B0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <DF4PR8401MB0985819C0E99668DFDE30734EC3B0@DF4PR8401MB0985.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB0387907183BC5CA6AE94289EAB3B0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <TU4PR8401MB0991FC9A2875B323D06B678FEC3B0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 29 Nov 2017 17:17:01 +0000
Message-ID: <CALjAwxhEs81ejDg+9OP5xHwSMMYCCh85STbBYxR13i8V=KMvww@mail.gmail.com>
Subject: Re: fio 3.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Rebecca Cran <rebecca@bluestop.org>, Tomohiro Kusumi <tkusumi@tuxera.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "Kani, Toshimitsu" <toshi.kani@hpe.com>

Unsigned number being printed as signed?

On 29 November 2017 at 13:12, Gavriliuk, Anton (HPS Ukraine)
<anton.gavriliuk@hpe.com> wrote:
> Latest findings...
>
> With the fio2.12 /dev/dax & mmap().  I run trace before start test.  We c=
an see above open(), mmap()
>
>     5.630816 cpu=3D65 pid=3D45154 tgid=3D45154 open [2] entry *pathname=
=3D0x7f62b6fabed0 flags=3DNOATIME mode=3D0600 filename: /dev/dax0.0
>     5.630819 cpu=3D65 pid=3D45154 tgid=3D45154 open [2] ret=3D3 syscallbe=
g=3D    0.000003 *pathname=3D0x7f62b6fabed0 flags=3DNOATIME mode=3D0600
>     5.630833 cpu=3D65 pid=3D45154 tgid=3D45154 mmap [9] entry *addr=3D0x0=
 length=3D-2147483648 prot=3DREAD|WRITE flags=3DSHARED fd=3D3 offset=3D0x0
>     5.630836 cpu=3D65 pid=3D45154 tgid=3D45154 mmap [9] ret=3D0x7f1a00200=
000 syscallbeg=3D    0.000003 *addr=3D0x0 length=3D-2147483648 prot=3DREAD|=
WRITE flags=3DSHARED fd=3D3 offset=3D0x0
>     5.630836 cpu=3D65 pid=3D45154 tgid=3D45154 madvise [28] entry *addr=
=3D0x7f1a00200000 length=3D-2147483648 advise=3D0x1
>     5.630837 cpu=3D65 pid=3D45154 tgid=3D45154 madvise [28] ret=3D0x0 sys=
callbeg=3D    0.000001 *addr=3D0x7f1a00200000 length=3D-2147483648 advise=
=3D0x1
>
> How it could be that mmap() length size -2Gb ??? (length=3D-2147483648). =
 I pointed +290g,
>
> dl560g10spmem01:/var/work/fio-3.2 # /usr/bin/fio --filename=3D/dev/dax0.0=
 --rw=3Drandrw --refill_buffers --norandommap --randrepeat=3D0 --ioengine=
=3Dmmap --bssplit=3D4k/4:8k/7:16k/7:32k/15:64k/65:128k/1:256k/1 --rwmixread=
=3D5 --iodepth=3D1 --numjobs=3D16 --runtime=3D1800 --group_reporting --name=
=3D4-rand-rw-3xx --size=3D290g

--=20
Sitsofe | http://sucs.org/~sits/
