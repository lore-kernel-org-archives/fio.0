Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33702 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967811AbeEYTVA (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 25 May 2018 15:21:00 -0400
Received: by mail-wm0-f51.google.com with SMTP id x12-v6so33819744wmc.0
        for <fio@vger.kernel.org>; Fri, 25 May 2018 12:20:59 -0700 (PDT)
Received: from [192.168.0.102] (146-241-34-115.dyn.eolo.it. [146.241.34.115])
        by smtp.gmail.com with ESMTPSA id z8-v6sm30684576wrl.62.2018.05.25.12.20.56
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 May 2018 12:20:57 -0700 (PDT)
From: Paolo Valente <paolo.valente@linaro.org>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: time_based not working with randread
Message-Id: <F0E1506A-A23F-4C12-B003-9860F71FC91A@linaro.org>
Date: Fri, 25 May 2018 21:20:55 +0200
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
if I run this job (even with the last version GitHub version of fio) on =
an SSD:
[global]
 ioengine=3Dsync
 time_based=3D1
 runtime=3D20
 readwrite=3Drandread
 size=3D100m
 numjobs=3D1
 invalidate=3D1
[job1]

then, after little time (I think after 100MB have been read), fio =
reports a nonsensically large value for the throughput, while a simple =
iostat shows that no I/O is going on. By just replacing time_based with =
loops, i.e., with a job file like this:

[global]
 ioengine=3Dsync
 loops=3D1000
 readwrite=3Drandread
 size=3D100m
 numjobs=3D1
 invalidate=3D1
[job1]

the problem disappears.

In a similar vein, there is no problem with sequential reads, even in =
time_based mode.

Looks like fio re-reads the file from cache in with time_based randread.

Thanks,
Paolo=
