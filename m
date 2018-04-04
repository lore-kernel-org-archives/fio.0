Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:41949 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbeDDSD3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Apr 2018 14:03:29 -0400
Received: by mail-io0-f171.google.com with SMTP id m83so27385215ioi.8
        for <fio@vger.kernel.org>; Wed, 04 Apr 2018 11:03:28 -0700 (PDT)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Wed, 4 Apr 2018 11:02:47 -0700
Message-ID: <CAKwzdDrVtNh+EHM4fwuKzxkyzUQLowYs454B7byXE2hi7dUCdw@mail.gmail.com>
Subject: random mix workload with offset support
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi,
Looking some support if this is doable in fio
I want to do random mix workload with specific % while writes going to
certain offset span and reads going to different offset span.

e.g.

Rw=randrw

Rndmixread=70 (70/30 mix)

Offset=,70%,  (reads full span, writes to last 30% of LBA span?)



-- 
Life is too short for silly things so invest your time in some
productive outputs!!
