Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36270 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbbDJGmO (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Apr 2015 02:42:14 -0400
Received: by lbbqq2 with SMTP id qq2so6635327lbb.3
        for <fio@vger.kernel.org>; Thu, 09 Apr 2015 23:42:12 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Apr 2015 08:42:12 +0200
Message-ID: <CAFAfLGOL7Bk_MQCApfLyVhFJs6Kf-V7Cs66LVaMa04ZocchXWQ@mail.gmail.com>
Subject: FIO Building per ANdroid
From: Fabio Salvati <fabio.salvati@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I need to run FIO on an ARM platform with Android OS.

I tried without success to build FIO configured for targetos=Android
and cpu=ARM.

The build error was:

.o blktrace.o trim.o profiles/tiobench.o lib/linux-dev-lookup.o fio.o
-lrt  -lpthread -lm   -ldl
backend.o: In function `thread_main':
/home/sys-lab/Desktop/fio/fio-
2.2.6/backend.c:1610: undefined reference to `cgroup_shutdown'
/home/sys-lab/Desktop/fio/fio-2.2.6/backend.c:1462: undefined
reference to `cgroup_setup'
backend.o: In function `fio_backend':
/home/sys-lab/Desktop/fio/fio-2.2.6/backend.c:2246: undefined
reference to `cgroup_kill'
collect2: ld returned 1 exit status
make: *** [fio] Error 1

Could you please help me to build FIO for ANDROID (ARM platform) ?

Any FIX?

Thanks,

Fabio
