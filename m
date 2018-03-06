Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:41557 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbeCFQfv (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Mar 2018 11:35:51 -0500
Received: by mail-ua0-f173.google.com with SMTP id u99so13457647uau.8
        for <fio@vger.kernel.org>; Tue, 06 Mar 2018 08:35:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 6 Mar 2018 16:35:20 +0000
Message-ID: <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
Subject: Re: Windows: FIO randomly hangs using attached script
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: fio <fio@vger.kernel.org>

On 6 March 2018 at 01:23, Rebecca Cran <rebecca@bluestop.org> wrote:
> I've had a report that FIO on Windows (at least Server 2012 R2 and 2016)
> hangs when the attached script is run. The point at which it hangs is
> apparently random, and within the condvar (pthread-win32) calls.
>
> I've replicated the hang, but I don't have time to debug it so I was hoping
> somebody on this mailing list might have time to dig into it and figure out
> what's wrong.

I'd like to look but I no longer have access to Windows machines
beyond what you can get with Appveyor so I'd need quite a restricted
test case to analyse this (see below for the problems I've been
having).

> The people I was talking to thought it might be due to FIO linking to
> msvcrt.dll, which is old and not supposed to be used by applications - they
> should use the CRT distributed with Visual C++, such as msvcr120.dll
> instead. However, it appears that fixing this would take quite a lot of work
> since while FIO is relatively straightforward to change, pthread-win32
> hasn't had a full release since 2012 and doesn't build under a current msys
> environment due to duplicated symbols etc.

It's true you're not supposed to link against the system msvcrt.dll
(see https://blogs.msdn.microsoft.com/oldnewthing/20140411-00/?p=1273
and https://sourceforge.net/p/mingw-w64/wiki2/The%20case%20against%20msvcrt.dll/
) however the MinGW folks have observed it can't really go away and
seem to gear everything up for doing that and only use it for basic
functionality (e.g. see
http://mingw-users.1079350.n2.nabble.com/Which-msvcrt-dll-does-MinGW-use-tp7582968p7582969.html
and https://ghc.haskell.org/trac/ghc/ticket/14537#comment:2 ).

Since your commit back in Jan 2014
(https://github.com/axboe/fio/commit/9aa5fe3290fd49c70e498d5e072a5b27e1c3034f
) fio migrated from pthread-win32 to MinGW's
internal winpthread (which seems to be alive as there's a commit from
Jan 2018 - https://github.com/mirror/mingw-w64/commits/master/mingw-w64-libraries/winpthreads
). If we have a repeatable small test case we might be able to send it
to the MinGW folks to look at...

I tried out the python script but it seemed to be complaining about a
whitespace issue. After fixing that up it's unclear exactly what fio
command lines it runs. I think for others to dig in we'd need
something less fiddly like the raw fio command lines that generate the
hang. Is there any chance the mystery user could join the mailing list
so they can answer questions directly? Ideally we'd need a job that
works on files within a filesystem and ideally nice small files so it
could go into an AppVeyor job...

-- 
Sitsofe | http://sucs.org/~sits/
