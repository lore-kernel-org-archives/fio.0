Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116307F93264CDB7F09870981F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB11163E6C999998E0A2F13F9E81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB111689EE46B3839EB0675D7B81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116307F93264CDB7F09870981F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 13 Feb 2018 07:26:48 +0000
Message-ID: <CALjAwxhHoS62hDsz9cvwjYBJFODDZ6EvTry9u4nErXAC67JwKg@mail.gmail.com>
Subject: Re: fiologparser_hist.py script patch and enhancements?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
List-ID: <fio@vger.kernel.org>

(CC'ing Vincent)

On 12 February 2018 at 21:38, Kris Davis <Kris.Davis@wdc.com> wrote:
> In light of some related commits, I am reposting my enhancements to fiolo=
gparser_hist.py, and a suggested addition of fiologparser_hist.nw.py
> I've included a patch at bottom.

It might be an idea to post this up on github too (it might make it
easier for others to pull down).

> Reasons for the changes:
>
> 1) The fiologparser_hist script didn't support the new nanosecond bin val=
ues.  So I changed the operation to assume nanosecond histogram bins, and n=
ew "--usbin" option to allow user to override so same script can still proc=
ess older version histogram logs.
>
> 2) The script asppeared hardcoded to only return 50% (median), 90%, 95%, =
and 99% values (along with min and max).
> I added "--percentiles" option to allow a request for more values ('media=
n' always printed, even if a duplicate 50% column is requested, for backwar=
d compatibility).

These sound good.

> 3) A recent commit made some changes to support python3.
> I added a check to make sure the python version is at least 2.7 or above,=
 and changed the "shbang" to only call out "python" rather than "python2.7"

Sadly the switch to python2.7 was done on purpose:
https://github.com/axboe/fio/commit/60023ade47e7817db1c18d9b7e511839de5c2c9=
9
- Linux distros are clamping down on python and macOS doesn't have
python2. The whole python interpreter line business is a mess and
there's simply no common agreement - if you look you can find
conflicting PEPs and I'm starting to think packagers will just have to
include a function to rename lines to their preferred style. My hope
is one day all the scripts are converted to be both python2 and
python3 compatible, all OSes finally get around to shipping python3 by
default and then the interpreter line can be switched.

> 4) The process can be slow for large or combining many log files.  I have=
 some automation which will generically process many log files, and found I=
 cut the process time in half if I loaded as a module rather than calling a=
s a command.  So, changed so I can load as a module and call main directly,=
 but needed to slightly alter the end of "guess_max_from_bins" to throw an =
exception on error rather than exit, when called as a module.
> Someone might know of a better, more conventional pythonic design pattern=
 to use, but it works.

I've no strong feeling on this.

> 5) The script appears to assume that the log is never missing samples.  T=
hat is, weight samples to the requested intervals, I think with the assumpt=
ion that the log samples are at longer intervals, or at least the same inte=
rval length as the "--interval" value.  If the workload actually contains "=
thinktime" intervals (with missing sample when zero data), the script canno=
t know this, and assumes the logged operations should still be spread acros=
s all the intervals.
>
> In my case, I'm mostly interested in results at the same interval as gath=
ered during logging, so I tweaked into an alternate version I named 'fiolog=
parser_hist_nw.py', which doesn't perform any weighting of samples.  It has=
 an added advantage of much quicker performance. For example, fiologparser_=
hist took about 1/2 hr to combine about 350 logs, but fiologparser_hist_nw =
took 45 seconds, way better for my automation.

Just out of interest does using pypy help you at all?

> Of course, larger number of 9's percentiles would have additional inaccur=
acies when there are not enough operations in a sample period, but that is =
just user beware.
>
> Thanks
>
> Kris
>
>
>
> diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hi=
st.py
> index 62a4eb4..c77bb11 100755
> --- a/tools/hist/fiologparser_hist.py
> +++ b/tools/hist/fiologparser_hist.py

<snip>

--=20
Sitsofe | http://sucs.org/~sits/

