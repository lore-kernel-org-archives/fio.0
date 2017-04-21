Return-Path: <fio-owner@vger.kernel.org>
Received: from v150-95-18-100.b001.p.han1.static.cnode.io ([150.95.18.100]:48260
        "EHLO citigomail.webstarterz.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1034407AbdDUByc (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 20 Apr 2017 21:54:32 -0400
From: "Son Chu" <son.ct@citigo.com.vn>
Subject: Does fio really bypass page cache with option direct=1?
Date: Fri, 21 Apr 2017 08:54:26 +0700
Message-ID: <000001d2ba42$3546dc90$9fd495b0$@citigo.com.vn>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Sitsofe Wheeler' <sitsofe@gmail.com>
Cc: fio@vger.kernel.org

Hi Sitsofe,

Sorry if this email troubled you but I could not find any useful =
information for this. I am getting the question with fio page cache =
bypass option (direct=3D1 ioengine=3Dlibaio)

I am using fio version 2.19 with command:

fio --filename=3D/opt/test --direct=3D1 --rw=3Drandrw --randrepeat=3D0 =
--ioengine=3Dlibaio --bs=3D4k --rwmixread=3D75 --iodepth=3D16 =
--numjobs=3D1 --name=3D4ktest --size=3D1G

and i used cachestat tool from here to monitor: =
https://github.com/brendangregg/perf-tools

The output was:

Counting cache functions... Output every 1 seconds.

HITS MISSES DIRTIES RATIO BUFFERS_MB CACHE_MB

1399 42 0 97.1% 2 31

1408 0 0 100.0% 2 31

-68699 39 71478 100.1% 3 532

-21325 0 22886 100.0% 3 621

-19956 0 21492 100.0% 3 705

-13739 0 15254 100.0% 3 765

As far as i know the buffer cache and page cache was unified from Linux =
kernel version 2.4. So i wondered why fio with option direct=3D1 that =
didn=E2=80=99t bypass page cache as it should?

I didn=E2=80=99t see page cache increasing when using dd with =
oflag=3Ddirect to copy or write file to disk.

Please correct me if i am wrong.

Thanks a lot in advance.

Regards,
Son

