Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33639 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbdKZP2k (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 26 Nov 2017 10:28:40 -0500
Received: by mail-vk0-f48.google.com with SMTP id o145so15976312vkd.0
        for <fio@vger.kernel.org>; Sun, 26 Nov 2017 07:28:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <TU4PR8401MB0991DC48F1741A8F8F1DEF20EC240@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <903d418b-bac4-104b-28e5-3c529efab7f5@kernel.dk> <TU4PR8401MB0991DC48F1741A8F8F1DEF20EC240@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 26 Nov 2017 15:28:09 +0000
Message-ID: <CALjAwxh9bP38Uqsy=OmxqZKRxpKYEArYuT1RYC76jL6oqF3daQ@mail.gmail.com>
Subject: Re: fio 3.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 26 November 2017 at 05:30, Gavriliuk, Anton (HPS Ukraine)
<anton.gavriliuk@hpe.com> wrote:
> OK, I rebuild 3.2 with libaio & libpmem libraries,
>
> dl560g10spmem01:/var/work/fio-3.2 # rpm -qa|grep libpmem
> libpmemblk-1.3-3.fc27.x86_64
> libpmempool-devel-1.3-3.fc27.

[snip]

> libpmem                       yes
> libpmemblk                    yes
> NVML pmemblk engine           yes
> NVML dev-dax engine           yes

OK so fio has been built with pmem support.

[...]

> dl560g10spmem01:/var/work/fio-3.2 # /usr/local/bin/fio --filename=3D/dev/=
dax0.0 --rw=3Drandrw --refill_buffers --norandommap --randrepeat=3D0 --ioen=
gine=3Ddev-dax --bssplit=3D4k/4:8k/7:16k/7:32k/15:64k/65:128k/1:256k/1 --rw=
mixread=3D5 --iodepth=3D1 --numjobs=3D1 --runtime=3D1800 --group_reporting =
--name=3D4-rand-rw-3xx --size=3D300Gb --name=3D4-rand-rw-3xx
> 4-rand-rw-3xx: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-256KiB, (W) 4096B-256=
KiB, (T) 4096B-256KiB, ioengine=3Ddev-dax, iodepth=3D1
> 4-rand-rw-3xx: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-256KiB, (W) 4096B-256=
KiB, (T) 4096B-256KiB, ioengine=3Ddev-dax, iodepth=3D1
> fio-3.2
> Starting 2 processes
>
> Run status group 0 (all jobs):

Where's the output of this job? Did it work?

> dl560g10spmem01:/var/work/fio-3.2 #
>
> /dev/pmem1 on /pmem type xfs (rw,relatime,attr2,dax,inode64,noquota)
^^^ So your dax filesystem appears at /pmem ...

> dl560g10spmem01:/var/work/fio-3.2 # /usr/local/bin/fio --filename=3D/dev/=
pmem1 --rw=3Drandrw --refill_buffers --norandommap --randrepeat=3D0 --ioeng=
ine=3Dpmemblk --bssplit=3D4k/4:8k/7:16k/7:32k/15:64k/65:128k/1:256k/1 --rwm=
ixread=3D5 --iodepth=3D1 --numjobs=3D1 --runtime=3D1800 --group_reporting -=
-name=3D4-rand-rw-3xx --allow_mounted_write=3D1 --thread=3D1 --direct=3D1
> 4-rand-rw-3xx: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-256KiB, (W) 4096B-256=
KiB, (T) 4096B-256KiB, ioengine=3Dpmemblk, iodepth=3D1
> fio-3.2
> Starting 1 thread
> pmemblk: unable to open pmemblk pool file /dev/pmem1 (Invalid argument)

...but you're using filename=3D/dev/pmem1 with pmemblk? At least the
filename option you used looks incorrect for this ioengine - have you
seen the comments and filenames in the example over on
https://github.com/axboe/fio/blob/fio-3.2/examples/pmemblk.fio ? Also
are you sure you want to be setting allow_mounted_write=3D1 in this case
- what should be mounted where the I/O happens - won't pmemblk create
the "device" itself?

--=20
Sitsofe | http://sucs.org/~sits/
