Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:54904 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdJDG6z (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Oct 2017 02:58:55 -0400
Received: by mail-oi0-f54.google.com with SMTP id u130so18109232oib.11
        for <fio@vger.kernel.org>; Tue, 03 Oct 2017 23:58:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGEeD9YPvDhbt7KFvLOJ6W99UM_Jck6PFF6HV2h=B5u2gChggg@mail.gmail.com>
References: <CAGEeD9YPvDhbt7KFvLOJ6W99UM_Jck6PFF6HV2h=B5u2gChggg@mail.gmail.com>
From: =?UTF-8?B?0J3QuNC60LjRgtCwINCT0L7RgNCx0YPQvdC+0LI=?= 
        <tshiva@promobit.ru>
Date: Wed, 4 Oct 2017 12:58:53 +0600
Message-ID: <CAGEeD9ajaBeqZvXnP+wn3Cc48sL+O_jF1p6RavLQzFn0vX8SvA@mail.gmail.com>
Subject: Re: Some questions
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I write my ioengine and have some questions about how work fio.

1. What to do if function "getevents" transmitted pointer (const
struct timespec *t) which indicated garbage?
I want to paused my ioengine on some msec(sec,nsec) when ioengine
wants get answer about recording of write. I don't understand how can
get time for waiting if time pointer indicated garbage. Why does he
pass the pointer to the garbage?
2. What is the call queue function of ioengine? Can you write minimal
viable call chain? (init->open->queue->commit->getevents->cleanup)

3. Are the function of ioengine can be called in several threads
without indicated numjobs?

4. Why in null-ioengine when iodepth=1 we indicate this flag:
"td->io_ops->flags |= FIO_SYNCIO;" (sorry for my english)

(sorry for my english)
