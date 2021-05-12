Return-Path: <fio-owner@vger.kernel.org>
Received: from mailin.dlr.de ([194.94.201.12]:54662 "EHLO mailin.dlr.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233378AbhELPMw (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 May 2021 11:12:52 -0400
From: <Azat.Nurgaliev@dlr.de>
Subject: Long delay between jobs
Date: Wed, 12 May 2021 15:11:39 +0000
Message-ID: <41eb2d7fd0244eae92685becbbedabe6@dlr.de>
References: <a38fc5698da142b8a25f536ee1c7378c@dlr.de>
In-Reply-To: <a38fc5698da142b8a25f536ee1c7378c@dlr.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello everyone,=20

I am trying to emulate a real I/O workload with multiple fio jobs.
And I noticed that switching between jobs takes around ~300 ms when using t=
he stonewall parameter and ~200 ms when using the wait_for parameter. This =
delay seems to be rather high from my point of view.
Is this the expected behavior? Is there any possibility to reduce the delay=
s between jobs?
This delays you could see if you reproduce fio run with a python script, wh=
ich I supplement to the message. This script is intended to get delays with=
 IO operations
It uses blktrace for getting IO traces and then parses them and generates a=
 CSV file with delays between IOs.
Because blktrace started before fio starts, it also collects some number of=
 IO operations that are not related to the fio job file. To separate these =
operations in IO trace output, I added a small separator job at the beginni=
ng of the job file which does a single 128k operation and waits for 1 secon=
d, which could be easily noticed at the IO trace output.
Blkparse parse then all IO trace binary files and IO traces filtered by the=
 D (issued) only operations and then filtered by fio process. It's should w=
ork fine with the OS disk, but will work better, if to make a test against =
a separated device. Depends on your setup, IO trace operations could not ap=
pear. In this case, you could try to use the USB stick to get the script wo=
rking.
This script is required to run with root rights because blktrace requires t=
o have root rights to be able to collect all IO traces.

Fio version
/usr/local/bin/fio --version=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=20
fio-3.26-39-g6308

Linux version
Linux dmt-ws 5.8.0-48-generic #54~20.04.1-Ubuntu SMP Sat Mar 20 13:40:25 UT=
C 2021 x86_64 x86_64 x86_64 GNU/Linux

Fio job file

[global]
direct=3D1
group_reporting
ioengine=3Dlibaio
directory=3D/media/optane/fio_temp
numjobs=3D1
iodepth=3D1

[separator job 0]
# used for understanding where in io traces starts job file
rw=3Dread
size=3D128k
bssplit=3D128k,,
thinktime=3D1s

[reading job 1]
wait_for=3Dseparator job 0
rw=3Dread
size=3D4096b
bssplit=3D4k,,

[reading job 2]
wait_for=3Dreading job 1
rw=3Dread
size=3D20480b
bssplit=3D4k,,

[reading job 3]
wait_for=3Dreading job 2
rw=3Dread
size=3D20480b
bssplit=3D4k,,

[reading job 4]
wait_for=3Dreading job 3
rw=3Dread
size=3D20480b
bssplit=3D4k,,

[reading job 5]
stonewall
rw=3Dread
size=3D20480b
bssplit=3D4k,,

[reading job 6]
stonewall
rw=3Dread
size=3D16384b
bssplit=3D4k,,


My output with delays of read_delta.csv
Header includes:
Timestamp (nanoseconds), operation from blktrace, size of IO in bytes, numb=
er of CPU (core), name of the process, a calculated value from previous IO =
(nanoseconds).
Most important values, which I am concerning I highlighted below. These are=
 numbers represents the delay, which required for fio to switch to the next=
 job.
;timestamp;operation;io_size;cpu_id;process;delta
0;0.047131672;D;4096;2;fio;0.021224560
1;0.068356232;D;135168;2;fio;0.004784061
2;0.073140293;D;135168;2;fio;0.269024046
3;0.342164339;D;131072;11;fio;1.205111417 <- Job file started here
4;1.547275756;D;4096;10;fio;**0.201172283**
5;1.748448039;D;4096;11;fio;0.000361312
6;1.748809351;D;4096;11;fio;0.000271772
7;1.749081123;D;4096;11;fio;0.000261770
8;1.749342893;D;4096;11;fio;0.000256501
9;1.749599394;D;4096;11;fio;**0.200772160**
10;1.950371554;D;4096;11;fio;0.000259826
11;1.950631380;D;4096;11;fio;0.000158999
12;1.950790379;D;4096;11;fio;0.000163855
13;1.950954234;D;4096;11;fio;0.000189879
14;1.951144113;D;4096;11;fio;**0.199244653**
15;2.150388766;D;4096;4;fio;0.000203573
16;2.150592339;D;4096;4;fio;0.000150124
17;2.150742463;D;4096;4;fio;0.000146229
18;2.150888692;D;4096;4;fio;0.000184647
19;2.151073339;D;4096;4;fio;**0.300860646**
20;2.451933985;D;4096;10;fio;0.001125194
21;2.453059179;D;4096;10;fio;0.000649955
22;2.453709134;D;4096;10;fio;0.009264417
23;2.462973551;D;4096;10;fio;0.008190598
24;2.471164149;D;4096;10;fio;**0.282772655**
25;2.753936804;D;4096;10;fio;0.000448414
26;2.754385218;D;4096;10;fio;0.000282554
27;2.754667772;D;4096;10;fio;0.000258501
28;2.754926273;D;4096;10;fio;


Python code to generate the result
'''
=EF=BF=BD=EF=BF=BD=EF=BF=BD Script intended to get delays of IO operations.
=EF=BF=BD=EF=BF=BD=EF=BF=BD Author: Azat Nurgaliev, mailto:azat.nurgaliev@d=
lr.de
=EF=BF=BD=EF=BF=BD=EF=BF=BD Created Date: May 4 2021
'''

import pandas as pd
import subprocess, os
from pathlib import Path
import time

# define the device, from which will be collected IO traces
device =3D "nvme1n1"

# creating a folder with output files
Path("blktrace").mkdir(parents=3DTrue, exist_ok=3DTrue)

# clearing system caches
subprocess.run(["sh", "-c", 'echo 3 >/proc/sys/vm/drop_caches'])

# submitting blktrace process requires root rights
blktrace =3D subprocess.Popen(["blktrace", "-d", "/dev/" + device, "-o", de=
vice, "-D", "blktrace"], preexec_fn=3Dos.setpgrp, stdout=3Dsubprocess.DEVNU=
LL)
print("blktrace spawned with PID: %s" % blktrace.pid)

# starting the fio process
fio =3D subprocess.Popen(["fio", "delay_job.fio"], stdout=3Dsubprocess.PIPE)
print("fio spawned with PID: %s" % fio.pid)
outs, errs =3D fio.communicate(timeout=3D100)
print("fio finished")

time.sleep(10)
blktrace.terminate()

# running blkparse and filtering required values
blkparse_read_throughput =3D "blkparse -i blktrace/" + device + ".blktrace.=
 -f '%5T.%t %a %N %c %C\\n' -a read -o blktrace/" + device + "_read_raw.csv"
blkparse_read_throughput_filtered_operation =3D "grep ' fio' blktrace/" + d=
evice + "_read_raw.csv > blktrace/" + device +=EF=BF=BD "_read_filtered_pro=
cess.csv"
blkparse_read_throughput_filtered_process =3D "grep ' D ' blktrace/" + devi=
ce + "_read_filtered_process.csv > blktrace/" + device +=EF=BF=BD "_read_fi=
ltered_operation.csv"

subprocess.call(blkparse_read_throughput, shell=3DTrue, stdout=3Dsubprocess=
.DEVNULL)
subprocess.call(blkparse_read_throughput_filtered_operation, shell=3DTrue)
subprocess.call(blkparse_read_throughput_filtered_process, shell=3DTrue)

data_read =3D pd.read_csv("blktrace/" + device + "_read_filtered_operation.=
csv", delim_whitespace=3DTrue, names=3D['timestamp', 'operation', 'io_size'=
, 'cpu_id', 'process'])

data_read['delta'] =3D data_read.timestamp.diff().shift(-1)
#print(data_read)

data_read.to_csv("blktrace/" + device + "_read_delta.csv", sep=3D";", encod=
ing=3D"utf-8", float_format=3D"%.9f")


How to run the script:
. Create a folder for fio temp files. Better on the separated device
. Change parameter directory in the fio job file with pointing the fio temp=
 folder
. Specify correct device in the python script
. Install required python dependencies, if needed
. Put the fio job file in the same directory as the python script. Name it =
delay_job.fio
. Run python script with root rights
. The result will be added to the blktrace folder, which is created by the =
script in the same folder as the script


Best regards,
Azat Nurgaliev


