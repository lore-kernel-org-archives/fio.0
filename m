Return-Path: <erwan@enovance.com>
Message-ID: <52023CF1.7050902@enovance.com>
Date: Wed, 07 Aug 2013 14:26:25 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: 2.1.2 released
References: <52011D0F.5060308@kernel.dk> <52012346.9040609@enovance.com> <520171C0.2090400@conversis.de> <52020BFD.3080504@enovance.com> <52022BFB.2070100@conversis.de>
In-Reply-To: <52022BFB.2070100@conversis.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Dennis Jacobfeuerborn <dennisml@conversis.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 07/08/2013 13:14, Dennis Jacobfeuerborn wrote:

[...]
> I tested the version from the erwan/next branch and the --iops option 
> works now and if I don't provide it I get a proper error. Although 
> when I provide a nonsense option like "--fnsofno" I get the error 
> "Error: One of the option passed to the cmdline was supported". That 
> is probably supposed to say "was not supported".
This is now fixed in my branch.... silly typo.
>
> The graphing seems to have issues too. I attached a job file and the 
> graphs generated using "./fio2gnuplot.py -d t -g -i". As you can see 
> in the compare-2Draw graph I get multiple lines for the test4k and 
> test8k jobs but not for the test16k job and in the compare-2Dtrend 
> graph I get strange loops for the same two out of three jobs. The 3D 
> graph looks strange too and shows "disks" which doesn't really apply 
> in this particular case.
Waow... I ran this test on my local setup with fio 2.1.2 and this 
doesn't occurs.... I do have the 3 lines perfectly printed.
That's maybe a gnuplot effect.
Can you provide the version of gnuplot you use and the log files ?
I'm running 4.6 patchlevel 1

> Lastly the tool does output a lot of things by default which are 
> probably not useful to 99.9% of the people out there. 
This is now fixed in my branch.

> I think the default should be to only output the 2Draw and the 3D 
> graph and delete the data files (mygraph, mymath, etc.) and allow the 
> user to keep these files and create the additional graphs using 
> command line options.
Fixed in my branch. Default is to kill temp files if gnuplot success 
unless keep them. If user ask to keep them using -k option, let's always 
keep them.
That shall solve your issue.

> In fact in the case of multiple input files it would probably be best 
> to only end up with the compate-2Draw graph as the graphs for the 
> individual jobs are pretty much redundant in that case.
That really depends on people's usage. Some could be interested at 
publishing the compare-* graphs but need to understand some traces if 
weird effects occurs. I did develop all thoses graphs with a "pick the 
one you need" approach.

Yes I do plot too much but this avoids having too much options to pass 
to the tool. People have just to pick the one they need.

