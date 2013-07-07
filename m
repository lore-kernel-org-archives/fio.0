Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44339 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3GGQs4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 7 Jul 2013 12:48:56 -0400
Received: by mail-ie0-f178.google.com with SMTP id u16so8624546iet.9
        for <fio@vger.kernel.org>; Sun, 07 Jul 2013 09:48:56 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 7 Jul 2013 12:48:55 -0400
Message-ID: <CAJLXCZS6LzU3xCRmRsRwg_ddogS2c-rcWwpPafuDvi7OqcT9eg@mail.gmail.com>
Subject: Understanding iostat and vmstat output
From: Andrew Davidoff <davidoff@qedmf.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I realize this question isn't specifically fio related, but I imagine
many people on this list can accurately answer this question, and I
think the answer would be valuable for anyone doing disk IO
benchmarking/analysis. I looked for vmstat and iostat mailing lists
and documentation and came up short. I apologize if this is just
entirely inappropriate for this list.

I have noticed that while doing continuous writes with dd (simply
streaming from a partition to a file), vmstat's bo (blocks out)
counter sits at zero for long lengths of time while iostat's w/s (and
related) show significant write traffic. vmstat's bo jumps from 0
occasionally, and I have definitely correlated some of these bo counts
to hitting dirty_background_ratio.

I have noticed the same behavior when using fio in a write mode with
direct=0. In contrast, with fio's direct=1, vmstat's bo always shows
non-zero while iostat's w/sec and friends also show non-zero.

So, it seems like iostat is reporting all writes to disks/partitions
even if they are serviced by cached, but vmstat only reports bo/bi if
data is read or written from a disk (ex: when dirty pages are
flushed).

Is this accurate?

Thanks, and again, apologies if this is considered totally
inappropriate for this list.
Andy
