Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116FC09283C22316161F3E381CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB11163E6C999998E0A2F13F9E81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB111689EE46B3839EB0675D7B81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116307F93264CDB7F09870981F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhHoS62hDsz9cvwjYBJFODDZ6EvTry9u4nErXAC67JwKg@mail.gmail.com>
 <CY1PR0401MB111673C9DC353353BACFCE5B81F50@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116FC09283C22316161F3E381CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 21 Feb 2018 16:52:20 +0000
Message-ID: <CALjAwxgi-muVZ4XVF53amSHOzLjMEDSY2Z2GRmKso_VZ1sVazA@mail.gmail.com>
Subject: Re: fiologparser_hist.py script patch and enhancements?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Vincent Fu <vincentfu@gmail.com>
Cc: Vincent Fu <vincent.fu@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Kris Davis <Kris.Davis@wdc.com>
List-ID: <fio@vger.kernel.org>

Hi Kris,

From what you're saying it seems to make sense to leave the
interpreter line at 2.7 for now. If you can repost your patch with
that and/or send a github pull request to Jens' Github repo the rest of
the changes sound fine to me.

Vincent: any comment on these changes?

On 21 February 2018 at 14:41, Kris Davis <Kris.Davis@wdc.com> wrote:
> After doing some more research, my best guess is that python3.4 being muc=
h slower than python2.7 is due to the difference in integer handling, so py=
py 3 didn't do any better then cpython 3.4. I don't really have anything to=
 verify that.
>
> So, given no further feedback, is there any reason not to commit the sugg=
ested changes?   Is there anything else I need to do?
>
> Thanks
> Kris Davis
>
> -----Original Message-----
> From: Kris Davis
> Sent: Wednesday, February 14, 2018 11:51 AM
> To: 'Sitsofe Wheeler' <sitsofe@gmail.com>
> Cc: fio@vger.kernel.org; Jens Axboe <axboe@kernel.dk>; Vincent Fu <vincen=
tfu@gmail.com>
> Subject: RE: fiologparser_hist.py script patch and enhancements?
>
> I wasn't familiar with pypy.  I tried it out, but needed to build locally=
 on my Centos 7.3 machine.  However, I found something interesting...
> I ran fiologparser_hist.py in multiple trials against 9 log files to be c=
ombined.
> *  with pypy  it consistently took about 51-52 seconds.
> *  with python3.4.3, it also consistently took about 51-52 seconds.
> *  with python2.7.5 it consistently took 10-11 seconds.
>
> I also built python 3.4.3 from the distribution locally some months earli=
er.  Sure is suspicious.
> But, this is off topic, so I'll investigate further without further updat=
es.  Thanks for the reference Sitsofe.
>
> Kris Davis
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Tuesday, February 13, 2018 1:27 AM
> To: Kris Davis <Kris.Davis@wdc.com>
> Cc: fio@vger.kernel.org; Jens Axboe <axboe@kernel.dk>; Vincent Fu <vincen=
tfu@gmail.com>
> Subject: Re: fiologparser_hist.py script patch and enhancements?
>
> (CC'ing Vincent)
>
> On 12 February 2018 at 21:38, Kris Davis <Kris.Davis@wdc.com> wrote:
>> In light of some related commits, I am reposting my enhancements to
>> fiologparser_hist.py, and a suggested addition of fiologparser_hist.nw.p=
y I've included a patch at bottom.
>
> It might be an idea to post this up on github too (it might make it easie=
r for others to pull down).
>
>> Reasons for the changes:
>>
>> 1) The fiologparser_hist script didn't support the new nanosecond bin va=
lues.  So I changed the operation to assume nanosecond histogram bins, and =
new "--usbin" option to allow user to override so same script can still pro=
cess older version histogram logs.
>>
>> 2) The script asppeared hardcoded to only return 50% (median), 90%, 95%,=
 and 99% values (along with min and max).
>> I added "--percentiles" option to allow a request for more values ('medi=
an' always printed, even if a duplicate 50% column is requested, for backwa=
rd compatibility).
>
> These sound good.
>
>> 3) A recent commit made some changes to support python3.
>> I added a check to make sure the python version is at least 2.7 or above=
, and changed the "shbang" to only call out "python" rather than "python2.7=
"
>
> Sadly the switch to python2.7 was done on purpose:
> https://github.com/axboe/fio/commit/60023ade47e7817db1c18d9b7e511839de5c2=
c99
> - Linux distros are clamping down on python and macOS doesn't have python=
2. The whole python interpreter line business is a mess and there's simply =
no common agreement - if you look you can find conflicting PEPs and I'm sta=
rting to think packagers will just have to include a function to rename lin=
es to their preferred style. My hope is one day all the scripts are convert=
ed to be both python2 and
> python3 compatible, all OSes finally get around to shipping python3 by de=
fault and then the interpreter line can be switched.
>
>> 4) The process can be slow for large or combining many log files.  I hav=
e some automation which will generically process many log files, and found =
I cut the process time in half if I loaded as a module rather than calling =
as a command.  So, changed so I can load as a module and call main directly=
, but needed to slightly alter the end of "guess_max_from_bins" to throw an=
 exception on error rather than exit, when called as a module.
>> Someone might know of a better, more conventional pythonic design patter=
n to use, but it works.
>
> I've no strong feeling on this.
>
>> 5) The script appears to assume that the log is never missing samples.  =
That is, weight samples to the requested intervals, I think with the assump=
tion that the log samples are at longer intervals, or at least the same int=
erval length as the "--interval" value.  If the workload actually contains =
"thinktime" intervals (with missing sample when zero data), the script cann=
ot know this, and assumes the logged operations should still be spread acro=
ss all the intervals.
>>
>> In my case, I'm mostly interested in results at the same interval as gat=
hered during logging, so I tweaked into an alternate version I named 'fiolo=
gparser_hist_nw.py', which doesn't perform any weighting of samples.  It ha=
s an added advantage of much quicker performance. For example, fiologparser=
_hist took about 1/2 hr to combine about 350 logs, but fiologparser_hist_nw=
 took 45 seconds, way better for my automation.
>
> Just out of interest does using pypy help you at all?
>
>> Of course, larger number of 9's percentiles would have additional inaccu=
racies when there are not enough operations in a sample period, but that is=
 just user beware.
>>
>> diff --git a/tools/hist/fiologparser_hist.py
>> b/tools/hist/fiologparser_hist.py index 62a4eb4..c77bb11 100755
>> --- a/tools/hist/fiologparser_hist.py
>> +++ b/tools/hist/fiologparser_hist.py
>
> <snip>

--=20
Sitsofe | http://sucs.org/~sits/

