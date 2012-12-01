Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43113 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2LAIbn (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 1 Dec 2012 03:31:43 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so224546vby.19
        for <fio@vger.kernel.org>; Sat, 01 Dec 2012 00:31:43 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 1 Dec 2012 17:31:42 +0900
Message-ID: <CAPDOW77bBKw7dm1e+jHdN+PXMnAddEzQOxnL6nPY25nZU2FCfQ@mail.gmail.com>
Subject: I/O is issued twice at scsi level
From: Hiroyuki Yamada <mogwaing@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am using fio for benchmarking random read IOPS of files.
(Test configuration is listed at the bottom.)

I have traced I/Os from fio by systemtap and
noticed that the number of I/Os at scsi level is twice as many as the
number of I/Os at vfs level.
But, I/O size at both scsi level and vfs level shown as 4KB, so simply
measured 1/2 performance.
I also tried by benchmarking tools and the same issue happend.
so, it's not fio specific issue.
But, I am wondering if any of you knows the reason for that or some hints.


Test configuration.
=================
ioengine=psync
rw=randread
numjobs=1
blocksize=4096
filename=file_morethan_100G
thread
runtime=60
randrepeat=0
=================
(I clean up page caches every time before mesurement.)


Thanks,
Hiroyuki
