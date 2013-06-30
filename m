Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60471 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3F3Uqw (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 30 Jun 2013 16:46:52 -0400
Received: by mail-pb0-f44.google.com with SMTP id uo1so4051052pbc.31
        for <fio@vger.kernel.org>; Sun, 30 Jun 2013 13:46:52 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 30 Jun 2013 16:46:52 -0400
Message-ID: <CAJLXCZSLQ_GcM=v_nn8xKY+4+bBJC5DSqX9cDf58V5Diwm5MQQ@mail.gmail.com>
Subject: Understanding bandwidth results
From: Andrew Davidoff <davidoff@qedmf.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

In fio output, I see two values for bandwidth that I'd expect to be
the same, but that are different. For example, in the results from a
sync randread fileio test:

read : io=182811KB, bw=18279KB/s, iops=18279, runt= 10001msec
...
    bw (KB  /s): min=  966, max=21410, per=99.59%, avg=18204.94, stdev=5773.57


I realize they are close, but why are the values for bw= and avg= not
the same? I want to make sure I understand if these are not actually
reporting on the same statistic.

Also, why is per= not 100%, if this job was run with only a single
thread in a single group?

Thanks.
Andy
