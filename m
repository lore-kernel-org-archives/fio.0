Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42474 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab2HGBDI (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Aug 2012 21:03:08 -0400
Received: by pbbrr13 with SMTP id rr13so3406218pbb.19
        for <fio@vger.kernel.org>; Mon, 06 Aug 2012 18:03:08 -0700 (PDT)
Date: Mon, 6 Aug 2012 18:03:00 -0700
From: Mike Ryan <mike.ryan@inktank.com>
Subject: generating latency logs
Message-ID: <20120807010300.GD12248@splice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm trying to generate a latency log, but no log file is ever created.
I'm using the version tagged as fio-2.0.8 in git. This is how I'm
invoking fio:

  fio --latency-log=/tmp/log --output=/tmp/log random_write.fio

Here is the file random_write.fio:

  [random-writers]
  ioengine=libaio
  iodepth=4
  rw=randwrite
  bs=4k
  direct=0
  size=64m

I tried to debug it a little myself by adding some print statements. In
particular, at init.c:840 [1]:

        if (td->o.write_lat_log) {
                puts("latency logging");
                setup_log(&td->lat_log, td->o.log_avg_msec);
                setup_log(&td->slat_log, td->o.log_avg_msec);
                setup_log(&td->clat_log, td->o.log_avg_msec);
        }
        else {
                puts("not logging");
        }

[1] http://git.kernel.dk/?p=fio.git;f=init.c;hb=cf9a74#l840

When I run the command as above, I see the text "not logging". This
seems odd.
