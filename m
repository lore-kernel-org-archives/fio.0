Return-Path: <prvs=611231c00=jeff.furlong@wdc.com>
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: fio server/client disconnect bug
Date: Wed, 21 Mar 2018 18:16:59 +0000
Message-ID: <SN6PR04MB40649D252EA6B8B0E16BE8E18FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457692506FCB2E385AE2A2E8FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <SN6PR04MB4064CEF242E2091737402D268FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <47cd0e78-d881-a776-7f2d-c292b35e8211@kernel.dk>
 <5d0275d2-889e-314e-63bd-240d326beb47@kernel.dk>
 <33d87376-bbd9-69d9-83e0-120d93bd843d@kernel.dk>
 <SN6PR04MB4064961E38329062931640B68FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <7ea6910f-dc7b-d141-432e-62c2ee9f16ee@kernel.dk>
 <SN6PR04MB4064FBCCCA9542C6550E99668FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <4f5b0878-83fc-a224-e6b0-06896cd2155b@kernel.dk>
In-Reply-To: <4f5b0878-83fc-a224-e6b0-06896cd2155b@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Here's the failing case where host1 does not print:

back=3D1, groupid=3D0, nr_ts=3D1
client: got cmd op PROBE from host2 (pdu=3D112)
client host2 removed 2
client: got cmd op PROBE from host1 (pdu=3D112)
client host1 removed 2
client: got cmd op START from host2 (pdu=3D8)
client host2 removed 2
client: got cmd op START from host1 (pdu=3D8)
client host1 removed 2
client: got cmd op ADD_JOB from host2 (pdu=3D23204)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D70)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D90)
client host2 removed 2
client: got cmd op ADD_JOB from host1 (pdu=3D23204)
client host1 removed 2
client: got cmd op TEXT from host2 (pdu=3D51)
client host2 removed 2
client: got cmd op TEXT from host1 (pdu=3D70)
client host1 removed 2
client: got cmd op START from host2 (pdu=3D8)
client host2 removed 2
client: got cmd op TEXT from host1 (pdu=3D90)
client host1 removed 2
client: got cmd op TEXT from host1 (pdu=3D51)
client host1 removed 2
client: got cmd op START from host1 (pdu=3D8)
client host1 removed 2
client: got cmd op TEXT from host2 (pdu=3D33)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D33)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D25)
client host2 removed 2
client: got cmd op TEXT from host1 (pdu=3D33)
client host1 removed 2
client: got cmd op TEXT from host1 (pdu=3D33)
client host1 removed 2
client: got cmd op TEXT from host1 (pdu=3D25)
client host1 removed 2
client: got cmd op SERVER_START from host2 (pdu=3D0)
client host2 removed 2
client: got cmd op SERVER_START from host1 (pdu=3D0)
client host1 removed 2
client: got cmd op ETA from host2 (pdu=3D165)
client host2 removed 2
client: got cmd op ETA from host1 (pdu=3D165)
client host1 removed 2
client: got cmd op ETA from host2 (pdu=3D165)
client host2 removed 2
client: got cmd op ETA from host1 (pdu=3D165)
client host1 removed 2
client: got cmd op ETA from host2 (pdu=3D165)
client host2 removed 2
client: got cmd op ETA from host1 (pdu=3D165)
client host1 removed 25.0%][r=3D2667M,w=3D0k][r=3D41.7k,w=3D0 IOPS][eta 00m=
:02s]
client: got cmd op ETA from host2 (pdu=3D165)
client host2 removed 2
client: got cmd op ETA from host1 (pdu=3D165)
client host1 removed 28.9%][r=3D2661M,w=3D0k][r=3D41.6k,w=3D0 IOPS][eta 00m=
:01s]
client: got cmd op ETA from host2 (pdu=3D165)
client host2 removed 2
client: got cmd op ETA from host1 (pdu=3D165)
client host1 removed 200.0%][r=3D2669M,w=3D0k][r=3D41.7k,w=3D0 IOPS][eta 00=
m:00s]
client: got cmd op IOLOG from host2 (pdu=3D338)
client host2 removed 2
client: got cmd op IOLOG from host2 (pdu=3D327)
client host2 removed 2
client: got cmd op IOLOG from host2 (pdu=3D337)
client host2 removed 2
client: got cmd op IOLOG from host1 (pdu=3D338)
client host1 removed 2
client: got cmd op IOLOG from host1 (pdu=3D325)
client host1 removed 2
client: got cmd op IOLOG from host1 (pdu=3D337)
client host1 removed 2
client: got cmd op IOLOG from host1 (pdu=3D323)
client host1 removed 2
client: got cmd op IOLOG from host1 (pdu=3D320)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op STOP from host1 (pdu=3D8)
client host1 removed 2
client: got cmd op QUIT from host1 (pdu=3D0)
client host1 removed 2
client host1 removed 1
client: got cmd op IOLOG from host2 (pdu=3D331)
client host2 removed 2
client: got cmd op IOLOG from host2 (pdu=3D327)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op TS from host2 (pdu=3D94888)
client host2 removed 2
client: got cmd op GS from host2 (pdu=3D164)
client host2 removed 2
client: got cmd op DISK_UTIL from host2 (pdu=3D256)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D25)
client host2 removed 2
client: got cmd op STOP from host2 (pdu=3D8)
client host2 removed 2
client: got cmd op QUIT from host2 (pdu=3D0)
client host2 removed 2
client host2 removed 1

And here's a good case:

client: got cmd op PROBE from host2 (pdu=3D112)
client host2 removed 2
client: got cmd op PROBE from host1 (pdu=3D112)
client host1 removed 2
client: got cmd op START from host2 (pdu=3D8)
client host2 removed 2
client: got cmd op START from host1 (pdu=3D8)
client host1 removed 2
client: got cmd op ADD_JOB from host2 (pdu=3D23204)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D70)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D90)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D51)
client host2 removed 2
client: got cmd op START from host2 (pdu=3D8)
client host2 removed 2
client: got cmd op ADD_JOB from host1 (pdu=3D23204)
client host1 removed 2
client: got cmd op TEXT from host1 (pdu=3D70)
client host1 removed 2
client: got cmd op TEXT from host1 (pdu=3D90)
client host1 removed 2
client: got cmd op TEXT from host1 (pdu=3D51)
client host1 removed 2
client: got cmd op START from host1 (pdu=3D8)
client host1 removed 2
client: got cmd op TEXT from host2 (pdu=3D33)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D33)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D25)
client host2 removed 2
client: got cmd op SERVER_START from host2 (pdu=3D0)
client host2 removed 2
client: got cmd op TEXT from host1 (pdu=3D33)
client host1 removed 2
client: got cmd op TEXT from host1 (pdu=3D33)
client host1 removed 2
client: got cmd op TEXT from host1 (pdu=3D25)
client host1 removed 2
client: got cmd op SERVER_START from host1 (pdu=3D0)
client host1 removed 2
client: got cmd op ETA from host2 (pdu=3D165)
client host2 removed 2
client: got cmd op ETA from host1 (pdu=3D165)
client host1 removed 2
client: got cmd op ETA from host2 (pdu=3D165)
client host2 removed 2
client: got cmd op ETA from host1 (pdu=3D165)
client host1 removed 2
client: got cmd op ETA from host2 (pdu=3D165)
client host2 removed 2
client: got cmd op ETA from host1 (pdu=3D165)
client host1 removed 25.0%][r=3D2667M,w=3D0k][r=3D41.7k,w=3D0 IOPS][eta 00m=
:02s]
client: got cmd op ETA from host2 (pdu=3D165)
client host2 removed 2
client: got cmd op ETA from host1 (pdu=3D165)
client host1 removed 28.9%][r=3D2669M,w=3D0k][r=3D41.7k,w=3D0 IOPS][eta 00m=
:01s]
client: got cmd op ETA from host2 (pdu=3D165)
client host2 removed 2
client: got cmd op ETA from host1 (pdu=3D165)
client host1 removed 200.0%][r=3D2675M,w=3D0k][r=3D41.8k,w=3D0 IOPS][eta 00=
m:00s]
client: got cmd op IOLOG from host2 (pdu=3D336)
client host2 removed 2
client: got cmd op IOLOG from host2 (pdu=3D327)
client host2 removed 2
client: got cmd op IOLOG from host2 (pdu=3D337)
client host2 removed 2
client: got cmd op IOLOG from host1 (pdu=3D338)
client host1 removed 2
client: got cmd op IOLOG from host1 (pdu=3D327)
client host1 removed 2
client: got cmd op IOLOG from host1 (pdu=3D338)
client host1 removed 2
client: got cmd op IOLOG from host2 (pdu=3D330)
client host2 removed 2
client: got cmd op IOLOG from host2 (pdu=3D327)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client host2 removed 2
client: got cmd op TS from host2 (pdu=3D94888)
client host2 removed 2
client: got cmd op GS from host2 (pdu=3D164)
client host2 removed 2
client: got cmd op DISK_UTIL from host2 (pdu=3D256)
client host2 removed 2
client: got cmd op TEXT from host2 (pdu=3D25)
client host2 removed 2
client: got cmd op STOP from host2 (pdu=3D8)
client host2 removed 2
client: got cmd op QUIT from host2 (pdu=3D0)
client host2 removed 2
client host2 removed 1
client: got cmd op IOLOG from host1 (pdu=3D330)
client host1 removed 2
client: got cmd op IOLOG from host1 (pdu=3D327)
back=3D1, groupid=3D0, nr_ts=3D1
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client host1 removed 2
client: got cmd op TS from host1 (pdu=3D94888)
client host1 removed 2
client: got cmd op GS from host1 (pdu=3D164)
client host1 removed 2
client: got cmd op DISK_UTIL from host1 (pdu=3D256)
client host1 removed 2
client: got cmd op TEXT from host1 (pdu=3D25)
client host1 removed 2
client: got cmd op STOP from host1 (pdu=3D8)
client host1 removed 2
client: got cmd op QUIT from host1 (pdu=3D0)
client host1 removed 2
client host1 removed 1

Regards,
Jeff


-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, March 21, 2018 10:12 AM
To: Jeff Furlong <jeff.furlong@wdc.com>; fio@vger.kernel.org
Subject: Re: fio server/client disconnect bug

On 3/21/18 10:58 AM, Jeff Furlong wrote:
> Patch applied to latest git.  Failed after 26 iterations.  The host1 did =
not print output to the summary file.
>=20
> client: got cmd op PROBE from host2 (pdu=3D112)
> client: got cmd op PROBE from host1 (pdu=3D112)
> client: got cmd op START from host2 (pdu=3D8)
> client: got cmd op START from host1 (pdu=3D8)
> client: got cmd op ADD_JOB from host2 (pdu=3D23204)
> client: got cmd op TEXT from host2 (pdu=3D70)
> client: got cmd op TEXT from host2 (pdu=3D90)
> client: got cmd op TEXT from host2 (pdu=3D51)
> client: got cmd op ADD_JOB from host1 (pdu=3D23204)
> client: got cmd op START from host2 (pdu=3D8)
> client: got cmd op TEXT from host1 (pdu=3D70)
> client: got cmd op TEXT from host1 (pdu=3D90)
> client: got cmd op TEXT from host1 (pdu=3D51)
> client: got cmd op START from host1 (pdu=3D8)
> client: got cmd op TEXT from host2 (pdu=3D33)
> client: got cmd op TEXT from host2 (pdu=3D33)
> client: got cmd op TEXT from host2 (pdu=3D25)
> client: got cmd op TEXT from host1 (pdu=3D33)
> client: got cmd op TEXT from host1 (pdu=3D33)
> client: got cmd op TEXT from host1 (pdu=3D25)
> client: got cmd op SERVER_START from host2 (pdu=3D0)
> client: got cmd op SERVER_START from host1 (pdu=3D0)
> client: got cmd op ETA from host2 (pdu=3D165)
> client: got cmd op ETA from host1 (pdu=3D165)
> client: got cmd op ETA from host2 (pdu=3D165)
> client: got cmd op ETA from host1 (pdu=3D165)
> client: got cmd op ETA from host2 (pdu=3D165)
> client: got cmd op ETA from host1 (pdu=3D165)
> client: got cmd op ETA from host2 (pdu=3D165)=3D41.6k,w=3D0 IOPS][eta=20
> 00m:02s]
> client: got cmd op ETA from host1 (pdu=3D165)
> client: got cmd op ETA from host2 (pdu=3D165)=3D41.6k,w=3D0 IOPS][eta=20
> 00m:01s]
> client: got cmd op ETA from host1 (pdu=3D165)
> client: got cmd op IOLOG from host2 (pdu=3D338)41.6k,w=3D0 IOPS][eta=20
> 00m:00s]
> client: got cmd op IOLOG from host2 (pdu=3D327)
> client: got cmd op IOLOG from host2 (pdu=3D338)
> client: got cmd op IOLOG from host1 (pdu=3D337)
> client: got cmd op IOLOG from host1 (pdu=3D328)
> client: got cmd op IOLOG from host1 (pdu=3D336)
> client: got cmd op IOLOG from host2 (pdu=3D330)
> client: got cmd op IOLOG from host2 (pdu=3D327)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op JOB_OPT from host2 (pdu=3D200)
> client: got cmd op TS from host2 (pdu=3D94888)
> client: got cmd op GS from host2 (pdu=3D164)
> client: got cmd op IOLOG from host1 (pdu=3D324)
> client: got cmd op DISK_UTIL from host2 (pdu=3D256)
> client: got cmd op IOLOG from host1 (pdu=3D320)
> client: got cmd op TEXT from host2 (pdu=3D25)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op STOP from host2 (pdu=3D8)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op QUIT from host2 (pdu=3D0)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op JOB_OPT from host1 (pdu=3D200)
> client: got cmd op STOP from host1 (pdu=3D8)
> client: got cmd op QUIT from host1 (pdu=3D0)

So this is weird, after the JOB_OPT it should have send the gs/ts and so on=
 summary. Which is what triggers the stat display. Can you remove the previ=
ous patch, and add this debug patch with some more printf goodness in it?


diff --git a/client.c b/client.c
index bff0adc0d972..0f740b5f3057 100644
--- a/client.c
+++ b/client.c
@@ -179,6 +179,8 @@ static struct fio_client *find_client_by_fd(int fd)
=20
 void fio_put_client(struct fio_client *client)  {
+	printf("client %s removed %d\n", client->hostname, client->refs);
+
 	if (--client->refs)
 		return;
=20
@@ -1664,7 +1666,7 @@ int fio_handle_client(struct fio_client *client)
 	if (!cmd)
 		return 0;
=20
-	dprint(FD_NET, "client: got cmd op %s from %s (pdu=3D%u)\n",
+	printf("client: got cmd op %s from %s (pdu=3D%u)\n",
 		fio_server_op(cmd->opcode), client->hostname, cmd->pdu_len);
=20
 	client->last_cmd =3D cmd->opcode;
diff --git a/stat.c b/stat.c
index 98ab63893900..c23a3c9ddabc 100644
--- a/stat.c
+++ b/stat.c
@@ -1882,6 +1882,8 @@ void __show_run_stats(void)
 		json_object_add_value_array(root, "jobs", array);
 	}
=20
+	printf("back=3D%d, groupid=3D%d, nr_ts=3D%d\n", is_backend, groupid, nr_t=
s);
+
 	if (is_backend)
 		fio_server_send_job_options(&get_global_options()->opt_list, -1U);
=20

--
Jens Axboe


