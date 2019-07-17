Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lj1-f179.google.com ([209.85.208.179]:33543 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfGQQvN (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Jul 2019 12:51:13 -0400
Received: by mail-lj1-f179.google.com with SMTP id h10so24347083ljg.0
        for <fio@vger.kernel.org>; Wed, 17 Jul 2019 09:51:12 -0700 (PDT)
MIME-Version: 1.0
From: "Manu K.S." <cse.manuks@gmail.com>
Date: Wed, 17 Jul 2019 22:21:00 +0530
Message-ID: <CA+=P2Mtcy1nKo4bMoA+Ogpyxm4moaxKM70B=WWkaXgT7+GA7AA@mail.gmail.com>
Subject: Vary data patterns on same file and verify
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi, can we use fio to write different data patterns using
"buffer_pattern" or any other option to a single file after different
offsets and verify the same?

The requirement is :
1. Create a 1GB file on a shared volume from host_1.
2. From host _1, while creating the test file use different data
patterns to write the file. (example : patterns aaa,xxx,ccc should be
filled in the same file at different offsets)
3. From host_2, read the file and do a verify_pattern.


--
Cheers
Manu K S

