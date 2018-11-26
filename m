Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt1-f176.google.com ([209.85.160.176]:41103 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbeK0CQY (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Nov 2018 21:16:24 -0500
Received: by mail-qt1-f176.google.com with SMTP id d18so17906129qto.8
        for <fio@vger.kernel.org>; Mon, 26 Nov 2018 07:21:58 -0800 (PST)
MIME-Version: 1.0
From: Yijie Zhong <yijiezhong12@gmail.com>
Date: Mon, 26 Nov 2018 23:21:46 +0800
Message-ID: <CAHfRdgfCMsZWB7r=NfANSXnz7kHQY4dTsnGYvZoWPkBG_XfnWw@mail.gmail.com>
Subject: How to set up fio working with multiple files simultaneously?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I have learned that glibc emulate POSIX AIO via thread pool on Linux
and only one thread would service for one open file
(https://github.com/bminor/glibc/blob/glibc-2.28/sysdeps/pthread/aio_misc.c#L359).

I want to use fio to validate it, so I want to know how to set up fio
working with multiple files simultaneously?

Thanks!

