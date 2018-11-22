Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f176.google.com ([209.85.166.176]:33038 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730412AbeKVTqT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Nov 2018 14:46:19 -0500
Received: by mail-it1-f176.google.com with SMTP id p11-v6so14946223itf.0
        for <fio@vger.kernel.org>; Thu, 22 Nov 2018 01:07:45 -0800 (PST)
MIME-Version: 1.0
From: niall.litchfield@gmail.com
Date: Thu, 22 Nov 2018 09:07:32 +0000
Message-ID: <CABe10sbO6zVg5Xu-+3mfYYVGuRUH4Cm-Pb7Vh0kGD4arCDwjxQ@mail.gmail.com>
Subject: Use of direct=0 in examples.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Good day to all, and thanks to Jens especially for this excellent utility.

I see from closed issue 512
https://github.com/axboe/fio/issues/512#issuecomment-356552337 that
there was a discussion about the use of direct=0 in some of the
examples. It appears to me that only the sequential read example
fio-seq-read.fio has been updated, leaving the sequential write and
mixed sequential tests with direct=0. By comparison the 6 tests, I
think I would expect to see updated have been modified in the
(downstream?) repo
https://github.com/avocado-framework-tests/avocado-misc-tests/pull/780/files.
Is there some reason I'm missing for not updating all the sequential
examples to pass direct=1, or is this an omission?

Many apologies if this is off-topic, or a handy means of demonstrating
my ignorance.

-- 
Niall Litchfield

