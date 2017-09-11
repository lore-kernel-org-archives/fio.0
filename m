Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:45087 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdIKRYc (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Sep 2017 13:24:32 -0400
Received: by mail-wm0-f43.google.com with SMTP id f199so45151867wme.0
        for <fio@vger.kernel.org>; Mon, 11 Sep 2017 10:24:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOfm_=Vbf8fbusKvMQ+_2B7qpvUoCaYFEnoBnNa8Bwpdh__Zgg@mail.gmail.com>
References: <CAOfm_=Vbf8fbusKvMQ+_2B7qpvUoCaYFEnoBnNa8Bwpdh__Zgg@mail.gmail.com>
From: Udi-Yehuda Tamar <udi@excelero.com>
Date: Mon, 11 Sep 2017 20:24:30 +0300
Message-ID: <CAOfm_=XN7r7h-_epT6OFGzGYvjYekChLk5k+pSQr4LYuN+O64g@mail.gmail.com>
Subject: Fwd: FIO distinguish data corruption and io errors
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

---------- Forwarded message ----------
From: Udi-Yehuda Tamar <udi@excelero.com>
Date: Mon, Sep 11, 2017 at 8:23 PM
Subject: FIO distinguish data corruption and io errors
To: fio@vger.kernel.org


Hello Guys,

I guess this question answers it's self but I'll give it a try ,
Can Fio tell for sure the IO err is a data corruption ? say the drive
is busy and the read failed
but not necessarily on data corruption can Fio tell that?
I guess not! because every IO failure can be a data corruption , but I
prefer a pro answer - thx in adv.


-- 
Thanks,
Udi-Yehuda Tamar.
