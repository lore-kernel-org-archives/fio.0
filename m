Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:33795 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751016AbdFOGvF (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Jun 2017 02:51:05 -0400
Received: by mail-vk0-f46.google.com with SMTP id g66so2305932vki.1
        for <fio@vger.kernel.org>; Wed, 14 Jun 2017 23:51:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457210A285884036121C7F38FC30@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457EFC8350E7DAB393315B28FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxjKwFty9C42YcBkb7NStRMZrKRPKda5_gFejd358mCi_g@mail.gmail.com>
 <BN3PR0401MB14572E293EAA4723BE2750058FC90@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxjxvwMDn722Zg10VjNVd5t+6GcE1UOi9ams4Lh-UV9WzQ@mail.gmail.com> <BN3PR0401MB1457210A285884036121C7F38FC30@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 15 Jun 2017 07:50:34 +0100
Message-ID: <CALjAwxinwLmEjEmQaY0Rpg4VQLLO1DQNGyjrDHfiSdV0jBwRqg@mail.gmail.com>
Subject: Re: fio server errors
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 14 June 2017 at 23:20, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> On issue one (inflate error), I've gone through some of the code and I th=
ink nr_samples should be declared as uint64_t, not uint32_t, at https://git=
hub.com/axboe/fio/blob/master/client.c#L1451  I've changed it on my machine=
 and reran the prior test but after 25 hours the same issue occurred again.=
  It's still difficult to say what type of job is causing the issue.

I see there is another uint32_t nr_samples over in
https://github.com/axboe/fio/blob/master/iolog.c#L801 - do you think
that would need changing too? Is nr_samples slowly growing over time
and have you managed to print its value at the point of the inflate
error?

> On issue two (SEND_ETA), I can reproduce with a slightly smaller job file=
:
>
> #fio --client=3Dserver1 test.job --client=3Dserver2 test.job
>
> # cat test.job
> [test_job]
> ioengine=3Dlibaio
> direct=3D1
> rw=3Drandread
> iodepth=3D256
> size=3D100%
> numjobs=3D1
> bs=3D4k
> filename=3D/dev/nvme0n1
> group_reporting
> write_lat_log=3Dtest_job
> runtime=3D1m
>
> If I remove write_lat_log=3Dtest_job then there is no SEND_ETA issue.  On=
ly when logging (the latency) does this issue occur.  And, if I enable writ=
e_lat_log=3Dtest_job but reduce runtime=3D30s, then the issue does not occu=
r.  I must have write_lat_log=3Dtest_job and runtime=3D1m to produce the is=
sue.  I imagine some count must be exceeded or the pause in moving the lat =
data from memory to file at the end of the job is causing a timing conflict=
 (SEND_ETA msg vs "I've quit" msg).

I can reproduce the problem here using this job:
[sendeta]
ioengine=3Dlibaio
direct=3D1
rw=3Dread
bs=3D512
filename=3D/dev/nullb0
write_lat_log=3Dtest_job
disable_clat=3D1
disable_slat=3D1
iodepth=3D512
number_ios=3D16000000

and running
fio --debug=3Dnet --client=3Dlocalhost sendeta.fio --client=3D127.0.0.1 sen=
deta.fio

Using number_ios seems to make the job run for as long as needed to
show the problem regardless of what the iodepth is in my case. From
what I can see the client is forced to spend time on the IOLOG op
which in turn makes it unresponsive to other actions:

net      1709  client: got cmd op ETA from 127.0.0.1 (pdu=3D161)
net      1709  client: got eta tag 0x2442d90, 2
net      1709  client: handle localhost
net      1709  client: got cmd op ETA from localhost (pdu=3D161)
net      1709  client: got eta tag 0x2442d90, 1
net      1709  client: request eta (2)k][r=3D423k,w=3D0 IOPS][eta 27m:09s]
net      1709  client: requested eta tag 0x2442d90
net      1709  client: handle localhost
net      1709  client: got cmd op ETA from localhost (pdu=3D161)
net      1709  client: got eta tag 0x2442d90, 2
net      1709  client: handle 127.0.0.1
net      1709  client: got cmd op IOLOG from 127.0.0.1 (pdu=3D290)
net      1709  client: handle 127.0.0.1
net      1709  client: got cmd op IOLOG from 127.0.0.1 (pdu=3D290)
net      1709  client: handle 127.0.0.1
net      1709  client: got cmd op ETA from 127.0.0.1 (pdu=3D161)
net      1709  client: got eta tag 0x2442d90, 1
net      1709  client: handle localhost0k][r=3D387k,w=3D0 IOPS][eta 00m:00s=
]
net      1709  client: got cmd op IOLOG from localhost (pdu=3D11297502)
net      1709  client: request eta (2)
net      1709  client: requested eta tag 0x2442d90
net      1709  client: handle 127.0.0.1
net      1709  client: got cmd op IOLOG from 127.0.0.1 (pdu=3D11297330)
net      1709  client: handle localhost
net      1709  client: got cmd op IOLOG from localhost (pdu=3D290)
net      1709  client: request eta (2)
net      1709  client: requested eta tag 0x2449df0
client <127.0.0.1>: timeout on SEND_ETA
client <localhost>: timeout on SEND_ETA
net      1709  client: handle 127.0.0.1
net      1709  client: got cmd op ETA from 127.0.0.1 (pdu=3D161)
fio: client: unable to find matching tag (2442c80)

--=20
Sitsofe | http://sucs.org/~sits/
