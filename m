Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot1-f44.google.com ([209.85.210.44]:45670 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfFXCVr (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 23 Jun 2019 22:21:47 -0400
Received: by mail-ot1-f44.google.com with SMTP id x21so11903960otq.12
        for <fio@vger.kernel.org>; Sun, 23 Jun 2019 19:21:47 -0700 (PDT)
MIME-Version: 1.0
From: Chuck Tuffli <ctuffli@gmail.com>
Date: Sun, 23 Jun 2019 16:21:45 -0700
Message-ID: <CAKAYmMLCTnbsfo_B7fyMNYcyY4-6W_ZL-W4p9s8pTtS01fb1=g@mail.gmail.com>
Subject: gfio with multiple servers?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Should it be possible to have gfio connect to multiple servers? fio
seems to be able to connect, but gfio times out on the second server
with the error:
fio: client nh03, timeout on cmd PROBE
Note that if I change the order of connection (i.e. connect to nh03
first), the failure does not follow the server, but fails on which
ever the second server is.

This is running:
    gfio fio-3.14-6-g97134

--chuck

