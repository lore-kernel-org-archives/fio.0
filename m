Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:65513 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2BRBbj (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Feb 2012 20:31:39 -0500
Received: by qafk1 with SMTP id k1so4186294qaf.19
        for <fio@vger.kernel.org>; Fri, 17 Feb 2012 17:31:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAUT-yOi26hzpOdzCbSDTS9AE_y96USLK25LVYvfzCFP5skJ4g@mail.gmail.com>
References: <CAAUT-yOi26hzpOdzCbSDTS9AE_y96USLK25LVYvfzCFP5skJ4g@mail.gmail.com>
From: Steven Lang <tirea@google.com>
Date: Fri, 17 Feb 2012 17:31:18 -0800
Message-ID: <CAAUT-yOd-gnfN-tEC3SY-RcBON5tYqOz6DyRqXfwNyGq71mPgA@mail.gmail.com>
Subject: Re: Something odd with the fio random offset generator & time_based runs
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Looking into it more, what seems to be going on is that after writing
td->o.size bytes, a time_based job silently closes all open files,
resets, and starts over.  Part of the process of resetting involves
re-seeding all the random numbers.

It seems like there are other implications to the reset as well.  For
example, in async ioengines it drains all the remaining IO, which
results in less throughput.  Potentially latency numbers could be
effected as well, either positively or negatively.

Would it make sense, for time_based runs, to not break out of the loop
in do_io() so the state doesn't get reset?  This would also allow the
removal of the check in keep_running() for time_based, which would
then allow "time_based" and "loops" to be used together in a
meaningful way.

At first blush, this would probably just be a case of adding "||
(td->o.time_based)" to the loop condition in do_io(), and that
certainly addressed the case of random IO whe norandommap I initially
saw.  But the same performance issues could apply to sequential loads
and random mapped loads, and just changing the loop condition didn't
have any effect on that.  There is something else which is determining
that the end condition is met for sequential loads, read_iolog loads,
and randommap loads.  (For read_iolog loads, time_based and loops have
no effect, so I'm not sure the value of changing that.)

Would it be difficult to change the behavior so only loops= causes
do_io() to be called repeatedly like that?
