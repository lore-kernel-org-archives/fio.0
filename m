Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <a1022d126a861770281f3003eed29b477666c496.camel@wdc.com>
References: <CALjAwxgErjdsMQ60SOgoAdfTCvdTh_TwKY2DhgcV0OeOA36FjQ@mail.gmail.com>
 <a1022d126a861770281f3003eed29b477666c496.camel@wdc.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 28 Mar 2018 11:48:06 +0100
Message-ID: <CALjAwxhnGDcqVsq43ZyeH_Scb+bepT5gBKd0X151WTwNj85v4A@mail.gmail.com>
Subject: Re: Windows fio build processor group support testing
Content-Type: text/plain; charset="UTF-8"
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "rebecca@bluestop.org" <rebecca@bluestop.org>, "elliott@hpe.com" <elliott@hpe.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi Bart,

On 27 March 2018 at 21:25, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> My feedback about these patches is as follows:
> - Having to specify a target Windows version at build time seems wrong to me.
>   What I did myself when I wrote Windows code 15 years ago was to detect at
>   runtime which functionality is available and which functionality is not
>   available. An initialization function could e.g. call LoadLibrary() and
>   GetProcAddress(). The function pointer(s) returned by GetProcAddress() can
>   be stored in global variables. Any function that needs code that is not
>   available on every supported Windows version can then check these function
>   pointers, starting with the most recently introduced function, and call a
>   function that is available on the Windows platform fio has been started on.

I'll note that Jens suggested we could use build time configuration in
https://github.com/axboe/fio/issues/527#issuecomment-363804643 . With
runtime lookup it becomes tricky to test the legacy paths on new
systems because you can no longer force them to be taken (I don't have
access to a Windows before 2012 R2 myself). My hope is that support
for legacy Windows is eventually dropped because:
- Most mainstream versions of Windows before Windows 7/Windows Server
2008 are already EOL (both versions of Server 2008 go EOL in 2020)
- It's unclear who is running fio is running fio in those old Windows
environments

I also suspect we've quietly dropped support for old versions of other
OSes due to build requirements - it looks like it would be a struggle
to build a recent fio for a RHEL 4 era system due compiler
requirements (and who knows if there are other problems when using an
older glibc).

> - Explicit XP / 2000 / etc. version checks seem unfortunate to me because I
>   think these will lead to maintainability problems in the future.

The fact the code has a conditional (either a compile one or a runtime
one) is what's unfortunate and there's a maintenance burden either way
due to increased paths. The only way to save maintenance effort would
be to drop the old path...

> - Your patch series adds a lot of code in header files which will slow down
>   the build. I think such code should be added to .c files instead.

This argument applies to the other bigger os/os-*.h files (e.g.
os/os-linux.h) too but I think making such a change (and ensuring the
pieces that are performance sensitive stay inlinable) could be done in
a separate patch (which would be able to introduce an os.o) in the
future.

-- 
Sitsofe | http://sucs.org/~sits/

