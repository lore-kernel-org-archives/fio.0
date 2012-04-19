Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40344 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab2DSN4v (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Apr 2012 09:56:51 -0400
Received: by iagz16 with SMTP id z16so11953962iag.19
        for <fio@vger.kernel.org>; Thu, 19 Apr 2012 06:56:51 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 Apr 2012 21:56:50 +0800
Message-ID: <CAOipSa2xmUmcNTFT5SSBJ0CnDHEpZVmkekWuSf5BnC47u_s3zA@mail.gmail.com>
Subject: fio: first direct io errored
From: bin lin <lbin186@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi, i am a newer with fio. i have written a read_iolog and use fio to
run the trace in a

device /dev/sdb1, but it had errors when add --direct=1. the errors is
as follows:

replay: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 2.0.6
Starting 1 process
fio: first direct IO errored. File system may not support direct IO,
or iomem_align= is bad.
fio: pid=6363, err=22/file:engines/sync.c:62, func=xfer, error=Invalid argument

the trace file is as follows:
fio version 2 iolog
/dev/sdb1 add
/dev/sdb1 open
/dev/sdb1 read 27267456 8
/dev/sdb1 read 27267560 8
/dev/sdb1 read 34933120 8
/dev/sdb1 read 34933128 8
/dev/sdb1 read 34933136 8
/dev/sdb1 read 34933144 8
/dev/sdb1 read 34604888 8
/dev/sdb1 close

The filesystem on /dev/sdb1 is ext3 which supports the O_DIRECT, and
the trace file use

block size as 512 byte. I do not know where the error is and how to
solve it ? thanks

Best regards, linbin.
