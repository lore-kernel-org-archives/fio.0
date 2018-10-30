Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f42.google.com ([209.85.166.42]:35298 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbeJ3Sx0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 Oct 2018 14:53:26 -0400
Received: by mail-io1-f42.google.com with SMTP id 79-v6so6853277iou.2
        for <fio@vger.kernel.org>; Tue, 30 Oct 2018 03:00:40 -0700 (PDT)
MIME-Version: 1.0
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Tue, 30 Oct 2018 15:30:38 +0530
Message-ID: <CAFF4W0UAVN49BsfKa+nkzgCd8XKEPi57f9v8785YR5wjXqzepQ@mail.gmail.com>
Subject: Understanding --section=name option.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hello all,

Below is my job file

[job1]
rw=randread
size=100M

[job2]
rw=read
size=10m

I want to run the job2 only, so used --section option.
Below is the docker command have used to test --section option.

docker run -v /home/:/tmp/fio-data/ fio:5.0 --section job2 --client
172.17.0.3 read.fio

hostname=7e742f684ce7, be=0, 64-bit, os=Linux, arch=x86-64,
fio=fio-3.11-21-g307f, flags=1
<7e742f684ce7> job35: (g=0): rw=randread, bs=(R) 4096B-4096B, (W)
4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
<7e742f684ce7> hello: (g=0): rw=read, bs=(R) 4096B-4096B, (W)
4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
<7e742f684ce7> Starting 2 processes

But both process is running.

May be I am not using the option properly, please explain how to use
the option based on the job file I have given here.

Thanks and Regards,
Mohan

