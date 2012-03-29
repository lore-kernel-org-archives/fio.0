Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36988 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759672Ab2C2RKJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 29 Mar 2012 13:10:09 -0400
Received: by bkcik5 with SMTP id ik5so2195899bkc.19
        for <fio@vger.kernel.org>; Thu, 29 Mar 2012 10:10:08 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Mar 2012 10:10:07 -0700
Message-ID: <CAKAYmM+szZDvUmba3T-sCm8EB-QQhE0xQBsiePCJ7LqNGCA2BQ@mail.gmail.com>
Subject: odd result with iodepth
From: Chuck Tuffli <ctuffli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I've been testing disk performance using fio, and am seeing results I
can't explain. This may not necessarily be a problem with fio, or
perhaps I'm not using the some of the parameters correctly. The
testing uses the latest fio.git on a RHEL system running a 2.6.32
kernel.

The fio test is:

fio --name=global --ioengine=libaio --rw=read --bs=512 --size=500m
--iodepth=32 --direct=1 --filename=/dev/sdb --name=job1

The IOPs reported in this case appears to correlate with an external analyzer.

If I change the iodepth to 64, fio reports double the IOPs reported in
the previous case, but the performance measured by the analyzer is the
same as in the iodepth=32 case (i.e. half what fio reports). I tried
the iodepth=64 case with another disk performance tool, and it is
reporting the same results as the external analyzer.

Interestingly, using iodepth=32 and adding a second job (--name=job2)
seems to have the same effect as iodepth=64 (reported performance is
2x compared to the external analyzer).

Am I doing something obviously wrong? What else can/should I check? TIA

---chuck
