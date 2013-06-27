Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53785 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3F0SSK (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 27 Jun 2013 14:18:10 -0400
Received: by mail-ie0-f175.google.com with SMTP id a13so2064278iee.6
        for <fio@vger.kernel.org>; Thu, 27 Jun 2013 11:18:10 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 27 Jun 2013 14:18:09 -0400
Message-ID: <CAJLXCZTeqg6DTeRcMK0asRoZ7EShD8Od+Y05R-Tgi7OEcS2Fuw@mail.gmail.com>
Subject: Make threads access the same files?
From: Andrew Davidoff <davidoff@qedmf.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

If I understand fio's threaded operation, mrfiles are generated for
each thread (jobs=N), and each thread operates on its own files. Is
there a way to tell fio to spawn multiple threads, but for each to
access a single set of files?

So:

nrfiles=2048
jobs=12

Would produce 12 threads working against the same 2048 files.

Thanks.
Andy
