Return-Path: <erwan@enovance.com>
Message-ID: <52020BFD.3080504@enovance.com>
Date: Wed, 07 Aug 2013 10:57:33 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: 2.1.2 released
References: <52011D0F.5060308@kernel.dk> <52012346.9040609@enovance.com> <520171C0.2090400@conversis.de>
In-Reply-To: <520171C0.2090400@conversis.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Dennis Jacobfeuerborn <dennisml@conversis.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 06/08/2013 23:59, Dennis Jacobfeuerborn wrote:
> [..]
> How does the fio2gnuplot tool work? There is no man page or example 
> invocation that explains how to generate the plots. I tried 
> "fio2gnuplot --iops" but that only dumps the usage options without any 
> hint of what is wrong with that call.
Dear Dennis,

I'm sorry the inline help of fio2gnuplot isn't sufficient yet to get 
understood easily, I'll work on fixing this.

Anyway, here come how it works :

While running fio jobs, you are producing a set of log files located in 
a directory. When considering a good amount of logs, logs file are 
usually having different filename to remember what log match a 
particular run. i.e genfio does works this way ;o)

Then, when you want to plot some fio's output, you have to call 
fio2gnuplot with a 'pattern' (-p) option.
The pattern is a kind of regexp that allow you to choose what file you 
want to plot. Mostly, I do use the '*' for this purpose.

Let's say you have four files named like :
host1-read-4k_iops.log
host2-read-4k_iops.log
host3-read-4k_iops.log
host1-write-4k_iops.log

If you want to plot all the traces related to the reading you'll do :
fio2gnuplot -p 'host*-read-4k_iops.log'

Note the single quote to avoid the shell interpreting the star (*), it's 
up to fio2gnuplot to handle this.

Then, if you want to generate the rendering, you can use the '-g' flag 
to request the plotting (maybe this could be a default option).

Then, you can choose in which dir you want plot all this stuff, let's 
use the '-d' option. fio2gnuplot generates a _lot_ of traces, so that's 
a recommanded option.

So a typical cmdline would be :

fio2gnuplot -p 'host*-read-4k_iops.log' -g -d read-4k

About the --iops output you choose, it's just a predefined pattern that 
match all the "iops" files from the current directory. In fact, I didn't 
used them a lot .... a you spotted two nice bugs I shoudn't have commit.

First, it does print the help while the cmdline wasn't correct. It 
should have told you something was wrong on the cmdline.

Then, the --iops wasn't properly managed and as a result didn't got 
supported... .What a shame... Please make a try with '-i' on this 
version of the tool.

To fix this two bugs, I've been pushing two fixes in my dev tree that 
I'll ask to merge a little bit later.
If you want to test them, that's available here : 
https://github.com/enovance/fio/commits/erwan/next

I do agree that I should had a man page and much more example.
Thanks for testing my work & reporting.

Cheers,
Erwan,

