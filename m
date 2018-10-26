Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:40031 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbeJZVbQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Oct 2018 17:31:16 -0400
Received: by mail-it1-f193.google.com with SMTP id i191-v6so1498887iti.5
        for <fio@vger.kernel.org>; Fri, 26 Oct 2018 05:54:16 -0700 (PDT)
MIME-Version: 1.0
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Fri, 26 Oct 2018 18:24:14 +0530
Message-ID: <CAFF4W0V0VTMUbtZHOziTp6ca_khY2yHEPRQNAe68ebmTg9BO6w@mail.gmail.com>
Subject: 
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I am trying to check how option --clocksource works.


bash# fio --name job1 --size 10m --clocksource 2
        valid values: gettimeofday Use gettimeofday(2) for timing
                    : clock_gettime Use clock_gettime(2) for timing
                    : cpu        Use CPU private clock

fio: failed parsing clocksource=2

bash# fio --name job1 --size 10m --clocksource gettimeofday(2)
bash: syntax error near unexpected token `('

Below command works fine.
bash# fio --name job1 --size 10m --clocksource gettimeofday

It runs without error but quiet not sure how to see the effect of this
option. also tried other options - clock_gettime, cpu gettimeofday and
dont see any difference.

Also is there any error in documentation passing gettimeofday(2)
throws parse error.

Thanks and Regards,
Mohan

