Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:50119 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdJWKCl (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Oct 2017 06:02:41 -0400
Received: by mail-wm0-f50.google.com with SMTP id b189so8335093wmd.4
        for <fio@vger.kernel.org>; Mon, 23 Oct 2017 03:02:41 -0700 (PDT)
Received: from [192.168.0.102] ([185.14.9.224])
        by smtp.gmail.com with ESMTPSA id 31sm3251085wrm.0.2017.10.23.03.02.38
        for <fio@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 23 Oct 2017 03:02:39 -0700 (PDT)
From: Paolo Valente <paolo.valente@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Subject: buffer-cache builds up with invalidate=1 too
Message-Id: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org>
Date: Mon, 23 Oct 2017 12:02:37 +0200
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
in a time_based test with direct=3D0, a small file happened to be read =
several times. Yet I/O was actually done only when the file was read for =
the first time, even if invalidate was set.

So, if I'm not mistaken, the buffer cache still builds up even if =
invalidate is set, right?

Then, in a time_based test, the only way to make sure that I/O is =
constantly done, is to use direct=3D1, isn't it? Of course, unless the =
file is so large that one knows that no portion of the file will be =
found in the buffer cache when read again.

Thanks,
Paolo=
