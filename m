Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f54.google.com ([209.85.128.54]:53781 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfIPHQf (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Sep 2019 03:16:35 -0400
Received: by mail-wm1-f54.google.com with SMTP id i16so2877206wmd.3
        for <fio@vger.kernel.org>; Mon, 16 Sep 2019 00:16:33 -0700 (PDT)
MIME-Version: 1.0
From: Elliott Balsley <elliott@altsystems.com>
Date: Mon, 16 Sep 2019 00:16:22 -0700
Message-ID: <CABO+gV-AvdsAWe+0SZXga4iDZ-C8xR9MuHQhBzm7aBiuGid8pg@mail.gmail.com>
Subject: How to cancel job
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hello.  Simple question, what is the best way to cancel an fio job in
progress?  If I start a job with wrong options by mistake, I try
Ctrl-C but this just prints "fio: terminating on signal 2" and the job
continues.

