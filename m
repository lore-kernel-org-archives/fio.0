Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgEZQJ2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 May 2020 12:09:28 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F420C03E96D
        for <fio@vger.kernel.org>; Tue, 26 May 2020 09:09:28 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id c20so21007145ilk.6
        for <fio@vger.kernel.org>; Tue, 26 May 2020 09:09:28 -0700 (PDT)
MIME-Version: 1.0
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Wed, 27 May 2020 01:08:49 +0900
Message-ID: <CAHndrBnYH-i1y890GfAjHq1Mz2kgB4b6JcxtT4q0wjE_pV-hUQ@mail.gmail.com>
Subject: Build failure on NetBSD since "fio: Generalize zonemode=zbd"
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

b76949618d557bd63181245aa522ead9b92d274b ("fio: Generalize zonemode=zbd")
which got rid of CONFIG_HAS_BLKZONED flag broke compilation on NetBSD,
as pthread in NetBSD doesn't have pthread_mutexattr_setpshared(3).
Looks like OpenBSD doesn't have it either.

--
ld: zbd.o: in function `parse_zone_info':
fio/zbd.c:422: undefined reference to `pthread_mutexattr_setpshared'
ld: zbd.o: in function `init_zone_info':
fio/zbd.c:378: undefined reference to `pthread_mutexattr_setpshared'
gmake: *** [Makefile:483: fio] Error 1

