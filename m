Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34665 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030473AbbDWTzu (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 23 Apr 2015 15:55:50 -0400
Received: by oiko83 with SMTP id o83so23778313oik.1
        for <fio@vger.kernel.org>; Thu, 23 Apr 2015 12:55:49 -0700 (PDT)
MIME-Version: 1.0
From: Brandon Schwartz <schwartz.xn@gmail.com>
Date: Thu, 23 Apr 2015 13:55:29 -0600
Message-ID: <CADAGN7VV15pQBpXVv=OptqZxjnz3-nkNHpXpotzCxeGUWDvFmA@mail.gmail.com>
Subject: Unable to replay blktrace with mixed workload
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Using FIO 2.2.7, I'm trying to replay the following workload
(capturing it with blktrace and replaying with FIO on the same device)

 sudo fio --name=rwmix --filename=/dev/sdd --blocksize=128k
--readwrite=randrw --rwmixread=75 --rwmixwrite=25 --runtime=60

And I get the following error:

fio: pid=21428, err=12/file:memory.c:242, func=iomem allocation,
error=Cannot allocate memory

Older versions of FIO (2.1.*) seem to be able to replay the blktrace
without that error, but those versions of FIO don't always seem to
respect the timing of IOs (if there is idle time for example).

Any idea what could be causing the problem?

Regards,
Brandon
