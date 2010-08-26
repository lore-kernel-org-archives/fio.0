Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33295 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0HZTZL (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 Aug 2010 15:25:11 -0400
Received: by qyk9 with SMTP id 9so6377763qyk.19
        for <fio@vger.kernel.org>; Thu, 26 Aug 2010 12:25:10 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 26 Aug 2010 12:25:10 -0700
Message-ID: <AANLkTimTvSmj-1L80KAyVf7uv9d+vDENsMj-_bFDqRBR@mail.gmail.com>
Subject: using ioengine=sg
From: Chuck Tuffli <ctuffli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi -

Reading the man page under ioengine, it mentions that sg will do
asynchronous IO if the target is the sg character device. So I'm
assuming that means a job file something like

> cat sgtest.fio
[global]
bs=512b
readwrite=read
ioengine=sg
size=1m

[/dev/sg2]

but when I run it,

> uname -srp
Linux 2.6.34-12-default x86_64
> ls -l /dev/sg2
crw-rw---- 1 root disk 21, 2 Aug 26 17:46 /dev/sg2
> ./fio --version
fio 1.43.1
> sudo ./fio sgtest.fio
/dev/sg2: (g=0): rw=read, bs=512-512/512-512, ioengine=sg, iodepth=1
Starting 1 process
fio: pid=3147, got signal=11


Run status group 0 (all jobs):
fio: file hash not empty on exit

Any idea what I'm doing wrong or might be missing on the system? Thanks!

---chuck
