Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:37194 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaJFVon (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Oct 2014 17:44:43 -0400
Received: by mail-oi0-f53.google.com with SMTP id v63so4155360oia.26
        for <fio@vger.kernel.org>; Mon, 06 Oct 2014 14:44:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com>
Date: Mon, 6 Oct 2014 16:44:43 -0500
Message-ID: <CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com>
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
From: Stephen Cameron <stephenmcameron@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Oct 6, 2014 at 4:12 PM, Neto, Antonio Jose Rodrigues
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>
> Hi All,
>
> This is neto from Brazil
>
> How are you?
>
> Trying to compile fio on RHEL 6.4 and I've got this error (latest git).
>
> Please any ideas how to fix it? (I've tried to use CONFIG_ARITHMETIC=n,
> but not success)
>
> CC verify.o
>     CC memory.o
>     CC io_u.o
>    LEX lex.yy.c
>   YACC y.tab.c
> Usage: /usr/bin/yacc [options] filename
>
> Options:
>   -b file_prefix        set filename prefix (default "y.")
>   -d                    write definitions (y.tab.h)
>   -g                    write a graphical description
>   -l                    suppress #line directives
>   -o output_file        (default "y.tab.c")
>   -p symbol_prefix      set symbol prefix (default "yy")
>   -r                    produce separate code and table files (y.code.c)
>   -t                    add debugging support
>   -v                    write description (y.output)
>   -V                    show version information and exit
> make: *** [y.tab.c] Error 1

I suspect that your version of yacc does not comprehend the --no-lines
option (which we needed only in order to avoid a bug in some other
versions of yacc).  From the usage message it does appear to
understand both -d and -l though.

Try changing the --no-lines option in the Makefile to -l instead, and
see if that helps.

You can also run "make V=1 > output.txt" to get more verbose output
from make and get a clearer idea of what the offending command line is
trying to do.

-- steve
