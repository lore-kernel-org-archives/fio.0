Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35842 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2HTA5G (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 19 Aug 2012 20:57:06 -0400
Received: by bkwj10 with SMTP id j10so1726464bkw.19
        for <fio@vger.kernel.org>; Sun, 19 Aug 2012 17:57:04 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 20 Aug 2012 10:57:04 +1000
Message-ID: <CAHaS=Qwn2zxQWkvy=ZPQstwwOuX1P__=Gp1jw9WW3Jy6jpDWxA@mail.gmail.com>
Subject: Direct io on Ubuntu i386?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm trying to do direct io (to avoid the file system cache) on Ubuntu
i386. I've tried direct=1, and tried the io engines sync and libaio -
it always seems to use the cache.

Is there a way to bypass the file system cache on Ubuntu? I've got a
vanilla install using the automated Ubuntu installer for Windows i386
32-bit (dual boot).

fio version: 2.0.8-

Greg.
