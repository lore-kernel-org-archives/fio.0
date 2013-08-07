Return-Path: <erwan@enovance.com>
Message-ID: <520291AB.2000702@enovance.com>
Date: Wed, 07 Aug 2013 20:27:55 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: 2.1.2 released
References: <52011D0F.5060308@kernel.dk> <52012346.9040609@enovance.com> <520171C0.2090400@conversis.de> <52020BFD.3080504@enovance.com> <52022BFB.2070100@conversis.de> <52023CF1.7050902@enovance.com> <5202797E.20602@conversis.de>
In-Reply-To: <5202797E.20602@conversis.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Dennis Jacobfeuerborn <dennisml@conversis.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 07/08/2013 18:44, Dennis Jacobfeuerborn wrote:
>    I attached the iops logs used and the Gnuplot is version 4.6.1 on 
> Fedora 18 (Package name "gnuplot-4.6.1-4.fc18.x86_64").

In fact, your logs are pretty surprising for me.
Can anyone, maybe jens, could explains why the time is getting backward 
in test4k_iops.log ?
It goes from 500 to 4500 and restart to 500 to 4500 and one more time.
My plotting considers that time is only getting forward never backward.

[...]
> I just tested this and for me it works as advertized. Thanks!

Glad it works !

[...]
> Doing it this way would allow fio2gnuplot to be invoked like 
> "fio2gnuplot -c/--config file.fiograph" so no complex command line 
> arguments would be necessary and the user could easily customize which 
> graphs are generated.
Interesting approach, I'll think about it.

