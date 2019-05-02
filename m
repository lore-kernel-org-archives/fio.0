Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f44.google.com ([209.85.222.44]:45904 "EHLO
        mail-ua1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfEBGGX (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 May 2019 02:06:23 -0400
Received: by mail-ua1-f44.google.com with SMTP id o33so324680uae.12
        for <fio@vger.kernel.org>; Wed, 01 May 2019 23:06:23 -0700 (PDT)
MIME-Version: 1.0
From: Left Right <olegsivokon@gmail.com>
Date: Thu, 2 May 2019 06:06:07 +0300
Message-ID: <CAJQBtgm5kTYnn0Qjs_CHXDqirr+7=qVhev0ScXq0x6wxoib8QQ@mail.gmail.com>
Subject: How do reads and writes overlap?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I was looking for this info, online, but with no luck so far. What I'm
really interested to know is this:

* Say, you have a mixed sequential workload 75% reads, 25% writes with
queue depth greater than one, then:
** are all writes executed before all reads?
** are there any reads from the blocks not yet written to?
** are there any reads performed against writes that are not ack'ed yet?
** are there any writes performed to the same blocks that have a
pending read request?

* Does any of the answers change if we modify the ratio of reads to
writes, sequential to random?

Thanks!

Oleg

