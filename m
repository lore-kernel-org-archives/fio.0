Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:39030 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbeCPVRB (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Mar 2018 17:17:01 -0400
Received: by mail-wm0-f42.google.com with SMTP id u10so5458923wmu.4
        for <fio@vger.kernel.org>; Fri, 16 Mar 2018 14:17:01 -0700 (PDT)
From: Michael Green <mishagreen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: random_generator=lfsr overhead with more disks?
Date: Fri, 16 Mar 2018 17:16:56 -0400
References: <9FD577EB-5F83-4AB3-9FBA-704094437C15@gmail.com>
 <BN3PR0401MB145797FEFD095957854800088FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
In-Reply-To: <BN3PR0401MB145797FEFD095957854800088FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
Message-Id: <13EF5126-4D32-4706-8495-B193C124826B@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

> -How does the cpu utilization look compared between the lfsr and =
default tausworthe generators?  Is the cpu util actually higher on lfsr? =
=20

It is actually less when using LFSR with 16 volumes:

Without LFSR (CPU utilization is 5th column):
[root@sm28 ~]# ps -eLo ppid,pid,pri,psr,pcpu,stat,wchan:14,comm | grep =
fio
 PPID   PID PRI PSR %CPU STAT WCHAN          COMMAND
 2239 24684  19   0  0.7 Sl+  hrtimer_nanosl fio
 2239 24684  19   0  0.2 Sl+  futex_wait_que fio
 2239 24684  19   3 60.4 Rl+  -              fio
 2239 24684  19   6 60.5 Sl+  -              fio
 2239 24684  19   1 61.2 Rl+  -              fio
 2239 24684  19  23 62.5 Sl+  -              fio
 2239 24684  19   7 60.6 Rl+  -              fio
 2239 24684  19  18 61.0 Rl+  -              fio
 2239 24684  19  16 61.0 Rl+  -              fio
 2239 24684  19   4 62.0 Rl+  -              fio

With LFSR:
[root@sm28 ~]# ps -eLo ppid,pid,pri,psr,pcpu,stat,wchan:14,comm | grep =
fio
 2239 25589  19  20  2.7 Sl+  hrtimer_nanosl fio
 2239 25589  19  25  0.3 Sl+  futex_wait_que fio
 2239 25589  19  16 80.1 Rl+  -              fio
 2239 25589  19  22 78.0 Rl+  -              fio
 2239 25589  19   5 82.6 Rl+  -              fio
 2239 25589  19   4 78.0 Rl+  -              fio
 2239 25589  19  18 82.7 Rl+  -              fio
 2239 25589  19  17 80.7 Sl+  14051005663345 fio
 2239 25589  19  23 76.6 Sl+  -              fio
 2239 25589  19   0 77.6 Rl+  -              fio


But almost the same with 1 volume:

Without LFSR
[root@sm28 ~]# ps -eLo ppid,pid,pri,psr,pcpu,stat,wchan:14,comm | grep =
fio
 2239 27559  19   7  4.0 Sl+  hrtimer_nanosl fio
 2239 27559  19   2  0.0 Sl+  futex_wait_que fio
 2239 27559  19  18 79.4 Rl+  -              fio
 2239 27559  19  17 79.0 Rl+  -              fio
 2239 27559  19   6 78.6 Rl+  -              fio
 2239 27559  19   5 77.6 Rl+  -              fio
 2239 27559  19  23 82.6 Rl+  -              fio
 2239 27559  19   3 77.4 Rl+  -              fio
 2239 27559  19   4 77.1 Sl+  -              fio
 2239 27559  19  16 75.9 Rl+  -              fio

With LFSR:
[root@sm28 ~]# ps -eLo ppid,pid,pri,psr,pcpu,stat,wchan:14,comm | grep =
fio
 2239 27174  19  20  2.0 Sl+  hrtimer_nanosl fio
 2239 27174  19  25  0.0 Sl+  futex_wait_que fio
 2239 27174  19  16 80.0 Rl+  -              fio
 2239 27174  19   6 78.4 Rl+  -              fio
 2239 27174  19   3 77.5 Rl+  -              fio
 2239 27174  19   5 76.4 Sl+  -              fio
 2239 27174  19  19 77.1 Rl+  -              fio
 2239 27174  19   4 76.4 Rl+  -              fio
 2239 27174  19   7 77.0 Rl+  -              fio
 2239 27174  19   1 75.8 Rl+  -              fio



> -Does a runtime of 2 minutes collect enough data points to assess the =
condition?  What happens if you extend the runtime?

Yes, it does. Shortening the test to 20 sec or extending to 10 min, =
doesn=E2=80=99t change a thing.


