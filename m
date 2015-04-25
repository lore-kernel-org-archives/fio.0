Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38620 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbbDYSEs (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 25 Apr 2015 14:04:48 -0400
Received: by igbhj9 with SMTP id hj9so36847873igb.1
        for <fio@vger.kernel.org>; Sat, 25 Apr 2015 11:04:47 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 25 Apr 2015 11:04:47 -0700
Message-ID: <CAHA74uot2-dZCi=iehNRgx0RF55QsBpLFFcxQ7KqdXmjbn1FuA@mail.gmail.com>
Subject: fio queue depth and windows build.
From: Iuliu Rus <iuliur@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,
Looking at fio for windows, we are pretty sure that the queue depth
parameter is not working.
We wanted to investigate this ourselves and prepare a fix, but the
windows build is not working either. From a cygwin64 shell, make clean
and make -j results in this:
t/dedupe.c:13:23: fatal error: sys/ioctl.h: No such file or directory
(although i see ioctl.h under cygwin64\usr\include\sys and under
cygwin64\usr\i686-pc-cygwin\sys-root\usr\include\sys).
Any idea why the build fails?
