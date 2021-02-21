Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhBULKY (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 21 Feb 2021 06:10:24 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70F3C061786
        for <fio@vger.kernel.org>; Sun, 21 Feb 2021 03:09:41 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id y202so10324897iof.1
        for <fio@vger.kernel.org>; Sun, 21 Feb 2021 03:09:41 -0800 (PST)
MIME-Version: 1.0
From: Hongwei Qin <glqinhongwei@gmail.com>
Date: Sun, 21 Feb 2021 19:09:28 +0800
Message-ID: <CAKvRR0TG4L3NqNiOMyh2zb0tA7vfuc_L8kU5ropGrY3fJm5GAg@mail.gmail.com>
Subject: [Question] A question about t/io_uring.c
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi,

I found two implementation details in t/io_uring.c quite interesting.
Both are in the prep_more_ios() function.

1.
reading the sq ring head is not protected using something like
READ_ONCE() or smp_read_acquire().
According to https://www.kernel.org/doc/Documentation/memory-barriers.txt
```
It _must_not_ be assumed that the compiler will do what you want
with memory references that are not protected by READ_ONCE() and
WRITE_ONCE().  Without them, the compiler is within its rights to
do all sorts of "creative" transformations, which are covered in
the COMPILER BARRIER section.
```

Is it possible that the modifications to the sqe using init_io() get
reordered prior to reading the sq ring head?

2.
Writing to the sq ring tail is not protected using something like
smp_store_release.
Even according to the article "Efficient IO with io_uring", adding an
sqe should be like:
```
write_barrier();
sqring->tail = tail;
write_barrier();
```
However, the first write barrier is missing in the t/io_uring.c
Is it possible that the memory stores get reordered?

Can anyone provide some insights on this? Thank you!

Best,
Hongwei

