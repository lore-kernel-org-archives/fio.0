Return-Path: <phoulihan9@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAB8+yyU-uZoyQgx_P0U=xhi9dA5y6D+bOW2BaQzDfEFH4j9+LA@mail.gmail.com>
References: <CAB8+yyVB8vaG6Vco21qcJie0+OkDNwOkqOxS-MyvQLYrqRzuWg@mail.gmail.com>
 <8e8a7151-9329-cdee-2100-3f94c5dd1b1f@kernel.dk> <CALjAwxgN=+PPByGL_ZQhq9RjTgzYE8h83NEapYtDDSSUAqDuuw@mail.gmail.com>
 <CAB8+yyU-uZoyQgx_P0U=xhi9dA5y6D+bOW2BaQzDfEFH4j9+LA@mail.gmail.com>
From: paul houlihan <phoulihan9@gmail.com>
Date: Mon, 8 May 2017 21:51:13 -0400
Message-ID: <CAB8+yyV+-vHSY7-iN0w6GY5Ukj-wt_oS064W+O7n6rO+rFmT8A@mail.gmail.com>
Subject: Re: Fio Checksum tracking and enhanced trim workloads
Content-Type: multipart/alternative; boundary=f403045d5af0403360054f0d9746
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--f403045d5af0403360054f0d9746
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Let me know if the changes are not accessible. I am new to github and not
sure I am doing it right. They are reviewable for me using the
aforementioned link..

I can look at Sitsofe overlapping changes but I don't have a lot of time
for major rework. What is here works fairly robustly, is quite useful and
that is what I am offering. Although I realize that there is huge number of
fio arguments and there might still be contradictions I don't use. I can
rework it a bit if there are small issues to tackle.

I have not spent a lot of time using bsrange. I am usually interested in
stressing specific block sizes. I think it will all just work as long as no
overlapping I/O results.

> Are you sure? I thought readwrite verifying workloads caused the reads
> to be verifying if the block had been written in the same workload?

Yes for read/write workload, all writes do result in a read verification.
However that still leaves unverified those blocks that were only read and
never written in this workload. That's not acceptable if your requirement
is absolute data integrity guarantees. My goal was that all reads (and for
that matter trims) in all workloads be verified including those blocks
written by a prior fio job or even a prior fio run on a different virtual
machine. The current fio verifies all read blocks only for read-only
workloads where it assumes a prior job has initialized the blocks.

> Many would find this useful. Perhaps it could be ported to C like
> t/verify-state.c ?
Yes I wish I had done it in C and there would be no extra dependency on
python for troubleshooting. Also the C could use the definition in verify.h
in case the header ever changes. However python is ubiquitous so it seems a
minor dependency. I could consider this if the list of requested changes is
doable.

> How does this interact with verify_state_*
Again something I have not stress. Bear in mind that if fio aborts on an
error the verify log is not created as this can lead to false corruption
detection. Note control-c is a normal exit and the tracking log is
preserved in this case. However it should just work if the tracking log is
preserved. I thought about tracking checksums within verify state but it
was not easily extended to track all checksums for all blocks.

paul

On Mon, May 8, 2017 at 9:01 PM, paul houlihan <phoulihan9@gmail.com> wrote:

> The second sentence was incorrect.
>
> It should read: I would like the changes at https://github.com/
> phoulihan9/fio/pull/1/commits  to be reviewed and considered for
> inclusion to fio.
>
> On Mon, May 8, 2017 at 4:05 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote=
:
>
>> > -------- Forwarded Message --------
>> > Subject:        Fio Checksum tracking and enhanced trim workloads
>> > Date:   Sun, 7 May 2017 23:54:16 -0400
>> > From:   paul houlihan <phoulihan9@gmail.com>
>> > To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
>> >
>> > I have a submission for fio that enhances the data corruption detectio=
n
>> and diagnosis capabilities taking fio from pretty good corruption detect=
ion
>> to absolute guarantees. I would like these changes on the tracking
>> branch???? to be reviewed and considered for inclusion to fio. A quick
>> review would be helpful as I am losing access to test systems shortly.
>> >
>> >
>> > These changes were used by a Virtual Machine caching company to assure
>> data integrity. Most testing was on Linux 64 bits and windows 32/64 bits=
.
>> The windows build still had an issue with compile time asserts in libfio=
.c
>> that I worked around by commenting out the asserts as this looked like a
>> performance restriction. This should be researched more. The initial
>> development was on version fio 2.2.10 sources and I just ported the chan=
ges
>> to fio latest sources and tested on linux but haven=E2=80=99t yet test o=
n windows.
>> No testing on all other fio supported OSes was done, although the change=
s
>> are almost exclusively to OS independent code.
>> >
>> >
>> > The absolute guarantees are brought about by tracking checksums to
>> prevent a stale but intact prior version of a block being returned and b=
y
>> verifying all reads. I was surprised to learn about the number of times =
fio
>> performed concurrent I/O to the same blocks which yields indeterminate
>> results that prevent data integrity verification. Thus a number of optio=
ns
>> are not supported when tracking is enabled.
>>
>> Sounds interesting! Are the patches available on Github or otherwise
>> published?
>>
>> I have a couple of patches related to overlapping I/Os (see
>> https://github.com/axboe/fio/pull/343 and
>> https://github.com/sitsofe/fio/commit/6b4cfeb95fca2d75a291c5
>> 4ca20162470c837a38
>> ) because I can't afford for such I/O to be sent to the storage.
>> Perhaps it would be possible to amend your work to detect the overlaps
>> in a more efficient manner?
>>
>> How does this work play with varying blocksizes (bsrange etc)?
>>
>> > These limitations can be addressed by setting the verify_track option
>> which
>> >
>> > allocates a memory array to track the header and data checksums to
>> assure
>> >
>> > data integrity is absolute. The array starts out empty at the beginnin=
g
>> of
>> >
>> > each fio job and is filled in as reads or writes occur, once defined t=
he
>> >
>> > checksums from succeeding I/Os must all match. This option extends
>> checksum
>> >
>> > verification to all reads in all workloads, not just the read-only
>> workloads.
>>
>> Are you sure? I thought readwrite verifying workloads caused the reads
>> to be verifying if the block had been written in the same workload?
>>
>> > fio_header.py - a python script that displays the contents of the bloc=
k
>> header
>> >
>> >               in a corrupt data file.
>>
>> Many would find this useful. Perhaps it could be ported to C like
>> t/verify-state.c ?
>>
>> > Here are the related parameter descriptions from HOWTO:
>> >
>> >
>> > option verify_track=3Dbool
>> >
>> >
>> > Fio normally verifies data within a verify_intervalwith checksums and
>> file
>> >
>> > offsets embedded in the data. However a prior version of a block could
>> be
>> >
>> > returned and verified successfully. When verify_track is enabled the
>> checksum
>> >
>> > for every verify_interval in the file is stored in a table and all rea=
d
>> data
>> >
>> > must match the checksums in the table. The tracking table is sized as
>> >
>> > (size / verify_interval) * 4 bytes. For very large size=3D option
>> settings,
>> >
>> > such a large memory allocation may impact testing. Reads assume that
>> the entire
>> >
>> > file has been previously written with a verification format using the
>> same
>> >
>> > verify_interval. When verify_track is enabled, all reads are verified,
>> whether
>> >
>> > writes are present in the workload or not. Sharing files by threads
>> within a job
>> >
>> > is supported but not between jobs running concurrently so use the
>> stonewall
>> >
>> > option when more than one non-global job is present. Verify of trimmed
>> blocks
>> >
>> > is described for the verify_track_trim_zero option. When disabled, fio
>> falls
>> >
>> > back on verification described under the verify option. The
>> restrictions when
>> >
>> > enabling the verify_track option are:
>> >
>> > - randommap is required
>> >
>> > - softrandommap is not supported
>> >
>> > - lfsr random generator not supported when using multiple block sizes
>> >
>> > - stonewall option required when more than one job present
>> >
>> > - file size must be an even multiple of the block size when iodepth > =
1
>> >
>> > - verify_backlog not supported when iodepth > 1
>> >
>> > - verify_async is not supported
>> >
>> > - file sharing between concurrent jobs not supported
>> >
>> > - numjobs must be 1
>> >
>> > - io_submit_mode must be set to "inline"
>>
>> Yeah I've noticed a number of issues trying to verify with
>> io_submit_mode=3Doffload ...
>>
>> > option verify_track_log=3Dbool
>> >
>> >
>> > If set when verify_track is set then on a clean shutdown, fio writes
>> the checksum
>> >
>> > for each data block that has been read or written to a log named
>> >
>> > (datafilename).tracking.log. If set when fio reopens this data file an=
d
>> a tracking
>> >
>> > log exists then the checksums are read into the tracking table and use=
d
>> to validate
>> >
>> > every subsequent read. This allows rigorous validation of data
>> integrity as data
>> >
>> > files are passed between fio jobs or over the termination of fio and
>> restart on
>> >
>> > the same system or on another system or after an OS reboot. Reverting =
a
>> virtual
>> >
>> > machine to a snapshot can be tested by saving the tracking log after a
>> successful
>> >
>> > fio run and later restoring the saved log after reverting the virtual
>> machine.
>> >
>> > The log is deleted after being read in, so on abnormal termination no
>> stale
>> >
>> > checksums can be used. This option, the data file size and
>> verify_interval
>> >
>> > parameters should not change between jobs in the same run or on restar=
t
>> of fio.
>> >
>> > Defaults to off. verify_track_dir defines the tracking log's directory=
.
>>
>> How does this interact with verify_state_*
>> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-
>> arg-verify-state-load
>> ) ?
>>
>> --
>> Sitsofe | http://sucs.org/~sits/
>>
>
>

--f403045d5af0403360054f0d9746
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Let me know if the changes are not accessible. I am new to=
 github and not sure I am doing it right. They are reviewable for me using =
the aforementioned link..<div><br></div><div>I can look at Sitsofe overlapp=
ing changes but I don&#39;t have a lot of time for major rework. What is he=
re works fairly robustly, is quite useful and that is what I am offering. A=
lthough I realize that there is huge number of fio arguments and there migh=
t still be contradictions I don&#39;t use. I can rework it a bit if there a=
re small issues to tackle.=C2=A0</div><div><br></div><div>I have not spent =
a lot of time using bsrange. I am usually interested in stressing specific =
block sizes. I think it will all just work as long as no overlapping I/O re=
sults.</div><div><br></div><div><span style=3D"font-size:12.8px">&gt; Are y=
ou sure? I thought readwrite verifying workloads caused the reads</span><br=
 style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">&gt; to be ver=
ifying if the block had been written in the same workload?</span><br></div>=
<div><br></div><div>Yes for read/write workload, all writes do result in a =
read verification. However that still leaves unverified those blocks that w=
ere only read and never written in this workload. That&#39;s not acceptable=
 if your requirement is absolute data integrity guarantees. My goal was tha=
t all reads (and for that matter trims) in all workloads be verified includ=
ing those blocks written by a prior fio job or even a prior fio run on a di=
fferent virtual machine. The current fio verifies all read blocks only for =
read-only workloads where it assumes a prior job has initialized the blocks=
. =C2=A0</div><div><br></div><div><span style=3D"font-size:12.8px">&gt; Man=
y would find this useful. Perhaps it could be ported to C like</span><br st=
yle=3D"font-size:12.8px"><span style=3D"font-size:12.8px">&gt; t/verify-sta=
te.c ?</span><br></div><div>Yes I wish I had done it in C and there would b=
e no extra dependency on python for troubleshooting. Also the C could use t=
he definition in verify.h in case the header ever changes. However python i=
s ubiquitous so it seems a minor dependency. I could consider this if the l=
ist of requested changes is doable.</div><div><br></div><div>&gt;=C2=A0<spa=
n style=3D"font-size:12.8px">How does this interact with verify_state_*</sp=
an></div><div><span style=3D"font-size:12.8px">Again something I have not s=
tress. Bear in mind that if fio aborts on an error the verify log is not cr=
eated as this can lead to false corruption detection. Note control-c is a n=
ormal exit and the tracking log is preserved in this case. However it shoul=
d just work if the tracking log is preserved. I thought about tracking chec=
ksums within verify state but it was not easily extended to track all check=
sums for all blocks.</span></div><div><br></div><div><span style=3D"font-si=
ze:12.8px">paul=C2=A0</span></div></div><div class=3D"gmail_extra"><br><div=
 class=3D"gmail_quote">On Mon, May 8, 2017 at 9:01 PM, paul houlihan <span =
dir=3D"ltr">&lt;<a href=3D"mailto:phoulihan9@gmail.com" target=3D"_blank">p=
houlihan9@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
><div dir=3D"ltr">The second sentence was incorrect.=C2=A0<div><br></div><d=
iv>It should read:=C2=A0<span style=3D"color:rgb(80,0,80);font-size:12.8px"=
>I would like the changes at=C2=A0</span><font color=3D"#500050"><span styl=
e=3D"font-size:12.8px"><a href=3D"https://github.com/phoulihan9/fio/pull/1/=
commits" target=3D"_blank">https://github.com/<wbr>phoulihan9/fio/pull/1/co=
mmits</a>=C2=A0</span></font><span style=3D"color:rgb(80,0,80);font-size:12=
.8px"><wbr>=C2=A0to be reviewed and considered for inclusion to fio.</span>=
=C2=A0</div></div><div class=3D"HOEnZb"><div class=3D"h5"><div class=3D"gma=
il_extra"><br><div class=3D"gmail_quote">On Mon, May 8, 2017 at 4:05 PM, Si=
tsofe Wheeler <span dir=3D"ltr">&lt;<a href=3D"mailto:sitsofe@gmail.com" ta=
rget=3D"_blank">sitsofe@gmail.com</a>&gt;</span> wrote:<br><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pad=
ding-left:1ex"><span>&gt; -------- Forwarded Message --------<br>
&gt; Subject:=C2=A0 =C2=A0 =C2=A0 =C2=A0 Fio Checksum tracking and enhanced=
 trim workloads<br>
&gt; Date:=C2=A0 =C2=A0Sun, 7 May 2017 23:54:16 -0400<br>
&gt; From:=C2=A0 =C2=A0paul houlihan &lt;<a href=3D"mailto:phoulihan9@gmail=
.com" target=3D"_blank">phoulihan9@gmail.com</a>&gt;<br>
&gt; To:=C2=A0 =C2=A0 =C2=A0<a href=3D"mailto:fio@vger.kernel.org" target=
=3D"_blank">fio@vger.kernel.org</a>, Jens Axboe &lt;<a href=3D"mailto:axboe=
@kernel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;<br>
&gt;<br>
&gt; I have a submission for fio that enhances the data corruption detectio=
n and diagnosis capabilities taking fio from pretty good corruption detecti=
on to absolute guarantees. I would like these changes on the tracking branc=
h???? to be reviewed and considered for inclusion to fio. A quick review wo=
uld be helpful as I am losing access to test systems shortly.<br>
&gt;<br>
&gt;<br>
&gt; These changes were used by a Virtual Machine caching company to assure=
 data integrity. Most testing was on Linux 64 bits and windows 32/64 bits. =
The windows build still had an issue with compile time asserts in libfio.c =
that I worked around by commenting out the asserts as this looked like a pe=
rformance restriction. This should be researched more. The initial developm=
ent was on version fio 2.2.10 sources and I just ported the changes to fio =
latest sources and tested on linux but haven=E2=80=99t yet test on windows.=
 No testing on all other fio supported OSes was done, although the changes =
are almost exclusively to OS independent code.<br>
&gt;<br>
&gt;<br>
&gt; The absolute guarantees are brought about by tracking checksums to pre=
vent a stale but intact prior version of a block being returned and by veri=
fying all reads. I was surprised to learn about the number of times fio per=
formed concurrent I/O to the same blocks which yields indeterminate results=
 that prevent data integrity verification. Thus a number of options are not=
 supported when tracking is enabled.<br>
<br>
</span>Sounds interesting! Are the patches available on Github or otherwise=
 published?<br>
<br>
I have a couple of patches related to overlapping I/Os (see<br>
<a href=3D"https://github.com/axboe/fio/pull/343" rel=3D"noreferrer" target=
=3D"_blank">https://github.com/axboe/fio/p<wbr>ull/343</a> and<br>
<a href=3D"https://github.com/sitsofe/fio/commit/6b4cfeb95fca2d75a291c54ca2=
0162470c837a38" rel=3D"noreferrer" target=3D"_blank">https://github.com/sit=
sofe/fio<wbr>/commit/6b4cfeb95fca2d75a291c5<wbr>4ca20162470c837a38</a><br>
) because I can&#39;t afford for such I/O to be sent to the storage.<br>
Perhaps it would be possible to amend your work to detect the overlaps<br>
in a more efficient manner?<br>
<br>
How does this work play with varying blocksizes (bsrange etc)?<br>
<span><br>
&gt; These limitations can be addressed by setting the verify_track option =
which<br>
&gt;<br>
&gt; allocates a memory array to track the header and data checksums to ass=
ure<br>
&gt;<br>
&gt; data integrity is absolute. The array starts out empty at the beginnin=
g of<br>
&gt;<br>
&gt; each fio job and is filled in as reads or writes occur, once defined t=
he<br>
&gt;<br>
&gt; checksums from succeeding I/Os must all match. This option extends che=
cksum<br>
&gt;<br>
&gt; verification to all reads in all workloads, not just the read-only wor=
kloads.<br>
<br>
</span>Are you sure? I thought readwrite verifying workloads caused the rea=
ds<br>
to be verifying if the block had been written in the same workload?<br>
<span><br>
&gt; fio_header.py - a python script that displays the contents of the bloc=
k header<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in a corrupt dat=
a file.<br>
<br>
</span>Many would find this useful. Perhaps it could be ported to C like<br=
>
t/verify-state.c ?<br>
<div><div class=3D"m_-306099096856596816h5"><br>
&gt; Here are the related parameter descriptions from HOWTO:<br>
&gt;<br>
&gt;<br>
&gt; option verify_track=3Dbool<br>
&gt;<br>
&gt;<br>
&gt; Fio normally verifies data within a verify_intervalwith checksums and =
file<br>
&gt;<br>
&gt; offsets embedded in the data. However a prior version of a block could=
 be<br>
&gt;<br>
&gt; returned and verified successfully. When verify_track is enabled the c=
hecksum<br>
&gt;<br>
&gt; for every verify_interval in the file is stored in a table and all rea=
d data<br>
&gt;<br>
&gt; must match the checksums in the table. The tracking table is sized as<=
br>
&gt;<br>
&gt; (size / verify_interval) * 4 bytes. For very large size=3D option sett=
ings,<br>
&gt;<br>
&gt; such a large memory allocation may impact testing. Reads assume that t=
he entire<br>
&gt;<br>
&gt; file has been previously written with a verification format using the =
same<br>
&gt;<br>
&gt; verify_interval. When verify_track is enabled, all reads are verified,=
 whether<br>
&gt;<br>
&gt; writes are present in the workload or not. Sharing files by threads wi=
thin a job<br>
&gt;<br>
&gt; is supported but not between jobs running concurrently so use the ston=
ewall<br>
&gt;<br>
&gt; option when more than one non-global job is present. Verify of trimmed=
 blocks<br>
&gt;<br>
&gt; is described for the verify_track_trim_zero option. When disabled, fio=
 falls<br>
&gt;<br>
&gt; back on verification described under the verify option. The restrictio=
ns when<br>
&gt;<br>
&gt; enabling the verify_track option are:<br>
&gt;<br>
&gt; - randommap is required<br>
&gt;<br>
&gt; - softrandommap is not supported<br>
&gt;<br>
&gt; - lfsr random generator not supported when using multiple block sizes<=
br>
&gt;<br>
&gt; - stonewall option required when more than one job present<br>
&gt;<br>
&gt; - file size must be an even multiple of the block size when iodepth &g=
t; 1<br>
&gt;<br>
&gt; - verify_backlog not supported when iodepth &gt; 1<br>
&gt;<br>
&gt; - verify_async is not supported<br>
&gt;<br>
&gt; - file sharing between concurrent jobs not supported<br>
&gt;<br>
&gt; - numjobs must be 1<br>
&gt;<br>
&gt; - io_submit_mode must be set to &quot;inline&quot;<br>
<br>
</div></div>Yeah I&#39;ve noticed a number of issues trying to verify with<=
br>
io_submit_mode=3Doffload ...<br>
<span><br>
&gt; option verify_track_log=3Dbool<br>
&gt;<br>
&gt;<br>
&gt; If set when verify_track is set then on a clean shutdown, fio writes t=
he checksum<br>
&gt;<br>
&gt; for each data block that has been read or written to a log named<br>
&gt;<br>
&gt; (datafilename).tracking.log. If set when fio reopens this data file an=
d a tracking<br>
&gt;<br>
&gt; log exists then the checksums are read into the tracking table and use=
d to validate<br>
&gt;<br>
&gt; every subsequent read. This allows rigorous validation of data integri=
ty as data<br>
&gt;<br>
&gt; files are passed between fio jobs or over the termination of fio and r=
estart on<br>
&gt;<br>
&gt; the same system or on another system or after an OS reboot. Reverting =
a virtual<br>
&gt;<br>
&gt; machine to a snapshot can be tested by saving the tracking log after a=
 successful<br>
&gt;<br>
&gt; fio run and later restoring the saved log after reverting the virtual =
machine.<br>
&gt;<br>
&gt; The log is deleted after being read in, so on abnormal termination no =
stale<br>
&gt;<br>
&gt; checksums can be used. This option, the data file size and verify_inte=
rval<br>
&gt;<br>
&gt; parameters should not change between jobs in the same run or on restar=
t of fio.<br>
&gt;<br>
&gt; Defaults to off. verify_track_dir defines the tracking log&#39;s direc=
tory.<br>
<br>
</span>How does this interact with verify_state_*<br>
(<a href=3D"http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-=
verify-state-load" rel=3D"noreferrer" target=3D"_blank">http://fio.readthed=
ocs.io/en/<wbr>latest/fio_doc.html#cmdoption-<wbr>arg-verify-state-load</a>=
<br>
) ?<br>
<span class=3D"m_-306099096856596816HOEnZb"><font color=3D"#888888"><br>
--<br>
Sitsofe | <a href=3D"http://sucs.org/~sits/" rel=3D"noreferrer" target=3D"_=
blank">http://sucs.org/~sits/</a><br>
</font></span></blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--f403045d5af0403360054f0d9746--

