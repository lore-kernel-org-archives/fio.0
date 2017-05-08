Return-Path: <phoulihan9@gmail.com>
MIME-Version: 1.0
From: paul houlihan <phoulihan9@gmail.com>
Date: Sun, 7 May 2017 23:54:16 -0400
Message-ID: <CAB8+yyVB8vaG6Vco21qcJie0+OkDNwOkqOxS-MyvQLYrqRzuWg@mail.gmail.com>
Subject: Fio Checksum tracking and enhanced trim workloads
Content-Type: multipart/alternative; boundary=f403045f55da6cfc27054efb318f
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--f403045f55da6cfc27054efb318f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have a submission for fio that enhances the data corruption detection and
diagnosis capabilities taking fio from pretty good corruption detection to
absolute guarantees. I would like these changes on the tracking branch????
to be reviewed and considered for inclusion to fio. A quick review would be
helpful as I am losing access to test systems shortly.


These changes were used by a Virtual Machine caching company to assure data
integrity. Most testing was on Linux 64 bits and windows 32/64 bits. The
windows build still had an issue with compile time asserts in libfio.c that
I worked around by commenting out the asserts as this looked like a
performance restriction. This should be researched more. The initial
development was on version fio 2.2.10 sources and I just ported the changes
to fio latest sources and tested on linux but haven=E2=80=99t yet test on w=
indows.
No testing on all other fio supported OSes was done, although the changes
are almost exclusively to OS independent code.


The absolute guarantees are brought about by tracking checksums to prevent
a stale but intact prior version of a block being returned and by verifying
all reads. I was surprised to learn about the number of times fio performed
concurrent I/O to the same blocks which yields indeterminate results that
prevent data integrity verification. Thus a number of options are not
supported when tracking is enabled.


Finally I have enhanced the usage of trims and am able to verify data
integrity of these operations in an integrated fashion.


Here is a list of changes in this submission:

 * Bug where expected version of verify_interval is not generated
correctly, dummy io_u not setup correctly

 * Bug where unknown header_interval referenced in HOWTO, fixed a bunch of
typos.

 * Bug where windows hangs on nano sleep in windows 7.

 * Also stonewall=3D option does not seem to work on windows 7, seems fixed
in later releases so painfully worked around this by having separate init
and run fio scripts. No change was made here but just mentioning this in
passing.

 * Fixed bug where FD_IO logging was screwed up in io_c.h. Here is example
of logging problem:

io       2212  io complete: io_u 0x787280: off=3D1048576/len=3D2097152/ddir=
=3D0io
      2212  /b.datio       2212

io       2212  fill_io_u: io_u 0x787280: off=3D3145728/len=3D2097152/ddir=
=3D1io
    2212  /b.datio       2212

io       2212  prep: io_u 0x787280: off=3D3145728/len=3D2097152/ddir=3D1io
2212  /b.datio       2212

io       2212  ->prep(0x787280)=3D0

io       2212  queue: io_u 0x787280: off=3D3145728/len=3D2097152/ddir=3D1io
2212  /b.datio       2212

 * In order to make fio into an superb data integrity test tool, a number
of shortcomings were addressed. New verify_track switch enables in memory
tracking of checksums within each fio job, preventing a block from rolling
back to prior version. The in memory checksums can be written to a tracking
log file to provide an absolute checksum guarantees between fio jobs or
between fio runs. Verification of trim operations is supported in an
integrated fashion. See HOWTO description of verify_tracking.
verify_tacking_log, verify_tracking_required, verify_tracking_dir,
verify_trim_zero

 * Enhanced description surrounding corruption added to HOWTO as well as
providing some corruption analyze tools.

 * Bad header will dump received buffer into *.received before you gave you
an error message

 * If verify_interval is less than the block size, fio will now always dump
the complete buffer in an additional file called *.complete. Seeing whole
buffer can reveal more about the corruption pattern.

 * Changed the printing of the hex checksum to display in MSB to LSB order
to facilitate compares to memory dumps and debug logging

 * Added a dump of the complete return buffer on trim write verification
failure.

 * Debug logging was being truncated at the end of a job so you could not
see the full set of debug log messages, so added a log flush at the end of
each job if debug=3D switch is used.

 * rw=3Dreadwrite seems to have independent last_pos read/write pointers as
you sequentially access the file. If the mix is 50/50 then you could have
fio reading and writing the same block as the read and write pointer cross
each other which is not reliably verifiable. This pattern result is chaos
and contradicts all the other sequential patterns and even randrw.
Overlapping I/O makes little sense and is usually a sign of a broken
application. Moreover readwrite workload would not complete a sequential
pass over the entire file which everyone I spoke to assumed it was doing.
So a change was made to the existing read/write workload functionality. Now
the max of the file=E2=80=99s last_pos pointers for DDIR_READ and DDIR_WRIT=
E are
used for selecting the next offset as we sequentially scan a file. If the
old behavior is somehow useful then an option can be added to preserve it.
If preserved, it should never be the default and should disable
verification.


My changes revolve around maintaining the last_pos array in a special way.
When multiple operations (read/write/trim) are requested by a workload then
as the last position is changed, the changes are reflected in all three
entries in the array. This way a randomly selected next operation always
use the right last_pos. However we retained the old behavior for single
operation workloads and for trimwrite which operates like a single
operation workload.

 * Synchronous Trim I/O completions were not updating bytes_issued in
backend.c and thus trimwrite was actually making 2 passes of the file.

 * I kept the new verify_tracking verification entirely separate from the
experimental_verify code. These new tracking changes provides fully
persistent verification of trims integrated into standard verify, so we
might want to consider deprecating support for experimental_verify. Note
that verify_track and experimental_verify cannot both be enabled.

 * With the wide adoption of thin LUN datastores and recent expanded OS
support for trim operations to reclaim unused space, testing trim
operations in a wide variety of contexts has been a necessity. Added some
new trim I/O workloads to the existing trim workloads, that require use of
verify_tracking option to verify:

trim Sequential trims

readtrim Sequential mixed reads and trims

writetrim Sequential mixed writes and trims.

Each block will be trimmed or written.

readwritetrim Sequential mixed reads/writes/trims

randtrim Random trims

randreadtrim Random mixed reads and trims

randwritetrim Random mixed writes and trims

randrwt Random mixed reads/writes/trims

 * A second change to existing fio functionality involves an inconsistency
of counting read verification bytes against the size=3D argument. Some rw=
=3D
workloads count read verification I/Os or bytes against size=3D values (lik=
e
readwrite and randrw) and some do not  like write, trim and trimwrite.
Counting read verifications bytes makes it hard to predict the number of
bytes or I/Os that will be performed in the readwrite workload and the new
rw=3D workloads increases the unpredictability with even more read
verifications in a readwritetrim workload. Normally I expect that fio
should process all the bytes in a file pass but when the bytes from read
verifies count towards the total bytes to process in size=3D, only part of
the file is processed. So I made it consistent for size and io_limit by not
counting read verify bytes. One could argue that number_os=3D could also be
similarly changed but I left this alone and it still uses raw I/O counts
which include read verification I/Os. Another justification is that
this_io_bytes never records verification reads for the dry_run and we need
dry_run and do_io to be in synch. Note this explains why I removed code to
add extra bytes to total_bytes in do_io for verify_backlog.

 * Seems like the processing of TD_F_VER_NONE is backwards from its name.
If verify !=3D VERIFY_NONE then the bit is set but the name implies it shou=
ld
be clear. So now it sets the bit only if verify =3D=3D VERIFY_NONE to avoid
this very confusing state.

 * Added a sync and invalidate after the close in iolog.c ipo_special().
This is needed if you capture checksums in the tracking log and there is a
close followed immediately by an open. The close is not immediate if you
have iodepth set to a large number. The file is still marked =E2=80=9Copen=
=E2=80=9D but
=E2=80=9Cclosing=E2=80=9D on return from the close  and will close only aft=
er the last I/O
completes. The sync avoids the assert on trying to open an already open
file which has a close pending.

 * =E2=80=94read_iolog does not support trims at this time.

 * io_u.c get_next_seq_offset() seems to suggest that ddir_seq_add can be
negative but there are a number of unhandled cases with such a setting. Add
TODOs to document issues. I have a number of reservations about the
correctness of get_next_seq_offset(). Note whenever I saw a possible
problem in the code but did not have time to research it, I added a TODO
comment.

 * io_u.c get_next_seq_offset() has a problem when it uses fixed value when
relative values are what is being manipulated, so this code:

if (pos >=3D f->real_file_size)

pos =3D f->file_offset;

should be:

if (pos >=3D f->io_size)

pos =3D 0;

 * Given there are a couple of changes to existing fio workload behavior,
you might want to consider going to a V3.0.




Here are two new sections on Verification Tracking and Data Corruption
Troubleshooting from HOWTO:


Verification Tracking

---------------------


Absolute data integrity guarantee is the primary mission of a storage

software/hardware subsystem. Fio is good at detecting data corruption but

there are gaps. Currently only when rw option is set to read only are

workload reads verified. It is desirable to validate all reads in addition

to writes to protect against data rolling back to earlier versions.


With the addition of the block's offset to the header in recent fio
releases,

block data returned for another block will be flagged as corrupt. However

a limitation of the fio header and data embedded checksums is that fio
cannot

detect if a prior intact version of a block was returned on a read. If the

header and data checksum match the block is declared valid.


These limitations can be addressed by setting the verify_track option which

allocates a memory array to track the header and data checksums to assure

data integrity is absolute. The array starts out empty at the beginning of

each fio job and is filled in as reads or writes occur, once defined the

checksums from succeeding I/Os must all match. This option extends checksum

verification to all reads in all workloads, not just the read-only
workloads.


However use of verify_track requires that fio avoid overlapping, concurrent

reads and writes to the same block. Reading and writing a block at the same

time yields indeterminate results and making guaranteeing data integrity

impossible. So some fio options where this is a risk are disabled when usin=
g

verify_track. See verify_track argument for list of restrictions.


Even better verification would validate data more persistently. You would

like to track checksums persistently between fio jobs or between runs of fi=
o

which could be after a shutdown/restart of the system or on a different
system

that shares storage. Proving seamless data integrity from the application

perspective over complex failover and recovery situations like reverting a

virtual machine to a prior snapshot is quite valuable.


Also the popularity of thin LUNs in the storage world has caused problems

if the unused disk space is not reclaimed by use of trims. So we would like

to have the ability to mix and match trims with reads and writes. The rw
option

now supports a full set of combinations and the rwtmix=3Dread%,write%,trim%
option

allows specifying the mix percentages of all three types of I/O in one
argument.

However trims do have special requirements as documented under the rw
option.

Finally we would like to verify trims operations. If you read a trimmed
block

before re-writing the block, it should return a block of zeroes.


The verify_track_log option permits persistent checksum tracking and

verification of trims by enabling the saving of the tracking array to a
tracking

log on the close of a data file at the end of a fio job and reading it back
in

at the next start. A clean shutdown of fio is needed for tracking log to be

persistent. When no errors occur checksum context is automatically preserve=
d

between fio jobs and fio runs. On revert of a virtual machine snapshot if

the tracking log is restored from the time of the snapshot then checksum

context is again preserved. There is a tracking log for each data file.


Tracking log filename format is: [dir] / [filename].tracking.log

where:

   filename - is name of file system file or block device name like =E2=80=
=9Csdb=E2=80=9D

   dir - is log directory that defaults to directory of data file.

         For block devices, dir defaults to the process current default

         directory.


The tracking log is plain text and contains data from when it was first
created:

the data file name it is tracking, the size of the data file, the starting

file offset for I/Os, its verify_interval option setting. From the last

save of the log it has: timestamp of last save and a checksum of the

tracking log contents. For checksums, Bit 0 =3D 1 defines a valid checksum.

Bit 0 =3D 0 signifies special case entries (dddddddc indicates a trimmed bl=
ock

and 0 indicates an undefined entry).


Tracking Log Example with "--" comments added:


$ cat xxx.tracking.log

Fio-tracking-log-version: 1

DataFileName: xxx

DataFileSize: 2048

DataFileOffset: 0

DataFileVerifyInterval: 512

TrackingLogSaveTimestamp: 2017-02-23T14:25:32.446981

TrackingLogChecksum: cae34cd8

VerifyIntervalChecksums:

4028ab33    -- Checksums from read or write of 3 blocks, Bit 0 =3D 1

a450bffb

81858a3

dddddddc    -- Means trimmed block, Bit 0 =3D 0

0           -- Means undefined entry never been accessed, Bit 0 =3D 0

$


Tracking arguments are:


verify_track=3Dbool - enables checksum tracking in memory

verify_track_log=3Dbool - enable savings and restoring of tracking log

verify_track_required=3Dbool - By default fio will create a log on the fly.

    If a log is found at the start it is read and then the log file is
deleted.

    If any error occurs during the fio run then the tracking log is not

    written on close so compromised logs do not cause false failures.
However

    testing requiring absolute data integrity guarantees will want to use
this

    option to require that the tracking log always be present between fio
jobs

    or at the start of a new fio run.

verify_track_dir=3Dstr - Specifies dir to place all tracking logs. It is
advisable

    when evaluating the data integrity of device to place the tracking log
on a

    different, more trusted device.

verify_track_trim_zero=3Dbool - When no tracking array entry exists, this
option

    allows a zeroed block from prior fio run to be treated as previously
trimmed

    instead of as data corruption. Once the array entry for a block is
defined,

    this option is no longer used as the array entry determines the require=
d

    verification.

debug=3Dchksum - a new debug option allows tracing of all checksum entry

    additions/changes to the tracking array or entry use in verification


There are a couple considerations to be aware of when using tracking log.

Tracking log is sticky. If you change the following options that make

the tracking log no longer match the data layout then you will receive

a persistent error until the tracking log is recreated: size=3D or offset=
=3D

or verify_interval=3D options. You do get a friendly error indicating

what tracking log file to delete to start with a fresh tracking log. Note

if a fio run an fails with other errors, the tracking log is discarded so
that

stale checksums do not cause false failures on subsequent runs.


The tracking log uses 4 bytes for tracking each verify_interval block

in the data file or block device as specified by 4*(size/verify_interval).

So there are scaling implications for memory usage and log file size.

However blocks are only tracked for the active I/O range from:

offset - (offset+size-1).


The performance impact of the few extra I/Os to read and write the tracking
log

between fio jobs and fio runs is negligible since one is not usually
verifying

data when doing performance studies. There is no overhead when verify
tracking

is disabled and no extra I/Os when verify_track_log is disabled.



Data Corruption Troubleshooting

-------------------------------


When a corruption occurs immediate analysis can reveal many clues as to the

source of the corruption. Is the corruption persistent? In memory and on
disk?

The exact pattern of the corruption is often revealing: At the beginning of

an I/O block? Sector aligned? All zeroes or garbage? What is the exact rang=
e

of the corruption? Is corruption a stale but intact prior version of the

block?


When a corruption is detected, three possible corrupt data files are
created:


*.received - the corrupt data which is possibly a verify_interval block
within

              the full block used in the I/O.

*. complete - the full block used in the I/O

*. expected - if the block's header is intact, the expected data pattern fo=
r

              the *.received block can be generated


Two scripts exist in the analyze directory to assist in analysis:


corruption_triage.sh - a bash script that contains a sequence of diagnostic

              steps

fio_header.py - a python script that displays the contents of the block
header

              in a corrupt data file.




Here are the related parameter descriptions from HOWTO:


option verify_track=3Dbool


Fio normally verifies data within a verify_interval with checksums and file

offsets embedded in the data. However a prior version of a block could be

returned and verified successfully. When verify_track is enabled the
checksum

for every verify_interval in the file is stored in a table and all read dat=
a

must match the checksums in the table. The tracking table is sized as

(size / verify_interval) * 4 bytes. For very large size=3D option settings,

such a large memory allocation may impact testing. Reads assume that the
entire

file has been previously written with a verification format using the same

verify_interval. When verify_track is enabled, all reads are verified,
whether

writes are present in the workload or not. Sharing files by threads within
a job

is supported but not between jobs running concurrently so use the stonewall

option when more than one non-global job is present. Verify of trimmed
blocks

is described for the verify_track_trim_zero option. When disabled, fio fall=
s

back on verification described under the verify option. The restrictions
when

enabling the verify_track option are:

- randommap is required

- softrandommap is not supported

- lfsr random generator not supported when using multiple block sizes

- stonewall option required when more than one job present

- file size must be an even multiple of the block size when iodepth > 1

- verify_backlog not supported when iodepth > 1

- verify_async is not supported

- file sharing between concurrent jobs not supported

- numjobs must be 1

- io_submit_mode must be set to "inline"

- verify=3Dnull or pattern are not supported

- verify_only is not supported

- io_submit_mode must be set to 'inline'

- supplying a sequence number with rw option is not supported

- experimental_verify is not supported

Defaults to off.


You can enable verify_track for individual jobs and each job will start wit=
h

a empty table which is filled in as each block is initially read or written
and

enforced on subsequent reads within the job. For persistent tracking of
checksums

between jobs or fio runs, see verify_track_log.


option verify_track_log=3Dbool


If set when verify_track is set then on a clean shutdown, fio writes the
checksum

for each data block that has been read or written to a log named

(datafilename).tracking.log. If set when fio reopens this data file and a
tracking

log exists then the checksums are read into the tracking table and used to
validate

every subsequent read. This allows rigorous validation of data integrity as
data

files are passed between fio jobs or over the termination of fio and
restart on

the same system or on another system or after an OS reboot. Reverting a
virtual

machine to a snapshot can be tested by saving the tracking log after a
successful

fio run and later restoring the saved log after reverting the virtual
machine.

The log is deleted after being read in, so on abnormal termination no stale

checksums can be used. This option, the data file size and verify_interval

parameters should not change between jobs in the same run or on restart of
fio.

Defaults to off. verify_track_dir defines the tracking log's directory.


option verify_track_required=3Dbool


If set when verify_track_log is set then the tracking log for each file
must exist

at the start of a fio job or an error is returned. Defaults to off which is

the case for the first job in a new fio run. Subsequent jobs in this run ca=
n

require use of the tracking log. If set to off then any tracking log found
will be

used otherwise an empty tracking table is used. If a prior fio run created =
a

tracking log for the data file then all jobs can require use of the
tracking log.


option verify_track_dir=3Dstr


If verify_track_log is set then this defines the single directory for all
tracking

logs. The default is to use the same directory where each data file resides=
.

When filename points to a block device or pipe then the directory defaults
to the

current process default directory. To assure data integrity of the tracking
log,

each tracking log also contains its own checksum. However when checking a
device

for data integrity it is advisable to place tracking logs containing
checksums on

a different, more trusted device.


option verify_track_trim_zero=3Dbool


Typically a read of a trimmed block that has not been re-written will
return a block

of zeros. If set with verify_tracking enabled then all zeroed blocks with
no tracking

information are assumed to have resulted from a trim. If clear zeroed
blocks are

treated as corruption. If your device does not return zeroed blocks for
reads after

a trim then it cannot participate in tracking verification. Fio sets to 1
if trims

are present in the rw argument and defaults 0 otherwise. You would only use
this when

verify_tracking is enabled, trims are not specified in the rw argument and
a prior

fio job or run had performed trims.


option readwrite=3Dstr, rw=3Dstr


Type of I/O pattern. Accepted values are:


read

Sequential reads.

write

Sequential writes.

randwrite

Random writes.

randread

Random reads.

rw,readwrite

Sequential mixed reads or writes.

randrw

Random mixed reads or writes.


Trim I/O has several requirements:

- File system and OS support varies but Linux block devices

  accept trims. You need privilege to write to a Linux block device.

  See example fio: track-mem.fio

- Often minimal block size required. Linux on VMware requires

  at least 1 MB in size aligned on 1 MB boundary

- VMware requires minimum VM OS hardware level 11

- To verify the trim I/Os requires verify_track


Trim I/O patterns are:


trim

Sequential trims

readtrim

Sequential mixed reads or trims

trimwrite

Sequential mixed trim then write. Each block

will be trimmed first, then written to.

writetrim

Sequential mixed writes or trims.

Each block will be trimmed or written.

rwt,readwritetrim

Sequential mixed reads/writes/trims

randtrim

Random trims

randreadtrim

Random mixed reads or trims

randwritetrim

Random mixed writes or trims

randrwt

Random mixed reads/writes/trims


Fio defaults to read if the option is not specified.  For the mixed I/O

types, the default is to split them 50/50.  For certain types of I/O the

result may still be skewed a bit, since the speed may be different. It is

possible to specify a number of I/O's to do before getting a new offset,

this is done by appending a ``:[nr]`` to the end of the string given.  For =
a

random read, it would look like ``rw=3Drandread:8`` for passing in an offse=
t

modifier with a value of 8. If the suffix is used with a sequential I/O

pattern, then the value specified will be added to the generated offset for

each I/O.  For instance, using ``rw=3Dwrite:4k`` will skip 4k for every

write. It turns sequential I/O into sequential I/O with holes.  See the

:option:`rw_sequencer` option. Storage array vendors often require

trims to use a minimum block size.


option rwtmix=3Dint[,int][,int]


When trims along with reads and/or writes are specified in the rw option
then

this is the preferred argument for specifying mix percentages. The argument
is

of the form: read,write,trim and the percentages must total 100.  Note any

argument may be empty to leave that value at its default from rwmix*
arguments

of 50,50,0. If a trailing comma isn't given, the remainder will inherit

the last value set.

--f403045f55da6cfc27054efb318f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">







<p class=3D"gmail-p1"><span class=3D"gmail-s1">I have a submission for fio =
that enhances the data corruption detection and diagnosis capabilities taki=
ng fio from pretty good corruption detection to absolute guarantees. I woul=
d like these changes on the tracking branch???? to be reviewed and consider=
ed for inclusion to fio. A quick review would be helpful as I am losing acc=
ess to test systems shortly.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">These changes were used by a=
 Virtual Machine caching company to assure data integrity. Most testing was=
 on Linux 64 bits and windows 32/64 bits. The windows build still had an is=
sue with compile time asserts in libfio.c that I worked around by commentin=
g out the asserts as this looked like a performance restriction. This shoul=
d be researched more. The initial development was on version fio 2.2.10 sou=
rces and I just ported the changes to fio latest sources and tested on linu=
x but haven=E2=80=99t yet test on windows. No testing on all other fio supp=
orted OSes was done, although the changes are almost exclusively to OS inde=
pendent code.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">The absolute guarantees are =
brought about by tracking checksums to prevent a stale but intact prior ver=
sion of a block being returned and by verifying all reads. I was surprised =
to learn about the number of times fio performed concurrent I/O to the same=
 blocks which yields indeterminate results that prevent data integrity veri=
fication. Thus a number of options are not supported when tracking is enabl=
ed.=C2=A0</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Finally I have enhanced the =
usage of trims and am able to verify data integrity of these operations in =
an integrated fashion.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Here is a list of changes in=
 this submission:</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Bug where expected v=
ersion of verify_interval is not generated correctly, dummy io_u not setup =
correctly</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Bug where unknown he=
ader_interval referenced in HOWTO, fixed a bunch of typos.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Bug where windows ha=
ngs on nano sleep in windows 7.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Also stonewall=3D op=
tion does not seem to work on windows 7, seems fixed in later releases so p=
ainfully worked around this by having separate init and run fio scripts. No=
 change was made here but just mentioning this in passing.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Fixed bug where FD_I=
O logging was screwed up in io_c.h. Here is example of logging problem:</sp=
an></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>io =C2=A0 =C2=A0 =C2=A0 2212=C2=A0 io complete: io_u 0x787=
280: off=3D1048576/len=3D2097152/ddir=3D0io =C2=A0 =C2=A0 =C2=A0 2212=C2=A0=
 /b.datio =C2=A0 =C2=A0 =C2=A0 2212 =C2=A0</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>io =C2=A0 =C2=A0 =C2=A0 2212=C2=A0 fill_io_u: io_u 0x78728=
0: off=3D3145728/len=3D2097152/ddir=3D1io =C2=A0 =C2=A0 =C2=A0 2212=C2=A0 /=
b.datio =C2=A0 =C2=A0 =C2=A0 2212 =C2=A0</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>io =C2=A0 =C2=A0 =C2=A0 2212=C2=A0 prep: io_u 0x787280: of=
f=3D3145728/len=3D2097152/ddir=3D1io =C2=A0 =C2=A0 =C2=A0 2212=C2=A0 /b.dat=
io =C2=A0 =C2=A0 =C2=A0 2212 =C2=A0</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>io =C2=A0 =C2=A0 =C2=A0 2212=C2=A0 -&gt;prep(0x787280)=3D0=
</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>io =C2=A0 =C2=A0 =C2=A0 2212=C2=A0 queue: io_u 0x787280: o=
ff=3D3145728/len=3D2097152/ddir=3D1io =C2=A0 =C2=A0 =C2=A0 2212=C2=A0 /b.da=
tio =C2=A0 =C2=A0 =C2=A0 2212 =C2=A0</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* In order to make fio=
 into an superb data integrity test tool, a number of shortcomings were add=
ressed. New verify_track switch enables in memory tracking of checksums wit=
hin each fio job, preventing a block from rolling back to prior version. Th=
e in memory checksums can be written to a tracking log file to provide an a=
bsolute checksum guarantees between fio jobs or between fio runs. Verificat=
ion of trim operations is supported in an integrated fashion. See HOWTO des=
cription of verify_tracking. verify_tacking_log, verify_tracking_required, =
verify_tracking_dir, verify_trim_zero</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Enhanced description=
 surrounding corruption added to HOWTO=C2=A0as well as providing some corru=
ption analyze tools.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Bad header will dump=
 received buffer into *.received before you gave you an error message=C2=A0=
</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* If verify_interval i=
s less than the block size, fio will now always dump the complete buffer in=
 an additional file called *.complete. Seeing whole buffer can reveal more =
about the corruption pattern.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Changed the printing=
 of the hex checksum to display in MSB to LSB order to facilitate compares =
to memory dumps and debug logging</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Added a dump of the =
complete return buffer on trim write verification failure.=C2=A0</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Debug logging was be=
ing truncated at the end of a job so you could not see the full set of debu=
g log messages, so added a log flush at the end of each job if debug=3D swi=
tch is used.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* rw=3Dreadwrite seems=
 to have independent last_pos read/write pointers as you sequentially acces=
s the file. If the mix is 50/50 then you could have fio reading and writing=
 the same block as the read and write pointer cross each other which is not=
 reliably verifiable. This pattern result is chaos and contradicts all the =
other sequential patterns and even randrw. Overlapping I/O makes little sen=
se and is usually a sign of a broken application. Moreover readwrite worklo=
ad would not complete a sequential pass over the entire file which everyone=
 I spoke to assumed it was doing. So a change was made to the existing read=
/write workload functionality. Now the max of the file=E2=80=99s last_pos p=
ointers for DDIR_READ and DDIR_WRITE are used for selecting the next offset=
 as we sequentially scan a file. If the old behavior is somehow useful then=
 an option can be added to preserve it. If preserved, it should never be th=
e default and should disable verification.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">My changes revolve around ma=
intaining the last_pos array in a special way. When multiple operations (re=
ad/write/trim) are requested by a workload then as the last position is cha=
nged, the changes are reflected in all three entries in the array. This way=
 a randomly selected next operation always use the right last_pos. However =
we retained the old behavior for single operation workloads and for trimwri=
te which operates like a single operation workload.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Synchronous Trim I/O=
 completions were not updating bytes_issued in backend.c and thus trimwrite=
 was actually making 2 passes of the file.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* I kept the new verif=
y_tracking verification entirely separate from the experimental_verify code=
. These new tracking changes provides fully persistent verification of trim=
s integrated into standard verify, so we might want to consider deprecating=
 support for experimental_verify. Note that verify_track and experimental_v=
erify cannot both be enabled.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* With the wide adopti=
on of thin LUN datastores and recent expanded OS support for trim operation=
s to reclaim unused space, testing trim operations in a wide variety of con=
texts has been a necessity. Added some new trim I/O workloads to the existi=
ng trim workloads, that require use of verify_tracking option to verify:</s=
pan></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>trim<span class=3D"gmail-Apple-tab-span">	</span><span cla=
ss=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	<=
/span>Sequential trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>readtrim<span class=3D"gmail-Apple-tab-span">	</span><span=
 class=3D"gmail-Apple-tab-span">	</span>Sequential mixed reads and trims</s=
pan></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>writetrim<span class=3D"gmail-Apple-tab-span">	</span><spa=
n class=3D"gmail-Apple-tab-span">	</span>Sequential mixed writes and trims.=
</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Each block will be trimmed or written.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>readwritetrim<span class=3D"gmail-Apple-tab-span">	</span>=
<span class=3D"gmail-Apple-tab-span">	</span>Sequential mixed reads/writes/=
trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>randtrim<span class=3D"gmail-Apple-tab-span">	</span><span=
 class=3D"gmail-Apple-tab-span">	</span>Random trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>randreadtrim<span class=3D"gmail-Apple-tab-span">	</span><=
span class=3D"gmail-Apple-tab-span">	</span>Random mixed reads and trims</s=
pan></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>randwritetrim<span class=3D"gmail-Apple-tab-span">	</span>=
<span class=3D"gmail-Apple-tab-span">	</span>Random mixed writes and trims<=
/span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>randrwt<span class=3D"gmail-Apple-tab-span">	</span><span =
class=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span"=
>	</span>Random mixed reads/writes/trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* A second change to e=
xisting fio functionality involves an inconsistency of counting read verifi=
cation bytes against the size=3D argument. Some rw=3D workloads count read =
verification I/Os or bytes against size=3D values (like readwrite and randr=
w) and some do not=C2=A0 like write, trim and trimwrite. Counting read veri=
fications bytes makes it hard to predict the number of bytes or I/Os that w=
ill be performed in the readwrite workload and the new rw=3D workloads incr=
eases the unpredictability with even more read verifications in a readwrite=
trim workload. Normally I expect that fio should process all the bytes in a=
 file pass but when the bytes from read verifies count towards the total by=
tes to process in size=3D, only part of the file is processed. So I made it=
 consistent for size and io_limit by not counting read verify bytes. One co=
uld argue that number_os=3D could also be similarly changed but I left this=
 alone and it still uses raw I/O counts which include read verification I/O=
s. Another justification is that this_io_bytes never records verification r=
eads for the dry_run and we need dry_run and do_io to be in synch. Note thi=
s explains why I removed code to add extra bytes to total_bytes in do_io fo=
r verify_backlog.=C2=A0</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Seems like the proce=
ssing of TD_F_VER_NONE is backwards from its name. If verify !=3D VERIFY_NO=
NE then the bit is set but the name implies it should be clear. So now it s=
ets the bit only if verify =3D=3D VERIFY_NONE to avoid this very confusing =
state.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Added a sync and inv=
alidate after the close in iolog.c ipo_special(). This is needed if you cap=
ture checksums in the tracking log and there is a close followed immediatel=
y by an open. The close is not immediate if you have iodepth set to a large=
 number. The file is still marked =E2=80=9Copen=E2=80=9D but =E2=80=9Cclosi=
ng=E2=80=9D on return from the close=C2=A0 and will close only after the la=
st I/O completes. The sync avoids the assert on trying to open an already o=
pen file which has a close pending.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* =E2=80=94read_iolog =
does not support trims at this time.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* io_u.c get_next_seq_=
offset() seems to suggest that ddir_seq_add can be negative but there are a=
 number of unhandled cases with such a setting. Add TODOs to document issue=
s. I have a number of reservations about the correctness of get_next_seq_of=
fset(). Note whenever I saw a possible problem in the code but did not have=
 time to research it, I added a TODO comment.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* io_u.c get_next_seq_=
offset() has a problem when it uses fixed value when relative values are wh=
at is being manipulated, so this code:</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>if (pos &gt;=3D f-&gt;real_file_size)</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan><span class=3D"gmail-Apple-tab-span">	</span>pos =3D f-&gt;file_offset;=
</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>should be:</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>if (pos &gt;=3D f-&gt;io_size)</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan><span class=3D"gmail-Apple-tab-span">	</span>pos =3D 0;</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0* Given there are a co=
uple of changes to existing fio workload behavior, you might want to consid=
er going to a V3.0.=C2=A0</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Here are two new=C2=A0sectio=
ns on=C2=A0Verification Tracking and Data Corruption Troubleshooting from H=
OWTO:</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Verification Tracking</span>=
</p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">---------------------</span>=
</p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Absolute data integrity guar=
antee is the primary mission of a storage</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">software/hardware subsystem.=
 Fio is good at detecting data corruption but</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">there are gaps. Currently on=
ly when rw option is set to read only are</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">workload reads verified. It =
is desirable to validate all reads in addition</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">to writes to protect against=
 data rolling back to earlier versions.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">With the addition of the blo=
ck&#39;s offset to the header in recent fio releases,</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">block data returned for anot=
her block will be flagged as corrupt. However</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">a limitation of the fio head=
er and data embedded checksums is that fio cannot</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">detect if a prior intact ver=
sion of a block was returned on a read. If the</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">header and data checksum mat=
ch the block is declared valid.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">These limitations can be add=
ressed by setting the verify_track option which</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">allocates a memory array to =
track the header and data checksums to assure</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">data integrity is absolute. =
The array starts out empty at the beginning of</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">each fio job and is filled i=
n as reads or writes occur, once defined the</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">checksums from succeeding I/=
Os must all match. This option extends checksum</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">verification to all reads in=
 all workloads, not just the read-only workloads.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">However use of verify_track =
requires that fio avoid overlapping, concurrent</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">reads and writes to the same=
 block. Reading and writing a block at the same</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">time yields indeterminate re=
sults and making guaranteeing data integrity</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">impossible. So some fio opti=
ons where this is a risk are disabled when using</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">verify_track. See verify_tra=
ck argument for list of restrictions.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Even better verification wou=
ld validate data more persistently. You would</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">like to track checksums pers=
istently between fio jobs or between runs of fio</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">which could be after a shutd=
own/restart of the system or on a different system</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">that shares storage. Proving=
 seamless data integrity from the application</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">perspective over complex fai=
lover and recovery situations like reverting a</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">virtual machine to a prior s=
napshot is quite valuable.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Also the popularity of thin =
LUNs in the storage world has caused problems</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">if the unused disk space is =
not reclaimed by use of trims. So we would like</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">to have the ability to mix a=
nd match trims with reads and writes. The rw option</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">now supports a full set of c=
ombinations and the rwtmix=3Dread%,write%,trim% option</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">allows specifying the mix pe=
rcentages of all three types of I/O in one argument.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">However trims do have specia=
l requirements as documented under the rw option.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Finally we would like to ver=
ify trims operations. If you read a trimmed block</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">before re-writing the block,=
 it should return a block of zeroes.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">The verify_track_log option =
permits persistent checksum tracking and</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">verification of trims by ena=
bling the saving of the tracking array to a tracking</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">log on the close of a data f=
ile at the end of a fio job and reading it back in</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">at the next start. A clean s=
hutdown of fio is needed for tracking log to be</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">persistent. When no errors o=
ccur checksum context is automatically preserved</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">between fio jobs and fio run=
s. On revert of a virtual machine snapshot if</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">the tracking log is restored=
 from the time of the snapshot then checksum</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">context is again preserved. =
There is a tracking log for each data file.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Tracking log filename format=
 is: [dir] / [filename].tracking.log</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">where:</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0=C2=A0 filename - is n=
ame of file system file or block device name like =E2=80=9Csdb=E2=80=9D</sp=
an></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0=C2=A0 dir - is log di=
rectory that defaults to directory of data file.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 For block devices, dir defaults to the process current default</span=
></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 directory.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">The tracking log is plain te=
xt and contains data from when it was first created:</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">the data file name it is tra=
cking, the size of the data file, the starting</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">file offset for I/Os, its ve=
rify_interval option setting. From the last</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">save of the log it has: time=
stamp of last save and a checksum of the</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">tracking log contents. For c=
hecksums, Bit 0 =3D 1 defines a valid checksum.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Bit 0 =3D 0 signifies specia=
l case entries (dddddddc indicates a trimmed block</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">and 0 indicates an undefined=
 entry).</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Tracking Log Example with &q=
uot;--&quot; comments added:</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">$ cat xxx.tracking.log</span=
></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Fio-tracking-log-version: 1<=
/span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">DataFileName: xxx</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">DataFileSize: 2048</span></p=
>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">DataFileOffset: 0</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">DataFileVerifyInterval: 512<=
/span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">TrackingLogSaveTimestamp: 20=
17-02-23T14:25:32.446981</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">TrackingLogChecksum: cae34cd=
8</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">VerifyIntervalChecksums:</sp=
an></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">4028ab33=C2=A0 =C2=A0 -- Che=
cksums from read or write of 3 blocks, Bit 0 =3D 1</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">a450bffb</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">81858a3</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">dddddddc=C2=A0 =C2=A0 -- Mea=
ns trimmed block, Bit 0 =3D 0</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 -- Means undefined entry never been accessed, Bit 0 =3D 0</span>=
</p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">$</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Tracking arguments are:</spa=
n></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">verify_track=3Dbool - enable=
s checksum tracking in memory</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">verify_track_log=3Dbool - en=
able savings and restoring of tracking log</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">verify_track_required=3Dbool=
 - By default fio will create a log on the fly.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 If a log is fo=
und at the start it is read and then the log file is deleted.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 If any error o=
ccurs during the fio run then the tracking log is not</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 written on clo=
se so compromised logs do not cause false failures. However</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 testing requir=
ing absolute data integrity guarantees will want to use this</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 option to requ=
ire that the tracking log always be present between fio jobs</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 or at the star=
t of a new fio run.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">verify_track_dir=3Dstr - Spe=
cifies dir to place all tracking logs. It is advisable</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 when evaluatin=
g the data integrity of device to place the tracking log on a</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 different, mor=
e trusted device.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">verify_track_trim_zero=3Dboo=
l - When no tracking array entry exists, this option</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 allows a zeroe=
d block from prior fio run to be treated as previously trimmed</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 instead of as =
data corruption. Once the array entry for a block is defined,</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 this option is=
 no longer used as the array entry determines the required</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 verification.<=
/span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">debug=3Dchksum - a new debug=
 option allows tracing of all checksum entry</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 additions/chan=
ges to the tracking array or entry use in verification</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">There are a couple considera=
tions to be aware of when using tracking log.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Tracking log is sticky. If y=
ou change the following options that make</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">the tracking log no longer m=
atch the data layout then you will receive</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">a persistent error until the=
 tracking log is recreated: size=3D or offset=3D</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">or verify_interval=3D option=
s. You do get a friendly error indicating</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">what tracking log file to de=
lete to start with a fresh tracking log. Note</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">if a fio run an fails with o=
ther errors, the tracking log is discarded so that</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">stale checksums do not cause=
 false failures on subsequent runs.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">The tracking log uses 4 byte=
s for tracking each verify_interval block</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">in the data file or block de=
vice as specified by 4*(size/verify_interval).</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">So there are scaling implica=
tions for memory usage and log file size.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">However blocks are only trac=
ked for the active I/O range from:</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">offset - (offset+size-1).</s=
pan></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">The performance impact of th=
e few extra I/Os to read and write the tracking log</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">between fio jobs and fio run=
s is negligible since one is not usually verifying</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">data when doing performance =
studies. There is no overhead when verify tracking</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">is disabled and no extra I/O=
s when verify_track_log is disabled.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Data Corruption Troubleshoot=
ing</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">----------------------------=
---</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">When a corruption occurs imm=
ediate analysis can reveal many clues as to the</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">source of the corruption. Is=
 the corruption persistent? In memory and on disk?</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">The exact pattern of the cor=
ruption is often revealing: At the beginning of</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">an I/O block? Sector aligned=
? All zeroes or garbage? What is the exact range</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">of the corruption? Is corrup=
tion a stale but intact prior version of the</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">block?</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">When a corruption is detecte=
d, three possible corrupt data files are created:</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">*.received - the corrupt dat=
a which is possibly a verify_interval block within</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 the full block used in the I/O.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">*. complete - the full block=
 used in the I/O</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">*. expected - if the block&#=
39;s header is intact, the expected data pattern for</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 the *.received block can be generated</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Two scripts exist in the ana=
lyze directory to assist in analysis:</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">corruption_triage.sh - a bas=
h script that contains a sequence of diagnostic</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 steps</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">fio_header.py - a python scr=
ipt that displays the contents of the block header</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 in a corrupt data file.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">Here are the related paramet=
er descriptions from HOWTO:</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">option verify_track=3Dbool</=
span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>Fio normally verifies data within a verify_interval<span c=
lass=3D"gmail-Apple-tab-span">	</span>with checksums and file</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>offsets embedded in the data. However a prior version of a=
 block could be</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>returned and verified successfully. When verify_track is e=
nabled the checksum</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>for every verify_interval in the file is stored in a table=
 and all read data</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>must match the checksums in the table. The tracking table =
is sized as</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>(size / verify_interval) * 4 bytes. For very large size=3D=
 option settings,</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>such a large memory allocation may impact testing. Reads a=
ssume that the entire</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>file has been previously written with a verification forma=
t using the same</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>verify_interval. When verify_track is enabled, all reads a=
re verified, whether</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>writes are present in the workload or not. Sharing files b=
y threads within a job</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>is supported but not between jobs running concurrently so =
use the stonewall</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>option when more than one non-global job is present. Verif=
y of trimmed blocks</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>is described for the verify_track_trim_zero option. When d=
isabled, fio falls</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>back on verification described under the verify option. Th=
e restrictions when</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>enabling the verify_track option are:</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- randommap i=
s required</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- softrandomm=
ap is not supported</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- lfsr random=
 generator not supported when using multiple block sizes</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- stonewall o=
ption required when more than one job present</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- file size m=
ust be an even multiple of the block size when iodepth &gt; 1</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- verify_back=
log not supported when iodepth &gt; 1</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- verify_asyn=
c is not supported</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- file sharin=
g between concurrent jobs not supported</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- numjobs mus=
t be 1</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- io_submit_m=
ode must be set to &quot;inline&quot;</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- verify=3Dnu=
ll or pattern are not supported</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- verify_only=
 is not supported</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- io_submit_m=
ode must be set to &#39;inline&#39;</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- supplying a=
 sequence number with rw option is not supported</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>- experimenta=
l_verify is not supported</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>Defaults to off.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>You can enable verify_track for individual jobs and each j=
ob will start with</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>a empty table which is filled in as each block is initiall=
y read or written and</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>enforced on subsequent reads within the job. For persisten=
t tracking of checksums</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>between jobs or fio runs, see verify_track_log.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">option verify_track_log=3Dbo=
ol</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>If set when verify_track is set then on a clean shutdown, =
fio writes the checksum</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>for each data block that has been read or written to a log=
 named</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>(datafilename).tracking.log. If set when fio reopens this =
data file and a tracking</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>log exists then the checksums are read into the tracking t=
able and used to validate</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>every subsequent read. This allows rigorous validation of =
data integrity as data</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>files are passed between fio jobs or over the termination =
of fio and restart on</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>the same system or on another system or after an OS reboot=
. Reverting a virtual</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>machine to a snapshot can be tested by saving the tracking=
 log after a successful</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>fio run and later restoring the saved log after reverting =
the virtual machine.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>The log is deleted after being read in, so on abnormal ter=
mination no stale</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>checksums can be used. This option, the data file size and=
 verify_interval</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>parameters should not change between jobs in the same run =
or on restart of fio.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>Defaults to off. verify_track_dir defines the tracking log=
&#39;s directory.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">option verify_track_required=
=3Dbool</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>If set when verify_track_log is set then the tracking log =
for each file must exist</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>at the start of a fio job or an error is returned. Default=
s to off which is</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>the case for the first job in a new fio run. Subsequent jo=
bs in this run can</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>require use of the tracking log. If set to off then any tr=
acking log found will be</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>used otherwise an empty tracking table is used. If a prior=
 fio run created a</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>tracking log for the data file then all jobs can require u=
se of the tracking log.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">option verify_track_dir=3Dst=
r</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>If verify_track_log is set then this defines the single di=
rectory for all tracking</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>logs. The default is to use the same directory where each =
data file resides.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>When filename points to a block device or pipe then the di=
rectory defaults to the</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>current process default directory. To assure data integrit=
y of the tracking log,</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>each tracking log also contains its own checksum. However =
when checking a device</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>for data integrity it is advisable to place tracking logs =
containing checksums on</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>a different, more trusted device.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">option verify_track_trim_zer=
o=3Dbool</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>Typically a read of a trimmed block that has not been re-w=
ritten will return a block</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>of zeros. If set with verify_tracking enabled then all zer=
oed blocks with no tracking</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>information are assumed to have resulted from a trim. If c=
lear zeroed blocks are</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>treated as corruption. If your device does not return zero=
ed blocks for reads after</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>a trim then it cannot participate in tracking verification=
. Fio sets to 1 if trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>are present in the rw argument and defaults 0 otherwise. Y=
ou would only use this when</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>verify_tracking is enabled, trims are not specified in the=
 rw argument and a prior</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>fio job or run had performed trims.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">option readwrite=3Dstr, rw=
=3Dstr</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>Type of I/O pattern. Accepted values are:</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>read</span></=
p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Sequential reads.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>write</span><=
/p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Sequential writes.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>randwrite</sp=
an></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Random writes.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>randread</spa=
n></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Random reads.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>rw,readwrite<=
/span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Sequential mixed reads or writes.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>randrw</span>=
</p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Random mixed reads or writes.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>Trim I/O has =
several requirements:</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span> - File syste=
m and OS support varies but Linux block devices</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span> =C2=A0 accep=
t trims. You need privilege to write to a Linux block device.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span> =C2=A0 See e=
xample fio: track-mem.fio</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span> - Often mini=
mal block size required. Linux on VMware requires</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span> =C2=A0 at le=
ast 1 MB in size aligned on 1 MB boundary</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span> - VMware req=
uires minimum VM OS hardware level 11</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span> - To verify =
the trim I/Os requires verify_track</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>Trim I/O patt=
erns are:</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>trim</span></=
p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Sequential trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>readtrim</spa=
n></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Sequential mixed reads or trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>trimwrite</sp=
an></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Sequential mixed trim then write. Each block</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>will be trimmed first, then written to.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>writetrim</sp=
an></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Sequential mixed writes or trims.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Each block will be trimmed or written.</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>rwt,readwrite=
trim</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Sequential mixed reads/writes/trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>randtrim</spa=
n></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Random trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>randreadtrim<=
/span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Random mixed reads or trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>randwritetrim=
</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Random mixed writes or trims</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span>randrwt</span=
></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span><span class=3D"gmail-Apple-tab-span">	</span><span class=
=3D"gmail-Apple-tab-span">	</span><span class=3D"gmail-Apple-tab-span">	</s=
pan>Random mixed reads/writes/trims</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>Fio defaults to read if the option is not specified.=C2=A0=
 For the mixed I/O</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>types, the default is to split them 50/50.=C2=A0 For certa=
in types of I/O the</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>result may still be skewed a bit, since the speed may be d=
ifferent. It is</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>possible to specify a number of I/O&#39;s to do before get=
ting a new offset,</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>this is done by appending a ``:[nr]`` to the end of the st=
ring given.=C2=A0 For a</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>random read, it would look like ``rw=3Drandread:8`` for pa=
ssing in an offset</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>modifier with a value of 8. If the suffix is used with a s=
equential I/O</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>pattern, then the value specified will be added to the gen=
erated offset for</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>each I/O.=C2=A0 For instance, using ``rw=3Dwrite:4k`` will=
 skip 4k for every</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>write. It turns sequential I/O into sequential I/O with ho=
les.=C2=A0 See the</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>:option:`rw_sequencer` option. Storage array vendors often=
 require</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>trims to use a minimum block size.</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1">option rwtmix=3Dint[,int][,i=
nt]</span></p>
<p class=3D"gmail-p2"><span class=3D"gmail-s1"></span><br></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>When trims along with reads and/or writes are specified in=
 the rw option then</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>this is the preferred argument for specifying mix percenta=
ges. The argument is</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>of the form: read,write,trim and the percentages must tota=
l 100.=C2=A0 Note any</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>argument may be empty to leave that value at its default f=
rom rwmix* arguments</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>of 50,50,0. If a trailing comma isn&#39;t given, the remai=
nder will inherit</span></p>
<p class=3D"gmail-p1"><span class=3D"gmail-s1"><span class=3D"gmail-Apple-t=
ab-span">	</span>the last value set.</span></p></div>

--f403045f55da6cfc27054efb318f--

