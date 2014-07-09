Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:52385 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaGIOVM (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Jul 2014 10:21:12 -0400
Received: by mail-qg0-f42.google.com with SMTP id e89so6602267qgf.1
        for <fio@vger.kernel.org>; Wed, 09 Jul 2014 07:21:10 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Jul 2014 10:21:10 -0400
Message-ID: <CAFTzLMPWvQ8+rxmbSruzmHTMvkDXQ_ednA5rkDb3_CVoAtdVVw@mail.gmail.com>
Subject: Disk utilization statistics in terse format
From: Vasily Tarasov <tarasov@vasily.name>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi All,

When I run fio as a standalone application (without using a
server-client model) and use terse output format, disk utilization is
never printed. Here are the results of my analysis:

1) show_thread_status_terse_v2() does not call show_disk_util() at all.

2) show_thread_status_terse_v3_v4() does call show_disk_util(), but
only if is_backend variable is true (which is not, in case of a
standalone run).

3) __show_run_stats() call show_disk_util() only in case of
FIO_OUTPUT_JSON or FIO_OUTPUT_NORMAL formats.

There are several ways to fix this issue. I think the best way is to
call show_disk_util() from __show_run_stats() in case of terse format.
This will break the current terse format: disk utilization fields will
be printed in the end of the lines (after thread statistics), which is
not how the HOWTO defines it. But, it seems like the v2 format is
already inconsistent with HOWTO. And for v3 format, if client-server
model is used, disk utilization fields will be printed in the end of
the terse line anyway (at least this is my current understanding of
the code). So, what I suggest will bring consistency accross
client-server and standalone runs. We will also need to fix HOWTO.

Let me know what is the best way to fix this, and I'll be happy to send a patch.

Thanks,
Vasily
