Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f178.google.com ([209.85.166.178]:52848 "EHLO
        mail-it1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbeKZCQM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 25 Nov 2018 21:16:12 -0500
Received: by mail-it1-f178.google.com with SMTP id i7so24611865iti.2
        for <fio@vger.kernel.org>; Sun, 25 Nov 2018 07:24:54 -0800 (PST)
MIME-Version: 1.0
From: Bari Antebi <bari@lightbitslabs.com>
Date: Sun, 25 Nov 2018 17:24:42 +0200
Message-ID: <CALD1HU=N7v3ZV9fFF0cEsO50GtHPrPV-XEa5mRsFyoaX8+P8zQ@mail.gmail.com>
Subject: FIO compression bug
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

To Whom It May Concern,

I've noticed a bug in fio while testing it. I expected to receive
output similar to the expected output below for: "hexdump -n 4096
/dev/nvme0n1" (considering the configuration file I've used  that may
be found below).

Expected output:

0000000 fdc6 a8a8 7190 0219 1fb8 9632 d9dd 1e64
                /* random data */
00004c0 d8a3 13fe aeec 0fb6 5b14 162e 0000 0000
00004d0 0000 0000 0000 0000 0000 0000 0000 0000
*
0001000


However, the output I've received  contained data after address 4cc
(which should have been filled with zeros until 1000 as far as I
understand, but as you can see 99a contains data.


0000000 fdc6 a8a8 7190 0219 1fb8 9632 d9dd 1e64
/* random data */
00004c0 d8a3 13fe aeec 0fb6 5b14 162e 0000 0000
00004d0 0000 0000 0000 0000 0000 0000 0000 0000
*
0000990 0000 0000 0000 0000 fdc6 a8a8 7190 0219

Config file:

[global]
group_reporting=1
filename=/dev/nvme0n1
name=task_nvme0n1
rw=write
bs=4096
numjobs=1
iodepth=32
buffer_compress_chunk=4096
buffer_compress_percentage=70
cpus_allowed=0-8
cpus_allowed_policy=split
direct=1
ioengine=libaio
loops=1
refill_buffers=0

[job empty]
size=4096

The version I ran is  fio-3.11, but it seems the bug wasn't fixed in
the new version from a look at the code.

I solved the issue locally & would like to send a pr for the fix.
The problem in the code maybe found in "lib/rand.c", at the function
"__fill_random_buf_percentage".
After fio finishes to write the random part, it should write the
remainder of "((unsigned long long)segment * (100 - percentage)) /
100",
but currently it writes "this_len" zeros which seems wrong.

My solution is to add a single line under line 168 (of the current fio
version). If it's possible I'd like to add the PR myself, it will be
my first contribution to any open source code :)
168. buf += this_len;
169. this_len = segment - this_len

Have a light day,
Bari Antebi - Software developer at Lightbits


This message is sent in confidence for the addressee only.  It may
contain legally privileged information. The contents are not to be
disclosed to anyone other than the addressee. Unauthorized recipients
are requested to preserve this confidentiality, advise the sender
immediately of any error in transmission and delete the email from
their systems.

