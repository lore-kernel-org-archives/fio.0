Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:32980 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbbDXWun (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Apr 2015 18:50:43 -0400
Received: by qcrf4 with SMTP id f4so33486505qcr.0
        for <fio@vger.kernel.org>; Fri, 24 Apr 2015 15:50:43 -0700 (PDT)
MIME-Version: 1.0
From: Akash Verma <akashv@google.com>
Date: Fri, 24 Apr 2015 15:50:22 -0700
Message-ID: <CAFFT=UmoooCznxAkUREsC5rGN-hxD++PYbL94s-m11jdycDM0w@mail.gmail.com>
Subject: [Bug report] Runtime, IOPS, bandwidth recorded incorrectly if small
 size with time_based
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>
Cc: Brian Fulton <bfulton@google.com>

If there's a load with a very small size, but forced to repeat using
time_based, the runtime reported at the end, as well as IOPS,
bandwidth are wrong.

E.g. using this control file:

[short_and_suite]
rw=randread
bs=128k
size=128k
ioengine=libaio
time_based=1
runtime=1
filename=datafile.tmp

(where datafile.tmp already exists, for a more dramatic demonstration)
The results I'm seeing on a hard drive are:
read : io=304128KB, bw=24750MB/s, iops=198000, runt=    12msec

This is a regression from FIO 2.0.5, which gives the following results:
read : io=242176KB, bw=242418KB/s, iops=1893 , runt=   999msec

which is much more reasonable.
