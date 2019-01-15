Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f175.google.com ([209.85.166.175]:39750 "EHLO
        mail-it1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728780AbfAOTYH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Jan 2019 14:24:07 -0500
Received: by mail-it1-f175.google.com with SMTP id a6so5995071itl.4
        for <fio@vger.kernel.org>; Tue, 15 Jan 2019 11:24:07 -0800 (PST)
MIME-Version: 1.0
References: <trinity-5edc4e1f-7ce7-4ae4-9806-1e4c7954208a-1547463614450@3c-app-webde-bs22>
In-Reply-To: <trinity-5edc4e1f-7ce7-4ae4-9806-1e4c7954208a-1547463614450@3c-app-webde-bs22>
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Tue, 15 Jan 2019 11:23:54 -0800
Message-ID: <CAF+0mvmEhEPMOYR0ddoxziC=YscxNDZxqBty0neFt==-msrBNQ@mail.gmail.com>
Subject: Re: Question regarding option "numjobs"
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: c.monty@web.de
Cc: fio@vger.kernel.org

> Hi,
> I have a question regarding fio option "numjobs":
> 1. Is there a rule-of-thumb for how many jobs should be defined?
> 2. Is the number of jobs impacting the total runtime of fio benchmark?

1. In general you want to increment numjobs if you want to create a
multi-threaded workload. One example would be to drive IOPS, since a
single-threaded workload might become CPU-bound instead of IO-bound.
2. This depends on how you set up your workload in your job file.
Runtime can be global affecting all jobs or different jobs can have
different runtimes.

