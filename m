Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f178.google.com ([209.85.166.178]:36032 "EHLO
        mail-it1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfABSWe (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Jan 2019 13:22:34 -0500
Received: by mail-it1-f178.google.com with SMTP id c9so39780546itj.1
        for <fio@vger.kernel.org>; Wed, 02 Jan 2019 10:22:34 -0800 (PST)
MIME-Version: 1.0
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Wed, 2 Jan 2019 10:22:22 -0800
Message-ID: <CAF+0mvkvfO5Te7yRk4B5x4yndbM=2e+7qMZVwo-W2ZYZVpUfOA@mail.gmail.com>
Subject: Reporting mixed latency percentiles
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello fio group,

I have a general question. Normally fio outputs latency percentiles
for mixed reads and writes separately. What is the proper way to
report a unified read/write percentile? Do you max them? Sum them?

Thanks!

