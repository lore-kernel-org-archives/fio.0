Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:44150 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbeCXATh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 23 Mar 2018 20:19:37 -0400
Received: by mail-wr0-f176.google.com with SMTP id u46so13684730wrc.11
        for <fio@vger.kernel.org>; Fri, 23 Mar 2018 17:19:37 -0700 (PDT)
From: Jason Sirichoke <jason.sirichoke@broadcom.com>
MIME-Version: 1.0
Date: Fri, 23 Mar 2018 18:19:34 -0600
Message-ID: <36675d390f3348432593d72af3abdbe8@mail.gmail.com>
Subject: Can I send UNMAP commands with FIO?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi everyone,

I am trying to run a test to a device that only supports UNMAP commands
but not TRIM. So I am able to use sg_unmap successfully but it looks like
the trim commands sent by FIO fail as unsupported

Is there a way to easily configure or modify FIO to send UNMAP instead of
TRIM? These commands should be functionally very close to each other so
was hoping this might be possible.

Thanks,

Jason
