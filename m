Return-Path: <fio-owner@vger.kernel.org>
Received: from dna.y42.org ([138.201.40.98]:45867 "EHLO dna.y42.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbfIUXud (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 21 Sep 2019 19:50:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by dna.y42.org (Postfix) with ESMTP id 43A3E9EA11
        for <fio@vger.kernel.org>; Sun, 22 Sep 2019 01:50:32 +0200 (CEST)
Received: from dna.y42.org ([127.0.0.1])
        by localhost (dna.y42.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XYOGz32lNJKV for <fio@vger.kernel.org>;
        Sun, 22 Sep 2019 01:50:30 +0200 (CEST)
Received: from [192.168.2.2] (p2E5426A0.dip0.t-ipconnect.de [46.84.38.160])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by dna.y42.org (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Sun, 22 Sep 2019 01:50:30 +0200 (CEST)
From: Robert Urban <urban@unix-beratung.de>
Subject: what is the point of config-host.h?
Message-ID: <4b960e8e-f9a0-ebd0-7e8a-1ce839ffb6a4@unix-beratung.de>
Date: Sun, 22 Sep 2019 01:50:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I'm trying to port fio (I used the "download ZIP" link on github on September
13th) to Tru64 UNIX V5.1B, an OS no longer being maintained :(

In the meantime I've built gcc 4.6 for Tru64 (a few days and 3.5 GB later.)

When I run configure it produces a "config-host.h" which looks correct, but this
is never included anywhere. By what mechanism is this header supposed to be
included?

rob


