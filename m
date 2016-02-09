Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35904 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbcBINCP (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Feb 2016 08:02:15 -0500
Received: by mail-lf0-f53.google.com with SMTP id 78so114904197lfy.3
        for <fio@vger.kernel.org>; Tue, 09 Feb 2016 05:02:14 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 9 Feb 2016 14:02:13 +0100
Message-ID: <CADr68WaBX2_Z9+dfScoLb62Td+sUWsuCS0F2q1L9JgYBP+m9rA@mail.gmail.com>
Subject: Small writes being split with fdatasync based on non-aligned
 partition ending
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Fio <fio@vger.kernel.org>, linux-kernel@vger.kernel.org

While trying to reproduce some performance issues I have been seeing
with Ceph, I have come across a strange behaviour which is seemingly
affected only by the end point (and thereby the size) of a partition
being an odd number of sectors. Since all documentation about
alignment only refers to the starting point of the partition, this was
pretty surprising and I would like to know whether this is expected
behaviour or maybe a kernel issue.

The command I am using is pretty simple:

fio --rw=randwrite --size=1G --fdatasync=1 --bs=4k
--filename=/dev/sdb2 --runtime=10 --name=test

The difference shows itself when the partition is created either by
sgdisk or by parted:

sgdisk --new=2:6000M: /dev/sdb

parted -s /dev/sdb mkpart osd-device-1-block 6291456000B 100%

The difference in the partition table looks like this:

<  2      6291456000B  1600320962559B  1594029506560B
osd-device-1-block
---
>  2      6291456000B  1600321297919B  1594029841920B               osd-device-1-block

So this is really only the end of the partition that is different.
However, in the first case, the 4k writes all get broken up into 512b
writes somewhere in the kernel, as can be seen with btrace:

  8,16   3       36     0.000102666  8184  A  WS 12353985 + 1 <- (8,18) 65985
  8,16   3       37     0.000102739  8184  Q  WS 12353985 + 1 [fio]
  8,16   3       38     0.000102875  8184  M  WS 12353985 + 1 [fio]
  8,16   3       39     0.000103038  8184  A  WS 12353986 + 1 <- (8,18) 65986
  8,16   3       40     0.000103109  8184  Q  WS 12353986 + 1 [fio]
  8,16   3       41     0.000103196  8184  M  WS 12353986 + 1 [fio]
  8,16   3       42     0.000103335  8184  A  WS 12353987 + 1 <- (8,18) 65987
  8,16   3       43     0.000103403  8184  Q  WS 12353987 + 1 [fio]
  8,16   3       44     0.000103489  8184  M  WS 12353987 + 1 [fio]
  8,16   3       45     0.000103609  8184  A  WS 12353988 + 1 <- (8,18) 65988
  8,16   3       46     0.000103678  8184  Q  WS 12353988 + 1 [fio]
  8,16   3       47     0.000103767  8184  M  WS 12353988 + 1 [fio]
  8,16   3       48     0.000103879  8184  A  WS 12353989 + 1 <- (8,18) 65989
  8,16   3       49     0.000103947  8184  Q  WS 12353989 + 1 [fio]
  8,16   3       50     0.000104035  8184  M  WS 12353989 + 1 [fio]
  8,16   3       51     0.000104150  8184  A  WS 12353990 + 1 <- (8,18) 65990
  8,16   3       52     0.000104219  8184  Q  WS 12353990 + 1 [fio]
  8,16   3       53     0.000104307  8184  M  WS 12353990 + 1 [fio]
  8,16   3       54     0.000104452  8184  A  WS 12353991 + 1 <- (8,18) 65991
  8,16   3       55     0.000104520  8184  Q  WS 12353991 + 1 [fio]
  8,16   3       56     0.000104609  8184  M  WS 12353991 + 1 [fio]
  8,16   3       57     0.000104885  8184  I  WS 12353984 + 8 [fio]

whereas in the second case, I'm getting the expected 4k writes:

  8,16   6       42 1266874889.659842036  8409  A  WS 12340232 + 8 <-
(8,18) 52232
  8,16   6       43 1266874889.659842167  8409  Q  WS 12340232 + 8 [fio]
  8,16   6       44 1266874889.659842393  8409  G  WS 12340232 + 8 [fio]

The above examples are from running with an SSD, where the small
writes get merged together again before hitting the block device,
which is still pretty o.k. performance wise. But when I run the same
test on some NVMe device, the writes do not get merged, instead the
performance drops to less then 10% of what I get in the second case.

If this is indeed expected behaviour from the kernel pov, it might
need some better documentation and probably sgdisk should also be
enhanced to align the end of the partition as well. FWIW, this happens
on a stock 4.4.0 kernel as well as recent Ubuntu and CentOS kernels.
