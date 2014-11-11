Return-Path: <stephenmcameron@gmail.com>
MIME-Version: 1.0
In-Reply-To: <54627C44.3080909@kernel.dk>
References: <54627C44.3080909@kernel.dk>
Date: Tue, 11 Nov 2014 15:52:43 -0600
Message-ID: <CADzpL0T=m8qy6=sxDuksBT4ML-sZK=RLtT4Gz_JSww2-V1CZFg@mail.gmail.com>
Subject: Re: Fio 2.1.14 released
From: Stephen Cameron <stephenmcameron@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Double parens?  If a single pair of parens is no longer sufficient,
that is news to me (git top of tree seems to take a single pair of
surrounding parens ok, and I didn't see a recent commit that looked
like a change to require double parens.)

Eg:

sleekness fio # grep 2k examples/latency-profile.fio
bs=(2k+2k)
sleekness fio # ./fio examples/latency-profile.fio
device: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
fio-2.1.14-3-g9e311
Starting 1 process
^Cbs: 1 (f=1)
fio: terminating on signal 2

-- steve

On Tue, Nov 11, 2014 at 3:14 PM, Jens Axboe <axboe@kernel.dk> wrote:
> Hi,
>
> I've released version 2.1.14 today. Here's a (rough) list of the changes,
> features, additions that were added/done since 2.1.13:
>
> - Fio now supports arithmetic expressions in job files or on the
>   command line. They have to be enclosed in double parentheses. This
>   might be relaxed in the future, once it's matured a bit. This means
>   you can do things like:
>
>   bs=((4*1024))
>
>   etc. The parser understands the regular +, -, /, *, as well as ^ for
>   exponentiation, and % for modulus operations. Fio needs development
>   packages of lex/flex and yacc/bison, it'll detect these at configure
>   time.
>
> - Some of the test tools are now installed properly when fio is
>   installed. Generally they are prefixed with fio-, like fio-dedupe or
>   fio-btrace2fio.
>
> - The net IO engine grew some options to support setting socket buffer
>   sizes and tcp max segments. It also supports counting dropped packets
>   for UDP now.
>
> - Various improvements and fixes to the RBD IO engine.
>
> - The client/server functionally has seen some bug fixes and should be
>   improved in stability.
>
> - Fix for a stat related hang on exit, and for a stat related issue
>   with periodical dumps through --status-interval.
>
> - Support added for DragonFly BSD.
>
> - The OS provided random functions have been removed. Fio defaulted
>   to its own default random generator for years now, since it was
>   easier to provide consistent workloads across operating systems
>   that way. This means that the 'use_os_rand' option has now been
>   deprecated.
>
> - Fix a potential crash on fio exit with data verification enabled,
>   which has existed since version 2.1.11.
>
> - Fio will exit a bit faster now, since the disk util thread and the
>   helper thread were combined into one, and it'll be immediately torn
>   down on exit. It had to wait around 250msecs before this change. You
>   might have noticed this delay when doing ctrl-c on a workload.
>
> - Lots of small bug fixes.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

