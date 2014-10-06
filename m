Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:16607 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750956AbaJFWeK (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Oct 2014 18:34:10 -0400
Received: from [10.0.10.100] (c-67-182-239-81.hsd1.ut.comcast.net [67.182.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id DF9751D66C5
	for <fio@vger.kernel.org>; Mon,  6 Oct 2014 16:34:08 -0600 (MDT)
Message-ID: <543318E1.2070701@cran.org.uk>
Date: Mon, 06 Oct 2014 16:34:09 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com>
In-Reply-To: <CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 10/6/2014 3:44 PM, Stephen Cameron wrote:
> I suspect that your version of yacc does not comprehend the --no-lines
> option (which we needed only in order to avoid a bug in some other
> versions of yacc).  From the usage message it does appear to
> understand both -d and -l though.
>
> Try changing the --no-lines option in the Makefile to -l instead, and
> see if that helps.

The same problem occurs on FreeBSD 10. After changing "--no-lines" to 
"-l" the build works, with the following warnings:

   YACC y.tab.c
     CC lex.yy.o
lex.yy.c:1245:3: warning: incompatible pointer types passing 'yy_size_t 
*' (aka 'unsigned long *') to parameter of type 'int *' 
[-Wincompatible-pointer-types]
                 YY_INPUT( 
(&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exp/expression-parser.l:31:25: note: expanded from macro 'YY_INPUT'
                 lexer_input((buffer), &(bytes_read), (bytes_requested))
                                       ^~~~~~~~~~~~~
exp/expression-parser.l:27:43: note: passing argument to parameter 
'nbytes' here
extern int lexer_input(char* buffer, int *nbytes, int buffersize);

-- 
Bruce
