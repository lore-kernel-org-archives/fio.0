Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgFOTWE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 Jun 2020 15:22:04 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8BEC061A0E
        for <fio@vger.kernel.org>; Mon, 15 Jun 2020 12:22:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s23so8238143pfh.7
        for <fio@vger.kernel.org>; Mon, 15 Jun 2020 12:22:04 -0700 (PDT)
Received: from walkaboutrs.localdomain (ip72-208-142-24.ph.ph.cox.net. [72.208.142.24])
        by smtp.gmail.com with ESMTPSA id 23sm14797037pfy.199.2020.06.15.12.22.02
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 12:22:02 -0700 (PDT)
From: Jared Walton <jawalking@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: How to split IO by block size and read/write
Message-Id: <3866F5B3-377A-4452-B7DB-F57404C6D157@gmail.com>
Date: Mon, 15 Jun 2020 12:22:01 -0700
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I=E2=80=99m trying to setup workload where 70% of the IOs are read and =
30% are write, but all reads would be 4k reads, and all writes would be =
8k. Is this possible with FIO?

I see that I can set bssplit=3D4k/70:8k/30 but where how would I ensure =
that all 4k are reads?=

