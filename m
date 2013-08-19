Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:44690 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3HSXLv (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 19 Aug 2013 19:11:51 -0400
Received: by mail-vb0-f54.google.com with SMTP id q14so3771317vbe.27
        for <fio@vger.kernel.org>; Mon, 19 Aug 2013 16:11:51 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 19 Aug 2013 16:11:50 -0700
Message-ID: <CAPet_21dehFMKwU25L+ho1uRWOO6w_p7LqxxyJe5gQ5a9G0M5A@mail.gmail.com>
Subject: Using LFSR
From: Juan Casse <jcasse@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

How is LFSR used?

When running the job file:

[global]
readwrite=randwrite
size=64k
bs=8192
random_generator=lfsr
[test_job]

fio returns:

"fio: failed allocating random map. If running a large number of jobs,
try the 'norandommap' option or set 'softrandommap'. Or give a larger
--alloc-size to fio."

I tried the recommendations in the message above to no avail. I also
tried other combinations of size, bs, and readwrite.

Thank you,
Juan
