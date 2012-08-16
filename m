Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42000 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2HPPYa (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Aug 2012 11:24:30 -0400
Received: by bkwj10 with SMTP id j10so964228bkw.19
        for <fio@vger.kernel.org>; Thu, 16 Aug 2012 08:24:28 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 Aug 2012 01:24:28 +1000
Message-ID: <CAHaS=QzhdnM-TpzWb9eC3woLXZPM9t-LmcUzsf24rzUfUzPn-Q@mail.gmail.com>
Subject: Suggestion: Add ramp-up for rate testing.
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I suggest adding a ramp-up time parameter that can be used to prevent
the rate testing from occurring until the ramp-up time has passed.
This will more accurately model the throughput capacity of streaming
systems that have a pre-load buffer to ride over the initial cache
warm-up period.

Greg.
p.s The rate stuff is working on Windows now - thanks Bruce.
