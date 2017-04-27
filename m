Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37371 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938549AbdD0XM7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2017 19:12:59 -0400
Received: by mail-wm0-f54.google.com with SMTP id m123so32034799wma.0
        for <fio@vger.kernel.org>; Thu, 27 Apr 2017 16:12:59 -0700 (PDT)
MIME-Version: 1.0
From: Andy Wolin <andywolin@gmail.com>
Date: Thu, 27 Apr 2017 17:12:57 -0600
Message-ID: <CABfA-bWxeM5wHmwqowzjQhE30vwx3K0ncLxiHb6mGGsNgZzCxQ@mail.gmail.com>
Subject: Realtime access to performance data
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

After fio completes the _bw.log is created.  I am wondering how I can
access this log data realtime so that I can time correlate other data
points such as power and temperature.  I tried the following:

1) send SIGUSR1 and get the 'bw=value' from the output.  That would
work but that value seems to be the running average over the entire
duration
2) I modified eta.c to write the bandwidth to a log file, but that
only updates about every second.

If a native solution does not exist I am open to quick and dirty
solutions.  I tried to find out where the log buffer gets updated so
that I could hack in a file write of that data (accepting the
performance hit) but wasn't able to figure that out.

Thanks,
Andy
