Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36825 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbbLHOEu (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Dec 2015 09:04:50 -0500
Received: by lfs39 with SMTP id 39so13263823lfs.3
        for <fio@vger.kernel.org>; Tue, 08 Dec 2015 06:04:48 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 8 Dec 2015 15:04:47 +0100
Message-ID: <CADr68Wabo8sjpN6VAB6jxPAEogjMEqX_fHBpOBtoMUvyC_QeTA@mail.gmail.com>
Subject: Latency percentile cap
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

When running jobs where some operations are taking very long, the
calculation of the latency percentiles seems to get capped at 16.7s or
rather exactly at 2^24-2^16 microseconds.

Looking at the code, I'm not sure whether this is intentional or not,
the long comment at the beginning of stat.h seems to indicate that the
highest bucket should be uncapped, but maybe I am reading this wrong.

If it is indeed intentional, then there are two additional questions:

1. Can the code generate a warning when it notices that it reaches its limits?
2. Can I increase the limit by just setting FIO_IO_U_PLAT_BITS to some
higher value like 7 or 8? Or do some of the other constants need to be
changed accordingly?

Yours,
Jens
