Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33403 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2HPDel (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Aug 2012 23:34:41 -0400
Received: by bkwj10 with SMTP id j10so759894bkw.19
        for <fio@vger.kernel.org>; Wed, 15 Aug 2012 20:34:39 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Aug 2012 13:34:39 +1000
Message-ID: <CAHaS=QxT7Prz4jw8b5rZ-D3gTmejFp3D6ZA6DxcigHpEcVAJbw@mail.gmail.com>
Subject: Test files being created twice as large as requested (Win7)
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

fio seems to be creating test files that are twice as large as
requested. The following config creates a file that is 209,715,200
bytes in size:

[read]
size=100M
rw=read

Environment: Windows 7 32-bit, fio 2.0.8

Greg.
