Return-Path: <dennisml@conversis.de>
Message-ID: <5202797E.20602@conversis.de>
Date: Wed, 07 Aug 2013 18:44:46 +0200
From: Dennis Jacobfeuerborn <dennisml@conversis.de>
MIME-Version: 1.0
Subject: Re: 2.1.2 released
References: <52011D0F.5060308@kernel.dk> <52012346.9040609@enovance.com> <520171C0.2090400@conversis.de> <52020BFD.3080504@enovance.com> <52022BFB.2070100@conversis.de> <52023CF1.7050902@enovance.com>
In-Reply-To: <52023CF1.7050902@enovance.com>
Content-Type: multipart/mixed;
 boundary="------------000807010301030107010103"
To: Erwan Velu <erwan@enovance.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000807010301030107010103
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.08.2013 14:26, Erwan Velu wrote:
> On 07/08/2013 13:14, Dennis Jacobfeuerborn wrote:
>
> [...]
>> I tested the version from the erwan/next branch and the --iops option
>> works now and if I don't provide it I get a proper error. Although
>> when I provide a nonsense option like "--fnsofno" I get the error
>> "Error: One of the option passed to the cmdline was supported". That
>> is probably supposed to say "was not supported".
> This is now fixed in my branch.... silly typo.
>>
>> The graphing seems to have issues too. I attached a job file and the
>> graphs generated using "./fio2gnuplot.py -d t -g -i". As you can see
>> in the compare-2Draw graph I get multiple lines for the test4k and
>> test8k jobs but not for the test16k job and in the compare-2Dtrend
>> graph I get strange loops for the same two out of three jobs. The 3D
>> graph looks strange too and shows "disks" which doesn't really apply
>> in this particular case.
> Waow... I ran this test on my local setup with fio 2.1.2 and this
> doesn't occurs.... I do have the 3 lines perfectly printed.
> That's maybe a gnuplot effect.
> Can you provide the version of gnuplot you use and the log files ?
> I'm running 4.6 patchlevel 1

I attached the iops logs used and the Gnuplot is version 4.6.1 on Fedora 
18 (Package name "gnuplot-4.6.1-4.fc18.x86_64").

>> Lastly the tool does output a lot of things by default which are
>> probably not useful to 99.9% of the people out there.
> This is now fixed in my branch.
>
>> I think the default should be to only output the 2Draw and the 3D
>> graph and delete the data files (mygraph, mymath, etc.) and allow the
>> user to keep these files and create the additional graphs using
>> command line options.
> Fixed in my branch. Default is to kill temp files if gnuplot success
> unless keep them. If user ask to keep them using -k option, let's always
> keep them.
> That shall solve your issue.

I just tested this and for me it works as advertized. Thanks!

>> In fact in the case of multiple input files it would probably be best
>> to only end up with the compate-2Draw graph as the graphs for the
>> individual jobs are pretty much redundant in that case.
> That really depends on people's usage. Some could be interested at
> publishing the compare-* graphs but need to understand some traces if
> weird effects occurs. I did develop all thoses graphs with a "pick the
> one you need" approach.
>
> Yes I do plot too much but this avoids having too much options to pass
> to the tool. People have just to pick the one they need.

I have thought about this a bit and wonder if it would be useful to to 
use a job file similar to the fio job files to describe which graphs to 
render and which parameters to use. Example:

[global]
output_dir=test
min_time=0
max_time=-1

[graph1]
type=individual
interpolation=raw
title="raw iops"
pattern="*_iops.log"

[graph2]
type=grouped2d
interpolation=smooth
title="smooth iops summary"
pattern="*_iops.log"

Doing it this way would allow fio2gnuplot to be invoked like 
"fio2gnuplot -c/--config file.fiograph" so no complex command line 
arguments would be necessary and the user could easily customize which 
graphs are generated.

Regards,
   Dennis

--------------000807010301030107010103
Content-Type: text/x-log;
 name="test4k_iops.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test4k_iops.log"

500, 8716, 0, 0
1000, 8760, 0, 0
1500, 8730, 0, 0
2000, 8692, 0, 0
2500, 8868, 0, 0
3000, 8686, 0, 0
3500, 9002, 0, 0
4000, 8838, 0, 0
4500, 8966, 0, 0
500, 8998, 0, 0
1000, 9002, 0, 0
1500, 9076, 0, 0
2000, 9050, 0, 0
2500, 8966, 0, 0
3000, 9008, 0, 0
3500, 9078, 0, 0
4000, 9018, 0, 0
4500, 9022, 0, 0
500, 8628, 0, 0
1000, 8842, 0, 0
1500, 8880, 0, 0
2000, 8828, 0, 0
2500, 8748, 0, 0
3000, 8780, 0, 0
3500, 8948, 0, 0
4000, 8764, 0, 0
4500, 8856, 0, 0

--------------000807010301030107010103
Content-Type: text/x-log;
 name="test8k_iops.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test8k_iops.log"

500, 7198, 0, 0
1000, 7222, 0, 0
1500, 7300, 0, 0
2000, 7154, 0, 0
2500, 7096, 0, 0
3000, 7268, 0, 0
3500, 7372, 0, 0
4000, 7228, 0, 0
4500, 7268, 0, 0
500, 7678, 0, 0
1000, 7812, 0, 0
1500, 7774, 0, 0
2000, 7728, 0, 0
2500, 7572, 0, 0
3000, 7598, 0, 0
3500, 7254, 0, 0
4000, 7144, 0, 0
4500, 7298, 0, 0
500, 7142, 0, 0
1000, 6960, 0, 0
1500, 7430, 0, 0
2000, 7258, 0, 0
2500, 7376, 0, 0
3000, 7468, 0, 0
3500, 7362, 0, 0
4000, 7100, 0, 0
4500, 7192, 0, 0

--------------000807010301030107010103
Content-Type: text/x-log;
 name="test16k_iops.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test16k_iops.log"

500, 5536, 0, 0
1000, 5524, 0, 0
1500, 5416, 0, 0
2000, 5212, 0, 0
2500, 5384, 0, 0
3000, 5288, 0, 0
3500, 5116, 0, 0
4001, 5418, 0, 0
4501, 5380, 0, 0

--------------000807010301030107010103--


