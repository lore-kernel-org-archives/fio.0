Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38734 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979AbbDPLQG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Apr 2015 07:16:06 -0400
Received: by igbhj9 with SMTP id hj9so3171852igb.1
        for <fio@vger.kernel.org>; Thu, 16 Apr 2015 04:16:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABtFm2USrxVrNJyow6sFFNGdJFKoMieFepCWiPBHckg4e_k3-w@mail.gmail.com>
References: <CABtFm2USrxVrNJyow6sFFNGdJFKoMieFepCWiPBHckg4e_k3-w@mail.gmail.com>
Date: Thu, 16 Apr 2015 19:16:06 +0800
Message-ID: <CABtFm2XhAte41q9AFHSuEjAt-Tth=iiayqc=KSxaFcn86+rLSg@mail.gmail.com>
Subject: Re: lex/yacc not configured properly.
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Srinivasa Chamarthy <chamarthy.raju@gmail.com>

This might fail for solaris. May require some conditional compilation.

On Thu, Apr 16, 2015 at 6:22 PM, Srinivasa Chamarthy
<chamarthy.raju@gmail.com> wrote:
> There seems to be a small issue with configure while checking
> lex/yacc. Eventhough lex/yacc is available, it fails as the library
> name for lex is not what is expected.
>
> library for lex should be "-lfl" instead of "-ll".
>
> + echo 'Compiling test case lex'
> + do_cc -D_GNU_SOURCE -include config-host.h -o
> /tmp/fio-conf-1068-8707-30378.exe /tmp/fio-conf-10872-8707-1500.c -ll
> -lnuma -lrt -laio -lz
> + echo gcc -D_GNU_SOURCE -include config-host.h -o
> /tmp/fio-conf-1068-8707-30378.exe /tmp/fio-conf-10872-8707-1500.c -ll
> -lnuma -lrt -laio -lz
> + gcc -D_GNU_SOURCE -include config-host.h -o
> /tmp/fio-conf-1068-8707-30378.exe /tmp/fio-conf-10872-8707-1500.c -ll
> -lnuma -lrt -laio -lz
> + return 1
> + arith=no
> + echo 'lex/yacc for arithmetic       no'
>
> The following fixes the issue:
> ------------------------
> --- configure.old       2015-04-16 06:19:44.016796602 -0400
> +++ configure   2015-04-16 06:19:55.272796870 -0400
> @@ -1420,8 +1420,8 @@ int main(int argc, char **argv)
>    return 0;
>  }
>  EOF
> -if compile_prog "" "-ll" "lex"; then
> -  LIBS="-ll $LIBS"
> +if compile_prog "" "-lfl" "lex"; then
> +  LIBS="-lfl $LIBS"
>  else
>    arith="no"
>  fi
> -------------------
>
> lex/yacc for arithmetic       yes
>
> --
> Srinivasa R Chamarthy



-- 
Srinivasa R Chamarthy
