Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34956 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbcFQRuK (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Jun 2016 13:50:10 -0400
Received: by mail-oi0-f45.google.com with SMTP id v7so16742364oig.2
        for <fio@vger.kernel.org>; Fri, 17 Jun 2016 10:50:09 -0700 (PDT)
MIME-Version: 1.0
From: Oscar Wahlberg <oscar.wahlberg@gmail.com>
Date: Fri, 17 Jun 2016 10:49:29 -0700
Message-ID: <CACAMNSzaK8_iqbEEsuBZMR_WuZ7RY6vGU4iqxX3edu_h7owb3A@mail.gmail.com>
Subject: Per-second logs using client/server mode
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am trying to figure out if there is a way to use client/server mode
and get per-second statistics, in terse format, printed either on
STDOUT or in the output log.

At best I have been able to get the client to print this at the
completion of the job, but not continuously.
I want the per-second stats to parse the output and send it to
Graphite database for analysis in correlation with other data
collected during the runs.

I've been unsuccessful in finding a way to do this.
For example, "fio --client=host.list simple.fio --status-interval=1
--output=simple.log --output-format=terse"
did not do what I expected/hoped it would.

Is there a way to do what I want to do,
or do I need to stick with my current approach of manually running fio
on each server?

Thank you,
Oscar
