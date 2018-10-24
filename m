Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi1-f170.google.com ([209.85.167.170]:46701 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbeJYG7K (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Oct 2018 02:59:10 -0400
Received: by mail-oi1-f170.google.com with SMTP id k64-v6so5443805oia.13
        for <fio@vger.kernel.org>; Wed, 24 Oct 2018 15:29:16 -0700 (PDT)
MIME-Version: 1.0
From: Taylor Yang <taylor4869@gmail.com>
Date: Wed, 24 Oct 2018 15:29:05 -0700
Message-ID: <CAKiK_mBJvdwd6pLaLb9P4pzGPrsffLwnP2ofTyDgEBXN-sJP+Q@mail.gmail.com>
Subject: Question about data verification using FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I know for the option 'verify', we could specify it when we write and
read a file. But does it work with the option 'time_base' and
'runtime'?

For example, does the configuration below make sense?

[global]
direct=1
ioengine=libaio
time_based
numjobs=1
verify=crc32
runtime=50000

The verification process might not even start if the runtime ends,
right? If this is the case, what should I do to configure it in such a
way that it could do the read and write and also data verification in
some targeted period of time?

Thank you so much in advance.
Best wishes,
Taylor

