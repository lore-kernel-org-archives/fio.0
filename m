Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33009 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035253AbdDUFHa (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Apr 2017 01:07:30 -0400
Received: by mail-oi0-f43.google.com with SMTP id y11so46599640oie.0
        for <fio@vger.kernel.org>; Thu, 20 Apr 2017 22:07:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <000001d2ba42$3546dc90$9fd495b0$@citigo.com.vn>
References: <000001d2ba42$3546dc90$9fd495b0$@citigo.com.vn>
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Date: Fri, 21 Apr 2017 13:07:28 +0800
Message-ID: <CABtFm2W3cL2f96xpHERD-7E-7509Hn6E3F_kVhNBfy=19PbNgw@mail.gmail.com>
Subject: Re: Does fio really bypass page cache with option direct=1?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Son Chu <son.ct@citigo.com.vn>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org

You may use options --create_on_open=3D1 --fallocate=3Dnone. By default
FIO will prepare the file of the size (creates a sparse file) and then
performs IO. The options --create_on_open=3D1 and --fallocate=3Dnone
should skip the step.

--
Srinivasa R Chamarthy


On Fri, Apr 21, 2017 at 9:54 AM, Son Chu <son.ct@citigo.com.vn> wrote:
> Hi Sitsofe,
>
> Sorry if this email troubled you but I could not find any useful informat=
ion for this. I am getting the question with fio page cache bypass option (=
direct=3D1 ioengine=3Dlibaio)
>
> I am using fio version 2.19 with command:
>
> fio --filename=3D/opt/test --direct=3D1 --rw=3Drandrw --randrepeat=3D0 --=
ioengine=3Dlibaio --bs=3D4k --rwmixread=3D75 --iodepth=3D16 --numjobs=3D1 -=
-name=3D4ktest --size=3D1G
>
> and i used cachestat tool from here to monitor: https://github.com/brenda=
ngregg/perf-tools
>
> The output was:
>
> Counting cache functions... Output every 1 seconds.
>
> HITS MISSES DIRTIES RATIO BUFFERS_MB CACHE_MB
>
> 1399 42 0 97.1% 2 31
>
> 1408 0 0 100.0% 2 31
>
> -68699 39 71478 100.1% 3 532
>
> -21325 0 22886 100.0% 3 621
>
> -19956 0 21492 100.0% 3 705
>
> -13739 0 15254 100.0% 3 765
>
> As far as i know the buffer cache and page cache was unified from Linux k=
ernel version 2.4. So i wondered why fio with option direct=3D1 that didn=
=E2=80=99t bypass page cache as it should?
>
> I didn=E2=80=99t see page cache increasing when using dd with oflag=3Ddir=
ect to copy or write file to disk.
>
> Please correct me if i am wrong.
>
> Thanks a lot in advance.
>
> Regards,
> Son
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
