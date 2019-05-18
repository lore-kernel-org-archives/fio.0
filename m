Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw1-f43.google.com ([209.85.161.43]:45315 "EHLO
        mail-yw1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728813AbfERVKh (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 18 May 2019 17:10:37 -0400
Received: by mail-yw1-f43.google.com with SMTP id w18so4177783ywa.12
        for <fio@vger.kernel.org>; Sat, 18 May 2019 14:10:37 -0700 (PDT)
MIME-Version: 1.0
From: Gary Little <gary.j.little@gmail.com>
Date: Sat, 18 May 2019 17:10:26 -0400
Message-ID: <CANQrb8i=qoGivQuk4nGX-fce7zCf8_hqO=+VJzW7By_uCS1kvg@mail.gmail.com>
Subject: Issues with read_iolog trace replay
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I am trying to simulate bursty traffic with fo.  I know that I can do
this by tracing a bursty app and then doing a blktrace replay, but I
would like to do something programatic.

I had hoped that I could create an io_replay file that looks like this
which would read, then pause for 100ms before issuing the next read.
Once working I could then vary (lower) the "wait" period to generate
the bursts.

But what seems to happen is that all the "wait" lines are executed
sequentially, followed by all the "reads" sequentially, without the
100ms pause in-between.

FWIW, using blktrace input works as expected, and replays the trace at
the same iO rate as the traced workload.

[root@arches filebench]# /usr/local/bin/fio --version
fio-3.13

[root@arches filebench]# /usr/local/bin/fio --name=replay
--read_iolog=read100.csv

[gary@arches filebench]$ cat read100.csv
fio version 2 iolog
/dev/sdc add
/dev/sdc open
/dev/sdc read 16384 4096
/dev/sdc wait 100000 1
/dev/sdc read 16384 4096
/dev/sdc wait 100000 1
/dev/sdc read 16384 4096
/dev/sdc wait 100000 1
/dev/sdc read 16384 4096
/dev/sdc wait 100000 1
/dev/sdc read 16384 4096
/dev/sdc wait 100000 1
/dev/sdc read 16384 4096
/dev/sdc wait 100000 1
/dev/sdc read 16384 4096
/dev/sdc wait 100000 1
/dev/sdc read 16384 4096
/dev/sdc wait 100000 1
/dev/sdc read 16384 4096
/dev/sdc wait 100000 1
/dev/sdc read 16384 4096
/dev/sdc wait 100000 1
/dev/sdc close

