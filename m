Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt1-f179.google.com ([209.85.160.179]:38623 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgBFUYd (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Feb 2020 15:24:33 -0500
Received: by mail-qt1-f179.google.com with SMTP id c24so124818qtp.5
        for <fio@vger.kernel.org>; Thu, 06 Feb 2020 12:24:32 -0800 (PST)
MIME-Version: 1.0
From: Linux Newbie <f2fsnewbie@gmail.com>
Date: Thu, 6 Feb 2020 12:24:20 -0800
Message-ID: <CAF9YTdqf3KB6T_LOHAL1tg+OoWoYpau9DtKEMHR3C8Q6zxepLA@mail.gmail.com>
Subject: Hot Cold Filesystem I/O distribution
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi All,

I am a fio newbie. I am writing benchmarks to test the performance
improvement with my work.
I want to create the following standard scenario:
 - 90% writes go to 10% of the files (HOT Files)
 - 10% writes go to 90% of the files (Cooler files)

How do I go about doing this? I looked at the zipf distribution and
played with theta a bit. However, I can never specify how many times a
particular file must be accessed at max - to be able to control this
percentage.

How can we achieve the above scenario?

I appreciate your feedback a lot! Thanks!

Best Regards,
Surbhi

