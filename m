Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw1-f41.google.com ([209.85.161.41]:33802 "EHLO
        mail-yw1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730262AbfHGTEK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Aug 2019 15:04:10 -0400
Received: by mail-yw1-f41.google.com with SMTP id q128so32871076ywc.1
        for <fio@vger.kernel.org>; Wed, 07 Aug 2019 12:04:10 -0700 (PDT)
MIME-Version: 1.0
From: Taylor Yang <taylor4869@gmail.com>
Date: Wed, 7 Aug 2019 12:03:56 -0700
Message-ID: <CAKiK_mD4F9MBSdaYdBbJLy_ki0TfmQFZJPchNy0xRvNXr8FkKQ@mail.gmail.com>
Subject: Question about data verification for shared storage
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am planning to write a data verification test for shared storage.
Other than splitting the shared storage with offset and size (so that
each machine would only write and read to certain part of the storage
and there will not be concurrent write and read), is there any other
FIO load or options I could use?

Thank you very much in advance.
Best wishes,
Taylor

