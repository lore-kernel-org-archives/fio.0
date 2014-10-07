Return-Path: <axboe@kernel.dk>
Message-ID: <543402A6.6010706@kernel.dk>
Date: Tue, 07 Oct 2014 09:11:34 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com> <D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0RsVUsRD25Rr0MokhXVCVa30OXa1RzCLK6X3nKhYn_u=Q@mail.gmail.com> <D0588B95.51DDD%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0TS_5vnOR-VHrgXRhaeef71stgNtqdYAEotqFisLtejQg@mail.gmail.com> <54333D69.7060304@kernel.dk> <CADzpL0SQ56xmwT5umYu+OdCMu5YwaV6vngruLzpPyoEu=_iy+w@mail.gmail.com> <54334D63.70909@kernel.dk> <D05964A6.51EA6%Antonio.Jose.Rodrigues.Neto@netapp.com> <D05967DE.51EB1%Antonio.Jose.Rodrigues.Neto@netapp.com> <5433F5FF.60508@kernel.dk> <5433F8C1.1030100@kernel.dk> <D0597430.51EDC%Antonio.Jose.Rodrigues.Neto@netapp.com> <5433FEEF.2070402@kernel.dk> <D059784E.51EFC%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D059784E.51EFC%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>, Stephen Cameron <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/07/2014 09:00 AM, Neto, Antonio Jose Rodrigues wrote:
>     CC lex.yy.o
> lex.yy.c:1231:3: warning: incompatible pointer types passing 'yy_size_t *'
> (aka 'unsigned long *') to parameter of type 'int *'
>       [-Wincompatible-pointer-types]
>                 YY_INPUT(
> (&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
>                 
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> exp/expression-parser.l:31:25: note: expanded from macro 'YY_INPUT'
>                 lexer_input((buffer), &(bytes_read), (bytes_requested))
>                                       ^~~~~~~~~~~~~
> exp/expression-parser.l:27:43: note: passing argument to parameter
> 'nbytes' here
> extern int lexer_input(char* buffer, int *nbytes, int buffersize);

OK, try and re-pull, I think I fixed the size_t issue as well now. This
is the commit:

http://git.kernel.dk/?p=fio.git;a=commit;h=3fcc6ca7f15db70b9f82df1f9065765b4cca4e9d

-- 
Jens Axboe


