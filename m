Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34576 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdEKH1e (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 May 2017 03:27:34 -0400
Received: by mail-qk0-f176.google.com with SMTP id k74so15348037qke.1
        for <fio@vger.kernel.org>; Thu, 11 May 2017 00:27:33 -0700 (PDT)
MIME-Version: 1.0
From: Guruganesh Hegde <guruhegde4u@gmail.com>
Date: Thu, 11 May 2017 12:57:31 +0530
Message-ID: <CACqzM2CQsTnY-1d=hZ-e6d7HD9on8_3OXTtySB1nk3Kjb2-qAg@mail.gmail.com>
Subject: FIO Latency and IOPS variation with blktrace
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

HI,

When fio is run with blktrace,
IOPS drops by 8%, average clat increased by 9% and max clat is5 times
more compared to the test run without running blktrace.

Is this expected overhead when blktrace is run?
Wondering why max latency is 5 time more!!

Regards,
Gruu
