Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:34148 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbbKFDIn (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Nov 2015 22:08:43 -0500
Received: by qgeb1 with SMTP id b1so29634433qge.1
        for <fio@vger.kernel.org>; Thu, 05 Nov 2015 19:08:42 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Nov 2015 19:08:42 -0800
Message-ID: <CAF+0mvkVOvpqUHRLO_mBXt7UFMFYJMQWH0Au1wssZHa5V=THVA@mail.gmail.com>
Subject: Increasing startup time
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I noticed during testing recent fio releases it seemed bit laggy to
start, so I tried some tests and it seems fio has been increasingly
taking longer to start for some reason.  Don't know if this is
expected or if something is wrong?

These are some tests I ran on a few different release versions...

matt@matt-desktop:~$ time fio-2.2.3/fio -v
fio-2.2.3

real    0m0.008s
user    0m0.004s
sys    0m0.004s
matt@matt-desktop:~$ time fio-2.2.3/fio -v
fio-2.2.3

real    0m0.009s
user    0m0.009s
sys    0m0.000s
matt@matt-desktop:~$ time fio-2.2.4/fio -v
fio-2.2.4

real    0m0.009s
user    0m0.000s
sys    0m0.008s
matt@matt-desktop:~$ time fio-2.2.4/fio -v
fio-2.2.4

real    0m0.009s
user    0m0.009s
sys    0m0.000s
matt@matt-desktop:~$ time fio-2.2.5/fio -v
fio-2.2.5

real    0m0.015s
user    0m0.011s
sys    0m0.004s
matt@matt-desktop:~$ time fio-2.2.5/fio -v
fio-2.2.5

real    0m0.014s
user    0m0.003s
sys    0m0.010s
matt@matt-desktop:~$ time fio-2.2.6/fio -v
fio-2.2.6

real    0m0.015s
user    0m0.004s
sys    0m0.011s
matt@matt-desktop:~$ time fio-2.2.6/fio -v
fio-2.2.6

real    0m0.015s
user    0m0.000s
sys    0m0.015s
matt@matt-desktop:~$ time fio-2.2.7/fio -v
fio-2.2.7

real    0m0.083s
user    0m0.015s
sys    0m0.066s
matt@matt-desktop:~$ time fio-2.2.7/fio -v
fio-2.2.7

real    0m0.081s
user    0m0.013s
sys    0m0.067s
matt@matt-desktop:~$ time fio-2.2.11/fio -v
fio-2.2.11

real    0m0.079s
user    0m0.020s
sys    0m0.059s
matt@matt-desktop:~$ time fio-2.2.11/fio -v
fio-2.2.11

real    0m0.079s
user    0m0.000s
sys    0m0.078s
