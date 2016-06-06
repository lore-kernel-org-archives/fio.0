Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36290 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbcFFVAO (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Jun 2016 17:00:14 -0400
Received: by mail-oi0-f52.google.com with SMTP id p204so50513808oih.3
        for <fio@vger.kernel.org>; Mon, 06 Jun 2016 14:00:14 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Jun 2016 17:00:13 -0400
Message-ID: <CAJ9yE1BYp_jqjwVVap1U-zjYfGT6bsOuXbOMcJV0r8Mz-5LQBQ@mail.gmail.com>
Subject: computing percentiles from fio data
From: Karl Cronburg <kcronbur@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

In benchmarking ceph I've been using fio / fiologparser, and want to
get out the sort of stats & percentiles fiologparser currently gives
(min, avg, max, percentiles). However I'm concerned the data coming
out of fio is insufficient when I pass it the log_avg_msec argument.
Namely using the average of a possibly asymmetric sample distribution
(the set of I/O request samples over which fio is averaging when I
pass it this argument) will not give accurate percentiles.

Something like this argument is necessary though to keep the log files
a reasonable size. Would it be a good idea to push the sort of
statistics done in the log parser directly into fio? I'm considering
writing some code to compute the quantiles directly in fio, either
brute-force by maintaining a sorted list or implementing something
like the algorithm described here:

http://www.cs.rutgers.edu/~muthu/bquant.pdf

with some acceptable user-defined level of error given to fio when
asked to compute the percentiles on long-running / large data sets.

Is there any interest in having this added directly into fio? If so
where in the code should I be looking?

-Karl Cronburg-
