Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f45.google.com ([209.85.222.45]:36919 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbfDDQkY (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Apr 2019 12:40:24 -0400
Received: by mail-ua1-f45.google.com with SMTP id l17so1112745uar.4
        for <fio@vger.kernel.org>; Thu, 04 Apr 2019 09:40:23 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Olivi <matteoolivi7@gmail.com>
Date: Thu, 4 Apr 2019 18:40:12 +0200
Message-ID: <CAEESUgmg2YW7qsq+xQqWyJhmOHi1Rfs_4h0kFthWm2FpHe1oaw@mail.gmail.com>
Subject: force sync percentiles unit of measure
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Is there a way to force fio output (no --minimal) to use msec as the
unit of measure for sync percentiles?

I'm using fio-3.13.

Thanks,
Matteo.

