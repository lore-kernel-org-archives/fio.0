Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35661 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbcHCGV6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Aug 2016 02:21:58 -0400
Received: by mail-wm0-f52.google.com with SMTP id f65so434349372wmi.0
        for <fio@vger.kernel.org>; Tue, 02 Aug 2016 23:21:57 -0700 (PDT)
MIME-Version: 1.0
From: Martin Dev <mrturtledev@gmail.com>
Date: Wed, 3 Aug 2016 07:21:56 +0100
Message-ID: <CAG6KGPRQf7Mii35T1drhL=u0mZB8PQEeOMnmuBFWSNgBy4E31A@mail.gmail.com>
Subject: Unlink after each loop in job
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm after the following data pattern from a job, which is 1 out of 4
jobs run at the same time:

Targeted at the filesystem level
Write Xgb of verifiable data to file
Verify file
Delete file
Loop

The idea is we want to test trim at the file system level, whilst also
having 3 other jobs that perform different workloads.

Unlink=1 will only trigger after all loops of a job are complete
exec_post_run will only trigger after all loops of a job are complete

I have implemented the functionality I'm after, by adding a
unlink_each_loop paremeter to options.c, and in backend.c under the
while(keep_running) I've added an unlink() to both the if block
checking verify is false (before the loop continue) and after the
verification, if the flag is set.

The problem is, I'm not a C programmer (in the slightest), and I don't
know FIO at all well. My code probably does not live up to the
standard, or understand the internals of FIO well enough to handle
errors in the correct way etc.

So I guess I have 2 questions,

1) Have I missed something which already does what I need (delete file
on each loop of a write job)
2) How can I get someone who actually knows what they're doing to
implement this feature :)

--Martin
