Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f54.google.com ([209.85.222.54]:37757 "EHLO
        mail-ua1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfEaPR4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 May 2019 11:17:56 -0400
Received: by mail-ua1-f54.google.com with SMTP id l3so3843827uad.4
        for <fio@vger.kernel.org>; Fri, 31 May 2019 08:17:55 -0700 (PDT)
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Fri, 31 May 2019 08:17:18 -0700
Message-ID: <CAB-428m1s=qZjcX6m=E3QXnP18ExpUKAZrahpNfxgY8XVGWh+Q@mail.gmail.com>
Subject: Aggregated clients performance logging
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Is there any way to collect the the performance log of all clients in
the following job in a single log file?

# fio -client host.list job.fio

In the job.fio description, I have enabled write_iops_log only. I have
10 clients in the host.list file and after I run the job, I get 10 log
file for each client which is not interesting. I am interested to see
what all 10 clients combine are doing.

Thanks

