Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Makefile: Rerun the configure script if it has been
 modified
References: <20180309165104.16860-1-bart.vanassche@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8baa3a81-40ee-4988-264a-385af4ac04d4@kernel.dk>
Date: Fri, 9 Mar 2018 10:25:40 -0700
MIME-Version: 1.0
In-Reply-To: <20180309165104.16860-1-bart.vanassche@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/9/18 9:51 AM, Bart Van Assche wrote:
> Because of a typo in the Makefile ("config-host-mak") the configure
> script is not rerun if the configure script is modified after
> config-host.mak has been generated. Merge the two make goals for
> rerunning configure into a single goal. This patch relies on the
> following make behavior (see also https://www.gnu.org/software/make/manual/make.html#Remaking-Makefiles):
> 
>   Sometimes makefiles can be remade from other files, such as RCS or SCCS
>   files. If a makefile can be remade from other files, you probably want
>   make to get an up-to-date version of the makefile to read in.
> 
>   To this end, after reading in all makefiles, make will consider each as a
>   goal target and attempt to update it. If a makefile has a rule which says
>   how to update it (found either in that very makefile or in another one) or
>   if an implicit rule applies to it (see Using Implicit Rules), it will be
>   updated if necessary. After all makefiles have been checked, if any have
>   actually been changed, make starts with a clean slate and reads all the
>   makefiles over again. (It will also attempt to update each of them over
>   again, but normally this will not change them again, since they are
>   already up to date.)
> 
> This patch has been tested by verifying that the commands run by make
> were as expected for the following invocations:
> 
> rm -f config-host.mak && make
> make && touch configure && make
> make> 
> Note: fio already requires GNU make because of the use of "ifeq" etc.

Thanks Bart, applied.

-- 
Jens Axboe


