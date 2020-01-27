Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi1-f182.google.com ([209.85.167.182]:43969 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgA0SYq (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Jan 2020 13:24:46 -0500
Received: by mail-oi1-f182.google.com with SMTP id p125so7581943oif.10
        for <fio@vger.kernel.org>; Mon, 27 Jan 2020 10:24:45 -0800 (PST)
MIME-Version: 1.0
From: Mauricio Tavares <raubvogel@gmail.com>
Date: Mon, 27 Jan 2020 13:24:34 -0500
Message-ID: <CAHEKYV7Hzs_TbhGsAXoFUP55oGQGeDot+c8Dh3RcLjWrxbqO9Q@mail.gmail.com>
Subject: clock setaffinity failed: Invalid argument
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

I am seeing a lot of those errors:

run write in 512K(1)][90.3%][w=1942MiB/s][w=7766 IOPS][eta 03m:13s]
clock setaffinity failed: Invalid argument
clock setaffinity failed: Invalid argument
clock setaffinity failed: Invalid argument
[...]
clock setaffinity failed: Invalid argument
Jobs: 1 (f=1): [W(1)][45.2%][w=2010MiB/s][w=4019 IOPS][eta 18m:07s]

According to https://github.com/axboe/fio/issues/46, I would expect to
see a bit more descriptive error (I am compiling using source checked
out of https://github.com/axboe/fio on Fedora 31 on Intel), but that
is not the case. Any suggestions of what I should be looking into?

