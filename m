Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50228 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3HFVwD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 6 Aug 2013 17:52:03 -0400
Received: by mail-oa0-f46.google.com with SMTP id l10so1944466oag.33
        for <fio@vger.kernel.org>; Tue, 06 Aug 2013 14:52:02 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 6 Aug 2013 15:52:02 -0600
Message-ID: <CAGRFgs1hbS8pT01+w50-iF3sj3b1gCCrf-zSpP0CGhnQ-utgrA@mail.gmail.com>
Subject: Server mode problems with 2.1.1
From: George Smith <glsmith555@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I have been using FIO (2.0.15) server mode successfully on Linux
(CentOS 6) and Windows (2012) for perhaps the last 6 months.

Today I built the new (as of a few days ago) FIO 2.1.1 on Linux, and
everything seems fine there including server mode (Linux -> Linux).

On Windows (package downloaded from bluestop), however, server mode
does not seem to work anymore.  To be clear, I'm running

fio --client <ip> job

from Linux, to an

fio --server

instance running on Win2012.  The client connect hangs, and the server
on the Windows box spews the following:

fork is not implemented
waitpid is not implemented
fio: waitpid: Function not implemented
waitpid is not implemented
<repeat of the previous errors until the client or server is killed>

I haven't really debugged this too much, was just wondering if I'm
missing something major (being relatively new to FIO and this list).
I'm assuming server mode is still supposed to work in these newer
releases much the same way that the 2.0.15 I'm using does?

Thanks,

--gls
