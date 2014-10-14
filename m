Return-Path: <axboe@kernel.dk>
Message-ID: <543D907B.3080005@kernel.dk>
Date: Tue, 14 Oct 2014 15:07:07 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: BUG - Cannot build fio on redhat 5
References: <CAMA-6iaCvppOLvBOP6K2+Gt-BEo5x_m_BXvq8xs8K8ezgt132w@mail.gmail.com>
In-Reply-To: <CAMA-6iaCvppOLvBOP6K2+Gt-BEo5x_m_BXvq8xs8K8ezgt132w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Tim Delaney <2timdelaney@gmail.com>, fio@vger.kernel.org, Stephen Cameron <stephenmcameron@gmail.com>
List-ID: <fio@vger.kernel.org>

On 10/14/2014 01:58 PM, Tim Delaney wrote:
> Trying to make fio on redhat 5.9 results in:
> 
>     lex: unknown flag '-'.  For usage, try
>             lex --help
>     make: *** [lex.yy.c] Error 1
> 
> Changeset "c9fa1c8d (Stephen M. Cameron  2014-10-06 17:58:32 -0500
> 270)" introduced the lex '--header-file' option, but that option is
> not valid on redhat 5.
> 
> Makefile diff...
> 
>      ifdef CONFIG_ARITHMETIC
>      lex.yy.c: exp/expression-parser.l
>     -       $(QUIET_LEX)$(LEX) exp/expression-parser.l
>     +       $(QUIET_LEX)$(LEX) --header-file=lexer.h exp/expression-parser.l

Stephen, ideas on how to work around this? Would be nice if we could
make-do without the lexer.h generation. Unfortunately I don't have a
RHEL5 here.

Tim, what does lex --version and flex --version say?

-- 
Jens Axboe


