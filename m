Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f169.google.com ([209.85.166.169]:56251 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfDZF2s (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Apr 2019 01:28:48 -0400
Received: by mail-it1-f169.google.com with SMTP id y134so3943952itc.5
        for <fio@vger.kernel.org>; Thu, 25 Apr 2019 22:28:48 -0700 (PDT)
MIME-Version: 1.0
From: Prabhakaran <prabhugce@gmail.com>
Date: Thu, 25 Apr 2019 23:28:36 -0600
Message-ID: <CAPqbHXjNdcEwM_nfVaRu6BxVzg2HjBVZo0jdPGqJV=xw4=UHfw@mail.gmail.com>
Subject: Sequential Writes and Random Reads in parallel
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I=E2=80=99m trying to do both Random and Sequential operations simultaneous=
ly
in one job. In specific, I would like to do Sequential Writes and
Random Reads in parallel. Here is what I have got so far.

[global]
ioengine=3Dlibaio
disable_slat=3D1
disable_lat=3D1
thread
direct=3D1

[job2]
stonewall
bs=3D128kb,4kb
ba=3D128kb,4kb
rw=3Drandrw
iodepth=3D256
runtime=3D5s
time_based=3D1
log_avg_msec=3D0
randrepeat=3D0
norandommap
refill_buffers
write_bw_log=3Djob2
write_iops_log=3Djob2
write_lat_log=3Djob2
bs_is_seq_rand=3D1
rwmixread=3D1
percentage_random=3D50

I=E2=80=99m assuming the above job would do 128k Sequential and 4k Random (=
50%
each), writes and reads (with reads=3D1%) combined for both Sequential
and Random, for 5s.
I=E2=80=99m still not able to do just Sequential Writes and Random Reads al=
one
in parallel.

Thanks,
Prabhu

