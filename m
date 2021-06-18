Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhFRBLL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Jun 2021 21:11:11 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB4EC061574
        for <fio@vger.kernel.org>; Thu, 17 Jun 2021 18:09:02 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id m21so13525022lfg.13
        for <fio@vger.kernel.org>; Thu, 17 Jun 2021 18:09:02 -0700 (PDT)
MIME-Version: 1.0
From: Arthur Shau <arthurcshau@gmail.com>
Date: Thu, 17 Jun 2021 18:08:47 -0700
Message-ID: <CA+_dZJifi4+5GX1D=HELXrNkniVgVMnJgbYX+PMhuZ0s0ZiQFA@mail.gmail.com>
Subject: Question about rwmixread/rwmixwrite implementation
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I have a basic question about how the read/write ratio is enforced in
fio. I am new to fio, and I am not well versed enough in C to dig into
the source code myself, so I am asking here.

For I/O in a fixed size region, I am assuming that fio dynamically
throttles the number of requests in each direction as the job runs,
rather than predetermining the number of requests based on total size
and block sizes. Is this correct?

1. If so, how does it do this? Is there some sort of threshold where,
if too much of one type of request is happening, it will limit that
type and only allow the other to be requested? What happens if there
are multiple jobs reading and writing concurrently?

2. Why choose to do it this way rather than predetermining the number
of requests and limiting it that way?

If you could also point me to where this logic is happening in the
source code, that would also be immensely helpful. Thanks so much!

