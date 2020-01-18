Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50623 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgARPsm (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 18 Jan 2020 10:48:42 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so10261414wmb.0
        for <fio@vger.kernel.org>; Sat, 18 Jan 2020 07:48:40 -0800 (PST)
MIME-Version: 1.0
References: <CA+zhgFSVYMYkDeGEc1Tn3yEy24PgmFRiKABcCQkuEByMuLsnsQ@mail.gmail.com>
 <CALjAwxg+OKr3co5K++St1B=EdztytsDbhWUhNe6Bjz0Vg2uVQw@mail.gmail.com>
 <CA+zhgFRV0LcX+jZOGgjkfc+5v0iwk=C+hVEoP9e1hnTQEMa2vQ@mail.gmail.com>
 <TU4PR8401MB092733E68E23F041756044D9AB380@TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM>
 <CA+zhgFTY4AgJ9EBUk_z7EfN3wxwE8c5Ccx+A4u4aFmFGvdOfdQ@mail.gmail.com>
 <TU4PR8401MB09274B35275964C4D924BAF5AB380@TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxioWYxdHY+myk=tSkncuQn8qLdVUTGSSDzprSSsHJJKYA@mail.gmail.com> <CA+zhgFTeqGMarz264rRwt1eTtujyCL35VpruQ23EYydMUV5X+A@mail.gmail.com>
In-Reply-To: <CA+zhgFTeqGMarz264rRwt1eTtujyCL35VpruQ23EYydMUV5X+A@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 18 Jan 2020 15:48:14 +0000
Message-ID: <CALjAwxi1DDZmgEDuoGwea_Ct+QcDK8qfC4C+YERcS+MadX11jA@mail.gmail.com>
Subject: Re: 4KiB + 64 B formatted drive : Invalid or incomplete multibyte or
 wide character: write offset=4096, buflen=4096
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: smitha sunder <sundersmitha@gmail.com>
Cc: "Elliott, Robert (Servers)" <elliott@hpe.com>, fio <fio@vger.kernel.org>

On Fri, 17 Jan 2020 at 21:17, smitha sunder <sundersmitha@gmail.com> wrote:
>
> If I issue "nvme write" that works :
>
> #  echo "hello" | nvme write -s 0 -c 0 -y 64 -z 4096 --prinfo=0 /dev/nvme0n1
> write: Success
>
> # nvme read /dev/nvme0n1 -s 0  --prinfo=0 -z 4096  -y 64
> hello
> read: Success
>
>
> fio fails :
>
> #  fio --filename=/dev/nvme0n1  --rw=write --ioengine=libaio
> --direct=1  --do_verify=0  --name=test --bs=4096 --number_ios=1
> --offset=100M --debug=io
> fio: set debug option io
> test: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=libaio, iodepth=1
> fio-3.7
> Starting 1 process
> io       20252 drop page cache /dev/nvme0n1
> io       20252 fill: io_u 0xb4cc80:
> off=0x6400000,len=0x1000,ddir=1,file=/dev/nvme0n1
> io       20252 prep: io_u 0xb4cc80:
> off=0x6400000,len=0x1000,ddir=1,file=/dev/nvme0n1
> io       20252 prep: io_u 0xb4cc80: ret=0
> io       20252 queue: io_u 0xb4cc80:
> off=0x6400000,len=0x1000,ddir=1,file=/dev/nvme0n1
> io       20252 calling ->commit(), depth 1
> io       20252 io_u_queued_complete: min=1
> io       20252 getevents: 1
> io       20252 complete: io_u 0xb4cc80:
> off=0x6400000,len=0x1000,ddir=1,file=/dev/nvme0n1
> fio: io_u error on file /dev/nvme0n1: Invalid or incomplete multibyte
> or wide character: write offset=104857600, buflen=4096
> io       20252 io_u_queued_complete: min=0
> io       20252 getevents: 0
> test: No I/O performed by libaio, perhaps try --debug=io option for details?
> fio: pid=20252, err=84/file:io_u.c:1747, func=io_u error,
> error=Invalid or incomplete multibyte or wide character
> io       20252 close ioengine libaio
> io       20252 free ioengine libaio
>
> test: (groupid=0, jobs=1): err=84 (file:io_u.c:1747, func=io_u error,
> error=Invalid or incomplete multibyte or wide character): pid=20252:
> Fri Jan 17 13:13:52 2020
>   cpu          : usr=0.00%, sys=0.00%, ctx=1, majf=0, minf=24
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=50.0%, 4=50.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwts: total=0,1,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
>
> Run status group 0 (all jobs)

Your nvme write is presumably crafting an entire NVMe command and
getting that sent to the device rather than going through the block
layer and letting that create NVMe commands so it's not really a fair
comparison (but it's another data point). I'd guess you're going to
still get kernel errors even using something like dd (but with the
appropriate direct flag with it and the same block size as fio)...

Generally speaking, if you're seeing kernel errors while doing block
level I/O that's indicative of something happening below fio and
you're better off talking to the folks on the linux-block list
(http://vger.kernel.org/vger-lists.html#linux-block ) to learn more...

--
Sitsofe | http://sucs.org/~sits/

