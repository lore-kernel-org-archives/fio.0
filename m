Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55596 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1GRTBW (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 18 Jul 2011 15:01:22 -0400
Received: by ywe9 with SMTP id 9so1459590ywe.19
        for <fio@vger.kernel.org>; Mon, 18 Jul 2011 12:01:20 -0700 (PDT)
MIME-Version: 1.0
From: Daniel Farina <daniel@heroku.com>
Date: Mon, 18 Jul 2011 12:01:00 -0700
Message-ID: <CAAZKuFauk_dFsN-H5-r5+PjTL2F1ay1bzkGyYWpY0WVhHAW2uw@mail.gmail.com>
Subject: fio: when not using a job file, timeouts are not applied
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello list,

Recently I found a bug whereby when when the --timeout option is
utilized yet one does not use a job file (instead packing all the jobs
into the arguments to fio) that timeouts to not work in fio 1.55.
Having poked around via gdb it does appear the step whereby the
timeout is propagated throughout the program does not occur when there
are precisely 0 job files.

Let me know if I can help with additional details, or it is thought
that I am in error.

Thanks,
fdr
