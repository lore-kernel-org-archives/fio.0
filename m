Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:57796 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab3KSRMI (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Nov 2013 12:12:08 -0500
Received: by mail-la0-f52.google.com with SMTP id ev20so6299886lab.39
        for <fio@vger.kernel.org>; Tue, 19 Nov 2013 09:12:07 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 19 Nov 2013 11:12:07 -0600
Message-ID: <CAEyTGCcDDgN=5Oa0J_40Q2F=uoGSZkAtrbR0npzjZLzfmSZ=EQ@mail.gmail.com>
Subject: Blktrace replay in FIO failed with lseek err=22
From: Lakshmi Devi <sendtold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am using FIO version 2.1.1 and blktrace 2.0.0

I ran a read, 4K workload through FIO and collected blktrace for it.
I got like 16 trace files one for each CPU core with varying sizes.

I parsed one of the files as below
blkparse -i ./*.blktrace.0 -d ./bp.bin -o bp.txt -w 0:600

used this bp.bin to perform a read_iolog in FIO.

When I replay in FIO using read_iolog=/root/bp.bin , I get the below error.

Replay: (groupid=0, jobs=1): err=22 file engine sync.c: 45, func=lseek,
error=invalid argument.

Please help me understand the reason for this error


Thanks
