Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lj1-f180.google.com ([209.85.208.180]:34608 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgBZVdI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Feb 2020 16:33:08 -0500
Received: by mail-lj1-f180.google.com with SMTP id x7so841360ljc.1
        for <fio@vger.kernel.org>; Wed, 26 Feb 2020 13:33:06 -0800 (PST)
MIME-Version: 1.0
From: Elliott Balsley <elliott@altsystems.com>
Date: Wed, 26 Feb 2020 13:32:54 -0800
Message-ID: <CABO+gV_6uBVxzzZ3K4HmDs18w_KzT8C5QxsNgLN3wp1C=x7NwQ@mail.gmail.com>
Subject: Setting number of read threads
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

When I do a sequential read test with multiple threads, the initial
write only uses one thread.  Is there some way to adjust this?  For
example a command like this:

fio --name moe --rw read --directory /mnt/nv01/fio/local --size 40G
--bs 4M --numjobs 4 --group_reporting --direct 1

It lays out four files one at a time, then it reads them all back at
once.  I would like to lay out the four files simultaneously to save
time.  I hope this makes sense; I'm not sure if I'm phrasing this in
the right way.

