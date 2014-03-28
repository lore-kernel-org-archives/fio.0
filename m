Return-Path: <Eric.Lamkin@lsi.com>
From: "Lamkin, Eric" <Eric.Lamkin@lsi.com>
Subject: RE: fio replay
Date: Fri, 28 Mar 2014 13:52:03 +0000
Message-ID: <320b5fe9560e4697a924b2efca65104c@DM2PR07MB448.namprd07.prod.outlook.com>
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com>
 <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org>
 <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com>
 <530E2933.2080903@kernel.dk> <530E6056.2020309@kernel.dk>
 <c79c5d2e1b3f4a3487815ca851a8399e@BN1PR07MB437.namprd07.prod.outlook.com>
 <70dc0e01a5674f159ed9e02dc61b64ce@BN1PR07MB437.namprd07.prod.outlook.com>
 <53189A5D.1070602@kernel.dk>
 <d47f31f7932e4ce3928874fe5019d6da@BN1PR07MB437.namprd07.prod.outlook.com>
In-Reply-To: <d47f31f7932e4ce3928874fe5019d6da@BN1PR07MB437.namprd07.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens,

Finally got back to this.

I do get different results with 2.1.6.1.
Not sure what is wrong.

[root@x3650M4 Run2]# ls
bprun2all.bin
[root@x3650M4 Run2]# fio --name=3Drp2 --ioengine=3Dlibaio --iodepth=3D12 --=
read_iolog=3Dbprun2all.bin
rp2: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio, iodepth=
=3D12
fio-2.1.6.1
Starting 1 process
blktrace: got timestamp notify: 4000001, 0
fio: filesetup.c:1264: get_file: Assertion `fio_file_open(f)' failed.:00s]
fio: pid=3D14664, got signal=3D6e] [0KB/37KB/0KB /s] [0/9/0 iops] [eta 09h:=
02m:07s]

rp2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D14664: Fri Mar 28 08:47:57 20=
14
    lat (usec) : 100=3D10.71%, 250=3D89.29%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=3D0
  IO depths    : 1=3D3.6%, 2=3D7.1%, 4=3D14.3%, 8=3D75.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D94.4%, 8=3D0.0%, 16=3D5.6%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D28/d=3D0, short=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D12

Run status group 0 (all jobs):
  WRITE: io=3D0KB, aggrb=3D0KB/s, minb=3D0KB/s, maxb=3D0KB/s, mint=3D595mse=
c, maxt=3D595msec
[root@x3650M4 Run2]#

Eric
-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Lamkin, Eric
Sent: Thursday, March 06, 2014 10:12 AM
To: Jens Axboe
Cc: fio@vger.kernel.org; David Nellans
Subject: RE: fio replay

OK, will grab 2.1.6 and reply with observations.

I've only recently subscribed to this mail-list and it amazes me that you c=
an give attention to such a barrage of requests.

Eric
-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]
Sent: Thursday, March 06, 2014 9:55 AM
To: Lamkin, Eric; David Nellans
Cc: fio@vger.kernel.org
Subject: Re: fio replay

On 03/03/2014 06:25 AM, Lamkin, Eric wrote:
> Here's my update with a blktrace captured on a single device with no drop=
ped events.
> Also switched to fio 2.1.4.
>
> Capture a single device trace with no dropped events.

[snip]

Thanks for the detailed report. But why are you replaying with fio-2.1.4? I=
f there's a bug here (and it looks like it), then please replay the blktrac=
e with fio-2.1.6 and I can take a look at it.

--
Jens Axboe


--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html


