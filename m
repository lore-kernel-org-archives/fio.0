Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33695 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2DRPlX (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Apr 2012 11:41:23 -0400
Received: by vbbff1 with SMTP id ff1so5042053vbb.19
        for <fio@vger.kernel.org>; Wed, 18 Apr 2012 08:41:22 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Apr 2012 08:41:22 -0700
Message-ID: <CAKa9NmtX=2jQGDGaesyLQtrpdHbPExZ6Dq4ikKOSt35NtbrBYw@mail.gmail.com>
Subject: fio memory usage
From: Vikram Seth <seth.vik@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

What's the max memory used per job (per device) for fio? Is there a
rule of thumb for min memory needed for fio?
Like, if I am running N #threads with numjobs on M #devices in the
system, then I'd like to know if I have enough memory before I start
the test rather than I wait for it to crashes days later.

Also, in case fio finds that it is running out of memory while
running, then does it generate an OOM kind of message in the output
file that can be used to track the reason for a crashed test.

Thanks,

Vikram.
