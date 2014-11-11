Return-Path: <axboe@kernel.dk>
Received: from [192.168.3.11] (66.29.187.51.static.utbb.net. [66.29.187.51])
        by mx.google.com with ESMTPSA id n2sm20252366pdg.2.2014.11.11.13.14.44
        for <fio@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Nov 2014 13:14:45 -0800 (PST)
Message-ID: <54627C44.3080909@kernel.dk>
Date: Tue, 11 Nov 2014 14:14:44 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Fio 2.1.14 released
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

I've released version 2.1.14 today. Here's a (rough) list of the 
changes, features, additions that were added/done since 2.1.13:

- Fio now supports arithmetic expressions in job files or on the
   command line. They have to be enclosed in double parentheses. This
   might be relaxed in the future, once it's matured a bit. This means
   you can do things like:

   bs=((4*1024))

   etc. The parser understands the regular +, -, /, *, as well as ^ for
   exponentiation, and % for modulus operations. Fio needs development
   packages of lex/flex and yacc/bison, it'll detect these at configure
   time.

- Some of the test tools are now installed properly when fio is
   installed. Generally they are prefixed with fio-, like fio-dedupe or
   fio-btrace2fio.

- The net IO engine grew some options to support setting socket buffer
   sizes and tcp max segments. It also supports counting dropped packets
   for UDP now.

- Various improvements and fixes to the RBD IO engine.

- The client/server functionally has seen some bug fixes and should be
   improved in stability.

- Fix for a stat related hang on exit, and for a stat related issue
   with periodical dumps through --status-interval.

- Support added for DragonFly BSD.

- The OS provided random functions have been removed. Fio defaulted
   to its own default random generator for years now, since it was
   easier to provide consistent workloads across operating systems
   that way. This means that the 'use_os_rand' option has now been
   deprecated.

- Fix a potential crash on fio exit with data verification enabled,
   which has existed since version 2.1.11.

- Fio will exit a bit faster now, since the disk util thread and the
   helper thread were combined into one, and it'll be immediately torn
   down on exit. It had to wait around 250msecs before this change. You
   might have noticed this delay when doing ctrl-c on a workload.

- Lots of small bug fixes.

-- 
Jens Axboe


