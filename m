Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:37482 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932833AbdHYWLp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 25 Aug 2017 18:11:45 -0400
Received: by mail-it0-f53.google.com with SMTP id 77so1087760itj.0
        for <fio@vger.kernel.org>; Fri, 25 Aug 2017 15:11:45 -0700 (PDT)
MIME-Version: 1.0
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Fri, 25 Aug 2017 15:11:44 -0700
Message-ID: <CAF+0mvk-1dfYeJ2XBFoi7afSPVAb1r0w=sDF0Eb-c5KvRtbeEQ@mail.gmail.com>
Subject: File Servicing
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello fio group.

I have a volume with 3573 files and I am trying to write to them 10 at
a time in sequential order so I have:

[job]
direct=1
bs=128k
rw=write
refill_buffers
opendir=/media/sped/rmfs
openfiles=10
file_service_type=sequential

The above is close to what I want. Fio sees all 3573 files but only
services 1 file at a time.

If I remove file_service_type=sequential fio services 10 files at a
time but using lsof I see only the last file incrementing:

fio       6003                  root    3u      REG               8,17
134217728      84934 /media/sped/rmfs/0001
fio       6003                  root    4u      REG               8,17
134217728      84935 /media/sped/rmfs/0002
fio       6003                  root    5u      REG               8,17
134217728      84936 /media/sped/rmfs/0003
fio       6003                  root    6u      REG               8,17
134217728      84937 /media/sped/rmfs/0004
fio       6003                  root    7u      REG               8,17
134217728      84938 /media/sped/rmfs/0005
fio       6003                  root    8u      REG               8,17
134217728      84939 /media/sped/rmfs/0006
fio       6003                  root    9u      REG               8,17
134217728      84940 /media/sped/rmfs/0007
fio       6003                  root   10u      REG               8,17
134217728      84941 /media/sped/rmfs/0008
fio       6003                  root   11u      REG               8,17
134217728      84942 /media/sped/rmfs/0009
fio       6003                  root   12u      REG               8,17
134217728      90617 /media/sped/rmfs/0058

Fio version is latest from git: fio-3.0-9-gb427

Is this the correct behavior?
