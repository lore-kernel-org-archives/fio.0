Return-Path: <Vincent.Fu@sandisk.com>
From: Vincent Fu <Vincent.Fu@sandisk.com>
Subject: Re: steadystate job termination
Date: Fri, 16 Dec 2016 18:16:51 +0000
Message-ID: <8697CBF0E1940C48BC792ECE899B6642025A56@ULS-OP-MBXIP02.sdcorp.global.sandisk.com>
References: <BL2PR02MB19867DB3F155CE80CB07DEF08C980@BL2PR02MB1986.namprd02.prod.outlook.com>
 <92a78a95-06b0-de7c-f458-f93f53a51e52@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Return-Path: Vincent.Fu@sandisk.com
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2016-12-16 1:04 PM, Jens Axboe wrote:
> On 12/12/2016 09:25 AM, Vincent Fu wrote:
>> Jens, at https://bitbucket.org/vincentfu/fio-steadystate/commits/all is
>> a repo where I have committed patches to fio's steady-state branch that
>> address the following TODO items:
>>
>> steadystate data is now transmitted over the wire in client/server mode
>> steadystate summary data is included with --output-format=3Dnormal
>> example steadystate job file added
>> man page updated
>>
>> Please let me know what feedback you have.
>>
>> With respect to client/server mode, I successfully tested the job file
>> below on x86-64 hardware using the following server platforms with each
>> of the listed client operating systems:
>> servers: Ubuntu 64-bit, Ubuntu 32-bit, OSX 10.11
>> clients: Ubuntu 64-bit, Ubuntu 32-bit, OSX 10.11, Windows 8.1 x64
>>
>> Vincent
>>
>> [iops_slope]
>> filename=3D/dev/zero
>> time_based=3D1
>> runtime=3D300s
>> size=3D8M
>> ss=3Diops_slope:0.5%
>> ss_dur=3D5
>> ss_ramp=3D2
>> numjobs=3D4
>> group_reporting
>>
>> [bw_dev]
>> stonewall
>> filename=3D/dev/zero
>> time_based=3D1
>> runtime=3D300s
>> size=3D8M
>> ss=3Dbw:4%
>> ss_dur=3D5
>> ss_ramp=3D2
>> numjobs=3D2
> Looks good enough to go in at this point, thanks Vincent! This is a cool
> and useful feature.
>
> I had some suggested cleanups in here:
>
> http://git.kernel.dk/cgit/fio/commit/?h=3Dsteady-state
>
> did you see those? Any that still apply?
>
Jens, thanks. I used all of those clean-ups and based my new patches on
the tip of that branch.

Vincent

$ git log --oneline
32df42c steadystate: make test script work better under Windows
39f5379 steadystate: make file for read testing optional on posix systems
dd4e870 steadystate: improve output of test script
2c5d94b steadystate: rename options->ss to options->ss_state since ss is
used elsewhere to refer to struct steadystate_data
0c13c96 steadystate: clean up checks for when steadystate termination is
not engaged
9d19301 steadystate: use uint64_t for storing bw and iops calculations
and related values. Also fix an overflow with group_bw on 32-bit platforms.
11e955e steadystate: fix alignment in stat.h
cb84f1f steadystate: ensure that pointers in thread_stat occupy the same
amount of storage in 32- and 64-bit platforms
b56cc3d steadystate: rename TODO to STEADYSTATE-TODO
17df702 steadystate: instead of including ss_sum_y in thread_stat record
whether ss_sum_y is nonzero in ss_state via __FIO_SS_BUFFER_FULL
bb49c8b steadystate: implement transmission of steadystate data over the
wire in client/server mode
d685adf steadystate: add line for output-format=3Dnormal
e6a6a98 steadystate: get rid of ->ss_pct and encode this information in
->state via __FIO_SS_PCT
ec55e63 steadystate: rename __FIO_SS_LAST to __FIO_SS_DATA
39c7a2c steadystate: update man page
c93fae1 steadystate: add example job file
56a90eb steadystate: reject job if steadystate options are not
consistent within reporting group
94f218f steadystate: bug fixes

**** new patches above

5b4b658 steadystate: kill ->last_in_group and ->ramp_time_over
ad743db steadystate: kill off ->attained
f0c50c6 steadystate: eliminate some steadystate_data members
84784e0 steadystate: rename 'steadystate' to 'steadystate_enabled'
7be78a8 steadystate: more cleanups
4cd5b75 steadystate: cleanups
0a70e05 steadystate: move into its own header
29f480e TODO: man page missing
7286328 steady-state: convert options across the wire
1fe7cda Add local TODO for steady-state work

**** Jens' clean-ups above, original steadystate patches below

bfc4884 Clear up white space errors
4001d82 Update test script for new JSON steadystate['criterion'] reporting
e569ca6 Split helper thread debug logging away from steadystate debug
logging
412c7d9 Fix bug where measurements were not printed in the correct order
when steady state was not attained
6da94b0 JSON output, code formatting changes
ba8fb6f Steady state detection: enhance reporting of results, change
memory allocation point
e4e3e34 Change steadystate reporting:
0587ef3 Add locking around reads of td->io_blocks and io_byes.
3ce3881 Fix typo, restore unintended HOWTO deletion
16e56d2 Allow fio to terminate jobs when steady state is attained

--
Vincent Fu
Software Dev Engr II
SanDisk, a Western Digital brand
Email: Vincent.Fu@SanDisk.com
Office: 801 987 7079


________________________________

PLEASE NOTE: The information contained in this electronic mail message is i=
ntended only for the use of the designated recipient(s) named above. If the=
 reader of this message is not the intended recipient, you are hereby notif=
ied that you have received this message in error and that any review, disse=
mination, distribution, or copying of this message is strictly prohibited. =
If you have received this communication in error, please notify the sender =
by telephone or e-mail (as shown above) immediately and destroy any and all=
 copies of this message in your possession (whether hard copies or electron=
ically stored copies).


