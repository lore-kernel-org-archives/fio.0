Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:61102 "EHLO muon.bluestop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752356AbdLBQMn (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 2 Dec 2017 11:12:43 -0500
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.bluestop.org (Postfix) with ESMTP id 68ACB883B5
        for <fio@vger.kernel.org>; Sat,  2 Dec 2017 16:12:43 +0000 (UTC)
Received: from muon.bluestop.org ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yqJoHdJHiXKn for <fio@vger.kernel.org>;
        Sat,  2 Dec 2017 16:12:43 +0000 (UTC)
Received: from [IPv6:2607:fb90:a6a7:cbf5:911d:37c0:25f:241a] (unknown [IPv6:2607:fb90:a6a7:cbf5:911d:37c0:25f:241a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by muon.bluestop.org (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Sat,  2 Dec 2017 16:12:42 +0000 (UTC)
From: Rebecca Cran <rebecca@bluestop.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0 (1.0)
Date: Sat, 2 Dec 2017 09:12:41 -0700
Subject: memalign.c and posix_memalign
Message-Id: <8FBD8EC3-8FCE-4071-9A28-032E3E24CA5A@bluestop.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I noticed that fio has code in lib/memalign.c to return an aligned pointer. I was wondering if we could call posix_memalign instead? Or is it too new to exist on all systems we support?

— 
Rebecca
