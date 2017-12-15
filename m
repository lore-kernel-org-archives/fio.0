Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:57160 "EHLO
        mx0b-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756564AbdLOVaS (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 15 Dec 2017 16:30:18 -0500
Received: from pps.filterd (m0075034.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vBFLJpNE010994
        for <fio@vger.kernel.org>; Fri, 15 Dec 2017 16:30:17 -0500
Received: from mail-lf0-f70.google.com (mail-lf0-f70.google.com [209.85.215.70])
        by mx0b-00003501.pphosted.com with ESMTP id 2evmmr0b33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Fri, 15 Dec 2017 16:30:17 -0500
Received: by mail-lf0-f70.google.com with SMTP id h191so1666081lfg.19
        for <fio@vger.kernel.org>; Fri, 15 Dec 2017 13:30:16 -0800 (PST)
MIME-Version: 1.0
From: Phillip Chen <phillip.a.chen@seagate.com>
Date: Fri, 15 Dec 2017 14:29:33 -0700
Message-ID: <CAODBMz=eP9o0j_DeBtEzeULv49nSPCbMAjThrno8m8ns2ELdGg@mail.gmail.com>
Subject: FLEX feature requests
Content-Type: multipart/mixed; boundary="001a113f9a5ccb5b57056067b4a0"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--001a113f9a5ccb5b57056067b4a0
Content-Type: text/plain; charset="UTF-8"

Hello again,
I've been working on getting FIO running on a FLEX drive and I've been
accumulating a laundry list of features that would be nice to have and
I've run into one that is necessary. I also found one bug while
experimenting with various FIO options that I'll include in the list.
Here are the changes I'd appreciate seeing starting with the most
desired. I've included

1. --ignore_device_size
The current FLEX protocol maps storage to sectors/bytes greater than
the reported capacity of the drive. I'd like to run FIO on these out
of bounds sectors, but right now I can't because I get the error "you
need to specify valid offset=". Would it be possible to add a flag
that would let users run IO outside of the reported device capacity?
Without this I believe that FIO cannot run on the SMR portions of any
FLEX drive.

2. --readwrite=write_pointer_randwrite:offset,io_size:offset,io_size...
In write pointer zones, all writes must be at the write pointer, so
random IO is not possible. However, it would be useful to run
random-like workloads in which random zones are written to
sequentially. This would be very similar to the
random_distribution=zoned_abs argument except for instead of writing
randomly within a zone, it would write to a specific offset and then
increment that offset by the amount written, but would stop writing to
that zone entirely once the incrementing offset reached the end of the
zone. So if I had 3 zones I wanted to write to that were each 128mb
long, I could specify something like
--readwrite=write_pointer_randwrite:0,128m:128m,128m:256m,128m. It
might also make sense to add distribution percentages like in the
zoned_abs argument, although I'm not entirely sure what you would do
with those percentages when a zone got fully written and thus could
not be picked anymore.

3. --readwrite=write_pointer_randrw:offset,io_size:offset,io_size...
Additionally, in write pointer zones, all reads must be below the
write pointer, so random read IO is restricted. This is why I
requested the random_distribution:zoned_abs argument, because that can
be used quite well for issuing random reads to write pointer zones.
However, I would like to read and write "randomly" to write pointer
zones so that I can more easily control the read/write ratio as well
as being able to read data that was written during the same FIO run
(currently I can use random_distribution:zoned_abs to read randomly
from the beginning of the zone up to the write pointer at the
beginning of the FIO run, but I cannot read further after FIO
increments the write pointer). This workload would write randomly as
described above, and read between the offset and the incremented
offset. So before any writes went to the zone, you wouldn't be able to
read randomly from that zone.

4. Automatic zone detection with the above two readwrite modes
I believe this would be quite a bit of work, but it would nice to be
able to specify the previous two workload types without specifically
specifying the zones. Instead the user could specify offset and size
as normal, and additionally specify the zone number (perhaps through a
new option or perhaps with an extended syntax in the readwrite
option), and FIO would get the zones and randomly perform write
pointer legal IO within all the zones specified by the user using
offset and size. And if the user specified a drive area that contains
non-write pointer zones, FIO would just do normal IO. It might also be
possible for me to help with the implementation of this, if that would
be something you'd be interested in.

5. Bug report: --random_percentage sequential behaviour
It seems that sequential IO is increasing but not sequential when
using the --random_percentage option. Running the following FIO job:
fio --name=rand_reads_seq_writes --ioengine=libaio --direct=1
--exitall --thread --filename=/dev/sdf --runtime=30 --readwrite=randrw
--iodepth=1 --percentage_random=100,0 --norandommap
--output-format=terse
results in an even distribution of reads as expected and writes that
are increasing but not sequential. Here's an example of writes that I
am seeing running this job:
First 20 writes (sector, sectors written)
[(0, 8), (3048, 8), (3056, 8), (3064, 8), (3072, 8), (3080, 8), (3088,
8), (6408, 8), (7000, 8), (13440, 8), (13496, 8), (13648, 8), (13768,
8), (13920, 8), (14288, 8), (14400, 8), (16376, 8), (18824, 8),
(18936, 8), (19832, 8)]
Here is my environment information:
# cat /etc/centos-release
CentOS Linux release 7.3.1611 (Core)
# uname -r
3.10.0-514.21.1.el7.x86_64
I saw the same behaviour on fio-3.2 and fio-3.2-81-g3e262 which was
the newest version I could see as of today.

So I see some bursts of sequential writes, but mostly it seems to be
skipping around.

I've attached a python 3.6 script that will run this workload and
collect the IO information using blktrace/blkparse. To run the script,
use the -h flag to see usage, but at a minimum you'll need to give the
device handle to run on as the first argument.

Thank you for your help, and let me know if you decide to add these
features or if I need to provide any further information.

--001a113f9a5ccb5b57056067b4a0
Content-Type: text/plain; charset="US-ASCII"; name="fio_percentage_random.py"
Content-Disposition: attachment; filename="fio_percentage_random.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jb8feqha0

aW1wb3J0IHJlDQppbXBvcnQgc3VicHJvY2Vzcw0KaW1wb3J0IHRpbWUNCmltcG9ydCBzeXMNCmlt
cG9ydCBtYXRoDQppbXBvcnQgYXJncGFyc2UNCg0KDQphcmdfcGFyc2VyID0gYXJncGFyc2UuQXJn
dW1lbnRQYXJzZXIoKQ0KYXJnX3BhcnNlci5hZGRfYXJndW1lbnQoImRyaXZlX2hhbmRsZSIsIGhl
bHAgPSAiRHJpdmUgaGFuZGxlIHRvIHRlc3QiKQ0KYXJnX3BhcnNlci5hZGRfYXJndW1lbnQoIi1y
dCIsICItLXJ1bnRpbWUiLCBkZWZhdWx0ID0gMzAsIGhlbHAgPSAiVGltZSB0byBydW4gd29ya2xv
YWQiKQ0KYXJnX3BhcnNlci5hZGRfYXJndW1lbnQoIi1zYnAiLCAiLS1zYXZlX2Jsb2NrX3BhcnNl
IiwgYWN0aW9uID0gInN0b3JlX3RydWUiLA0KICAgICAgICAgICAgICAgICAgICAgICAgaGVscCA9
ICJTYXZlIGJsb2NrcGFyc2Ugb3V0cHV0IHRvIGJsa3BhcnNlX291dHB1dC50eHQgaWYgZmxhZyBp
cyBzZXQiKQ0KYXJnX3BhcnNlci5hZGRfYXJndW1lbnQoIi1mcCIsICItLWZpb19wYXRoIiwgZGVm
YXVsdCA9ICJmaW8iLA0KICAgICAgICAgICAgICAgICAgICAgICAgaGVscCA9ICJUaGUgcGF0aCB0
byB0aGUgRklPIGV4ZWN1dGFibGUgdG8gcnVuIikNCmFyZ3MgPSBhcmdfcGFyc2VyLnBhcnNlX2Fy
Z3MoKQ0KDQpkZXZfaGFuZGxlID0gYXJncy5kcml2ZV9oYW5kbGUNCg0KYmxrdHJhY2UgPSBzdWJw
cm9jZXNzLlBvcGVuKFsiYmxrdHJhY2UiLCBkZXZfaGFuZGxlLCAiLW8iLCAiLSJdLCBzdGRvdXQg
PSBzdWJwcm9jZXNzLlBJUEUsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RkZXJyID0g
c3VicHJvY2Vzcy5QSVBFKQ0KIyBibGt0cmFjZSBuZWVkcyBhIGxpdHRsZSB0aW1lIHRvIGdldCBz
ZXQgdXANCnRpbWUuc2xlZXAoMSkNCg0KIyBTdGFydCBGSU8gam9iDQpmaW9fc3RyaW5nID0gKGFy
Z3MuZmlvX3BhdGggKyAiIC0tbmFtZT1yYW5kX3JlYWRzX3NlcV93cml0ZXMgLS1pb2VuZ2luZT1s
aWJhaW8gLS1kaXJlY3Q9MSAtLWV4aXRhbGwiDQogICAgICAgICAgICAgICIgLS10aHJlYWQgLS1m
aWxlbmFtZT0iICsgZGV2X2hhbmRsZSArICIgLS1ydW50aW1lPSIgKyBzdHIoYXJncy5ydW50aW1l
KSArDQogICAgICAgICAgICAgICIgLS1yZWFkd3JpdGU9cmFuZHJ3IC0taW9kZXB0aD0xIC0tcGVy
Y2VudGFnZV9yYW5kb209MTAwLDAgLS1ub3JhbmRvbW1hcCAiDQogICAgICAgICAgICAgICItLW91
dHB1dC1mb3JtYXQ9dGVyc2UiKQ0KcHJpbnQoIlJ1bm5pbmcgIiArIGZpb19zdHJpbmcpDQpjbWRf
cmV0ID0gc3VicHJvY2Vzcy5ydW4oZmlvX3N0cmluZy5zcGxpdCgnICcpLCBzdGRvdXQgPSBzdWJw
cm9jZXNzLlBJUEUsIHN0ZGVyciA9IHN1YnByb2Nlc3MuUElQRSkNCg0KaWYgY21kX3JldC5zdGRl
cnIgIT0gYiIiOg0KICAgIHByaW50KCJGSU8gZXJyb3JzOiIpDQogICAgcHJpbnQoY21kX3JldC5z
dGRlcnIuZGVjb2RlKHN5cy5zdGRlcnIuZW5jb2RpbmcpKQ0KICAgIHByaW50KCJGSU8gc3Rkb3V0
OiIpDQogICAgcHJpbnQoY21kX3JldC5zdGRvdXQuZGVjb2RlKHN5cy5zdGRvdXQuZW5jb2Rpbmcp
KQ0KDQojIFRlcm1pbmF0ZSBpcyBob3cgYmxrdHJhY2UgZXhwZWN0cyB0byBlbmQsIGRvbid0IHVz
ZSBraWxsIG9yIHlvdSdsbCBsb3NlIGNvbW1hbmRzIG5lYXIgdGhlIGVuZA0KYmxrdHJhY2UudGVy
bWluYXRlKCkNCnRyeToNCiAgICBzdGRvdXQsIHN0ZGVyciA9IGJsa3RyYWNlLmNvbW11bmljYXRl
KHRpbWVvdXQgPSAyMCkNCmV4Y2VwdCBzdWJwcm9jZXNzLlRpbWVvdXRFeHBpcmVkOg0KICAgIGJs
a3RyYWNlLmtpbGwoKQ0KICAgIHN0ZG91dCwgc3RkZXJyID0gYmxrdHJhY2UuY29tbXVuaWNhdGUo
KQ0KcHJpbnQoImJsa3RyYWNlIGVycm9yczoiKQ0KcHJpbnQoc3RkZXJyKQ0KIyBUaGlzIHdpbGwg
Z2l2ZSB5b3UgdGhlIHJhdyBibGt0cmFjZSBvdXRwdXQNCiMgcHJpbnQoc3Rkb3V0KQ0KYmxrcGFy
c2VfZm9ybWF0X3N0ciA9ICclRCAlMmMgJThzICU1VC4lOXQgJTVwICUyYSAlM2QgY29tbWFuZCA9
ICVDIHNlY3RvcnMgPSAlUyBibG9ja19udW0gPSAlblxuJw0KYmxrcGFyc2VfcmV0ID0gc3VicHJv
Y2Vzcy5ydW4oWyJibGtwYXJzZSIsICItaSIsICItIiwgIi1mIiwgYmxrcGFyc2VfZm9ybWF0X3N0
ciwgIi1hIiwgImlzc3VlIl0sDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnB1dCA9
IHN0ZG91dCwgc3Rkb3V0ID0gc3VicHJvY2Vzcy5QSVBFLCBzdGRlcnIgPSBzdWJwcm9jZXNzLlBJ
UEUpDQpwcmludCgiYmxrcGFyc2UgZXJyb3JzOiIpDQpwcmludChibGtwYXJzZV9yZXQuc3RkZXJy
KQ0KIyBwcmludChibGtwYXJzZV9yZXQuc3Rkb3V0KQ0KYmxrcGFyc2Vfc3RyID0gYmxrcGFyc2Vf
cmV0LnN0ZG91dC5kZWNvZGUoc3lzLnN0ZG91dC5lbmNvZGluZykNCg0KaWYgYXJncy5zYXZlX2Js
b2NrX3BhcnNlOg0KICAgIHdpdGggb3BlbigiYmxrcGFyc2Vfb3V0cHV0LnR4dCIsICd3JykgYXMg
b3V0cHV0X2ZpbGU6DQogICAgICAgIG91dHB1dF9maWxlLndyaXRlKGJsa3BhcnNlX3N0cikNCg0K
IyBQYXJzZSBibGt0cmFjZSByZXN1bHQgaW50byBiaW5zDQpibGtsaW5lX3JlID0gcmUuY29tcGls
ZShyIihcZCssXGQrKVxzKyhcZCspXHMrKFxkKylccysoP1A8dGltZXN0YW1wPlxkK1wuXGQrKVxz
KyhcZCspXHMrRFxzKyINCiAgICAgICAgICAgICAgICAgICAgICAgIHIiKD9QPHR5cGU+KFJ8VylT
Pylccytjb21tYW5kID0gZmlvXHMrc2VjdG9ycyA9ICg/UDxzZWN0b3I+XGQrKVxzIg0KICAgICAg
ICAgICAgICAgICAgICAgICAgciJibG9ja19udW0gPSAoP1A8YmxvY2tfbnVtPlxkKykiKQ0KdG90
YWxfcmVhZHMgPSAwDQphdmdfbGJhID0gMA0KbWF4X2xiYSA9IDANCm1pbl9sYmEgPSBOb25lDQoj
IFBhcnNlIG91dCB0aGUgc2VjdG9ycyBmcm9tIHRoZSBibG9ja3RyYWNlIG91dHB1dCB0byBnZXQg
c29tZSBwcmVsaW1pbmFyeSBzdGF0aXN0aWNzDQptYXRjaF9pdGVyID0gYmxrbGluZV9yZS5maW5k
aXRlcihibGtwYXJzZV9zdHIpDQpmb3IgbWF0Y2hfb2JqIGluIG1hdGNoX2l0ZXI6DQogICAgaWYg
bWF0Y2hfb2JqLmdyb3VwZGljdCgpWyJ0eXBlIl1bMF0gPT0gJ1InOg0KICAgICAgICBzZWN0b3Jf
bnVtID0gaW50KG1hdGNoX29iai5ncm91cGRpY3QoKVsic2VjdG9yIl0pDQogICAgICAgIHRvdGFs
X3JlYWRzICs9IDENCiAgICAgICAgYXZnX2xiYSArPSBzZWN0b3JfbnVtDQogICAgICAgIGlmIG1p
bl9sYmEgaXMgTm9uZSBvciBzZWN0b3JfbnVtIDwgbWluX2xiYToNCiAgICAgICAgICAgIG1pbl9s
YmEgPSBzZWN0b3JfbnVtDQogICAgICAgIGlmIHNlY3Rvcl9udW0gPiBtYXhfbGJhOg0KICAgICAg
ICAgICAgbWF4X2xiYSA9IHNlY3Rvcl9udW0NCg0KcHJpbnQoInRvdGFsIHJlYWRzID0gIiArIHN0
cih0b3RhbF9yZWFkcykpDQpwcmludCgiYXZnOiB7Oi4yZn0sIG1pbjoge30sIG1heDoge30iLmZv
cm1hdChhdmdfbGJhIC8gdG90YWxfcmVhZHMsIG1pbl9sYmEsIG1heF9sYmEpKQ0KaGlzdF9udW0g
PSAyMA0KaGlzdF9iaW5zID0gWzBdICogaGlzdF9udW0NCmhpc3RfZGl2ID0gbWF4X2xiYSAvIGhp
c3RfbnVtDQpoaXN0X2VkZ2VzID0gW10NCmZvciBpbmQgaW4gcmFuZ2UoaGlzdF9udW0pOg0KICAg
IGhpc3RfZWRnZXMuYXBwZW5kKGhpc3RfZGl2ICogKGluZCArIDEpKQ0KDQojIFNvcnQgdGhlIGRh
dGEgaW50byBhIHJlYWQgaGlzdG9ncmFtIGFuZCBhIHdyaXRlIGxpc3QNCndyaXRlX2xpc3QgPSBb
XQ0KbWF0Y2hfaXRlciA9IGJsa2xpbmVfcmUuZmluZGl0ZXIoYmxrcGFyc2Vfc3RyKQ0KZm9yIG1h
dGNoX29iaiBpbiBtYXRjaF9pdGVyOg0KICAgIHNlY3Rvcl9udW0gPSBpbnQobWF0Y2hfb2JqLmdy
b3VwZGljdCgpWyJzZWN0b3IiXSkNCiAgICBpZiBtYXRjaF9vYmouZ3JvdXBkaWN0KClbInR5cGUi
XVswXSA9PSAnUic6DQogICAgICAgIGhpc3RfaW5kID0gbWF0aC5mbG9vcihzZWN0b3JfbnVtIC8g
aGlzdF9kaXYpDQogICAgICAgIGlmIGhpc3RfaW5kID09IGhpc3RfbnVtOg0KICAgICAgICAgICAg
aGlzdF9pbmQgLT0gMQ0KICAgICAgICBoaXN0X2JpbnNbaGlzdF9pbmRdICs9IDENCiAgICAjIEFz
c3VtZSBub24tcmVhZHMgYXJlIHdyaXRlcw0KICAgIGVsc2U6DQogICAgICAgIGJsb2NrX251bSA9
IGludChtYXRjaF9vYmouZ3JvdXBkaWN0KClbImJsb2NrX251bSJdKQ0KICAgICAgICB3cml0ZV9s
aXN0LmFwcGVuZCgoc2VjdG9yX251bSwgYmxvY2tfbnVtKSkNCg0KaGlzdF9wZXJjID0gW10NCmZv
ciBoaXN0X2JpbiBpbiBoaXN0X2JpbnM6DQogICAgaGlzdF9wZXJjLmFwcGVuZCgxMDAgKiBoaXN0
X2JpbiAvIHRvdGFsX3JlYWRzKQ0KDQpwcmludCgicmVhZCBoaXN0b2dyYW0gYmlucyA9ICIgKyBz
dHIoaGlzdF9iaW5zKSkNCnByaW50KCJyZWFkIGhpc3RvZ3JhbSBwZXJjZW50cyA9ICIgKyBzdHIo
aGlzdF9wZXJjKSkNCnByaW50KCJyZWFkIGhpc3RvZ3JhbSBlZGdlcyA9ICIgKyBzdHIoaGlzdF9l
ZGdlcykpDQpudW1fd3JpdGVfcHJpbnQgPSAyMA0KcHJpbnQoIkZpcnN0IHt9IHdyaXRlcyAoc2Vj
dG9yLCBzZWN0b3JzIHdyaXR0ZW4pIi5mb3JtYXQobnVtX3dyaXRlX3ByaW50KSkNCnByaW50KHdy
aXRlX2xpc3RbOm51bV93cml0ZV9wcmludF0pDQojIHByaW50IEZJTyB2ZXJzaW9uDQpjbWRfcmV0
ID0gc3VicHJvY2Vzcy5ydW4oW2FyZ3MuZmlvX3BhdGgsICItdiJdKQ0K
--001a113f9a5ccb5b57056067b4a0--
