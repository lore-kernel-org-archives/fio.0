Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([65.103.231.193]:39562 "EHLO
        muon.bluestop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfDWXvt (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 Apr 2019 19:51:49 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.bluestop.org (Postfix) with ESMTP id 6F9BDC46E2
        for <fio@vger.kernel.org>; Tue, 23 Apr 2019 17:53:25 -0600 (MDT)
Received: from muon.bluestop.org ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YEhVeWgCF62Y for <fio@vger.kernel.org>;
        Tue, 23 Apr 2019 17:53:25 -0600 (MDT)
Received: from photon.int.bluestop.org (unknown [65.103.231.197])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by muon.bluestop.org (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Tue, 23 Apr 2019 17:53:25 -0600 (MDT)
From: Rebecca Cran <rebecca@bluestop.org>
Subject: fio fails to build on x86_64 Solaris 11.4
Message-ID: <c4b78148-e812-1abf-1b38-78d1452e5e34@bluestop.org>
Date: Tue, 23 Apr 2019 17:51:48 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I don't know how many people care about Solaris these days, but since I've been doing a bit of work on 11.4 x86_64 recently, I
decided to see if fio works on it.

It turns out it fails to build (using gcc 7.3.0):


bcran@solaris:~/workspace/fio$ gmake
    CC stat.o
In file included from os/os.h:46:0,
                 from thread_options.h:5,
                 from fio.h:18,
                 from stat.c:7:
stat.c: In function 'show_thread_status_normal':
os/os-solaris.h:46:33: error: too many arguments to function 'ctime_r'
 #define os_ctime_r(x, y, z)     ctime_r((x), (y), (z))
                                 ^
stat.c:804:2: note: in expansion of macro 'os_ctime_r'
  os_ctime_r((const time_t *) &time_p, time_buf, sizeof(time_buf));
  ^~~~~~~~~~
In file included from /usr/include/sys/time.h:447:0,
                 from /usr/include/sys/select.h:27,
                 from /usr/include/sys/types.h:665,
                 from /usr/include/string.h:15,
                 from stat.c:2:
/usr/include/time.h:265:14: note: declared here
 extern char *ctime_r(const time_t *, char *);
              ^~~~~~~
In file included from os/os.h:46:0,
                 from thread_options.h:5,
                 from fio.h:18,
                 from stat.c:7:
stat.c: In function '__show_run_stats':
os/os-solaris.h:46:33: error: too many arguments to function 'ctime_r'
 #define os_ctime_r(x, y, z)     ctime_r((x), (y), (z))
                                 ^
stat.c:1969:3: note: in expansion of macro 'os_ctime_r'
   os_ctime_r(&tv_sec, time_buf, sizeof(time_buf));
   ^~~~~~~~~~
In file included from /usr/include/sys/time.h:447:0,
                 from /usr/include/sys/select.h:27,
                 from /usr/include/sys/types.h:665,
                 from /usr/include/string.h:15,
                 from stat.c:2:
/usr/include/time.h:265:14: note: declared here
 extern char *ctime_r(const time_t *, char *);
              ^~~~~~~
gmake: *** [Makefile:369: stat.o] Error 1


