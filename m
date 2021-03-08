Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbhCHHuF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Mar 2021 02:50:05 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579EDC06174A
        for <fio@vger.kernel.org>; Sun,  7 Mar 2021 23:50:05 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id v14so7988758ilj.11
        for <fio@vger.kernel.org>; Sun, 07 Mar 2021 23:50:05 -0800 (PST)
MIME-Version: 1.0
From: Johann Lombardi <johann.lombardi@gmail.com>
Date: Mon, 8 Mar 2021 08:49:53 +0100
Message-ID: <CANRws8FYUtjVDcpV34+uxAYu6aT23O=KFeUrFHedoTQkLFR5=A@mail.gmail.com>
Subject: engines/dfs: add DAOS File System (dfs) engine
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi there,

I created a pull request (https://github.com/axboe/fio/pull/1189) a
few weeks ago to add a new engine (called dfs) supporting the DAOS
File System. DAOS is a new scale-out open-source object store (see
https://github.com/daos-stack/daos and http://doc.daos.io for more
information).

Please let me know if you have any feedback or if you prefer the patch
to be emailed to the list instead of a Github PR.

Thanks in advance.

Cheers,
Johann

