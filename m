Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbhESRcz (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 May 2021 13:32:55 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C14C06175F
        for <fio@vger.kernel.org>; Wed, 19 May 2021 10:31:35 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j10so20252456lfb.12
        for <fio@vger.kernel.org>; Wed, 19 May 2021 10:31:35 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?15HXldei15Yg15HXnyDXqdeR16o=?= <boazbsh@gmail.com>
Date: Wed, 19 May 2021 20:31:22 +0300
Message-ID: <CAKpZRtGwiYWz2q+n4n5C3u_8EAmN46hkF+idBaHs0K9L0DU3sQ@mail.gmail.com>
Subject: FIO mixed workload
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hey I'm trying to create a mixed workload with FIO, basically, I'm
trying to regulate the proportion of activity between jobs, what I'm
trying to achieve is:

oltp1_A - 10% of the total workload
oltp1_B - 35% of the total workload
oltp1_C - 35% of the total workload
oltp1_D - 5% of the total workload
oltp1_E - 15% of the total workload

Which according to my calculation should translate to the following ratio:
2:7:7:1:3

However, when I add the "flow" per job according to my ratios above
I'm getting a rate of 0 IOPS.
Can anyone tell me what am I doing wrong?
Thanks a lot!


FIO config file:

ioengine=libaio
runtime=20
time_based
norandommap
group_reporting
disk_util=0
continue_on_error=all
rate_process=poisson
group_reporting=1

[oltp1_A]
direct=0
buffered=1
block=4k
size=2G
filename=/var/stuff/bla1
rw=randread
iodepth=64
flow=2

[oltp1_B]
direct=1
buffered=0
block=4k
size=2G
filename=/var/stuff/bla2
rw=randread
iodepth=64
flow=7

[oltp1_C]
direct=1
buffered=0
block=4k
size=2G
filename=/var/stuff/bla3
rw=randwrite
iodepth=64
flow=7

[oltp1_D]
direct=1
buffered=0
block=4k
size=2G
filename=/var/stuff/bla3
rw=read
iodepth=64
flow=1

[oltp1_E]
direct=1
buffered=0
block=4k
size=2G
filename=/var/stuff/bla3
rw=write
iodepth=64
flow=3

