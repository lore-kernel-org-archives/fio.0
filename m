Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34594 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbbGFM6j (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Jul 2015 08:58:39 -0400
Received: by obbkm3 with SMTP id km3so106019899obb.1
        for <fio@vger.kernel.org>; Mon, 06 Jul 2015 05:58:38 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Jul 2015 15:58:38 +0300
Message-ID: <CAKk_wU5FJ_F+x6MksXd4+4NPwCTkhJtuHfHSfdU2d7QEyZMe9w@mail.gmail.com>
Subject: Logging starvation on large amount of threads
From: Gleb Stepanov <gstepanov@mirantis.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello, all.

We are using fio log files to get more information about disk performance and
have face a problem with this approach when run test with a lot of threads
- 100+, depending on storage.
Some threads starving due to big latency and gets only few IO per
second (or even less than one).
Fio produce log files with IOPS'es, also fio truncate iops to integers. That
produce some difference between json output(total_ios) and iopses from
log multiplied for time intervals.

We see three possible workaround, does any of them build in into
latest fio (git master):

 1) Have a global log instead of log per thread.
 2) Write operations instead of operations per second
 3) disable rounding of IOPS'es to increase accuracy.

There are some examples of fio logs.


thread_1_iops.log

610, 6, 1, 0
1090, 4, 1, 0
1519, 3, 1, 0
2053, 9, 1, 0
2615, 12, 1, 0
3192, 12, 1, 0
3753, 10, 1, 0
4263, 11, 1, 0


thread_2_iops.log

592, 5, 1, 0


thread_3_iops.log

5129, 8, 1, 0


Kind regards, Gleb Stepanov.
