Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53455 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaA1SMF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Jan 2014 13:12:05 -0500
Received: by mail-oa0-f46.google.com with SMTP id n16so825990oag.19
        for <fio@vger.kernel.org>; Tue, 28 Jan 2014 10:12:04 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 28 Jan 2014 10:12:03 -0800
Message-ID: <CANEJEGvtM3pyc_FqoLOe9X=EfcQLTtSUGokCAsyQ1fmFMhGcLw@mail.gmail.com>
Subject: rand_seed check failures with 2.1.4+ verify patches
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: FIO_list <fio@vger.kernel.org>
Cc: Puthikorn Voravootivat <puthik@chromium.org>

We've seen failures in rand_seed checking that go away when specifying
"verify_pattern=" parameter.

Jen's noted the same thing (I think) in a different thread with this job file:
[global]
filename=fio.ver
loops=10
verify=crc32

[random-rw]
size=31457280
rw=randrw


Puthik (CC'd) thinks he knows what the bug is in rand_seed checking
and I'll help review the fix once it's ready (should be available
later today or tomorrow).

Puthik will open a new bug in the chromium.org issue tracker. In the
mean time, some notes on the bug are here:
    https://code.google.com/p/chromium/issues/detail?id=337651

cheers,
grant
