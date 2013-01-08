Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:54310 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab3AHTpt (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Jan 2013 14:45:49 -0500
Received: by mail-la0-f42.google.com with SMTP id fe20so913590lab.29
        for <fio@vger.kernel.org>; Tue, 08 Jan 2013 11:45:48 -0800 (PST)
MIME-Version: 1.0
From: Niraj Tolia <ntolia@maginatics.com>
Date: Tue, 8 Jan 2013 11:37:28 -0800
Message-ID: <CA+6NFoBAhy8jR8jg8_MqDH8WP_e+Y2BVFxCysKo2Nqhkj8cmZw@mail.gmail.com>
Subject: Segfault on OS X
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am running fio (HEAD:a28b019) on OS X (10.8.2) and just ran into a
segfault after more than an hour of running the benchmark. Will dig
into this more but wanted to check if someone else had run into this.
I did manage to get a core though. There were three threads running
with two sitting in __semwait_signal () (via usleep) and the third
was:

[Switching to thread 3 (core thread 2)]
0x000000010fcf7910 in thread_main (data=0x1105fe000) at backend.c:510
510            if (break_on_this_error(td, io_u->ddir, &ret))
(gdb) where
#0  0x000000010fcf7910 in thread_main (data=0x1105fe000) at backend.c:510
#1  0x00007fff885d1742 in _pthread_start ()
#2  0x00007fff885be181 in thread_start ()

It seems like io_u is null here.

Cheers,
Niraj
