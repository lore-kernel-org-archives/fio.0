Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:14397 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbdGYP3l (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Jul 2017 11:29:41 -0400
Subject: Re: The commit 'filesetup: add native fallocate' breaks on Cygwin
References: <CAHndrBkV55xWU0yioqqYARdE3SzVpjxxnp9e8qoxxF+-Y_5F+A@mail.gmail.com>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <4b0decdf-1615-cf2b-1305-d55630bef9f0@bluestop.org>
Date: Tue, 25 Jul 2017 09:29:39 -0600
MIME-Version: 1.0
In-Reply-To: <CAHndrBkV55xWU0yioqqYARdE3SzVpjxxnp9e8qoxxF+-Y_5F+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org

On 7/25/2017 1:16 AM, Tomohiro Kusumi wrote:
> It seems the recent commit 2c3e17be ('filesetup: add native
> fallocate') breaks on Cygwin.
> It works on FreeBSD by the way.

I see the problem: FIO_FALLOCATE_NONE has a value of 1, so in 
fallocate_file the 0 which is produced for platforms like Windows that 
don't support fallocate fall through to the default case, which asserts. 
I'm not sure if we want to renumber the fio_fallocate_mode enum to start 
at 0?

By the way the breakage is on Windows in general: fio no longer uses Cygwin.

-- 
Rebecca
