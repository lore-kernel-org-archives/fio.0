Return-Path: <axboe@kernel.dk>
Subject: Fwd: Fio Checksum tracking and enhanced trim workloads
References: <CAB8+yyVB8vaG6Vco21qcJie0+OkDNwOkqOxS-MyvQLYrqRzuWg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8e8a7151-9329-cdee-2100-3f94c5dd1b1f@kernel.dk>
Date: Mon, 8 May 2017 08:18:02 -0600
MIME-Version: 1.0
In-Reply-To: <CAB8+yyVB8vaG6Vco21qcJie0+OkDNwOkqOxS-MyvQLYrqRzuWg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: paul houlihan <phoulihan9@gmail.com>
List-ID: <fio@vger.kernel.org>

Paul is having trouble sending this to the reflector, let's see
if this works.


-------- Forwarded Message --------
Subject: 	Fio Checksum tracking and enhanced trim workloads
Date: 	Sun, 7 May 2017 23:54:16 -0400
From: 	paul houlihan <phoulihan9@gmail.com>
To: 	fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>



I have a submission for fio that enhances the data corruption detection and diagnosis capabilities taking fio from pretty good corruption detection to absolute guarantees. I would like these changes on the tracking branch???? to be reviewed and considered for inclusion to fio. A quick review would be helpful as I am losing access to test systems shortly.


These changes were used by a Virtual Machine caching company to assure data integrity. Most testing was on Linux 64 bits and windows 32/64 bits. The windows build still had an issue with compile time asserts in libfio.c that I worked around by commenting out the asserts as this looked like a performance restriction. This should be researched more. The initial development was on version fio 2.2.10 sources and I just ported the changes to fio latest sources and tested on linux but haven’t yet test on windows. No testing on all other fio supported OSes was done, although the changes are almost exclusively to OS independent code.


The absolute guarantees are brought about by tracking checksums to prevent a stale but intact prior version of a block being returned and by verifying all reads. I was surprised to learn about the number of times fio performed concurrent I/O to the same blocks which yields indeterminate results that prevent data integrity verification. Thus a number of options are not supported when tracking is enabled. 


Finally I have enhanced the usage of trims and am able to verify data integrity of these operations in an integrated fashion.


Here is a list of changes in this submission:

 * Bug where expected version of verify_interval is not generated correctly, dummy io_u not setup correctly

 * Bug where unknown header_interval referenced in HOWTO, fixed a bunch of typos.

 * Bug where windows hangs on nano sleep in windows 7.

 * Also stonewall= option does not seem to work on windows 7, seems fixed in later releases so painfully worked around this by having separate init and run fio scripts. No change was made here but just mentioning this in passing.

 * Fixed bug where FD_IO logging was screwed up in io_c.h. Here is example of logging problem:

io       2212  io complete: io_u 0x787280: off=1048576/len=2097152/ddir=0io       2212  /b.datio       2212  

io       2212  fill_io_u: io_u 0x787280: off=3145728/len=2097152/ddir=1io       2212  /b.datio       2212  

io       2212  prep: io_u 0x787280: off=3145728/len=2097152/ddir=1io       2212  /b.datio       2212  

io       2212  ->prep(0x787280)=0

io       2212  queue: io_u 0x787280: off=3145728/len=2097152/ddir=1io       2212  /b.datio       2212  

 * In order to make fio into an superb data integrity test tool, a number of shortcomings were addressed. New verify_track switch enables in memory tracking of checksums within each fio job, preventing a block from rolling back to prior version. The in memory checksums can be written to a tracking log file to provide an absolute checksum guarantees between fio jobs or between fio runs. Verification of trim operations is supported in an integrated fashion. See HOWTO description of verify_tracking. verify_tacking_log, verify_tracking_required, verify_tracking_dir, verify_trim_zero

 * Enhanced description surrounding corruption added to HOWTO as well as providing some corruption analyze tools.

 * Bad header will dump received buffer into *.received before you gave you an error message 

 * If verify_interval is less than the block size, fio will now always dump the complete buffer in an additional file called *.complete. Seeing whole buffer can reveal more about the corruption pattern.

 * Changed the printing of the hex checksum to display in MSB to LSB order to facilitate compares to memory dumps and debug logging

 * Added a dump of the complete return buffer on trim write verification failure. 

 * Debug logging was being truncated at the end of a job so you could not see the full set of debug log messages, so added a log flush at the end of each job if debug= switch is used.

 * rw=readwrite seems to have independent last_pos read/write pointers as you sequentially access the file. If the mix is 50/50 then you could have fio reading and writing the same block as the read and write pointer cross each other which is not reliably verifiable. This pattern result is chaos and contradicts all the other sequential patterns and even randrw. Overlapping I/O makes little sense and is usually a sign of a broken application. Moreover readwrite workload would not complete a sequential pass over the entire file which everyone I spoke to assumed it was doing. So a change was made to the existing read/write workload functionality. Now the max of the file’s last_pos pointers for DDIR_READ and DDIR_WRITE are used for selecting the next offset as we sequentially scan a file. If the old behavior is somehow useful then an option can be added to preserve it. If preserved, it should never be the default and should disable verification.


My changes revolve around maintaining the last_pos array in a special way. When multiple operations (read/write/trim) are requested by a workload then as the last position is changed, the changes are reflected in all three entries in the array. This way a randomly selected next operation always use the right last_pos. However we retained the old behavior for single operation workloads and for trimwrite which operates like a single operation workload.

 * Synchronous Trim I/O completions were not updating bytes_issued in backend.c and thus trimwrite was actually making 2 passes of the file.

 * I kept the new verify_tracking verification entirely separate from the experimental_verify code. These new tracking changes provides fully persistent verification of trims integrated into standard verify, so we might want to consider deprecating support for experimental_verify. Note that verify_track and experimental_verify cannot both be enabled.

 * With the wide adoption of thin LUN datastores and recent expanded OS support for trim operations to reclaim unused space, testing trim operations in a wide variety of contexts has been a necessity. Added some new trim I/O workloads to the existing trim workloads, that require use of verify_tracking option to verify:

trimSequential trims

readtrimSequential mixed reads and trims

writetrimSequential mixed writes and trims.

Each block will be trimmed or written.

readwritetrimSequential mixed reads/writes/trims

randtrimRandom trims

randreadtrimRandom mixed reads and trims

randwritetrimRandom mixed writes and trims

randrwtRandom mixed reads/writes/trims

 * A second change to existing fio functionality involves an inconsistency of counting read verification bytes against the size= argument. Some rw= workloads count read verification I/Os or bytes against size= values (like readwrite and randrw) and some do not  like write, trim and trimwrite. Counting read verifications bytes makes it hard to predict the number of bytes or I/Os that will be performed in the readwrite workload and the new rw= workloads increases the unpredictability with even more read verifications in a readwritetrim workload. Normally I expect that fio should process all the bytes in a file pass but when the bytes from read verifies count towards the total bytes to process in size=, only part of the file is processed. So I made it consistent for size and io_limit by not counting read verify bytes. One could argue that number_os= could also be similarly changed but I left this alone and it still uses raw I/O counts which include read verification I/Os.
Another justification is that this_io_bytes never records verification reads for the dry_run and we need dry_run and do_io to be in synch. Note this explains why I removed code to add extra bytes to total_bytes in do_io for verify_backlog. 

 * Seems like the processing of TD_F_VER_NONE is backwards from its name. If verify != VERIFY_NONE then the bit is set but the name implies it should be clear. So now it sets the bit only if verify == VERIFY_NONE to avoid this very confusing state.

 * Added a sync and invalidate after the close in iolog.c ipo_special(). This is needed if you capture checksums in the tracking log and there is a close followed immediately by an open. The close is not immediate if you have iodepth set to a large number. The file is still marked “open” but “closing” on return from the close  and will close only after the last I/O completes. The sync avoids the assert on trying to open an already open file which has a close pending.

 * —read_iolog does not support trims at this time.

 * io_u.c get_next_seq_offset() seems to suggest that ddir_seq_add can be negative but there are a number of unhandled cases with such a setting. Add TODOs to document issues. I have a number of reservations about the correctness of get_next_seq_offset(). Note whenever I saw a possible problem in the code but did not have time to research it, I added a TODO comment.

 * io_u.c get_next_seq_offset() has a problem when it uses fixed value when relative values are what is being manipulated, so this code:

if (pos >= f->real_file_size)

pos = f->file_offset;

should be:

if (pos >= f->io_size)

pos = 0;

 * Given there are a couple of changes to existing fio workload behavior, you might want to consider going to a V3.0. 




Here are two new sections on Verification Tracking and Data Corruption Troubleshooting from HOWTO:


Verification Tracking

---------------------


Absolute data integrity guarantee is the primary mission of a storage

software/hardware subsystem. Fio is good at detecting data corruption but

there are gaps. Currently only when rw option is set to read only are

workload reads verified. It is desirable to validate all reads in addition

to writes to protect against data rolling back to earlier versions.


With the addition of the block's offset to the header in recent fio releases,

block data returned for another block will be flagged as corrupt. However

a limitation of the fio header and data embedded checksums is that fio cannot

detect if a prior intact version of a block was returned on a read. If the

header and data checksum match the block is declared valid.


These limitations can be addressed by setting the verify_track option which

allocates a memory array to track the header and data checksums to assure

data integrity is absolute. The array starts out empty at the beginning of

each fio job and is filled in as reads or writes occur, once defined the

checksums from succeeding I/Os must all match. This option extends checksum

verification to all reads in all workloads, not just the read-only workloads.


However use of verify_track requires that fio avoid overlapping, concurrent

reads and writes to the same block. Reading and writing a block at the same

time yields indeterminate results and making guaranteeing data integrity

impossible. So some fio options where this is a risk are disabled when using

verify_track. See verify_track argument for list of restrictions.


Even better verification would validate data more persistently. You would

like to track checksums persistently between fio jobs or between runs of fio

which could be after a shutdown/restart of the system or on a different system

that shares storage. Proving seamless data integrity from the application

perspective over complex failover and recovery situations like reverting a

virtual machine to a prior snapshot is quite valuable.


Also the popularity of thin LUNs in the storage world has caused problems

if the unused disk space is not reclaimed by use of trims. So we would like

to have the ability to mix and match trims with reads and writes. The rw option

now supports a full set of combinations and the rwtmix=read%,write%,trim% option

allows specifying the mix percentages of all three types of I/O in one argument.

However trims do have special requirements as documented under the rw option.

Finally we would like to verify trims operations. If you read a trimmed block

before re-writing the block, it should return a block of zeroes.


The verify_track_log option permits persistent checksum tracking and

verification of trims by enabling the saving of the tracking array to a tracking

log on the close of a data file at the end of a fio job and reading it back in

at the next start. A clean shutdown of fio is needed for tracking log to be

persistent. When no errors occur checksum context is automatically preserved

between fio jobs and fio runs. On revert of a virtual machine snapshot if

the tracking log is restored from the time of the snapshot then checksum

context is again preserved. There is a tracking log for each data file.


Tracking log filename format is: [dir] / [filename].tracking.log

where:

   filename - is name of file system file or block device name like “sdb”

   dir - is log directory that defaults to directory of data file.

         For block devices, dir defaults to the process current default

         directory.


The tracking log is plain text and contains data from when it was first created:

the data file name it is tracking, the size of the data file, the starting

file offset for I/Os, its verify_interval option setting. From the last

save of the log it has: timestamp of last save and a checksum of the

tracking log contents. For checksums, Bit 0 = 1 defines a valid checksum.

Bit 0 = 0 signifies special case entries (dddddddc indicates a trimmed block

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

4028ab33    -- Checksums from read or write of 3 blocks, Bit 0 = 1

a450bffb

81858a3

dddddddc    -- Means trimmed block, Bit 0 = 0

0           -- Means undefined entry never been accessed, Bit 0 = 0

$


Tracking arguments are:


verify_track=bool - enables checksum tracking in memory

verify_track_log=bool - enable savings and restoring of tracking log

verify_track_required=bool - By default fio will create a log on the fly.

    If a log is found at the start it is read and then the log file is deleted.

    If any error occurs during the fio run then the tracking log is not

    written on close so compromised logs do not cause false failures. However

    testing requiring absolute data integrity guarantees will want to use this

    option to require that the tracking log always be present between fio jobs

    or at the start of a new fio run.

verify_track_dir=str - Specifies dir to place all tracking logs. It is advisable

    when evaluating the data integrity of device to place the tracking log on a

    different, more trusted device.

verify_track_trim_zero=bool - When no tracking array entry exists, this option

    allows a zeroed block from prior fio run to be treated as previously trimmed

    instead of as data corruption. Once the array entry for a block is defined,

    this option is no longer used as the array entry determines the required

    verification.

debug=chksum - a new debug option allows tracing of all checksum entry

    additions/changes to the tracking array or entry use in verification


There are a couple considerations to be aware of when using tracking log.

Tracking log is sticky. If you change the following options that make

the tracking log no longer match the data layout then you will receive

a persistent error until the tracking log is recreated: size= or offset=

or verify_interval= options. You do get a friendly error indicating

what tracking log file to delete to start with a fresh tracking log. Note

if a fio run an fails with other errors, the tracking log is discarded so that

stale checksums do not cause false failures on subsequent runs.


The tracking log uses 4 bytes for tracking each verify_interval block

in the data file or block device as specified by 4*(size/verify_interval).

So there are scaling implications for memory usage and log file size.

However blocks are only tracked for the active I/O range from:

offset - (offset+size-1).


The performance impact of the few extra I/Os to read and write the tracking log

between fio jobs and fio runs is negligible since one is not usually verifying

data when doing performance studies. There is no overhead when verify tracking

is disabled and no extra I/Os when verify_track_log is disabled.



Data Corruption Troubleshooting

-------------------------------


When a corruption occurs immediate analysis can reveal many clues as to the

source of the corruption. Is the corruption persistent? In memory and on disk?

The exact pattern of the corruption is often revealing: At the beginning of

an I/O block? Sector aligned? All zeroes or garbage? What is the exact range

of the corruption? Is corruption a stale but intact prior version of the

block?


When a corruption is detected, three possible corrupt data files are created:


*.received - the corrupt data which is possibly a verify_interval block within

              the full block used in the I/O.

*. complete - the full block used in the I/O

*. expected - if the block's header is intact, the expected data pattern for

              the *.received block can be generated


Two scripts exist in the analyze directory to assist in analysis:


corruption_triage.sh - a bash script that contains a sequence of diagnostic

              steps

fio_header.py - a python script that displays the contents of the block header

              in a corrupt data file.




Here are the related parameter descriptions from HOWTO:


option verify_track=bool


Fio normally verifies data within a verify_intervalwith checksums and file

offsets embedded in the data. However a prior version of a block could be

returned and verified successfully. When verify_track is enabled the checksum

for every verify_interval in the file is stored in a table and all read data

must match the checksums in the table. The tracking table is sized as

(size / verify_interval) * 4 bytes. For very large size= option settings,

such a large memory allocation may impact testing. Reads assume that the entire

file has been previously written with a verification format using the same

verify_interval. When verify_track is enabled, all reads are verified, whether

writes are present in the workload or not. Sharing files by threads within a job

is supported but not between jobs running concurrently so use the stonewall

option when more than one non-global job is present. Verify of trimmed blocks

is described for the verify_track_trim_zero option. When disabled, fio falls

back on verification described under the verify option. The restrictions when

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

- verify=null or pattern are not supported

- verify_only is not supported

- io_submit_mode must be set to 'inline'

- supplying a sequence number with rw option is not supported

- experimental_verify is not supported

Defaults to off.


You can enable verify_track for individual jobs and each job will start with

a empty table which is filled in as each block is initially read or written and

enforced on subsequent reads within the job. For persistent tracking of checksums

between jobs or fio runs, see verify_track_log.


option verify_track_log=bool


If set when verify_track is set then on a clean shutdown, fio writes the checksum

for each data block that has been read or written to a log named

(datafilename).tracking.log. If set when fio reopens this data file and a tracking

log exists then the checksums are read into the tracking table and used to validate

every subsequent read. This allows rigorous validation of data integrity as data

files are passed between fio jobs or over the termination of fio and restart on

the same system or on another system or after an OS reboot. Reverting a virtual

machine to a snapshot can be tested by saving the tracking log after a successful

fio run and later restoring the saved log after reverting the virtual machine.

The log is deleted after being read in, so on abnormal termination no stale

checksums can be used. This option, the data file size and verify_interval

parameters should not change between jobs in the same run or on restart of fio.

Defaults to off. verify_track_dir defines the tracking log's directory.


option verify_track_required=bool


If set when verify_track_log is set then the tracking log for each file must exist

at the start of a fio job or an error is returned. Defaults to off which is

the case for the first job in a new fio run. Subsequent jobs in this run can

require use of the tracking log. If set to off then any tracking log found will be

used otherwise an empty tracking table is used. If a prior fio run created a

tracking log for the data file then all jobs can require use of the tracking log.


option verify_track_dir=str


If verify_track_log is set then this defines the single directory for all tracking

logs. The default is to use the same directory where each data file resides.

When filename points to a block device or pipe then the directory defaults to the

current process default directory. To assure data integrity of the tracking log,

each tracking log also contains its own checksum. However when checking a device

for data integrity it is advisable to place tracking logs containing checksums on

a different, more trusted device.


option verify_track_trim_zero=bool


Typically a read of a trimmed block that has not been re-written will return a block

of zeros. If set with verify_tracking enabled then all zeroed blocks with no tracking

information are assumed to have resulted from a trim. If clear zeroed blocks are

treated as corruption. If your device does not return zeroed blocks for reads after

a trim then it cannot participate in tracking verification. Fio sets to 1 if trims

are present in the rw argument and defaults 0 otherwise. You would only use this when

verify_tracking is enabled, trims are not specified in the rw argument and a prior

fio job or run had performed trims.


option readwrite=str, rw=str


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

this is done by appending a ``:[nr]`` to the end of the string given.  For a

random read, it would look like ``rw=randread:8`` for passing in an offset

modifier with a value of 8. If the suffix is used with a sequential I/O

pattern, then the value specified will be added to the generated offset for

each I/O.  For instance, using ``rw=write:4k`` will skip 4k for every

write. It turns sequential I/O into sequential I/O with holes.  See the

:option:`rw_sequencer` option. Storage array vendors often require

trims to use a minimum block size.


option rwtmix=int[,int][,int]


When trims along with reads and/or writes are specified in the rw option then

this is the preferred argument for specifying mix percentages. The argument is

of the form: read,write,trim and the percentages must total 100.  Note any

argument may be empty to leave that value at its default from rwmix* arguments

of 50,50,0. If a trailing comma isn't given, the remainder will inherit

the last value set.


