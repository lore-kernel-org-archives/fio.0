Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f45.google.com ([209.85.222.45]:42931 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgA2Wn2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 29 Jan 2020 17:43:28 -0500
Received: by mail-ua1-f45.google.com with SMTP id u17so391576uap.9
        for <fio@vger.kernel.org>; Wed, 29 Jan 2020 14:43:27 -0800 (PST)
MIME-Version: 1.0
From: Louwrentius <louwrentius@gmail.com>
Date: Wed, 29 Jan 2020 23:43:12 +0100
Message-ID: <CAL-AFxyeQ_mnGmy_458jm=CXVdXYd9Gdz77UDbAxDknR7Lv0Ow@mail.gmail.com>
Subject: Strange benchmark results of SSD - any ideas
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I've done some benchmarks with FIO of entire SSD devices. So the FIO
benchmark stops when the whole device has been read/written. I've
logged latency and iops for the entire run.

Those logs are then translated to graphs. The Intel SSD shows the kind
of graph I would expect. The Samsung and Kingston SSDs show 'strange'
results.

I've written a brief blog article about this which includes links to
the raw data and the images.
https://louwrentius.com/difference-of-behavior-in-sata-solid-state-drives.html

Does anybody have an idea what could be going on? Why do we see these
'golden gate bridge' patterns? Maybe I did something wrong?

With regards,

Louwrentius

