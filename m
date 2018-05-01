Return-Path: <axboe@kernel.dk>
Subject: Re: Windows: FIO randomly hangs using attached script
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxhxpLuLeysnp5kC-kQoWH++4hvehCWJxc9yA_Fcsy=pmw@mail.gmail.com>
 <BAE7B5AF-63F9-4E95-940D-7C84CE5AD92E@nutanix.com>
 <36259BEC-1CF0-45A5-85AE-F557989EDF30@nutanix.com>
 <2B8D69D8-05F3-4500-8A4E-F5DE21356676@nutanix.com>
 <CALjAwxiTX1=7pJKQ1Lz7nDkMXZqVJkMkNZDOA_XJYsEGP7wSfw@mail.gmail.com>
 <971ECD81-B100-4EEE-98CE-0E578A59BB02@nutanix.com>
 <7B5FFC71-BE67-435F-8DE6-8376E52754EB@nutanix.com>
 <CALjAwxgF-2dK+Bc9iwkVsxA4sfWKYSmHe8k3YbpUyDmBWP34ow@mail.gmail.com>
 <CALjAwxirkjduZof+F3prrKX0wp9YS8apS-YdK8+ru1supg1dnA@mail.gmail.com>
 <CALjAwxjPGXSOGwLOSMfVdrmxXsr8ObT6W6E1UBs2LkjttSnduw@mail.gmail.com>
 <e85db28f-da18-e6cc-7eda-1b04d2cc95eb@kernel.dk>
 <CALjAwxg1SzQV9ss9jjqry8_MLgDfPYq9QdbA5eVZi-PkmSEAKA@mail.gmail.com>
 <406902be-f4ce-c4f4-4e16-ee9caf8c0bcf@kernel.dk>
 <CALjAwxgr10F9X0n=7Scugz1yO48XPW5ANYGoD4JAss6Y3Egbcw@mail.gmail.com>
 <40961F5A-B8DE-4497-B697-8D0B2860C542@nutanix.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <196f210e-846a-c916-fcff-eaa7fdbdcc7d@kernel.dk>
Date: Tue, 1 May 2018 08:42:51 -0600
MIME-Version: 1.0
In-Reply-To: <40961F5A-B8DE-4497-B697-8D0B2860C542@nutanix.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Rob Scheepens <rob.scheepens@nutanix.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: David Knierim <knierim@nutanix.com>, Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Thanks for the update, a couple million iterations should suffice in
confidently saying it's fixed :-)


On 5/1/18 8:41 AM, Rob Scheepens wrote:
> Closing the loop on this: after running a couple of million times the script that used to reproduce this, I have not seen a single error with the patch.
> 
> Thanks All for the great work on this!
> 
> \Rob
> 
> 
> ﻿On 16/03/2018, 09:14, "Sitsofe Wheeler" <sitsofe@gmail.com> wrote:
> 
>     On 9 March 2018 at 14:55, Jens Axboe <axboe@kernel.dk> wrote:
>     >
>     > In some implementations it's actually mandated to have the wakeup
>     > within the lock, which seems to be the case here. It's a shame,
>     > since it's clearly suboptimal (from a scalability point of view)
>     > to have to hold the lock while issuing a wakeup for a process
>     > that's going to grab the same lock.
>     >
>     > I'll commit the patch. Thanks a lot for all your hard work on this
>     > one, let's hope that was it...
>     
>     FWIW this has been accepted as a bug in the mingw-w64 project's
>     winpthreads library. The standalone program on
>     https://urldefense.proofpoint.com/v2/url?u=https-3A__gist.github.com_sitsofe_abd99efec507b18234e7cc042d1baff1&d=DwIBaQ&c=s883GpUCOChKOHiocYtGcg&r=OMged-t_5I_fmfpUaT3vaA06lgLL_alYnDQJxHmXz64&m=C-SjzVSuoSBlexryZgGqFEfxhSdPbozUDu3U82Yjmqs&s=Xri6zcEiOde_B9rOwAyOAqm92oyNy-W5DHk01BPTQ_I&e=
>     reliably triggers the deadlock for me when using a mingw build on both
>     real Windows and under Wine but not when built for Linux with glibc.
>     See https://urldefense.proofpoint.com/v2/url?u=https-3A__sourceforge.net_p_mingw-2Dw64_bugs_710_&d=DwIBaQ&c=s883GpUCOChKOHiocYtGcg&r=OMged-t_5I_fmfpUaT3vaA06lgLL_alYnDQJxHmXz64&m=C-SjzVSuoSBlexryZgGqFEfxhSdPbozUDu3U82Yjmqs&s=Ms3hnbtg0t-Ycfm-kLxkR0pvsG1BpG6Ch-oyrsk6h4Y&e= for the "Deadlock in
>     winpthreads' pthread_cond_signal()" bug.
>     
>     Rob, David, Rebecca: do you know if the current git fio cures the
>     deadlock you were seeing?
>     
>     -- 
>     Sitsofe | https://urldefense.proofpoint.com/v2/url?u=http-3A__sucs.org_-7Esits_&d=DwIBaQ&c=s883GpUCOChKOHiocYtGcg&r=OMged-t_5I_fmfpUaT3vaA06lgLL_alYnDQJxHmXz64&m=C-SjzVSuoSBlexryZgGqFEfxhSdPbozUDu3U82Yjmqs&s=Chc6sQtGY11L4YRP_re07gL3JfHJosjt_F6tVk-WdsQ&e=
>     
> 


-- 
Jens Axboe


