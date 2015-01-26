Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:40839 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbbAZM5P (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 26 Jan 2015 07:57:15 -0500
Received: by mail-qg0-f50.google.com with SMTP id f51so6531345qge.9
        for <fio@vger.kernel.org>; Mon, 26 Jan 2015 04:57:14 -0800 (PST)
MIME-Version: 1.0
From: "telecolega ." <telecolega@gmail.com>
Date: Mon, 26 Jan 2015 13:56:54 +0100
Message-ID: <CADtCuZeCCbocXKJ-_fgcxsOUw-NzhP1H+=eH6Y_LOODnWiGWaQ@mail.gmail.com>
Subject: sequential writing
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi guys,

In the last days I tried to investigate how fio writes sequentially
when using the libaio engine. As far as I understood, the key here is
controlling the offset variable in the iocb struct (iocb->u.c.offset)
so that the new block is written right next to the previous block.

Now a question comes to my mind. Even if fio is writing sequentially
on a file or block, that does not guarantee that we are writing
sequentially on the hard disk, right? I guess the linux kernel will be
the one eventually deciding if that data is written sequentially or
randomly across the disk. Nevertheless, I assume that when FIO writes
sequentially to a file or block, the likelyhood that the data is
written sequentially is increased. Is this correct?

Do you know if there is a way from the user space (e.g. fio) to
"force" the kernel to write sequentially?

Thanks ofr your help!
