Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lj1-f172.google.com ([209.85.208.172]:33281 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgDDQrn (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Apr 2020 12:47:43 -0400
Received: by mail-lj1-f172.google.com with SMTP id f20so10224334ljm.0
        for <fio@vger.kernel.org>; Sat, 04 Apr 2020 09:47:41 -0700 (PDT)
MIME-Version: 1.0
From: Yigal Korman <ykorman@gmail.com>
Date: Sat, 4 Apr 2020 19:47:29 +0300
Message-ID: <CAOdGBnHqcmD2ZkKRFS4K=+pvDbqhe=1tgifw1+sDV0SUuoz77A@mail.gmail.com>
Subject: [Suggestion] build option to externalize ioengine
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I was wondering if you'll be open to a pull-request that adds a
'configure' option to convert some of the more dependency-heavy
ioengines into external engines?
The reason - installing fio via the distro package manager brings a
lot of dependencies[0], which are entirely unnecessary if all one
needs is the sync ioengine.
So I'd like to suggest externalizing some and packaging them
separately as optional.

Regards,
Yigal

[0] List of dependencies on Fedora 31:

[vm@vm1 fio]$ sudo dnf deplist fio | grep provider | sort | uniq
Last metadata expiration check: 0:02:14 ago on Sat 04 Apr 2020 04:36:08 PM UTC.
   provider: bash-5.0.11-1.fc31.x86_64
   provider: glibc-2.30-10.fc31.x86_64
   provider: libaio-0.3.111-6.fc31.x86_64
   provider: libibverbs-20.1-6.fc31.x86_64
   provider: libpmem-1.7-1.fc31.x86_64
   provider: libpmemblk-1.7-1.fc31.x86_64
   provider: librados2-2:14.2.8-1.fc31.x86_64
   provider: librbd1-2:14.2.8-1.fc31.x86_64
   provider: librdmacm-20.1-6.fc31.x86_64
   provider: numactl-libs-2.0.12-3.fc31.x86_64
   provider: python3-3.7.6-2.fc31.x86_64
   provider: zlib-1.2.11-20.fc31.x86_64

