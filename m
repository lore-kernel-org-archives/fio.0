Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:33796 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdF2Xv1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Jun 2017 19:51:27 -0400
Received: by mail-yw0-f179.google.com with SMTP id l21so34753467ywb.1
        for <fio@vger.kernel.org>; Thu, 29 Jun 2017 16:51:27 -0700 (PDT)
MIME-Version: 1.0
From: Nisha Miller <nisha43222@gmail.com>
Date: Thu, 29 Jun 2017 16:51:26 -0700
Message-ID: <CAO5fCYu2OhNo_FbwjGVk0rBZMpMx1VUn8WPppc+rBVr10nAEmg@mail.gmail.com>
Subject: --minimal does not work in client/server mode
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

When running fio locally, --minimal --status-interval=1 works fine.
Terse output is dumped once a second.

When I run fio remotely like this:

fio <jobfile> --client=10.10.1.165,55555 --minimal --status-interval=1

fio dumps normal output once a second and at the end of the test it
dumps terse output just once. I've tried this using fio version 2.12
and 2.20. Both have the same issue.

I see others have faced the same problems, but I don't see any solutions.

Can anyone help me?

thanks
Nisha Miller
