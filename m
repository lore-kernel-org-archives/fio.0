Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34914 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbbDHKh3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Apr 2015 06:37:29 -0400
Received: by wgyo15 with SMTP id o15so72681610wgy.2
        for <fio@vger.kernel.org>; Wed, 08 Apr 2015 03:37:28 -0700 (PDT)
MIME-Version: 1.0
From: Samuel Shapiro <samuel.sh79@gmail.com>
Date: Wed, 8 Apr 2015 13:37:08 +0300
Message-ID: <CANt18PxHj5p6f9gXsuKCRDNXwgo_nW0MwD0wM6QbYENBtJd1ww@mail.gmail.com>
Subject: during fio scenario with verify=meta some jobs fails
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi All,

I'd recently started using fio for NAS FS tests, and it's really great
tool, as for loading system,
so for finding various protocols bugs. Thank You :)
One of the scenarios, I'm using is "fsx", that is slightly modified to
run with 16 jobs:

; This job file works pretty works similarly to running fsx-linux
; with -r 4096 -w 4096 -Z -N 500000
[global]
verify=meta
verify_dump=1

[fsx-file-job1]
directory=/mnt/FIO-some-mountpoint-to-NAS-01
ioengine=libaio
iodepth=256
rw=randrw
size=256k
bs=4k
norandommap
direct=1
loops=500000

[fsx-file-job2]
directory=/mnt/FIO-some-mountpoint-to-NAS-02
ioengine=libaio
iodepth=256
rw=randrw
size=256k
bs=4k
norandommap
direct=1
loops=500000
.
.
.
[fsx-file-job16]
directory=/mnt/FIO-some-mountpoint-to-NAS-03
etc....

After several minutes if running scenario, jobs starting to fail on
"verify meta", generating
".state" files.
When I tried to run the same scenario with verify=md5 , there were no
more verify failures reported.

So I have couple of questions:
1. What is the possible reason verify=meta can fail?
2. Should I suspect my File System for data corruption or there is
some known fio issue?
3. How can I parse ".state" file so I could compare its data to
original file on storage?

Thank You,
Samuel
