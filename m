Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:44291 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751767AbeB1AXb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Feb 2018 19:23:31 -0500
Received: by mail-oi0-f46.google.com with SMTP id b8so506037oib.11
        for <fio@vger.kernel.org>; Tue, 27 Feb 2018 16:23:31 -0800 (PST)
MIME-Version: 1.0
From: Jared Walton <jawalking@gmail.com>
Date: Tue, 27 Feb 2018 17:23:30 -0700
Message-ID: <CAGfUJcHTNy4PgTNiGt8-xpYXwgyw59ud_12nLoGA3J9_9grJwg@mail.gmail.com>
Subject: question regarding queue depths and workers
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

If I correctly understand how fio spawns workers then: it takes the
given queue depth and splits it among workers such that a queue depth
of 32 with 16 workers results in 16 workers each maintaining a queue
depth of 2...

But what happens when a queue depth of 16 is specified with 32 workers?
