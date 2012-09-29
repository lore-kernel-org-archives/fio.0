Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52989 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759399Ab2I2CL2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 28 Sep 2012 22:11:28 -0400
Received: by lbon3 with SMTP id n3so2581755lbo.19
        for <fio@vger.kernel.org>; Fri, 28 Sep 2012 19:11:27 -0700 (PDT)
MIME-Version: 1.0
From: Akash Verma <akashv@google.com>
Date: Fri, 28 Sep 2012 19:11:06 -0700
Message-ID: <CAFFT=U=WusZz8z+J93NvS8QEe=4NuDtiHHJ6_KJQ=gLAggdouA@mail.gmail.com>
Subject: Should group_reporting be clumping together different groups?
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Let's say I use FIO with the following job file:


[group_1]
rw=randwrite
size=1024k
ioengine=libaio
time_based=1
runtime=10
direct=1
do_verify=0
numjobs=2
group_reporting=1

[group_2]
rw=randread
size=1024k
ioengine=libaio
time_based=1
runtime=10
direct=1
numjobs=2
group_reporting=1


I get a single report, named after group_1 but actually including
results for group_2 as well. Since I'm using group_reporting with
numjobs, shouldn't I be getting two reports, one for group_1 and one
for group_2?

I am able to get the desired functionality using:
new_group=1
under group_2, causing FIO to specifically treat that group as
separate for reporting purposes. However the current behavior still
doesn't conform with the description given for both group_reporting
and new_group.

Thanks,
Akash
