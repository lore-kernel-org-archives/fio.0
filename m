Return-Path: <stephenmcameron@gmail.com>
MIME-Version: 1.0
In-Reply-To: <543D907B.3080005@kernel.dk>
References: <CAMA-6iaCvppOLvBOP6K2+Gt-BEo5x_m_BXvq8xs8K8ezgt132w@mail.gmail.com>
	<543D907B.3080005@kernel.dk>
Date: Tue, 14 Oct 2014 23:24:39 -0500
Message-ID: <CADzpL0T6cQ=pWr4iM=0JoV_e-3wfO65s-PgYXC-YPr1mYvzuFQ@mail.gmail.com>
Subject: Re: BUG - Cannot build fio on redhat 5
From: Stephen Cameron <stephenmcameron@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Tim Delaney <2timdelaney@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Been traveling all day, so only just now saw this thread... I can take
a look tomorrow, if you haven't already solved it.  I don't have
access to any rhel5 systems though.

-- steve


On Tue, Oct 14, 2014 at 4:07 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 10/14/2014 01:58 PM, Tim Delaney wrote:
>> Trying to make fio on redhat 5.9 results in:
>>
>>     lex: unknown flag '-'.  For usage, try
>>             lex --help
>>     make: *** [lex.yy.c] Error 1
>>
>> Changeset "c9fa1c8d (Stephen M. Cameron  2014-10-06 17:58:32 -0500
>> 270)" introduced the lex '--header-file' option, but that option is
>> not valid on redhat 5.
>>
>> Makefile diff...
>>
>>      ifdef CONFIG_ARITHMETIC
>>      lex.yy.c: exp/expression-parser.l
>>     -       $(QUIET_LEX)$(LEX) exp/expression-parser.l
>>     +       $(QUIET_LEX)$(LEX) --header-file=lexer.h exp/expression-parser.l
>
> Stephen, ideas on how to work around this? Would be nice if we could
> make-do without the lexer.h generation. Unfortunately I don't have a
> RHEL5 here.
>
> Tim, what does lex --version and flex --version say?
>
> --
> Jens Axboe
>

