Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46378 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaLCStU (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Dec 2014 13:49:20 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so20435786wgh.24
        for <fio@vger.kernel.org>; Wed, 03 Dec 2014 10:49:19 -0800 (PST)
MIME-Version: 1.0
From: Karthick Srinivasachary <karthick@pernixdata.com>
Date: Wed, 3 Dec 2014 10:48:59 -0800
Message-ID: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com>
Subject: Repeat given pattern with buffer_compress_percentage
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Folks,

I have question. Any feedback appreciated..!

With buffer_compress_percentage, fio writes random data + zeros.

Is there a way to write random data + repeat_pattern (instead of
zero's). Pattern can be any user given pattern.

Thanks in advance.
-Karthick
