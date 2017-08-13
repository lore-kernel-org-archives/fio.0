Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxiE-xi=Bfaomen-XFbP-B+1WBSYfXcE0T=UCXN3uxO_HQ@mail.gmail.com>
References: <20170813191901.33195-1-tkusumi@tuxera.com> <20170813191901.33195-5-tkusumi@tuxera.com>
 <CALjAwxiE-xi=Bfaomen-XFbP-B+1WBSYfXcE0T=UCXN3uxO_HQ@mail.gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Mon, 14 Aug 2017 00:30:29 +0300
Message-ID: <CAHndrBmXewKthugSnibDQmFY=TEhB5k0qNY+HEBHSv3a=r+CRw@mail.gmail.com>
Subject: Re: [PATCH 4/4] HOWTO: minor fixes and backports from man page
Content-Type: text/plain; charset="UTF-8"
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

2017-08-13 23:59 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
> On 13 August 2017 at 20:19,  <kusumi.tomohiro@gmail.com> wrote:
>>
>> -.. option:: --runtime
>> -       Limit run time to runtime seconds.
>> +.. option:: --runtime=runtime
>> +       Limit run time to `runtime` seconds.
>
> I've got a commit to just throw this away. The lack of an empty line
> makes the formatting go weird and it's actually been removed from fio.
> See https://github.com/axboe/fio/pull/423 .
>
>>
>>  .. option:: --bandwidth-log
>>
>> @@ -128,9 +128,9 @@ Command line options
>>         **Deprecated**, use :option:`--output-format` instead to select multiple
>>         formats.
>>
>> -.. option:: --terse-version=type
>> +.. option:: --terse-version=version
>>
>> -       Set terse version output format (default 3, or 2 or 4 or 5).
>> +       Set terse `version` output format (default 3, or 2 or 4 or 5).
>>
>>  .. option:: --version
>>
>> @@ -156,8 +156,8 @@ Command line options
>>
>>  .. option:: --enghelp=[ioengine[,command]]
>>
>> -       List all commands defined by :option:`ioengine`, or print help for `command`
>> -       defined by :option:`ioengine`.  If no :option:`ioengine` is given, list all
>> +       List all commands defined by `ioengine`, or print help for `command`
>> +       defined by `ioengine`.  If no `ioengine` is given, list all
>>         available ioengines.
>
> Why remove the link to the ioengine section?
>
>> @@ -296,8 +296,8 @@ override a *global* section parameter, and a job file may even have several
>>  *global* sections if so desired. A job is only affected by a *global* section
>>  residing above it.
>>
>> -The :option:`--cmdhelp` option also lists all options. If used with an `option`
>> -argument, :option:`--cmdhelp` will detail the given `option`.
>> +The :option:`--cmdhelp` option also lists all options. If used with an `command`
>
> "a command" rather than "an command"?
>
>
>>
>> -.. option:: hostname=str : [netsplice] [net]
>> -
>> -       The hostname or IP address to use for TCP or UDP based I/O.  If the job is
>> -       a TCP listener or UDP reader, the hostname is not used and must be omitted
>> -       unless it is a valid UDP multicast address.
>> -
>
> Was this moved elsewhere?
>
>>  .. option:: namenode=str : [libhdfs]
>>
>>         The hostname or IP address of a HDFS cluster namenode to contact.
>>
>>  .. option:: port=int
>>
>> +   [libhdfs]
>> +
>> +               The listening port of the HFDS cluster namenode.
>> +
>>     [netsplice], [net]
>>
>>                 The TCP or UDP port to bind to or connect to. If this is used with
>> @@ -1856,9 +1853,11 @@ caveat that when used on the command line, they must come after the
>>                 this will be the starting port number since fio will use a range of
>>                 ports.
>>
>> -   [libhdfs]
>> +.. option:: hostname=str : [netsplice] [net]
>>
>> -               The listening port of the HFDS cluster namenode.
>> +       The hostname or IP address to use for TCP or UDP based I/O.  If the job is
>> +       a TCP listener or UDP reader, the hostname is not used and must be omitted
>> +       unless it is a valid UDP multicast address.
>>
>>  .. option:: interface=str : [netsplice] [net]
>>
>> @@ -1873,9 +1872,7 @@ caveat that when used on the command line, they must come after the
>>
>>         Set TCP_NODELAY on TCP connections.
>>
>> -.. option:: protocol=str : [netsplice] [net]
>> -
>> -.. option:: proto=str : [netsplice] [net]
>> +.. option:: protocol=str, proto=str : [netsplice] [net]
>>
>>         The network protocol to use. Accepted values are:
>>
>> @@ -1892,7 +1889,7 @@ caveat that when used on the command line, they must come after the
>>
>>         When the protocol is TCP or UDP, the port must also be given, as well as the
>>         hostname if the job is a TCP listener or UDP reader. For unix sockets, the
>> -       normal filename option should be used and the port is invalid.
>> +       normal :option:`filename` option should be used and the port is invalid.
>>
>>  .. option:: listen : [netsplice] [net]
>>
>> @@ -1977,7 +1974,7 @@ I/O depth
>>         engines may impose OS restrictions causing the desired depth not to be
>>         achieved.  This may happen on Linux when using libaio and not setting
>>         :option:`direct`\=1, since buffered I/O is not async on that OS.  Keep an
>> -       eye on the I/O depth distribution in the fio output to verify that the
>> +       eye on the I/O depths distribution in the fio output to verify that the
>
> I think the original version was correct.
>
>>         achieved depth is as expected. Default: 1.
>>
>>  .. option:: iodepth_batch_submit=int, iodepth_batch=int
>> @@ -2063,10 +2060,10 @@ I/O rate
>>  .. option:: thinktime_blocks=int
>>
>>         Only valid if :option:`thinktime` is set - control how many blocks to issue,
>> -       before waiting `thinktime` usecs. If not set, defaults to 1 which will make
>> -       fio wait `thinktime` usecs after every block. This effectively makes any
>> +       before waiting :option:`thinktime` usecs. If not set, defaults to 1 which will make
>> +       fio wait :option:`thinktime` usecs after every block. This effectively makes any
>>         queue depth setting redundant, since no more than 1 I/O will be queued
>> -       before we have to complete it and do our thinktime. In other words, this
>> +       before we have to complete it and do our :option:`thinktime`. In other words, this
>>         setting effectively caps the queue depth if the latter is larger.
>>
>>  .. option:: rate=int[,int][,int]
>> @@ -2350,7 +2347,7 @@ Threads, processes and job synchronization
>>  .. option:: exitall
>>
>>         By default, fio will continue running all other jobs when one job finishes
>> -       but sometimes this is not the desired action.  Setting ``exitall`` will
>> +       but sometimes this is not the desired action.  Setting :option:`exitall` will
>
> When you're already in the option it's not usually worth linking back to it...
>
>>         instead make fio terminate all other jobs when one job finishes.
>>
>>  .. option:: exec_prerun=str
>> @@ -2571,7 +2568,7 @@ Verification
>>         state is loaded for the verify read phase. The format of the filename is,
>>         roughly::
>>
>> -       <type>-<jobname>-<jobindex>-verify.state.
>> +               <type>-<jobname>-<jobindex>-verify.state.
>>
>>         <type> is "local" for a local run, "sock" for a client/server socket
>>         connection, and "ip" (192.168.0.1, for instance) for a networked
>> @@ -2693,7 +2690,7 @@ Measurements and reporting
>>         :command:`fio_generate_plots` script uses :command:`gnuplot` to turn these
>>         text files into nice graphs. See :option:`write_lat_log` for behavior of
>>         given filename. For this option, the postfix is :file:`_bw.x.log`, where `x`
>> -       is the index of the job (`1..N`, where `N` is the number of jobs). If
>> +       is the index of the job (1..N, where N is the number of jobs). If
>
> Perhaps this should be italicized?
>
>>
>> @@ -3194,7 +3191,7 @@ writes in the example above).  In the order listed, they denote:
>>                 entry denotes that amount and below, until the previous entry -- e.g.,
>>                 16=100% means that we submitted anywhere between 9 to 16 I/Os per submit
>>                 call.  Note that the range covered by a submit distribution entry can
>> -               be different to the range covered by the equivalent depth distribution
>> +               be different to the range covered by the equivalent depths distribution
>
> Again not sure depth should be pluralized because they're part of a
> distribution

OK, missed this last one.
Then this and the one above should be in singular.

>
> --
> Sitsofe | http://sucs.org/~sits/

