Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34110 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752265AbcJRUHU (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2016 16:07:20 -0400
Received: by mail-oi0-f44.google.com with SMTP id t73so6062036oie.1
        for <fio@vger.kernel.org>; Tue, 18 Oct 2016 13:07:19 -0700 (PDT)
MIME-Version: 1.0
From: Andrzej Jakowski <andrzej.jakowski@gmail.com>
Date: Tue, 18 Oct 2016 13:07:18 -0700
Message-ID: <CAOmo8DaQBEc6f0UdK+Ta-S919PzJXg_qe7fEN7UmdL=tH82maA@mail.gmail.com>
Subject: Sequential workload with fio
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Question on fio configuration.
I would like to run seq write workload on raw block device.
Fio finishes when it reaches end-of-device. Is there a way to force it
to continue in a circular way till "size" or "runtime" parameter is satisfied?

Thx,
Andrzej
