Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:45200 "EHLO
        mx0b-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751760AbdKTRS1 (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 20 Nov 2017 12:18:27 -0500
Received: from pps.filterd (m0075029.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAKHE5Mt026411
        for <fio@vger.kernel.org>; Mon, 20 Nov 2017 12:18:27 -0500
Received: from mail-lf0-f70.google.com (mail-lf0-f70.google.com [209.85.215.70])
        by mx0b-00003501.pphosted.com with ESMTP id 2ebx4fsqyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Mon, 20 Nov 2017 12:18:26 -0500
Received: by mail-lf0-f70.google.com with SMTP id y85so2283746lfk.15
        for <fio@vger.kernel.org>; Mon, 20 Nov 2017 09:18:26 -0800 (PST)
MIME-Version: 1.0
From: Phillip Chen <phillip.a.chen@seagate.com>
Date: Mon, 20 Nov 2017 10:17:40 -0700
Message-ID: <CAODBMzm2qZu=gcpDKLyQ27zyFgkDD1ieaw2b4=A869_zuQE7HA@mail.gmail.com>
Subject: Random distribution: zoned argument
Content-Type: multipart/mixed; boundary="001a1140774cec1b22055e6d4531"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--001a1140774cec1b22055e6d4531
Content-Type: text/plain; charset="UTF-8"

Hello,
I'm a test engineer at Seagate and we're using FIO to gather some
performance data. This email has two parts: a bug report and a feature
request.
The bug that I'm seeing is that when using the
random_distribution=zoned argument, the zone order is not honored. So
using zoned:18/90:7/5:75/5 will not weight IO towards the end of the
disk but rather towards the beginning. Using zoned:75/5:7/5:18/90
apparently gives the same distribution, but also not the correct
distribution. I've attached a python3.6 script that shows this
behaviour. Here is the histogram information from running the two
zoned arguments as described above:

Using fio --name=rand_reads --ioengine=libaio --direct=1 --exitall
--thread --filename=/dev/sdc --runtime=30 --readwrite=randread
--iodepth=1 --random_distribution=zoned:18/90:7/5:75/5 --norandommap
--output-format=terse
histogram bins = [2302, 25, 25, 30, 33, 36, 26, 32, 29, 37, 21, 21,
32, 27, 49, 34, 24, 36, 26, 184]
histogram percents = [75.99867943215582, 0.8253549026081215,
0.8253549026081215, 0.9904258831297458, 1.0894684714427203,
1.188511059755695, 0.8583690987124464, 1.0564542753383954,
0.9574116870254209, 1.2215252558600198, 0.6932981181908221,
0.6932981181908221, 1.0564542753383954, 0.8913832948167713,
1.6176956091119181, 1.1224826675470452, 0.7923407065037966,
1.188511059755695, 0.8583690987124464, 6.074612083195774]

Using fio --name=rand_reads --ioengine=libaio --direct=1 --exitall
--thread --filename=/dev/sdc --runtime=30 --readwrite=randread
--iodepth=1 --random_distribu   tion=zoned:75/5:7/5:18/90
--norandommap --output-format=terse
histogram bins = [2306, 25, 25, 30, 33, 36, 26, 32, 29, 37, 21, 21,
32, 27, 49, 34, 24, 36, 26, 184]
histogram percents = [76.03033300362677, 0.8242664029014177,
0.8242664029014177, 0.9891196834817013, 1.0880316518298714,
1.1869436201780414, 0.8572370590174745, 1.0550609957138146,
0.9561490273656446, 1.2199142762940982, 0.6923837784371909,
0.6923837784371909, 1.0550609957138146, 0.8902077151335311,
1.6155621496867787, 1.1210023079459281, 0.7912957467853611,
1.1869436201780414, 0.8572370590174745, 6.0666007253544345]

To run the script, use the -h flag to see usage, but at a minimum
you'll need to give the device handle to run on as the first argument
(the workload only does reads). The random_distribution argument is
set at the top of the file.

Here is my environment information:
# cat /etc/centos-release
CentOS Linux release 7.3.1611 (Core)
# uname -r
3.10.0-514.21.1.el7.x86_64
I used fio-3.2-13-g40e5f which was the newest version I could see as of today.

As for the feature request:
I am trying to adapt our current FIO job files for FLEX testing which
is a new protocol we announced recently
(http://blog.seagate.com/intelligent/new-flex-dynamic-recording-method-redefines-data-center-hard-drive/)
that has some requirements on where writes/reads are allowed. I would
like to have better control where random reads and writes are going
using the zoned random_distribution setting using sector numbers
rather than capacity percentages. Would that be a possible feature to
add? Or is there an existing way to randomly read/write to
non-contiguous zones on the disk with varying sizes?

Thank you,
Phillip Chen

--001a1140774cec1b22055e6d4531
Content-Type: text/plain; charset="US-ASCII"; name="fio_zoned.py"
Content-Disposition: attachment; filename="fio_zoned.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ja8gf84w0

aW1wb3J0IHJlDQppbXBvcnQgc3VicHJvY2Vzcw0KaW1wb3J0IHRpbWUNCmltcG9ydCBzeXMNCmlt
cG9ydCBtYXRoDQppbXBvcnQgYXJncGFyc2UNCg0KIyBXZWlnaHQgaGVhdmlseSB0b3dhcmRzIHRo
ZSBsYXN0IDUlIG9mIHRoZSBkcml2ZQ0KZGlzdF9zdHIgPSAiem9uZWQ6MTgvOTA6Ny81Ojc1LzUi
DQoNCiMgV2VpZ2h0cyBhcmUgaW4gZGVzY2VuZGluZyBvcmRlciwgYXMgaW4gdGhlIGV4YW1wbGUg
LS0gdGhpcyBzZWVtcyB0byBiZSB0aGUgb25seSB3YXkgdGhhdCB3b3Jrcw0KIyBkaXN0X3N0ciA9
ICJ6b25lZDo3NS81OjcvNToxOC85MCINCg0KIyBXZWlnaHRlZCBoZWF2aWx5IHRvd2FyZHMgdGhl
IG1pZGRsZSBvZiB0aGUgZHJpdmUNCiMgZGlzdF9zdHIgPSAiem9uZWQ6NS80NTo5MC8xMDo1LzQ1
Ig0KDQoNCmFyZ19wYXJzZXIgPSBhcmdwYXJzZS5Bcmd1bWVudFBhcnNlcigpDQphcmdfcGFyc2Vy
LmFkZF9hcmd1bWVudCgiZHJpdmVfaGFuZGxlIiwgaGVscCA9ICJEcml2ZSBoYW5kbGUgdG8gdGVz
dCIpDQphcmdfcGFyc2VyLmFkZF9hcmd1bWVudCgiLXJ0IiwgIi0tcnVudGltZSIsIGRlZmF1bHQg
PSAzMCwgaGVscCA9ICJUaW1lIHRvIHJ1biB3b3JrbG9hZCIpDQphcmdfcGFyc2VyLmFkZF9hcmd1
bWVudCgiLXNicCIsICItLXNhdmVfYmxvY2tfcGFyc2UiLCBhY3Rpb24gPSAic3RvcmVfdHJ1ZSIs
DQogICAgICAgICAgICAgICAgICAgICAgICBoZWxwID0gIlNhdmUgYmxvY2twYXJzZSBvdXRwdXQg
dG8gYmxrcGFyc2Vfb3V0cHV0LnR4dCBpZiBmbGFnIGlzIHNldCIpDQphcmdfcGFyc2VyLmFkZF9h
cmd1bWVudCgiLWZwIiwgIi0tZmlvX3BhdGgiLCBkZWZhdWx0ID0gImZpbyIsDQogICAgICAgICAg
ICAgICAgICAgICAgICBoZWxwID0gIlRoZSBwYXRoIHRvIHRoZSBGSU8gZXhlY3V0YWJsZSB0byBy
dW4iKQ0KYXJncyA9IGFyZ19wYXJzZXIucGFyc2VfYXJncygpDQoNCmRldl9oYW5kbGUgPSBhcmdz
LmRyaXZlX2hhbmRsZQ0KDQpibGt0cmFjZSA9IHN1YnByb2Nlc3MuUG9wZW4oWyJibGt0cmFjZSIs
IGRldl9oYW5kbGUsICItbyIsICItIl0sIHN0ZG91dCA9IHN1YnByb2Nlc3MuUElQRSwNCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBzdGRlcnIgPSBzdWJwcm9jZXNzLlBJUEUpDQojIGJsa3Ry
YWNlIG5lZWRzIGEgbGl0dGxlIHRpbWUgdG8gZ2V0IHNldCB1cA0KdGltZS5zbGVlcCgxKQ0KDQoj
IFN0YXJ0IEZJTyBqb2INCmZpb19zdHJpbmcgPSAoYXJncy5maW9fcGF0aCArICIgLS1uYW1lPXJh
bmRfcmVhZHMgLS1pb2VuZ2luZT1saWJhaW8gLS1kaXJlY3Q9MSAtLWV4aXRhbGwgIg0KICAgICAg
ICAgICAgICAiLS10aHJlYWQgLS1maWxlbmFtZT0iICsgZGV2X2hhbmRsZSArICIgLS1ydW50aW1l
PSIgKyBzdHIoYXJncy5ydW50aW1lKSArDQogICAgICAgICAgICAgICIgLS1yZWFkd3JpdGU9cmFu
ZHJlYWQgLS1pb2RlcHRoPTEgLS1yYW5kb21fZGlzdHJpYnV0aW9uPSIgKyBkaXN0X3N0ciArDQog
ICAgICAgICAgICAgICIgLS1ub3JhbmRvbW1hcCAtLW91dHB1dC1mb3JtYXQ9dGVyc2UiKQ0KcHJp
bnQoIlJ1bm5pbmcgIiArIGZpb19zdHJpbmcpDQpjbWRfcmV0ID0gc3VicHJvY2Vzcy5ydW4oZmlv
X3N0cmluZy5zcGxpdCgnICcpLCBzdGRvdXQgPSBzdWJwcm9jZXNzLlBJUEUsIHN0ZGVyciA9IHN1
YnByb2Nlc3MuUElQRSkNCg0KaWYgY21kX3JldC5zdGRlcnIgIT0gYiIiOg0KICAgIHByaW50KCJG
SU8gZXJyb3JzOiIpDQogICAgcHJpbnQoY21kX3JldC5zdGRlcnIuZGVjb2RlKHN5cy5zdGRlcnIu
ZW5jb2RpbmcpKQ0KcHJpbnQoIkZJTyBzdGRvdXQ6IikNCnByaW50KGNtZF9yZXQuc3Rkb3V0LmRl
Y29kZShzeXMuc3Rkb3V0LmVuY29kaW5nKSkNCg0KIyBUZXJtaW5hdGUgaXMgaG93IGJsa3RyYWNl
IGV4cGVjdHMgdG8gZW5kLCBkb24ndCB1c2Uga2lsbCBvciB5b3UnbGwgbG9zZSBjb21tYW5kcyBu
ZWFyIHRoZSBlbmQNCmJsa3RyYWNlLnRlcm1pbmF0ZSgpDQp0cnk6DQogICAgc3Rkb3V0LCBzdGRl
cnIgPSBibGt0cmFjZS5jb21tdW5pY2F0ZSh0aW1lb3V0ID0gMjApDQpleGNlcHQgc3VicHJvY2Vz
cy5UaW1lb3V0RXhwaXJlZDoNCiAgICBibGt0cmFjZS5raWxsKCkNCiAgICBzdGRvdXQsIHN0ZGVy
ciA9IGJsa3RyYWNlLmNvbW11bmljYXRlKCkNCnByaW50KCJibGt0cmFjZSBlcnJvcnM6IikNCnBy
aW50KHN0ZGVycikNCiMgVGhpcyB3aWxsIGdpdmUgeW91IHRoZSByYXcgYmxrdHJhY2Ugb3V0cHV0
DQojIHByaW50KHN0ZG91dCkNCmJsa3BhcnNlX2Zvcm1hdF9zdHIgPSAnJUQgJTJjICU4cyAlNVQu
JTl0ICU1cCAlMmEgJTNkIGNvbW1hbmQgPSAlQyBzZWN0b3JzID0gJVNcbicNCmJsa3BhcnNlX3Jl
dCA9IHN1YnByb2Nlc3MucnVuKFsiYmxrcGFyc2UiLCAiLWkiLCAiLSIsICItZiIsIGJsa3BhcnNl
X2Zvcm1hdF9zdHIsICItYSIsICJpc3N1ZSJdLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaW5wdXQgPSBzdGRvdXQsIHN0ZG91dCA9IHN1YnByb2Nlc3MuUElQRSwgc3RkZXJyID0gc3Vi
cHJvY2Vzcy5QSVBFKQ0KcHJpbnQoImJsa3BhcnNlIGVycm9yczoiKQ0KcHJpbnQoYmxrcGFyc2Vf
cmV0LnN0ZGVycikNCiMgcHJpbnQoYmxrcGFyc2VfcmV0LnN0ZG91dCkNCmJsa3BhcnNlX3N0ciA9
IGJsa3BhcnNlX3JldC5zdGRvdXQuZGVjb2RlKHN5cy5zdGRvdXQuZW5jb2RpbmcpDQoNCmlmIGFy
Z3Muc2F2ZV9ibG9ja19wYXJzZToNCiAgICB3aXRoIG9wZW4oImJsa3BhcnNlX291dHB1dC50eHQi
LCAndycpIGFzIG91dHB1dF9maWxlOg0KICAgICAgICBvdXRwdXRfZmlsZS53cml0ZShibGtwYXJz
ZV9zdHIpDQoNCiMgUGFyc2UgYmxrdHJhY2UgcmVzdWx0IGludG8gYmlucw0KYmxrbGluZV9yZSA9
IHJlLmNvbXBpbGUociIoXGQrLFxkKylccysoXGQrKVxzKyhcZCspXHMrKD9QPHRpbWVzdGFtcD5c
ZCtcLlxkKylccysoXGQrKVxzK0RccysoUnxXKSINCiAgICAgICAgICAgICAgICAgICAgICAgIHIi
XHMrY29tbWFuZCA9IGZpb1xzK3NlY3RvcnMgPSAoP1A8c2VjdG9yPlxkKykiKQ0KdG90YWxfaW9z
ID0gMA0KYXZnX2xiYSA9IDANCm1heF9sYmEgPSAwDQptaW5fbGJhID0gTm9uZQ0KIyBQYXJzZSBv
dXQgdGhlIHNlY3RvcnMgZnJvbSB0aGUgYmxvY2t0cmFjZSBvdXRwdXQgdG8gZ2V0IHNvbWUgcHJl
bGltaW5hcnkgc3RhdGlzdGljcw0KbWF0Y2hfaXRlciA9IGJsa2xpbmVfcmUuZmluZGl0ZXIoYmxr
cGFyc2Vfc3RyKQ0KZm9yIG1hdGNoX29iaiBpbiBtYXRjaF9pdGVyOg0KICAgIHNlY3Rvcl9udW0g
PSBpbnQobWF0Y2hfb2JqLmdyb3VwZGljdCgpWyJzZWN0b3IiXSkNCiAgICB0b3RhbF9pb3MgKz0g
MQ0KICAgIGF2Z19sYmEgKz0gc2VjdG9yX251bQ0KICAgIGlmIG1pbl9sYmEgaXMgTm9uZSBvciBz
ZWN0b3JfbnVtIDwgbWluX2xiYToNCiAgICAgICAgbWluX2xiYSA9IHNlY3Rvcl9udW0NCiAgICBp
ZiBzZWN0b3JfbnVtID4gbWF4X2xiYToNCiAgICAgICAgbWF4X2xiYSA9IHNlY3Rvcl9udW0NCg0K
cHJpbnQoInRvdGFsIElPcyA9ICIgKyBzdHIodG90YWxfaW9zKSkNCnByaW50KCJhdmc6IHs6LjJm
fSwgbWluOiB7fSwgbWF4OiB7fSIuZm9ybWF0KGF2Z19sYmEgLyB0b3RhbF9pb3MsIG1pbl9sYmEs
IG1heF9sYmEpKQ0KaGlzdF9udW0gPSAyMA0KaGlzdF9iaW5zID0gWzBdICogaGlzdF9udW0NCmhp
c3RfZGl2ID0gbWF4X2xiYSAvIGhpc3RfbnVtDQpoaXN0X2VkZ2VzID0gW10NCmZvciBpbmQgaW4g
cmFuZ2UoaGlzdF9udW0pOg0KICAgIGhpc3RfZWRnZXMuYXBwZW5kKGhpc3RfZGl2ICogKGluZCAr
IDEpKQ0KDQojIFNvcnQgdGhlIGRhdGEgaW50byBhIGhpc3RvZ3JhbQ0KbWF0Y2hfaXRlciA9IGJs
a2xpbmVfcmUuZmluZGl0ZXIoYmxrcGFyc2Vfc3RyKQ0KZm9yIG1hdGNoX29iaiBpbiBtYXRjaF9p
dGVyOg0KICAgIHNlY3Rvcl9udW0gPSBpbnQobWF0Y2hfb2JqLmdyb3VwZGljdCgpWyJzZWN0b3Ii
XSkNCiAgICBoaXN0X2luZCA9IG1hdGguZmxvb3Ioc2VjdG9yX251bSAvIGhpc3RfZGl2KQ0KICAg
IGlmIGhpc3RfaW5kID09IGhpc3RfbnVtOg0KICAgICAgICBoaXN0X2luZCAtPSAxDQogICAgaGlz
dF9iaW5zW2hpc3RfaW5kXSArPSAxDQogICAgIyBwcmludCgie306IGJpbiB7fSIuZm9ybWF0KHNl
Y3Rvcl9udW0sIGhpc3RfaW5kKSkNCg0KaGlzdF9wZXJjID0gW10NCmZvciBoaXN0X2JpbiBpbiBo
aXN0X2JpbnM6DQogICAgaGlzdF9wZXJjLmFwcGVuZCgxMDAgKiBoaXN0X2JpbiAvIHRvdGFsX2lv
cykNCg0KcHJpbnQoImhpc3RvZ3JhbSBiaW5zID0gIiArIHN0cihoaXN0X2JpbnMpKQ0KcHJpbnQo
Imhpc3RvZ3JhbSBwZXJjZW50cyA9ICIgKyBzdHIoaGlzdF9wZXJjKSkNCnByaW50KCJoaXN0b2dy
YW0gZWRnZXMgPSAiICsgc3RyKGhpc3RfZWRnZXMpKQ0KIyBwcmludCBGSU8gdmVyc2lvbiBhbmQg
ZGlzdHJpYnV0aW9uIHN0cmluZw0KcHJpbnQoZGlzdF9zdHIpDQpjbWRfcmV0ID0gc3VicHJvY2Vz
cy5ydW4oW2FyZ3MuZmlvX3BhdGgsICItdiJdKQ0K
--001a1140774cec1b22055e6d4531--
