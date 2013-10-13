Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:65215 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3JMCeG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 12 Oct 2013 22:34:06 -0400
Received: by mail-vc0-f170.google.com with SMTP id lc6so3939027vcb.15
        for <fio@vger.kernel.org>; Sat, 12 Oct 2013 19:34:05 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 12 Oct 2013 19:34:05 -0700
Message-ID: <CAF+0mv=YQqGT4=-_Zm+Smzw7aduVFrq4FxEgOz7fFuHG6Xn6+g@mail.gmail.com>
Subject: Using fio to test SSD (SNIA)
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi guys,

I'm using fio apply an enterprise SNIA test on a single SATA SSD but
one thing that confuses me is how to choose the number of threads and
oio per thread. What settings would you guys recommend?

I'm currently using 16 threads and 64 oio per thread so total oio is
1024. Is that overkill?

Also, I've been wondering since an SSD has a queue depth of 32, where
are the oios >32 stored?

Thank you for any insight here.
