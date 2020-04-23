Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726323AbgDWOlr (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 23 Apr 2020 10:41:47 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9661C08E934
        for <fio@vger.kernel.org>; Thu, 23 Apr 2020 07:41:46 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id u12so5879640uau.10
        for <fio@vger.kernel.org>; Thu, 23 Apr 2020 07:41:46 -0700 (PDT)
MIME-Version: 1.0
From: Seena Fallah <seenafallah@gmail.com>
Date: Thu, 23 Apr 2020 19:11:34 +0430
Message-ID: <CAK3+OmX5TX9KPw584_BT0u1Jb+roA=6_13pK5Ra8rwrcL5HecQ@mail.gmail.com>
Subject: Don't benchmark with fio
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all.

I'm trying to probe my file system with fio. I don't want to benchmark
my file system. The only thing I want do is to for example write 100K
file on a file system and then check how much IO does it take to write
and the bandwidth and the runtime.
The main thing I want is to just write that file size and don't bench on that.
Can anyone help me which ioengine or which args should I use to do this probe?

Thanks.

