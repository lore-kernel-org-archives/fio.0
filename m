Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:43286 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753881AbeCFSxj (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Mar 2018 13:53:39 -0500
Received: by mail-io0-f170.google.com with SMTP id l12so92396ioc.10
        for <fio@vger.kernel.org>; Tue, 06 Mar 2018 10:53:39 -0800 (PST)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Tue, 6 Mar 2018 10:52:57 -0800
Message-ID: <CAKwzdDrG3vgzMzttpZm4HgbziXUNsXiOgNP_PAty+KRasQ7szg@mail.gmail.com>
Subject: FIO size parameter feedback
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

All
If the size parameter is not given for the runs, how does the tool
decide what % (LBA span) needs to be written on the drive?

Reason I am asking as I see different data for the same workloads when
size=100% and no size parameter used.

-- 
Life is too short for silly things so invest your time in some
productive outputs!!
