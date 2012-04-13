Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42183 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971Ab2DMXsL (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 13 Apr 2012 19:48:11 -0400
Received: by eaaq12 with SMTP id q12so889219eaa.19
        for <fio@vger.kernel.org>; Fri, 13 Apr 2012 16:48:10 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 13 Apr 2012 16:48:10 -0700
Message-ID: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com>
Subject: Running fio with offset Increment option
From: Suresh Dhanarajan <sureshdrajan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I wanted to use the "offset increment option" and  "numjobs" so that i
can split the work load between ten jobs and reduce the run time.
But what i am seeing is that the offset counter is not getting reset
when the first job in the jobfile is completed.(is it that the offset
is global for the job file and not for the Jobs inside the jobfile?)
So  my read starts from the last offset set by the writes.

here is my job file,

[global]
bs=64k
direct=1
numjobs=10
size=1m
group_reporting

[write-phase]
offset_increment=1m
filename=/dev/sdb
rw=write
write_iolog=verfywrite2

[read-phase]
stonewall
offset_increment=1m
filename=/dev/sdb
rw=read
write_iolog=verfyread2

I tried using the offset=0 option in the read phase job but now every
time the read happens from zeroth offsite.
Now the offset increment option is not getting honored.

[write-phase]
offset_increment=1m
filename=/dev/sdb
rw=write
write_iolog=verfywrite2

[read-phase]
stonewall
offset=0
offset_increment=1m
filename=/dev/sdb
rw=read
write_iolog=verfyread2

I tried the same case with verify option.
the behavior is same.

Is there any way that i can reset the offset counters once the job is completed?

thanks,
