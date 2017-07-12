Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36192 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755283AbdGLFNh (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Jul 2017 01:13:37 -0400
Received: by mail-oi0-f50.google.com with SMTP id x187so10627408oig.3
        for <fio@vger.kernel.org>; Tue, 11 Jul 2017 22:13:37 -0700 (PDT)
MIME-Version: 1.0
From: Ido Ben-Tsion <idob@infinidat.com>
Date: Wed, 12 Jul 2017 08:13:16 +0300
Message-ID: <CAMHrwcRkq0vEiuqgqgZwN7djaJDS6=U1f6QPRWH2YDQpWf588w@mail.gmail.com>
Subject: unexpected stonewall parsing led jobs separated by stonewall to run concurrently
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

fio version: fio-2.21-37-ga2c9

fio file excerpt:
[global]
ioengine=sg
invalidate=1
ramp_time=5
iodepth=16
runtime=300
time_based
bs=64k
norandommap
loops=5

[seq_read-2-jobs]
rw=read
numjobs=2
stonewall

[randread]
rw=randread
[seq_write]
rw=write
stonewall
...

In the report, I see jobs with groupid 0 which are not supposed to be
on same group:
...,jobname,groupid,...
...,seq_read-2-jobs,0,...
...,seq_read-2-jobs,0,...
...,randread,0,...
...,seq_write,1,...


thanks,
Ido Ben-Tsion
