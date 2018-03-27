Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:35878 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeC0UOb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Mar 2018 16:14:31 -0400
Received: by mail-ua0-f177.google.com with SMTP id v9so114690uaj.3
        for <fio@vger.kernel.org>; Tue, 27 Mar 2018 13:14:31 -0700 (PDT)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 27 Mar 2018 21:13:57 +0100
Message-ID: <CALjAwxgErjdsMQ60SOgoAdfTCvdTh_TwKY2DhgcV0OeOA36FjQ@mail.gmail.com>
Subject: Windows fio build processor group support testing
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>
Cc: Rebecca Cran <rebecca@bluestop.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>

I have a git tree (https://github.com/sitsofe/fio/commits/proc_group )
that adds processor group support to fio CPU setting but to do so it
introduces a flag to target the build to Windows 7 and sets it to be
the default. If this change goes in it will mean if you would need to
explicitly set a flag to have an fio that will work for
WinXP/Vista/2003/2008 (before R2) etc. If you have time, any feedback
would be useful.

If I don't hear any complaints I'll send a pull request to Jens in a day or two.

-- 
Sitsofe | http://sucs.org/~sits/
