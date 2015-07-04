Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:35739 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbGEJZi (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 5 Jul 2015 05:25:38 -0400
Received: by ykfs198 with SMTP id s198so21135167ykf.2
        for <fio@vger.kernel.org>; Sun, 05 Jul 2015 02:25:38 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 4 Jul 2015 15:16:02 +0300
Message-ID: <CAFaEk=-grWeELSnpYKPJWGfBjgo3iuVLXeJVEnNRAy_hXPPZzA@mail.gmail.com>
Subject: Starvation on large amount of threads
From: Gleb Stepanov <glebstepanov1992@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello, all.

  1) We are using fio for testing disk perfomance and we use fio log
files to collect data about tests.
We have encontered one issue when run with bit amount of threads(100
or more). Some threads
starving due to big latency and produce less log data that another,
because time of test is restricted. is it possible to configure fio to
have global log file?

2) FIO produce log files with iopses. Is it possible to switch from
iopeses to io operation count?
That allows to compute iopses manually or at least disable rounding in
iops count. That rounding produce some difference between json
output(total_ios) and iopses from log multiplied for time intervals.

Kind regards, Gleb Stepanov.
