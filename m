Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:43219 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3KNBtU (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 Nov 2013 20:49:20 -0500
Received: by mail-ie0-f169.google.com with SMTP id tp5so1881300ieb.28
        for <fio@vger.kernel.org>; Wed, 13 Nov 2013 17:49:19 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 14 Nov 2013 09:49:19 +0800
Message-ID: <CA+8ZFnh+CqzzqsMh=FQw_5pgiiOCQo58eDA4u02iUb7zv1mmcQ@mail.gmail.com>
Subject: What does "ddir" mean?
From: "xan.peng" <xanpeng@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi all,

When reading the code, I found DDIR_* and TD_DDIR_* in fio/io_ddir.h.
Though I figured it out they are related with "rw" option, I'm still
confused what does "DDIR" mean? DIR=directory? Then what's the first
'D'?
